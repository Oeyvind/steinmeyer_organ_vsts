# Rope + ATEM setup guide

This project now uses one Python virtual environment for:
- camera control probe (`atem_camera_probe.py`)
- auto-calibration (`atem_auto_calibrate.py`)
- rope tracking (`rope.py`)

## 1) Create the virtual environment (one-time)

From PowerShell:

```powershell
& "C:\Users\obran\AppData\Local\Programs\Python\Python310\python.exe" -m venv "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\.venv"
& "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\.venv\Scripts\python.exe" -m pip install -r "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\requirements-rope.txt"
```

## 2) Activate the virtualenv

```powershell
cd "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope"
.\.venv\Scripts\Activate.ps1
```

If activation is blocked by policy, run scripts with explicit venv python instead:

```powershell
$py = "c:\Cabbage_VST\CabbageEfx\midiplugs\domen_ai\Rope\.venv\Scripts\python.exe"
& $py --version
```

## 3) Run camera probe

```powershell
python -B .\atem_camera_probe.py --ip 172.31.57.153 --camera 1 --write-test --target gain --step 200 --hold-seconds 3
```

(Without activation, replace `python` with `& $py`.)

## 4) Run stand-alone auto-calibration

Startup-style static baseline (rope not moving):

```powershell
python -B .\atem_auto_calibrate.py --ip 172.31.57.153 --camera 1 --video-device 1 --mode static
```

Motion refinement (while moving rope):

```powershell
python -B .\atem_auto_calibrate.py --ip 172.31.57.153 --camera 1 --video-device 1 --mode motion
```

## 5) Run rope tracking

```powershell
python -B .\rope.py
```

Run from the recorded test video instead of live camera input:

```powershell
python -B .\rope.py --use-recorded-video
```

In recorded-video mode, playback loops automatically.

Skip startup calibration when you want instant launch:

```powershell
python -B .\rope.py --skip-init-calibration
```

### New calibration behavior in `rope.py`

- On program start, `rope.py` runs ATEM calibration in `static` mode with **extended strategy** as default.
- Extended strategy automatically falls back to simple gain/ISO calibration if extended color refinement fails.
- Calibration now enforces shutter speed to `1/75` (when available) and triggers ATEM auto white balance before scoring.
- While running, press `c` to run a `motion` recalibration pass (intended while you move the rope).
- Press `q` to quit.

### Test video recording controls

- Press `r` to start recording raw camera input to `test_video.avi`.
- Press `t` to stop recording.
- Recording auto-stops after 60 seconds.
- Recording is written before rope processing.
- The saved file is grayscale to reduce disk usage.
- If `test_video.avi` already exists, the first `r` press only arms overwrite; press `r` again to actually overwrite and start recording.

### Tracking filter controls and stage readability

The tracker now includes additional robustness filters and layered stage rendering:

- `g` toggles background-model differencing (`lowpass_over_time`) on/off.
- `e` toggles screen-blend equalization on/off.
- `k` toggles kinematic continuity constraints on/off (rejects implausible rope shape jumps before fill/interpolation).
- Default startup state is now: median ON, lowpass ON, equalization OFF.
- Peak/zero-cross analysis now uses center-line residual gating (minimum amplitude, prominence, and spacing) to suppress wiggle/noise detections.

FFT analysis now uses selected spatial-cycle bins per image width:

- `0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 7, 8, 9, 10, 12, 16, 20` cycles.
- Existing OSC `fft_bin` output sends these 16 normalized values.
- Additional OSC `fft_hf` sends the aggregated high-frequency content above `20` cycles (useful as tracking-noise indicator).
- Scalar rope metrics are bundled in `rope_metrics` (peak stats, lobe stats, activity, spectral centroid, shape centroid).

Display layering is now ordered so earlier stages are drawn first and later stages are drawn on top.
Binary is shown as a translucent cyan tint instead of opaque white, so it does not hide later traces.
Wave traces use staged line widths to maintain visual distinction across fill/median/lowpass/final layers.

Pause behavior (`p`) with filter toggles:

- While paused, no new frames are captured.
- Per-frame processing can still be re-evaluated for the frozen frame when toggling options.
- The temporal background accumulator used by `lowpass_over_time` is frozen while paused, so background state does not drift during pause.
- `s` still steps exactly one frame when paused.

### Calibration progress output

Calibration now prints progress so it does not look frozen, for example:

- `waiting for ATEM switcher reply on network`
- `collecting initial ATEM camera packets`
- `scanning N ISO candidates (estimated Xs)`
- per-candidate score lines with range/sharpness/clipping values
- extended phase scan progress and fallback notice (if needed)

This makes the slow steps visible. The most time-consuming stages are:

- network waits for camera control/state updates from ATEM
- per-candidate settle + sample windows
- extended color refinement candidate sweep

To run faster, candidate sweeps are reduced:

- ISO candidates are pruned to a smaller set around current ISO.
- Extended color refinement tests fewer contrast/saturation combinations.

## 6) Config values you may want to edit

At the top of `rope.py`:
- `video_device`
- `atem_enable_calibration`
- `atem_ip`
- `atem_camera_input`
- `atem_gain_values`
- calibration timing values (`atem_collect_seconds`, `atem_settle_seconds`, `atem_sample_seconds_static`, `atem_sample_seconds_motion`)

## 7) Quick troubleshooting

- If ATEM does not connect, verify the IP and network route first.
- If camera device fails to open, change `video_device` (`0`, `1`, `2`, ...).
- If calibration output is noisy, increase `--sample-seconds` and keep framing constant.
- If your scene lighting changes, rerun calibration (`c` in `rope.py` or standalone `atem_auto_calibrate.py`).

## 8) How calibration quality is measured

The scoring now includes the criteria you suggested:

- **Dynamic range**: percentile spread of ROI pixels (approx darkest-to-brightest useful range)
- **Sharpness**: Laplacian-variance-based focus/detail metric in the ROI
- **Clipping penalty**: penalizes too many near-black or near-white pixels
- **Brightness balance penalty**: penalizes mean brightness far from mid-range

Additional anti-overexposure guard:

- Final ISO selection prefers candidates under brightness/clipping safety thresholds, even if a brighter setting has similar score.

For motion mode, these are combined with motion coverage/activity so tracking features remain visible while rope moves.
