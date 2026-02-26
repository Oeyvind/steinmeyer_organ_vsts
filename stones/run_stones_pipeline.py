import subprocess
import sys
import argparse
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
ANALYZE_SCRIPT = BASE_DIR / "analyze_stones.py"
PLOT_SCRIPT = BASE_DIR / "plot_stones_analysis.py"
DEFAULT_WAV_PATH = BASE_DIR / "stones_rec_example.wav"


def run_step(script_path: Path, title: str, wav_path: Path):
    print(f"\n=== {title} ===")
    cmd = [sys.executable, str(script_path), "--wav", str(wav_path)]
    result = subprocess.run(cmd, cwd=str(BASE_DIR))
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def main():
    parser = argparse.ArgumentParser(description="Run stone analysis and plotting pipeline for a WAV file.")
    parser.add_argument("--wav", type=str, default=str(DEFAULT_WAV_PATH), help="Path to WAV file")
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

    run_step(ANALYZE_SCRIPT, "Running analyzer", wav_path)
    run_step(PLOT_SCRIPT, "Generating plots", wav_path)

    print("\nPipeline complete.")


if __name__ == "__main__":
    main()
