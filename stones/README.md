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

## Generated outputs
- `*_note_compare_hits.csv` — note outputs per hit for BEFORE/AFTER presets
- `*_note_compare_spreads.csv` — grouped consistency spreads (3 hits per stone)
- `*_raw_features.csv` — raw features per hit (centroid/flatness/tilt/crest/trace Hz)
- `*_raw_features.png` — raw feature plots
- `*_notes_compare.png` — per-hit note comparison plots
- `*_spreads_compare.png` — spread comparison plots

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
