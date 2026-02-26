import wave
import math
import csv
import argparse
from pathlib import Path
import numpy as np

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_WAV_PATH = BASE_DIR / "stones_rec_example.wav"

FFT_SIZE = 2048
HOP = FFT_SIZE // 8
WINDOW_MS = 120
REFRACTORY_MS = 180
NOISE_DB = -55.0

BANDS = [(20, 500), (500, 1000), (1000, 3000)]
NBINS = [2, 2, 2]

FEATURE_NOTE_RANGES = {
    "centroid": (36, 84),
    "flatness": (36, 84),
    "tilt": (36, 84),
    "crest": (36, 84),
}
PRESETS = {
    "before": {
        "trace_note_ranges": [(36, 84), (36, 84), (36, 84)],
        "trace_transpose": [0, 0, 0],
        "crest_max": 80,
    },
    "after": {
        "trace_note_ranges": [(36, 84), (36, 100), (36, 108)],
        "trace_transpose": [0, 0, -12],
        "crest_max": 140,
    },
}


def dbfs_amp(x: np.ndarray) -> np.ndarray:
    return 20 * np.log10(np.maximum(np.abs(x), 1e-12))


def read_wav_mono(path: Path):
    with wave.open(str(path), "rb") as wf:
        nchan = wf.getnchannels()
        sr = wf.getframerate()
        sw = wf.getsampwidth()
        n = wf.getnframes()
        raw = wf.readframes(n)
    if sw == 2:
        data = np.frombuffer(raw, dtype=np.int16).astype(np.float64) / 32768.0
    elif sw == 3:
        b = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 3)
        x = (b[:, 0].astype(np.int32)
             | (b[:, 1].astype(np.int32) << 8)
             | (b[:, 2].astype(np.int32) << 16))
        sign = x & 0x800000
        x = x - (sign << 1)
        data = x.astype(np.float64) / 8388608.0
    elif sw == 4:
        data = np.frombuffer(raw, dtype=np.int32).astype(np.float64) / 2147483648.0
    else:
        raise RuntimeError(f"Unsupported sample width: {sw}")
    if nchan > 1:
        data = data.reshape(-1, nchan).mean(axis=1)
    return sr, data


def rms_envelope(x: np.ndarray, win: int, hop: int):
    if len(x) < win:
        return np.array([]), np.array([])
    idx = np.arange(0, len(x) - win + 1, hop)
    env = np.empty(len(idx), dtype=np.float64)
    for i, s in enumerate(idx):
        frame = x[s:s + win]
        env[i] = math.sqrt(np.mean(frame * frame) + 1e-18)
    return idx, env


def detect_onsets(env_db: np.ndarray, times: np.ndarray):
    above = env_db > NOISE_DB
    d = np.diff(env_db, prepend=env_db[0])
    candidates = np.where(above & (d > 1.0))[0]
    onsets = []
    last_t = -1e9
    refractory = REFRACTORY_MS / 1000.0
    for i in candidates:
        t = times[i]
        if t - last_t >= refractory:
            onsets.append(i)
            last_t = t
    return np.array(onsets, dtype=int)


def feature_window(x: np.ndarray, sr: int, center_sample: int, dur_ms: float):
    n = int(sr * dur_ms / 1000.0)
    s0 = max(0, center_sample)
    s1 = min(len(x), s0 + n)
    seg = x[s0:s1]
    if len(seg) < FFT_SIZE:
        seg = np.pad(seg, (0, FFT_SIZE - len(seg)))
    frames = []
    for s in range(0, max(1, len(seg) - FFT_SIZE + 1), HOP):
        fr = seg[s:s + FFT_SIZE]
        if len(fr) < FFT_SIZE:
            fr = np.pad(fr, (0, FFT_SIZE - len(fr)))
        frames.append(fr)
    return np.array(frames)


def map_feature_to_note(v, lo, hi, vmin, vmax):
    n = (v - vmin) / (vmax - vmin + 1e-12)
    n = min(1.0, max(0.0, n))
    return int(round(lo + n * (hi - lo)))


def hz_to_midi(freq):
    return 69.0 + 12.0 * math.log2(max(freq, 1e-12) / 440.0)


def analyze_hit(frames: np.ndarray, sr: int):
    win = np.hanning(FFT_SIZE)
    mags = []
    for fr in frames:
        sp = np.fft.rfft(fr * win)
        mags.append(np.abs(sp))
    mags = np.array(mags)
    mag_mean = np.mean(mags, axis=0)
    freqs = np.fft.rfftfreq(FFT_SIZE, d=1.0 / sr)

    energy = np.sum(mag_mean) + 1e-12
    centroid = float(np.sum(freqs * mag_mean) / energy)
    arith = float(np.mean(mag_mean) + 1e-12)
    flatness = float(np.exp(np.mean(np.log(mag_mean + 1e-12))) / arith)

    lo_mask = (freqs >= BANDS[0][0]) & (freqs <= BANDS[0][1])
    hi_mask = (freqs >= BANDS[2][0]) & (freqs <= BANDS[2][1])
    tilt = float(math.log((np.sum(mag_mean[hi_mask]) + 1e-9) / (np.sum(mag_mean[lo_mask]) + 1e-9)))
    crest = float(np.max(mag_mean) / arith)

    trace_hz = []
    for (f0, f1), ntrace in zip(BANDS, NBINS):
        mask = (freqs >= f0) & (freqs <= f1)
        band_mag = np.where(mask, mag_mean, 0.0)
        idx = np.argpartition(band_mag, -ntrace)[-ntrace:]
        idx = idx[np.argsort(band_mag[idx])[::-1]]
        idx = idx[band_mag[idx] > 0]
        trace_hz.append(float(freqs[idx[0]]) if len(idx) else 0.0)

    return {
        "centroid": centroid,
        "flatness": flatness,
        "tilt": tilt,
        "crest": crest,
        "trace_hz": trace_hz,
    }


def map_hit_to_notes(feat: dict, preset: dict):
    n_cent = map_feature_to_note(feat["centroid"], *FEATURE_NOTE_RANGES["centroid"], 0, 12000)
    n_flat = map_feature_to_note(feat["flatness"], *FEATURE_NOTE_RANGES["flatness"], 0, 1)
    n_tilt = map_feature_to_note(feat["tilt"], *FEATURE_NOTE_RANGES["tilt"], -8, 8)
    n_crest = map_feature_to_note(feat["crest"], *FEATURE_NOTE_RANGES["crest"], 0, preset["crest_max"])

    trace_notes = []
    for i, hz in enumerate(feat["trace_hz"]):
        lo, hi = preset["trace_note_ranges"][i]
        if hz > 0:
            note = int(round(min(hi, max(lo, hz_to_midi(hz) + preset["trace_transpose"][i]))))
        else:
            note = -1
        trace_notes.append(note)

    return n_cent, n_flat, n_tilt, n_crest, *trace_notes


def print_consistency(rows):
    spread_rows = []
    if len(rows) >= 12:
        groups = [rows[i:i+3] for i in range(0, 12, 3)]
        print("consistency (first 12 hits, grouped 3-by-3):")
        names = ["C", "F", "T", "Cr", "B1", "B2", "B3"]
        for gi, g in enumerate(groups, start=1):
            arr = np.array([x[2:] for x in g], dtype=np.float64)
            spreads = arr.max(axis=0) - arr.min(axis=0)
            s = ", ".join(f"{nm}±{int(sp)}" for nm, sp in zip(names, spreads))
            print(f"stone{gi}: {s}")
            spread_rows.append((gi, *[int(sp) for sp in spreads]))
    return spread_rows


def build_output_paths(wav_path: Path):
    hits_csv = wav_path.with_name(f"{wav_path.stem}_note_compare_hits.csv")
    spreads_csv = wav_path.with_name(f"{wav_path.stem}_note_compare_spreads.csv")
    raw_features_csv = wav_path.with_name(f"{wav_path.stem}_raw_features.csv")
    return hits_csv, spreads_csv, raw_features_csv


def write_hits_csv(rows_by_preset: dict, hits_csv_path: Path):
    with open(hits_csv_path, "w", newline="", encoding="utf-8") as fp:
        writer = csv.writer(fp)
        writer.writerow(["preset", "hit", "time_s", "C", "F", "T", "Cr", "B1", "B2", "B3"])
        for preset_name, rows in rows_by_preset.items():
            for r in rows:
                writer.writerow([preset_name, r[0], f"{r[1]:.6f}", *r[2:]])


def write_spreads_csv(spreads_by_preset: dict, spreads_csv_path: Path):
    with open(spreads_csv_path, "w", newline="", encoding="utf-8") as fp:
        writer = csv.writer(fp)
        writer.writerow(["preset", "stone", "C_spread", "F_spread", "T_spread", "Cr_spread", "B1_spread", "B2_spread", "B3_spread"])
        for preset_name, spread_rows in spreads_by_preset.items():
            for row in spread_rows:
                writer.writerow([preset_name, *row])


def write_raw_features_csv(hits: list, raw_features_csv_path: Path):
    with open(raw_features_csv_path, "w", newline="", encoding="utf-8") as fp:
        writer = csv.writer(fp)
        writer.writerow([
            "hit",
            "time_s",
            "centroid_hz",
            "flatness",
            "tilt",
            "crest",
            "trace1_hz",
            "trace2_hz",
            "trace3_hz",
        ])
        for k, t, feat in hits:
            writer.writerow([
                k,
                f"{t:.6f}",
                f"{feat['centroid']:.6f}",
                f"{feat['flatness']:.6f}",
                f"{feat['tilt']:.6f}",
                f"{feat['crest']:.6f}",
                f"{feat['trace_hz'][0]:.6f}",
                f"{feat['trace_hz'][1]:.6f}",
                f"{feat['trace_hz'][2]:.6f}",
            ])


def main():
    parser = argparse.ArgumentParser(description="Analyze stone-hit WAV and export feature/note comparison CSVs.")
    parser.add_argument("--wav", type=str, default=str(DEFAULT_WAV_PATH), help="Path to input WAV file")
    args = parser.parse_args()

    wav_path = Path(args.wav).expanduser().resolve()
    if not wav_path.exists():
        print(f"Input WAV not found: {wav_path}")
        raise SystemExit(1)

    hits_csv_path, spreads_csv_path, raw_features_csv_path = build_output_paths(wav_path)

    sr, x = read_wav_mono(wav_path)
    idx, env = rms_envelope(x, win=1024, hop=256)
    times = idx / sr
    env_db = dbfs_amp(env)
    onsets = detect_onsets(env_db, times)

    print(f"file={wav_path.name} sr={sr} len_s={len(x)/sr:.3f} detected_hits={len(onsets)}")

    hits = []
    for k, oi in enumerate(onsets, start=1):
        s = int(idx[oi])
        frames = feature_window(x, sr, s, WINDOW_MS)
        feat = analyze_hit(frames, sr)
        hits.append((k, float(times[oi]), feat))

    rows_by_preset = {}
    spreads_by_preset = {}
    for preset_name, preset in PRESETS.items():
        print(f"\n--- {preset_name.upper()} PRESET ---")
        rows = []
        for k, t, feat in hits:
            note_row = map_hit_to_notes(feat, preset)
            rows.append((k, t, *note_row))
        rows_by_preset[preset_name] = rows
        for r in rows:
            print("hit=%02d t=%.3f C=%d F=%d T=%d Cr=%d B1=%d B2=%d B3=%d" % r)
        spreads_by_preset[preset_name] = print_consistency(rows)

    write_hits_csv(rows_by_preset, hits_csv_path)
    write_spreads_csv(spreads_by_preset, spreads_csv_path)
    write_raw_features_csv(hits, raw_features_csv_path)
    print(f"\nwritten_csv_hits={hits_csv_path.name}")
    print(f"written_csv_spreads={spreads_csv_path.name}")
    print(f"written_csv_raw_features={raw_features_csv_path.name}")


if __name__ == "__main__":
    main()
