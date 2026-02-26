import wave
import math
import csv
import argparse
from itertools import combinations
from datetime import datetime
from pathlib import Path
import numpy as np

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_WAV_PATH = BASE_DIR / "stones_rec_example.wav"

FFT_SIZE = 2048
HOP = FFT_SIZE // 8
WINDOW_MS = 120
REFRACTORY_MS = 180
NOISE_DB = -55.0

DEFAULT_BANDS = [(20, 500), (500, 1000), (1000, 3000)]
NBINS = [2, 2, 2]

DEFAULT_NOISE_DB = -55
DEFAULT_MIDI_ANALYSIS_MS = 120
DEFAULT_CREST_MAP_MAX = 140

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


def analyze_hit(frames: np.ndarray, sr: int, bands):
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

    lo_mask = (freqs >= bands[0][0]) & (freqs <= bands[0][1])
    hi_mask = (freqs >= bands[2][0]) & (freqs <= bands[2][1])
    tilt = float(math.log((np.sum(mag_mean[hi_mask]) + 1e-9) / (np.sum(mag_mean[lo_mask]) + 1e-9)))
    crest = float(np.max(mag_mean) / arith)

    trace_hz = []
    for (f0, f1), ntrace in zip(bands, NBINS):
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


def build_split_band_candidates(lo_floor: float, hi_ceiling: float, step_hz: float, min_width_hz: float):
    candidates = []
    b1_hi = lo_floor + min_width_hz
    while b1_hi <= hi_ceiling - (2 * min_width_hz):
        b2_hi = b1_hi + min_width_hz
        while b2_hi <= hi_ceiling - min_width_hz:
            candidates.append([
                (lo_floor, b1_hi),
                (b1_hi, b2_hi),
                (b2_hi, hi_ceiling),
            ])
            b2_hi += step_hz
        b1_hi += step_hz
    return candidates


def separation_score(rows):
    if len(rows) < 12:
        return -1e9, 0.0, 0.0

    groups = [rows[i:i + 3] for i in range(0, 12, 3)]
    group_arrays = [np.array([x[2:] for x in g], dtype=np.float64) for g in groups]
    centroids = [arr.mean(axis=0) for arr in group_arrays]

    within_vals = []
    for arr, centroid in zip(group_arrays, centroids):
        dists = np.sqrt(np.sum((arr - centroid) ** 2, axis=1))
        within_vals.append(float(np.mean(dists)))
    within = float(np.mean(within_vals))

    between_vals = []
    for c1, c2 in combinations(centroids, 2):
        between_vals.append(float(np.sqrt(np.sum((c1 - c2) ** 2))))
    between = float(np.mean(between_vals)) if between_vals else 0.0

    score = between - within
    return score, within, between


def evaluate_bands(hit_frames, sr: int, bands, preset: dict):
    rows = []
    for k, t, frames in hit_frames:
        feat = analyze_hit(frames, sr, bands)
        note_row = map_hit_to_notes(feat, preset)
        rows.append((k, t, *note_row))
    score, within, between = separation_score(rows)
    return score, within, between, rows


def build_output_paths(wav_path: Path, tag: str = ""):
    suffix = f"_{tag}" if tag else ""
    stem = f"{wav_path.stem}{suffix}"
    hits_csv = wav_path.with_name(f"{stem}_note_compare_hits.csv")
    spreads_csv = wav_path.with_name(f"{stem}_note_compare_spreads.csv")
    raw_features_csv = wav_path.with_name(f"{stem}_raw_features.csv")
    suggested_settings_txt = wav_path.with_name(f"{stem}_suggested_live_settings.txt")
    return hits_csv, spreads_csv, raw_features_csv, suggested_settings_txt


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


def write_suggested_settings_txt(bands, preset_after: dict, suggested_settings_path: Path):
    trace_ranges = preset_after["trace_note_ranges"]
    trace_transpose = preset_after["trace_transpose"]
    crest_map_max = preset_after["crest_max"]

    text = f"""Stones Session - Suggested Live Parameter Settings
=================================================

Auto-updated from analyze_stones.py
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

Use this as a manual checklist for applying the Python/offline tuning in:
  stones/pvstrace_3band.csd

A) Main recommended values (current tuned baseline)
----------------------------------------------------
1) Noise gate and timing
    - NoiseFloorDb = {DEFAULT_NOISE_DB}
    - MidiAnalysisMs = {DEFAULT_MIDI_ANALYSIS_MS}

2) Band split frequencies (affect Trace MIDI B1/B2/B3)
    - Lo1 = {bands[0][0]:.1f}
    - Hi1 = {bands[0][1]:.1f}
    - Lo2 = {bands[1][0]:.1f}
    - Hi2 = {bands[1][1]:.1f}
    - Lo3 = {bands[2][0]:.1f}
    - Hi3 = {bands[2][1]:.1f}

3) Trace MIDI ranges/transposition
    - MidiTrace1Lo = {trace_ranges[0][0]}
    - MidiTrace1Hi = {trace_ranges[0][1]}
    - MidiTrace1Trsp = {trace_transpose[0]}

    - MidiTrace2Lo = {trace_ranges[1][0]}
    - MidiTrace2Hi = {trace_ranges[1][1]}
    - MidiTrace2Trsp = {trace_transpose[1]}

    - MidiTrace3Lo = {trace_ranges[2][0]}
    - MidiTrace3Hi = {trace_ranges[2][1]}
    - MidiTrace3Trsp = {trace_transpose[2]}

4) Feature mapping limits
    - CrestMapMax = {crest_map_max}
      (GUI slider \"CrMapMax\"; feature-domain max for crest mapping)

B) Optional per-recording tweaks
--------------------------------
If notes are saturating at top/bottom:
- Widen Lo/Hi ranges first (especially MidiTrace2Hi / MidiTrace3Hi)

If gate triggers too often on noise:
- Raise NoiseFloorDb (less negative), e.g. -52 to -48

If triggers feel unstable/jittery:
- Increase MidiAnalysisMs, e.g. 140-180

If response feels too slow:
- Reduce MidiAnalysisMs, e.g. 80-100

C) Quick apply order in UI
--------------------------
1. Set NoiseFloorDb and MidiAnalysisMs
2. Set Lo1/Hi1, Lo2/Hi2, Lo3/Hi3
3. Set B1/B2/B3 Lo/Hi/Trsp values
4. Set CrestMapMax (CrMapMax) to {crest_map_max}
5. Test with your recording and adjust only one control at a time

D) Python band-split parameters (match live Lo/Hi channels)
-----------------------------------------------------------
  --lo1 {bands[0][0]:.1f} --hi1 {bands[0][1]:.1f} --lo2 {bands[1][0]:.1f} --hi2 {bands[1][1]:.1f} --lo3 {bands[2][0]:.1f} --hi3 {bands[2][1]:.1f}

E) Notes
--------
- Python analysis does not auto-write to the live Csound patch.
- This file is auto-generated as the manual transfer checklist.
"""

    with open(suggested_settings_path, "w", encoding="utf-8") as fp:
        fp.write(text)


def main():
    parser = argparse.ArgumentParser(description="Analyze stone-hit WAV and export feature/note comparison CSVs.")
    parser.add_argument("--wav", type=str, default=str(DEFAULT_WAV_PATH), help="Path to input WAV file")
    parser.add_argument("--lo1", type=float, default=DEFAULT_BANDS[0][0], help="Band 1 low frequency (Hz)")
    parser.add_argument("--hi1", type=float, default=DEFAULT_BANDS[0][1], help="Band 1 high frequency (Hz)")
    parser.add_argument("--lo2", type=float, default=DEFAULT_BANDS[1][0], help="Band 2 low frequency (Hz)")
    parser.add_argument("--hi2", type=float, default=DEFAULT_BANDS[1][1], help="Band 2 high frequency (Hz)")
    parser.add_argument("--lo3", type=float, default=DEFAULT_BANDS[2][0], help="Band 3 low frequency (Hz)")
    parser.add_argument("--hi3", type=float, default=DEFAULT_BANDS[2][1], help="Band 3 high frequency (Hz)")
    parser.add_argument("--auto-bands", action="store_true", help="Auto-tune contiguous band split points for better stone separation")
    parser.add_argument("--auto-step", type=float, default=100.0, help="Hz step for auto band search")
    parser.add_argument("--auto-min-width", type=float, default=250.0, help="Minimum width per auto band (Hz)")
    parser.add_argument("--auto-topk", type=int, default=5, help="Number of top auto-band candidates to print")
    parser.add_argument("--tag", type=str, default="", help="Optional suffix tag to keep outputs from different runs")
    args = parser.parse_args()

    wav_path = Path(args.wav).expanduser().resolve()
    if not wav_path.exists():
        print(f"Input WAV not found: {wav_path}")
        raise SystemExit(1)

    bands = [
        (float(args.lo1), float(args.hi1)),
        (float(args.lo2), float(args.hi2)),
        (float(args.lo3), float(args.hi3)),
    ]
    for index, (lo_freq, hi_freq) in enumerate(bands, start=1):
        if lo_freq < 0 or hi_freq <= lo_freq:
            print(f"Invalid band {index}: lo={lo_freq}, hi={hi_freq} (require lo>=0 and hi>lo)")
            raise SystemExit(1)

    hits_csv_path, spreads_csv_path, raw_features_csv_path, suggested_settings_path = build_output_paths(wav_path, args.tag)

    sr, x = read_wav_mono(wav_path)
    idx, env = rms_envelope(x, win=1024, hop=256)
    times = idx / sr
    env_db = dbfs_amp(env)
    onsets = detect_onsets(env_db, times)

    print(f"file={wav_path.name} sr={sr} len_s={len(x)/sr:.3f} detected_hits={len(onsets)}")
    hit_frames = []
    for k, oi in enumerate(onsets, start=1):
        s = int(idx[oi])
        frames = feature_window(x, sr, s, WINDOW_MS)
        hit_frames.append((k, float(times[oi]), frames))

    if args.auto_bands:
        auto_candidates = build_split_band_candidates(
            lo_floor=float(args.lo1),
            hi_ceiling=float(args.hi3),
            step_hz=float(args.auto_step),
            min_width_hz=float(args.auto_min_width),
        )
        if len(auto_candidates) == 0:
            print("auto-bands: no valid candidates from current bounds; check --lo1/--hi3/--auto-step/--auto-min-width")
            raise SystemExit(1)

        auto_results = []
        for band_candidate in auto_candidates:
            score, within, between, _ = evaluate_bands(hit_frames, sr, band_candidate, PRESETS["after"])
            auto_results.append((score, within, between, band_candidate))
        auto_results.sort(key=lambda x: x[0], reverse=True)

        best_score, best_within, best_between, best_bands = auto_results[0]
        bands = best_bands
        print(f"auto-bands: tested={len(auto_candidates)} best_score={best_score:.3f} within={best_within:.3f} between={best_between:.3f}")
        print(
            "auto-bands best="
            f"Lo1:{bands[0][0]:.1f}-Hi1:{bands[0][1]:.1f}, "
            f"Lo2:{bands[1][0]:.1f}-Hi2:{bands[1][1]:.1f}, "
            f"Lo3:{bands[2][0]:.1f}-Hi3:{bands[2][1]:.1f}"
        )
        top_k = max(1, int(args.auto_topk))
        print(f"auto-bands top{top_k}:")
        for rank, (score, within, between, band_candidate) in enumerate(auto_results[:top_k], start=1):
            print(
                f"  #{rank} score={score:.3f} within={within:.3f} between={between:.3f} "
                f"| [{band_candidate[0][0]:.0f},{band_candidate[0][1]:.0f}] "
                f"[{band_candidate[1][0]:.0f},{band_candidate[1][1]:.0f}] "
                f"[{band_candidate[2][0]:.0f},{band_candidate[2][1]:.0f}]"
            )

    print(
        "bands="
        f"Lo1:{bands[0][0]:.1f}-Hi1:{bands[0][1]:.1f}, "
        f"Lo2:{bands[1][0]:.1f}-Hi2:{bands[1][1]:.1f}, "
        f"Lo3:{bands[2][0]:.1f}-Hi3:{bands[2][1]:.1f}"
    )

    hits = []
    for k, t, frames in hit_frames:
        feat = analyze_hit(frames, sr, bands)
        hits.append((k, t, feat))

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
    write_suggested_settings_txt(bands, PRESETS["after"], suggested_settings_path)
    print(f"\nwritten_csv_hits={hits_csv_path.name}")
    print(f"written_csv_spreads={spreads_csv_path.name}")
    print(f"written_csv_raw_features={raw_features_csv_path.name}")
    print(f"written_settings={suggested_settings_path.name}")


if __name__ == "__main__":
    main()
