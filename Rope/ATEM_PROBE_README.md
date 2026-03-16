# ATEM camera probe quick guide

This script tests ATEM camera-control read/write access and restores the original value after a short hold.

## Script location

- `atem_camera_probe.py`
- `atem_auto_calibrate.py`

## Run with Python 3.10 (PowerShell)

Use the full Python 3.10 path:

```powershell
& "C:\Users\obran\AppData\Local\Programs\Python\Python310\python.exe" -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --write-test
```

Optional convenience variable in the same terminal session:

```powershell
$py310 = "C:\Users\obran\AppData\Local\Programs\Python\Python310\python.exe"
& $py310 --version
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --write-test
```

Install project dependencies once for Python 3.10:

```powershell
& $py310 -m pip install -r "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\requirements-rope.txt"
```

## CLI options

```text
--ip <ATEM_IP>                required, ATEM IP address
--camera <INPUT_NUMBER>       required, ATEM camera/input destination
--collect-seconds <float>     initial read collection duration (default: 6.0)
--write-test                  perform one write and restore cycle
--target <mode>               auto|gain|iso|shutter|whitebalance (default: auto)
--step <int>                  change step size (default: 100)
--hold-seconds <float>        how long test value is held before restore (default: 2.0)
--write-timeout <float>       verification timeout for write/restore (default: 2.5)
```

## Common examples

Auto-pick a writable parameter (current behavior):

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --write-test --target auto
```

Force gain test, larger visible jump, hold for 3 seconds:

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --write-test --target gain --step 200 --hold-seconds 3
```

Try white balance temperature test (if decoded by ATEM state):

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --write-test --target whitebalance --step 200
```

Read-only snapshot without writing:

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_camera_probe.py" --ip 172.31.57.153 --camera 1 --collect-seconds 6
```

## Notes

- The script only writes when `--write-test` is present.
- It restores the original value after `--hold-seconds`.
- If a target cannot be tested with current decoded camera packets, output includes a `write_test.reason` message.

## Automatic calibration for rope tracking

`atem_auto_calibrate.py` scans candidate gain/ISO values, scores rope-visibility quality in the ROI, and applies the best result.

By default it now runs **extended** calibration (gain/ISO + color refinement) and automatically falls back to **simple** gain/ISO calibration if extended steps fail.

Default calibration run:

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_auto_calibrate.py" --ip 172.31.57.153 --camera 1 --video-device 1
```

Force simple calibration only:

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_auto_calibrate.py" --ip 172.31.57.153 --camera 1 --video-device 1 --strategy simple
```

Disable fallback (fail fast if extended fails):

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_auto_calibrate.py" --ip 172.31.57.153 --camera 1 --video-device 1 --no-fallback-simple
```

Use custom ISO candidates and longer sampling:

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_auto_calibrate.py" --ip 172.31.57.153 --camera 1 --video-device 1 --gain-values 100,200,300,400,500,600,800 --sample-seconds 2.5 --settle-seconds 1.0
```

Score only and restore original (no final apply):

```powershell
& $py310 -B "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\atem_auto_calibrate.py" --ip 172.31.57.153 --camera 1 --video-device 1 --no-apply-best
```

Calibration tips:

- Keep the rope moving while calibration runs.
- Keep framing and lighting stable during one calibration pass.
- Repeat calibration if the scene light level changes.
