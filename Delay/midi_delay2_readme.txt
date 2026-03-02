MIDI Delay 2 - Plugin Readme
============================

Quick Start (10 steps)
----------------------
1) Set inchan to your played MIDI channel.
2) Set bpm for all beat-based timing.
3) Enable tap1/tap2 as needed.
4) Set chan_1 / chan_2 output channels.
5) Set each tap's delay min/max and transpose.
6) Turn on gen on to enable phrase generation.
7) Set eps_min/eps_max to map density -> trigger probability.
8) Set row-5 generator controls (chan_g, delay, nevents, g_mult, tempo_var).
9) Use tvar + density controls to scale max generated events.
10) Monitor csoundoutput for density/count debug changes.

Overview
--------
midi_delay2 is a MIDI effect plugin that creates delayed MIDI-note copies from incoming notes.
It includes:
- Delay Tap 1 (random delay, transpose, duration shaping, output channel)
- Delay Tap 2 (fed from Tap 1 timing logic)
- Optional phrase generator that creates melodic note sequences

All output notes are sent as MIDI note-on/note-off events.


Main Signal Flow
----------------
1) Incoming MIDI note arrives on selected input channel.
2) Tap 1 may emit one delayed copy.
3) Tap 2 may emit a second delayed copy (offset from Tap 1 delay).
4) Generator may emit a short phrase, probabilistically triggered by playing density.


Timing Model
------------
- BPM control defines beat time: 60 / BPM seconds.
- Delay controls (min/max) are integer beat multipliers.
- Delay amount is randomly chosen between min and max (inclusive style).
- Generator step timing is set by speed mode (slow/medium/fast) and tempo variation mode.


GUI Controls
============

Global Row
----------
inchan
  MIDI input channel to listen to (1..16).

bpm
  Global tempo used for all beat-based delay and generator timing.


Tap 1 Row
---------
chan_1 (outchan)
  Output MIDI channel for Tap 1 notes.

dly_min / dly_max
  Random delay range for Tap 1, in beat units.

duration
  Release timing factor for Tap 1 note-off scheduling.

transp
  Semitone transpose for Tap 1 notes.

tap1 enable
  Enables/disables Tap 1.


Tap 2 Row
---------
chan_2 (outchan2)
  Output MIDI channel for Tap 2 notes.

dly2_mn / dly2_mx
  Random delta delay range for Tap 2 in beat units.
  Tap 2 start delay is Tap1 delay + Tap2 delta.

dur2
  Release timing factor for Tap 2 note-off scheduling.

trsp2
  Semitone transpose for Tap 2 notes.

tap2 enable
  Enables/disables Tap 2.


Generator Trigger / Density Row (Row 4)
---------------------------------------
gen on
  Master enable for phrase generator.

eps_min
  Lower note-density threshold (events/sec).
  Around this threshold, generator probability is about 25%.

eps_max
  Upper note-density threshold (events/sec).
  At/above this threshold, generator probability reaches 100%.

-nevents scaling-
  Group label for event-count scaling controls.

tvar (gen_scale_tempo)
  Toggle whether max generated event count scales with tempo variation factor.

density (gen_scale_density)
  Amount of additional max-event scaling based on current note density.
  0 = no density-based scaling.


Generator Phrase Row (Row 5)
-----------------------------
chan_g (gen_outchan)
  Output MIDI channel for generated phrase notes.

-delay- : min / max (gen_dly_min / gen_dly_max)
  Random start delay range for the phrase, in beat units.

-nevents- : min / max (gen_min / gen_max)
  Random phrase length range (number of generated events).
  Effective max may be scaled by tvar and/or density settings.

g_mult (gen_mult)
  Base phrase speed:
  - slow   -> factor 2
  - medium -> factor 4
  - fast   -> factor 8

tempo_var
  Phrase-level tempo variation mode:
  - unit     : factor 1
  - 1 and 2  : random factor 1 or 2
  - 1 and 3  : random factor 1, 1.5, or 2
  - 1_2_3    : random factor 1, 1.5, 2, or 3


Generator Phrase Behavior
-------------------------
- First 3 phrase events use small random +/-1 semitone movement.
- Remaining events choose one random phrase type per phrase:
  1) descending slope,
  2) ascending slope,
  3) expanding interval jumps,
  4) alternating up/down random semitone steps.
- Generated pitches are clamped to MIDI note range 36..96.


Density Tracking (for generator probability)
--------------------------------------------
- A circular event-time history (size 20) is maintained via Csound channels.
- On each new note-on:
  - entries older than 2 seconds are discarded,
  - current event is inserted,
  - density is computed from count over the 2-second window.
- Console print updates only when the event count changes.


Tips
----
- For subtle behavior, keep eps_min/eps_max relatively high.
- For frequent phrase generation, lower eps thresholds.
- Use tap transposition and generator transients together for layered melodic echoes.
