import subprocess
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
TARGET = BASE_DIR / "stones" / "run_stones_pipeline.py"


def main():
    if not TARGET.exists():
        print(f"Missing pipeline script: {TARGET}")
        raise SystemExit(1)

    cmd = [sys.executable, str(TARGET), *sys.argv[1:]]
    result = subprocess.run(cmd, cwd=str(BASE_DIR))
    raise SystemExit(result.returncode)


if __name__ == "__main__":
    main()
