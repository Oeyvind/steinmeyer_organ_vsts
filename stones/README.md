# Stones Session

This folder contains all files related to the stone-sound analysis/MIDI mapping session.

## Main files
- `pvstrace_3band.csd` — main Cabbage/Csound patch (live analyzer + MIDI output)
- `pvstrace_3band.dll` — plugin binary for the patch
- `pvstrace_3band – Kopi.csd` — backup variant
- `stones_rec_example.wav` — reference recording used for offline validation

## Offline tools
- `analyze_stones.py` — computes hit-level raw features and BEFORE/AFTER note mappings
- `plot_stones_analysis.py` — creates PNG plots from exported CSV files
- `run_stones_pipeline.py` — runs analyzer + plotting in one command

## One-command workflow
From `domen_ai` root:

```bash
python stones/run_stones_pipeline.py
```

Or for another WAV file:

```bash
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav"
```

To test alternate trace band splits (matching live `Lo1/Hi1 ... Lo3/Hi3`):

```bash
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav" --lo1 20 --hi1 500 --lo2 500 --hi2 1000 --lo3 1000 --hi3 3000
```

To keep outputs from different tests (no overwrite), add a run tag:

```bash
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav" --tag my_test
```

### Band-split sweep example (Lo1 starts at 150 Hz, then +25% twice)

```bash
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav" --lo1 150 --hi1 500 --lo2 500 --hi2 1000 --lo3 1000 --hi3 3000 --tag lo1_150_base
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav" --lo1 187.5 --hi1 625 --lo2 625 --hi2 1250 --lo3 1250 --hi3 3750 --tag lo1_150_p25
python stones/run_stones_pipeline.py --wav "C:/path/to/your/file.wav" --lo1 234.375 --hi1 781.25 --lo2 781.25 --hi2 1562.5 --lo3 1562.5 --hi3 4687.5 --tag lo1_150_p25x2
```

## Generated outputs
- `*_note_compare_hits.csv` — note outputs per hit for BEFORE/AFTER presets
- `*_note_compare_spreads.csv` — grouped consistency spreads (3 hits per stone)
- `*_raw_features.csv` — raw features per hit (centroid/flatness/tilt/crest/trace Hz)
- `*_raw_features.png` — raw feature plots
- `*_notes_compare.png` — per-hit note comparison plots
- `*_spreads_compare.png` — spread comparison plots
- `*_suggested_live_settings.txt` — run-specific manual transfer settings

## Quick tune checklist
1. Run `python stones/run_stones_pipeline.py --wav "..."` and open `*_notes_compare.png` + `*_spreads_compare.png`.
2. If many notes pin at min/max, widen or shift note ranges first (`Midi...Lo/Hi` sliders).
3. If crest saturates, increase crest mapping max (offline `crest_max`; live crest map max in the patch).
4. If B3 has little movement, raise `MidiTrace3Hi` and/or adjust `MidiTrace3Trsp`.
5. If false triggers/noise occur, raise `NoiseFloorDb` (less negative) and retest.
6. If hits feel unstable, increase `MidiAnalysisMs`; if too sluggish, reduce it.
7. Re-run pipeline after each change and compare spread reduction within stones plus separation between stones.

## Utility test files
- `pvstrace_3band_test.csd` — offline Csound test harness
- `db_test.csd` — dB conversion test patch
