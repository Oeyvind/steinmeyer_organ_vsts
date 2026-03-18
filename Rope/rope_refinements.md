# Rope refinements

This document started as an initial analysis pass and has since been updated to reflect implemented changes.

## 1. Current functionality summary

### Python analysis in rope.py

- Video is captured from camera index 1 (`video_device = 1`) and converted to grayscale.
- Motion is extracted by subtracting the previous grayscale frame from the current frame.
- Analysis is limited to a polygon mask, so the rope is expected to stay inside a manually defined quadrilateral region.
- The masked motion image is blurred and hard-thresholded to create a binary motion silhouette.
- For each image column, the script finds the mean y position of active pixels. This becomes a 1D rope trace.
- Missing points in the 1D trace are filled by linear interpolation so the rope curve becomes continuous enough for later analysis.
- A center line is estimated by linear regression across the rope trace inside the masked region.
- Peaks are extracted from the residual (`wave_1D - center_wave`) using amplitude + prominence + minimum-distance gating (noise-robust lobe detection).
- Zero crossings are derived from significant-lobe structure, including edge crossings between ROI borders and first/last significant peaks when the residual crosses the center line.
- Additional derived measures are extracted:
  - number of significant peaks
  - average horizontal distance between peaks
  - average horizontal movement across sorted peaks
  - normalized x positions of peaks
  - normalized distances between adjacent peaks
  - zero crossing positions relative to the center line
  - distances between zero crossings
  - FFT bins of the 1D rope curve
  - 10 fixed-position fader samples taken from the rope curve
  - perceptual wave activity from the extracted rope profile, weighted toward recent profile motion and secondarily toward current rope excursion

### OSC data sent from Python to Csound

- `rope_metrics`: bundled scalar metrics in one message (peak stats + shape stats + activity + spectral centroid + shape centroid).
- `xpos`: normalized peak x positions.
- `xdistance`: normalized spacing between adjacent peaks.
- `zerocross`: zero crossing positions.
- `zerocross_distance`: spacing between zero crossings.
- `fft_bin`: the first 16 FFT bins of the rope curve.
- `fft_hf`: aggregated high-frequency FFT energy above the configured cycle threshold.
- `faders`: 10 sampled rope values.

### Csound mapping in rope_midi.csd

The Csound side receives OSC into global arrays and channels, then uses several independent instruments:

- Wave shape oscillators:
  - `Wave_raw_on` and `Wave_fine_on` drive audio oscillators that use the sampled rope curve as a waveshaping table.
  - These appear to be audio-only in the current file.
- Peak count to MIDI:
  - `Wave_numpeaks` triggers a MIDI note whenever the number of peaks changes.
  - Note number = base note + number of peaks.
- Zero crossings to MIDI:
  - `Wave_zerocross` triggers a MIDI note whenever the zero-crossing count changes.
  - Note number = base note + zero-crossing count.
- Distance-grain module:
  - `Distance_grain` uses peak spacing data to drive a granular audio texture.
  - Grain sync pulses are converted to MIDI notes through `partikkelsync`.
  - MIDI note output depends on grain playback frequency, threshold, transpose, and channel settings.
- Grain cloud module:
  - `Grain2` uses activity, fader extremes, average movement, and peak count to drive an asynchronous granular cloud.
  - Grain pulses are also converted to MIDI notes, with per-voice thresholds, transpose, and MIDI channels.
- Fader bank oscillator module:
  - `Fader_bank` maps the 10 rope fader samples to a scale-constrained oscillator bank.
  - MIDI note-on and note-off events are generated when each oscillator amplitude crosses a threshold.
- Stop chord:
  - `Stopchord` listens for a drop in wave activity after previous motion and generates an audio chord based on extrema from peak, x-position, and zero-crossing data.
  - This appears to be audio-only in the current file.
- Stop_LSYS:
  - `Stop_LSYS` also listens for a stopping gesture.
  - It sets the L-system root from delayed peak count and triggers MIDI-driven L-system playback.
- L-system include file:
  - The include file `lsys_cs_midi.inc` generates recursive note patterns and outputs MIDI via instrument 201.
  - It also contains a sound generator instrument 131, but its audio output line is commented out, so it is currently silent.

## 2. Suggested CPU and realtime optimizations

### Python-side optimizations

- Replace the per-column Python loop in centroid extraction with a vectorized approach if possible. This loop is one of the most obvious per-frame hotspots.
- The display layer draws many circles and large text strings every frame. This is likely a significant part of the frame cost and should be made optional or decimated.
- OSC is sent as many small messages per frame. This creates overhead on both Python and Csound. Packing related arrays into fewer OSC messages would reduce traffic and parsing cost.
- The FFT should remain a per-frame calculation if it is being used as an instantaneous descriptor of the rope's current spatial shape. The optimization question is therefore not mainly update rate, but whether the current FFT implementation and downstream OSC packaging are as efficient as they could be. A lower FFT update rate only makes sense if a specific downstream mapping or display can tolerate temporally decimated spatial-shape data.
- The center-line estimate should also remain a per-frame calculation, because the rope's global tilt and offset change with the shape. The useful optimization question here is whether `np.polyfit` is the cheapest correct estimator for the needed center line, not whether the center line should be updated less often.
- The code allocates several arrays every frame, including `wave_img`, `wave_1D`, `faders`, string-built display lines, and FFT-derived arrays. Reusing buffers would reduce allocation churn.
- `median_filter` and Butterworth lowpass are now active in the frame loop; `sosfiltfilt` remains imported but unused and can still be removed.
- The `noise_gate` and `diff_thresh` logic is currently disabled scaffolding. It adds complexity without changing behavior.
- The code reads the camera before checking whether `ret` is valid. That is a robustness issue more than a CPU issue, but it should be fixed before more optimization work.
- The main frame-difference method only measures one subtraction direction. That may be intentional, but if not, an absolute difference could be more stable. It may slightly increase cost, so this should be treated as a tradeoff.

### Csound-side optimizations

- The biggest Csound cost is likely the granular processing in instruments 12 and 13. `partikkel` plus recursive multi-voice opcodes (`DistanceGrains`, `Graincloud`, `OscBank`) will dominate CPU compared with simpler MIDI mappers.
- In `rope_midi.csd`, those recursive opcode definitions/calls occur at:
  - `DistanceGrains`: definition around line 641, self-recursive call around line 769, used by instr 12 around line 799.
  - `Graincloud`: definition around line 804, self-recursive call around line 937, used by instr 13 around line 975.
  - `OscBank`: definition around line 979, self-recursive call around line 1011, used by instr 16/17 around lines 1029 and 1096.
- Instrument 1 parses many OSC messages every control cycle using repeated `OSClisten` loops. Reducing message count on the Python side would help Csound immediately.
- There are several real-time console prints in active code paths. These should be disabled in performance mode:
  - `puts "OK OSC received"`
  - various `print` and `printk2` statements in instruments and opcodes
- Instrument 2 rebuilds fine wave tables whenever a full fader frame arrives. That is probably acceptable at 20 fps, but it is still a repeated table-generation cost.
- Instrument 17 smooths 10 fader entries with 10 repeated `EnvFollow` calls. A loop would be cleaner and easier to maintain, though the CPU gain will be modest.
- Several audio modules appear to remain in the file even when their widgets are missing or the module is inaccessible. Removing dead modules will reduce maintenance burden and may reduce accidental runtime activity.
- The L-system audio instrument 131 is still present even though its audio output is commented out. If the intention is MIDI-only, it is a candidate for removal or explicit disabling.

### Potential multithread options

- If analysis load increases, the cleanest split is:
  - one thread/process for camera capture
  - one thread/process for rope analysis
  - one thread/process for OSC output and UI display
- Python threading may help for camera I/O and display coordination, but CPU-heavy numeric work benefits more from vectorization or separate processes than from threads because of the GIL.
- A practical first step would be to separate display rendering from analysis, so the core analysis can keep running at a stable realtime rate even if the UI falls behind.

## 3. Analysis display readability

The current overlay is information-rich but hard to scan in realtime.

### Current display issues

- Too many overlays are drawn directly on top of the video image.
- The stats text lines become very long and can be hard to read while the image updates.
- Long `x_pos`, `x_dist`, and zero-crossing text lines can still crowd the panel even with the transparent background.
- FFT dots, stats text, fader labels, and peak IDs compete for the same visual space.
- Zero-crossing and x-distance lists are printed as long strings, which are difficult to parse in motion.

### Suggested display refinements

- Split the display into panels:
  - camera + rope overlay
  - compact stats panel
  - small graph panel for FFT or recent activity history
- Make the default view minimal and expose advanced overlays only on demand.
- Replace long numeric text lists with compact bar graphs or sparklines.
- Use one consistent color legend and group related overlays by color family.
- Add an explicit ROI label and center-line label so the most important tracking geometry is immediately readable.
- Add a simple one-line status block with:
  - fps target
  - measured processing time
  - number of peaks
  - activity
  - OSC send status
- Consider downsampling or truncating displayed arrays so only the most informative values are shown.

## 4. Possible extensions and refinements

### Additional rope analysis features

- Estimate temporal frequency per peak by measuring peak motion over time rather than frame-to-frame x movement only.
- Track peak lifetimes and stability, not just current positions.
- Measure rope curvature or local curvature maxima, not only signed height relative to a center line.
- Estimate wavelength more directly from peak spacing and zero-crossing spacing and smooth it over time.
- Measure asymmetry between positive and negative lobes.
- Compute center-of-energy or motion centroid over time for gesture-like motion detection.
- Detect distinct states such as rest, traveling wave, standing wave, chaotic motion, and single impulse.
- Track left-to-right versus right-to-left wave propagation using time-delayed correlation.
- If general wave direction is more important than per-peak identity, consider replacing some or all of the current peak-ID tracking with a lower-dimensional motion estimate derived from FFT phase change, cross-spectrum phase slope, or frame-to-frame correlation of the 1D rope trace. This would likely be a better fit for global propagation direction than explicit peak identity tracking, but it would not replace the current "new peak appeared" event logic by itself.
- Compute activity in subregions of the rope so different rope segments can drive different sound layers.
- Use a temporal buffer of recent frames to extract more stable phase or periodicity estimates.

### New mapping ideas to sound and MIDI

- Use propagation direction to control note order, arpeggiation direction, or MIDI pan/channel allocation.
- Map wavelength to scale degree spacing or chord density.
- Use curvature or lobe asymmetry to control articulation, velocity accent, or note duration.
- Use peak lifetime and stability to choose between sustained notes and short triggers.
- Use rope segment zones to drive independent MIDI channels or independent synth layers.
- Use state detection to switch between mapping modes automatically, for example:
  - steady periodic rope motion -> clocked note stream
  - sharp impulses -> drum triggers
  - near-still rope -> stop chord or sparse ambient notes
- Build a hybrid mapping where one layer is event-based MIDI and another layer is continuous CC output derived from activity, center-line tilt, or spectral shape.
- Expose optional OSC outputs for MIDI CC, pitch bend, aftertouch, or MPE-like dimensions if the target synth supports them.

## 5. Csound GUI cleanup suggestions

The GUI is currently dense and mixes analysis-driven modules, thresholds, and L-system settings in the same visual field.

### Suggested structure

- Group the GUI into clear sections or tabs:
  - basic note mappings
  - grain-based mappings
  - bank/oscillator mappings
  - stop-event mappings
  - L-system settings
  - debug/advanced
- Give each module a consistent layout:
  - enable button
  - sound controls
  - MIDI controls
  - advanced controls
- Hide advanced per-voice controls unless the module is enabled.
- Separate audio-only controls visually from MIDI-output controls.
- Use clearer labels than short abbreviations where space allows.
- Add light section backgrounds or groupboxes around all non-L-system modules, not only the L-system block.
- Align repeated controls consistently, especially the threshold, transpose, and channel triplets.

### Highest-value immediate cleanup

- Move the two basic note-mapping modules (`Wave_numpeaks`, `Wave_zerocross`) into a compact top row.
- Put `Distance_grain`, `Grain2`, and `Fader_bank` in separate module boxes.
- Move `Stopchord` and `Stop_LSYS` together into one stop-event section.
- Keep L-system controls in their own full-width area because they already behave like a separate subsystem.

## 6. Other cleanup findings

### Audio-only modules to review

These appear to produce audio but not MIDI in the current file:

- `Wave_raw_on` / instrument 10
- `Wave_fine_on` / instrument 10 with the fine table
- `Stopchord` / instruments 18 and 19
- Peak sine cluster / instrument 4, if `Peaks_on` is ever re-enabled

Also note:

- L-system instrument 131 is a sound generator, but its output is commented out, so it is effectively inactive as audio.

### GUI controls that only affect audio synthesis

- `Freq_wav`, `Amp_wav`, `detune_wav`
- `detune_stopchord`, `amp_stopchord`

Controls that are mixed audio/MIDI and should probably stay if the module stays:

- `Distance_grain` block: grain parameters affect both audio behavior and MIDI pulse generation.
- `Fader_bank` block: some controls influence both oscillator bank sound and MIDI note generation.
- `Grain2` block: grain behavior affects MIDI generation through grain pulse extraction.

### Duplicate or overlapping control concepts

- There are several transpose controls in different modules. They are not direct duplicates, but they add conceptual clutter because each module uses pitch differently.
- `Freq_*` controls often set the underlying audio oscillator or grain pitch, while separate transpose controls affect emitted MIDI. This is defensible, but the UI should make the distinction explicit.

### Broken or stale wiring found in rope_midi.csd

There are several channel reads for widgets that do not appear to exist in the current GUI. These look like leftover modules or partially removed controls:

- `Wave_raw_detune_on`
- `Wave_fine_detune_on`
- `Fft_bank`
- `Noisebank`
- `Peaks_on`
- `Freq_wavd`
- `detune_wavd`
- `Amp_wavd`2
- `Freq_fft`
- `Amp_fft`
- `chroma_fft`
- `detune_fft`
- `dist_fft`
- `Amp`, `Freq`, `detune` channels referenced by older code paths

Additional stale-read note (Grain2 path):

- In `opcode Graincloud`, there is a read of `graincloud_midichan` (without voice suffix) before the per-voice read of `graincloud_midichan_1..4`. The unsuffixed read appears redundant/stale because it is overwritten by the suffixed channel read used for actual MIDI events.

This is the clearest cleanup opportunity in the current file. Even before implementing new features, it would help to decide which of these modules should be restored and which should be deleted.

### Likely dead or placeholder code

- `instr 5` is empty.
- The detuned waveshaping instrument 11 appears to be unreachable from the current GUI.
- The FFT bank instrument 16 appears to be unreachable from the current GUI.
- The peak cluster path relies on `Peaks_on` plus an `Amp` channel that is not in the current GUI.
- Python variables and scaffolding such as `send_counter`, `diff_thresh`, the inactive lowpass stage, and the commented noise gate should be reviewed.

## 7. Blackmagic camera control from Python

Short answer: probably yes, through the ATEM side rather than by controlling the camera directly as a generic webcam.

### What looks feasible

- Blackmagic provides an official ATEM Switchers SDK, so the switcher can be controlled programmatically.
- A Python library called `PyATEMMax` exists for monitoring and controlling ATEM switchers from Python.
- Because the camera is connected through an ATEM SDI Pro ISO, camera settings that ATEM exposes for supported Blackmagic cameras may be controllable from Python by talking to the ATEM over the network.

### Likely caveats

- This depends on which camera control parameters the ATEM exposes for the Blackmagic Micro Studio 4K G2 in your exact routing setup.
- Not every parameter may be available through the same interface.
- Some camera features may still require camera-native setup or may only be exposed through specific ATEM camera-control APIs.
- This should be treated as a small integration spike first, not assumed to be complete replacement for ATEM Software Control on day one.

### Suggested next step for camera control

- Test a minimal Python connection to the ATEM and verify read/write access for a few camera parameters first:
  - gain or ISO
  - white balance / color temperature
  - shutter
  - focus
  - iris, if exposed

If that works, camera setup can likely be folded into the same Python application as the rope tracker.

## 8. Specific implementation priorities I would suggest

If you want the next pass to improve the system without expanding scope too much, this is the order I would recommend:

1. Cleanup stale Csound controls and unreachable modules.
2. Clarify the Python display so the tracking quality is easier to judge in realtime.
3. Reduce OSC message count by batching arrays.
4. Decide whether audio-only modules should remain in this project.
5. Add one or two higher-value analysis features, preferably wave direction and a more stable wavelength estimate.
6. Prototype ATEM camera control from Python as a separate small test.

## 9. Notes on correctness and possible issues worth checking before implementation

- Peak extraction has been refactored to residual-based gated detection (`extract_wave_features`), but threshold tuning (amplitude/prominence/distance) remains an active tradeoff between sensitivity and noise rejection.
- The FFT calculation uses the real part of each FFT bin before taking the log, rather than using FFT magnitude. If the goal is to measure how much of each spatial frequency is present regardless of phase, magnitude is the standard descriptor. The current approach is more phase-sensitive than it first appears, because the real part of a bin can shrink or change sign purely because of phase rotation even when the spatial component is still strong.
- FFT phase may still be useful as a separate feature if the project wants a cheaper global estimate of wave travel direction. That would be a different use of the FFT from the current per-bin amplitude measure, and it should be treated as a possible complement to or simplification of the current peak-ID tracking rather than a direct drop-in replacement.
- The current Csound patch makes a strong distinction between peak identities and peak-derived summary data:
  - Peak identities, per-peak lifetimes, and `deleted_peaks` are only used by the peak-cluster path in instrument 1 and instrument 4. That path is currently behind the missing `Peaks_on` control and also refers to a missing `Amp` control, so it appears effectively inactive in the current GUI.
  - Peak-derived summaries are actively used elsewhere and should not be removed without replacement:
    - `numpeaks` drives the peak-count MIDI mapper, waveshaping brightness, grain-cloud density, stop-LSYS root selection, and other high-level mappings.
    - `avg_x_movement` is used as a general motion descriptor in active sound modules.
    - `avg_x_distance` and `gkXdistance` are used by the distance-grain module.
    - `gkXpos` and `gkPeaks_x` feed the stopchord and stop-LSYS logic through aggregate extrema and averages, not through identity tracking.
- This means the most expendable part of the current peak system is the explicit peak-ID tracking, not the whole peak-analysis layer. If the goal is to simplify processing, a sensible rework path would be:
  - keep or replace `numpeaks`
  - keep or replace a global motion-direction / movement measure
  - keep or replace a spacing measure for wavelength-like behavior
  - only keep explicit peak IDs if you still need per-peak event births, per-peak positions, or per-peak control streams
- If per-peak event births are no longer important, the current peak-ID layer could likely be replaced by a lighter combination of:
  - global direction estimation from frame-to-frame correlation or FFT/cross-spectrum phase
  - wavelength or spacing estimation from FFT magnitude, zero crossings, or autocorrelation
  - a simple event detector based on changes in peak count, curvature energy, or thresholded wave activity
- If the stopchord and stop-LSYS mappings should retain their present dependence on leftmost/rightmost or extreme peak positions, then some position-distribution feature still needs to be preserved. That does not necessarily require stable peak IDs, but it does require some representation of where the strongest rope lobes are located in the current frame.
- Zero-crossing extraction is now tied to significant-lobe structure and ROI bounds; further temporal hysteresis could still reduce one-frame flicker.
- Filtering and rope-tracking constraints are now significantly better, but still likely refinable; in particular, edge behavior, kinematic-vs-observation weighting, and residual dark-region artifacts should be treated as active tuning areas.
- Several active Csound code paths assume channels exist that are not present in the GUI. Even if those instruments are not enabled now, this is a maintenance risk.

## 10. Next planned refinement steps



## Manual edited todo, rope analysis
- amp dependent on frequency?
  - one cycle can span the whole vertical area
  - 6 cycles can not
  - new measure: effective amp
- review motion descriptors after adding cross-correlation wave movement meter
  - decide whether `avg_x_movement` is still useful or redundant
- review, calibrate and test the shape identification (straight, bump, waves) 

## Manual edited todo, midification
- fader bank midifications
  - currently high threshold, not responsive enough
  - note mapping for fader bank
    - positive only
    - negative and positive (abs)
    - negative produce other notes than positive
      - negative one octave down?
- for all fader bank midifications:
  - alternative where we have a fader per peak
  - if same note activated: sustain
  - if new note: stop old, start new
- fft to midi, bit like fader bank but for fft bins
- simple shape centroid to midi note
- simple freq centroid to midi note
- simple most prominent frequency to midi note
