import csv
import argparse
from pathlib import Path

try:
    import matplotlib.pyplot as plt
except Exception:
    print("matplotlib is required. Install with: pip install matplotlib")
    raise SystemExit(0)

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_WAV = BASE_DIR / "stones_rec_example.wav"


def build_paths(base_wav: Path):
    raw_csv = base_wav.with_name(f"{base_wav.stem}_raw_features.csv")
    hits_csv = base_wav.with_name(f"{base_wav.stem}_note_compare_hits.csv")
    spreads_csv = base_wav.with_name(f"{base_wav.stem}_note_compare_spreads.csv")
    raw_png = base_wav.with_name(f"{base_wav.stem}_raw_features.png")
    notes_png = base_wav.with_name(f"{base_wav.stem}_notes_compare.png")
    spreads_png = base_wav.with_name(f"{base_wav.stem}_spreads_compare.png")
    return raw_csv, hits_csv, spreads_csv, raw_png, notes_png, spreads_png


def read_raw_features(path: Path):
    rows = []
    with open(path, "r", newline="", encoding="utf-8") as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            rows.append({
                "hit": int(row["hit"]),
                "time_s": float(row["time_s"]),
                "centroid_hz": float(row["centroid_hz"]),
                "flatness": float(row["flatness"]),
                "tilt": float(row["tilt"]),
                "crest": float(row["crest"]),
                "trace1_hz": float(row["trace1_hz"]),
                "trace2_hz": float(row["trace2_hz"]),
                "trace3_hz": float(row["trace3_hz"]),
            })
    return rows


def read_hits_compare(path: Path):
    by_preset = {}
    with open(path, "r", newline="", encoding="utf-8") as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            preset = row["preset"]
            by_preset.setdefault(preset, []).append({
                "hit": int(row["hit"]),
                "C": int(row["C"]),
                "F": int(row["F"]),
                "T": int(row["T"]),
                "Cr": int(row["Cr"]),
                "B1": int(row["B1"]),
                "B2": int(row["B2"]),
                "B3": int(row["B3"]),
            })
    return by_preset


def read_spreads_compare(path: Path):
    by_preset = {}
    with open(path, "r", newline="", encoding="utf-8") as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            preset = row["preset"]
            by_preset.setdefault(preset, []).append({
                "stone": int(row["stone"]),
                "C": int(row["C_spread"]),
                "F": int(row["F_spread"]),
                "T": int(row["T_spread"]),
                "Cr": int(row["Cr_spread"]),
                "B1": int(row["B1_spread"]),
                "B2": int(row["B2_spread"]),
                "B3": int(row["B3_spread"]),
            })
    return by_preset


def plot_raw_features(rows, out_path: Path):
    hits = [r["hit"] for r in rows]

    fig, axes = plt.subplots(3, 2, figsize=(12, 10), sharex=True)
    axes = axes.ravel()

    axes[0].plot(hits, [r["centroid_hz"] for r in rows], marker="o")
    axes[0].set_title("Centroid (Hz)")

    axes[1].plot(hits, [r["flatness"] for r in rows], marker="o")
    axes[1].set_title("Flatness")

    axes[2].plot(hits, [r["tilt"] for r in rows], marker="o")
    axes[2].set_title("Tilt")

    axes[3].plot(hits, [r["crest"] for r in rows], marker="o")
    axes[3].set_title("Crest")

    axes[4].plot(hits, [r["trace1_hz"] for r in rows], marker="o", label="Trace1")
    axes[4].plot(hits, [r["trace2_hz"] for r in rows], marker="o", label="Trace2")
    axes[4].plot(hits, [r["trace3_hz"] for r in rows], marker="o", label="Trace3")
    axes[4].set_title("Trace Frequencies (Hz)")
    axes[4].legend()

    axes[5].axis("off")

    for ax in axes:
        ax.grid(True, alpha=0.25)
    fig.suptitle("Raw Features per Hit")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def plot_notes_compare(by_preset, out_path: Path):
    if "before" not in by_preset or "after" not in by_preset:
        return

    rows_before = sorted(by_preset["before"], key=lambda r: r["hit"])
    rows_after = sorted(by_preset["after"], key=lambda r: r["hit"])
    hits = [r["hit"] for r in rows_before]

    fields = ["C", "F", "T", "Cr", "B1", "B2", "B3"]
    fig, axes = plt.subplots(4, 2, figsize=(12, 12), sharex=True)
    axes = axes.ravel()

    for i, field in enumerate(fields):
        ax = axes[i]
        ax.plot(hits, [r[field] for r in rows_before], marker="o", label="before")
        ax.plot(hits, [r[field] for r in rows_after], marker="o", label="after")
        ax.set_title(field)
        ax.grid(True, alpha=0.25)
        if i == 0:
            ax.legend()

    axes[-1].axis("off")
    fig.suptitle("Mapped Notes per Hit: Before vs After")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def plot_spreads_compare(by_preset, out_path: Path):
    if "before" not in by_preset or "after" not in by_preset:
        return

    before = sorted(by_preset["before"], key=lambda r: r["stone"])
    after = sorted(by_preset["after"], key=lambda r: r["stone"])

    fields = ["C", "F", "T", "Cr", "B1", "B2", "B3"]
    stones = [r["stone"] for r in before]

    fig, axes = plt.subplots(4, 2, figsize=(12, 12), sharex=True)
    axes = axes.ravel()

    for i, field in enumerate(fields):
        ax = axes[i]
        x = list(range(len(stones)))
        width = 0.38
        ax.bar([v - width / 2 for v in x], [r[field] for r in before], width=width, label="before")
        ax.bar([v + width / 2 for v in x], [r[field] for r in after], width=width, label="after")
        ax.set_xticks(x)
        ax.set_xticklabels([f"stone{s}" for s in stones])
        ax.set_title(f"{field} spread")
        ax.grid(True, axis="y", alpha=0.25)
        if i == 0:
            ax.legend()

    axes[-1].axis("off")
    fig.suptitle("Within-Stone Spread: Before vs After")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description="Plot analyzer CSV outputs for a given WAV stem.")
    parser.add_argument("--wav", type=str, default=str(DEFAULT_WAV), help="Path to WAV used for CSV naming")
    args = parser.parse_args()

    base_wav = Path(args.wav).expanduser().resolve()
    raw_csv, hits_csv, spreads_csv, raw_png, notes_png, spreads_png = build_paths(base_wav)

    missing = [p for p in [raw_csv, hits_csv, spreads_csv] if not p.exists()]
    if missing:
        print("Missing input CSV files:")
        for p in missing:
            print(f" - {p.name}")
        print("Run analyze_stones.py first.")
        return

    raw_rows = read_raw_features(raw_csv)
    hits_by_preset = read_hits_compare(hits_csv)
    spreads_by_preset = read_spreads_compare(spreads_csv)

    plot_raw_features(raw_rows, raw_png)
    plot_notes_compare(hits_by_preset, notes_png)
    plot_spreads_compare(spreads_by_preset, spreads_png)

    print(f"written_plot_raw={raw_png.name}")
    print(f"written_plot_notes={notes_png.name}")
    print(f"written_plot_spreads={spreads_png.name}")


if __name__ == "__main__":
    main()
