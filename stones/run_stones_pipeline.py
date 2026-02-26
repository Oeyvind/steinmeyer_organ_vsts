import subprocess
import sys
import argparse
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
ANALYZE_SCRIPT = BASE_DIR / "analyze_stones.py"
PLOT_SCRIPT = BASE_DIR / "plot_stones_analysis.py"
DEFAULT_WAV_PATH = BASE_DIR / "stones_rec_example.wav"
DEFAULT_BANDS = [(20.0, 500.0), (500.0, 1000.0), (1000.0, 3000.0)]


def run_step(script_path: Path, title: str, wav_path: Path, args: argparse.Namespace):
    print(f"\n=== {title} ===")
    cmd = [sys.executable, str(script_path), "--wav", str(wav_path)]
    if args.tag:
        cmd += ["--tag", str(args.tag)]
    if script_path == ANALYZE_SCRIPT:
        cmd += [
            "--lo1", str(args.lo1),
            "--hi1", str(args.hi1),
            "--lo2", str(args.lo2),
            "--hi2", str(args.hi2),
            "--lo3", str(args.lo3),
            "--hi3", str(args.hi3),
        ]
        if args.auto_bands:
            cmd += [
                "--auto-bands",
                "--auto-step", str(args.auto_step),
                "--auto-min-width", str(args.auto_min_width),
                "--auto-topk", str(args.auto_topk),
            ]
    result = subprocess.run(cmd, cwd=str(BASE_DIR))
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def main():
    parser = argparse.ArgumentParser(description="Run stone analysis and plotting pipeline for a WAV file.")
    parser.add_argument("--wav", type=str, default=str(DEFAULT_WAV_PATH), help="Path to WAV file")
    parser.add_argument("--lo1", type=float, default=DEFAULT_BANDS[0][0], help="Band 1 low frequency (Hz)")
    parser.add_argument("--hi1", type=float, default=DEFAULT_BANDS[0][1], help="Band 1 high frequency (Hz)")
    parser.add_argument("--lo2", type=float, default=DEFAULT_BANDS[1][0], help="Band 2 low frequency (Hz)")
    parser.add_argument("--hi2", type=float, default=DEFAULT_BANDS[1][1], help="Band 2 high frequency (Hz)")
    parser.add_argument("--lo3", type=float, default=DEFAULT_BANDS[2][0], help="Band 3 low frequency (Hz)")
    parser.add_argument("--hi3", type=float, default=DEFAULT_BANDS[2][1], help="Band 3 high frequency (Hz)")
    parser.add_argument("--auto-bands", action="store_true", help="Auto-tune contiguous band split points")
    parser.add_argument("--auto-step", type=float, default=100.0, help="Hz step for auto band search")
    parser.add_argument("--auto-min-width", type=float, default=250.0, help="Minimum width per auto band (Hz)")
    parser.add_argument("--auto-topk", type=int, default=5, help="Top band candidates to print")
    parser.add_argument("--tag", type=str, default="", help="Optional suffix tag so outputs are not overwritten")
    args = parser.parse_args()

    wav_path = Path(args.wav).expanduser().resolve()
    if not wav_path.exists():
        print(f"Input WAV not found: {wav_path}")
        raise SystemExit(1)

    if not ANALYZE_SCRIPT.exists():
        print(f"Missing: {ANALYZE_SCRIPT.name}")
        raise SystemExit(1)
    if not PLOT_SCRIPT.exists():
        print(f"Missing: {PLOT_SCRIPT.name}")
        raise SystemExit(1)

    run_step(ANALYZE_SCRIPT, "Running analyzer", wav_path, args)
    run_step(PLOT_SCRIPT, "Generating plots", wav_path, args)

    print("\nPipeline complete.")


if __name__ == "__main__":
    main()
