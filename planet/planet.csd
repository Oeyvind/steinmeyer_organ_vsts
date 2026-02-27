<Cabbage>
form caption("Binary Star Trajectory Sonifier") size(980, 430), pluginId("bstr"), guiMode("queue"), colour(30,40,40)

checkbox bounds(20, 16, 110, 30), channel("on_off"), text("Instrument Off", "Instrument On"), value(0)
label bounds(220, 16, 60, 20), text("Presets"), fontSize(11)
button bounds(285, 12, 90, 28), channel("preset_stable_1"), text("Stable 1", "Stable 1"), latched(0)
button bounds(380, 12, 90, 28), channel("preset_stable_2"), text("Stable 2", "Stable 2"), latched(0)
button bounds(475, 12, 90, 28), channel("preset_chaotic"), text("Chaotic", "Chaotic"), latched(0)
button bounds(570, 12, 90, 28), channel("preset_tight"), text("Tight", "Tight"), latched(0)

rslider bounds(20, 60, 90, 90), channel("km1"),   text("Mass 1"),   range(0.01, 20, 2.7, 0.5, 0.001)
rslider bounds(110, 60, 90, 90), channel("km2"),  text("Mass 2"),   range(0.01, 20, 1.65, 0.5, 0.001)
rslider bounds(200, 60, 90, 90), channel("ksep"), text("Separation"), range(0.01, 20, 6.2, 0.5, 0.001)
rslider bounds(300, 60, 90, 90), channel("kamp"), text("Amp"), range(0, 1, 0.05, 0.5, 0.0001)
nslider bounds(390, 90, 90, 24), channel("safety_thresh"), text("Safety"), range(1, 100, 2, 1, 0.01)
rslider bounds(485, 60, 90, 90), channel("hp_cutoff"), text("HP Hz"), range(20, 2000, 20, 0.5, 1)

rslider bounds(20, 160, 90, 90), channel("ix"),  text("Init X"),  range(-20, 20, 4.2, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(110, 160, 90, 90), channel("iy"),  text("Init Y"),  range(-20, 20, 2.1, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(200, 160, 90, 90), channel("iz"),  text("Init Z"),  range(-20, 20, -2.5, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(290, 160, 90, 90), channel("ivx"), text("Vel X"),   range(-2, 2, 0.2, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(380, 160, 90, 90), channel("ivy"), text("Vel Y"),   range(-2, 2, 0.35, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(470, 160, 90, 90), channel("ivz"), text("Vel Z"),   range(-2, 2, 0.3, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(560, 160, 90, 90), channel("ih"),    text("Step h"),   range(0.00001, 1, 0.2, 0.5, 0.00001), trackerColour(50,95,185)
rslider bounds(650, 160, 90, 90), channel("ifric"), text("Friction"), range(-0.01, 0.01, 0, 0.5, 0.000001), trackerColour(50,95,185)
csoundoutput bounds(10, 270, 960, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 4
0dbfs = 1

instr 1
  kon chnget "on_off"
  kpreset_stable_1 chnget "preset_stable_1"
  kpreset_stable_2 chnget "preset_stable_2"
  kpreset_chaotic chnget "preset_chaotic"
  kpreset_tight chnget "preset_tight"

  kpreset_stable_1_trig = changed(kpreset_stable_1) * kpreset_stable_1
  kpreset_stable_2_trig = changed(kpreset_stable_2) * kpreset_stable_2
  kpreset_chaotic_trig = changed(kpreset_chaotic) * kpreset_chaotic
  kpreset_tight_trig = changed(kpreset_tight) * kpreset_tight
  ksafety_pulse chnget "safety_pulse"
  ksafety_hold init 0
  kreinit_hold init 0
  kix_gui chnget "ix"
  kiy_gui chnget "iy"
  kiz_gui chnget "iz"
  kivx_gui chnget "ivx"
  kivy_gui chnget "ivy"
  kivz_gui chnget "ivz"
  kih_gui chnget "ih"
  kifric_gui chnget "ifric"
  ki_params_changed changed kix_gui, kiy_gui, kiz_gui, kivx_gui, kivy_gui, kivz_gui, kih_gui, kifric_gui

  ksafety_hold = max(0, ksafety_hold - (1/kr))
  kreinit_hold = max(0, kreinit_hold - (1/kr))

  cabbageSetValue "km1", 2.7, kpreset_stable_1_trig
  cabbageSetValue "km2", 1.65, kpreset_stable_1_trig
  cabbageSetValue "ksep", 6.2, kpreset_stable_1_trig
  cabbageSetValue "ix", 4.2, kpreset_stable_1_trig
  cabbageSetValue "iy", 2.1, kpreset_stable_1_trig
  cabbageSetValue "iz", -2.5, kpreset_stable_1_trig
  cabbageSetValue "ivx", 0.2, kpreset_stable_1_trig
  cabbageSetValue "ivy", 0.35, kpreset_stable_1_trig
  cabbageSetValue "ivz", 0.3, kpreset_stable_1_trig
  cabbageSetValue "ih", 0.2, kpreset_stable_1_trig
  cabbageSetValue "ifric", 0, kpreset_stable_1_trig
  cabbageSetValue "kamp", 0.05, kpreset_stable_1_trig

  cabbageSetValue "km1", 3.5, kpreset_stable_2_trig
  cabbageSetValue "km2", 2.0, kpreset_stable_2_trig
  cabbageSetValue "ksep", 4.9, kpreset_stable_2_trig
  cabbageSetValue "ix", 5.2, kpreset_stable_2_trig
  cabbageSetValue "iy", 1.4, kpreset_stable_2_trig
  cabbageSetValue "iz", -0.9, kpreset_stable_2_trig
  cabbageSetValue "ivx", -0.28, kpreset_stable_2_trig
  cabbageSetValue "ivy", 1.08, kpreset_stable_2_trig
  cabbageSetValue "ivz", 0.17, kpreset_stable_2_trig
  cabbageSetValue "ih", 0.20, kpreset_stable_2_trig
  cabbageSetValue "ifric", 0.000006, kpreset_stable_2_trig
  cabbageSetValue "kamp", 0.05, kpreset_stable_2_trig

  cabbageSetValue "km1", 4.0, kpreset_chaotic_trig
  cabbageSetValue "km2", 1.5, kpreset_chaotic_trig
  cabbageSetValue "ksep", 3.9, kpreset_chaotic_trig
  cabbageSetValue "ix", 6.3, kpreset_chaotic_trig
  cabbageSetValue "iy", -3.0, kpreset_chaotic_trig
  cabbageSetValue "iz", 1.5, kpreset_chaotic_trig
  cabbageSetValue "ivx", -0.44, kpreset_chaotic_trig
  cabbageSetValue "ivy", 0.98, kpreset_chaotic_trig
  cabbageSetValue "ivz", -0.24, kpreset_chaotic_trig
  cabbageSetValue "ih", 0.19, kpreset_chaotic_trig
  cabbageSetValue "ifric", 0.00001, kpreset_chaotic_trig
  cabbageSetValue "kamp", 0.03, kpreset_chaotic_trig

  cabbageSetValue "km1", 4.1, kpreset_tight_trig
  cabbageSetValue "km2", 3.5, kpreset_tight_trig
  cabbageSetValue "ksep", 2.2, kpreset_tight_trig
  cabbageSetValue "ix", 1.9, kpreset_tight_trig
  cabbageSetValue "iy", 0.0, kpreset_tight_trig
  cabbageSetValue "iz", 0.0, kpreset_tight_trig
  cabbageSetValue "ivx", 0.0, kpreset_tight_trig
  cabbageSetValue "ivy", 0.56, kpreset_tight_trig
  cabbageSetValue "ivz", 0.03, kpreset_tight_trig
  cabbageSetValue "ih", 0.08, kpreset_tight_trig
  cabbageSetValue "ifric", 0.00003, kpreset_tight_trig
  cabbageSetValue "kamp", 0.08, kpreset_tight_trig

  kon_changed changed kon
  if kon_changed == 1 then
    if kon == 1 then
      event "i", 2, 0, -1
    else
      turnoff2 2, 0, 1
    endif
  endif

  if kon == 1 && ksafety_pulse > 0.5 && ksafety_hold == 0 then
    turnoff2 2, 0, 1
    event "i", 2, 0, -1
    ksafety_hold = 1.0
  endif

  if kon == 1 && ki_params_changed == 1 && kreinit_hold == 0 then
    turnoff2 2, 0, 1
    event "i", 2, 0, -1
    kreinit_hold = 0.2
  endif
endin

instr 2
  xtratim 0.1

  km1 chnget "km1"
  km2 chnget "km2"
  ksep chnget "ksep"
  ix chnget "ix"
  iy chnget "iy"
  iz chnget "iz"
  ivx chnget "ivx"
  ivy chnget "ivy"
  ivz chnget "ivz"
  ih chnget "ih"
  ifric chnget "ifric"
  kamp chnget "kamp"
  ksafety_thresh chnget "safety_thresh"
  khp_cutoff chnget "hp_cutoff"

  ax, ay, az planet km1, km2, ksep, ix, iy, iz, \
                 ivx, ivy, ivz, ih, ifric

  kenv linsegr 0, 0.1, 1, 0.1, 0
  aout_x = ax * kamp * kenv
  aout_y = ay * kamp * kenv
  aout_z = az * kamp * kenv

  krms_x rms aout_x
  krms_y rms aout_y
  krms_z rms aout_z
  kpeak_lvl = max(max(krms_x, krms_y), krms_z)
  ksafety_pulse trigger kpeak_lvl, ksafety_thresh, 0
  printks2 "Safety Pulse: %i\n",ksafety_pulse
  chnset ksafety_pulse, "safety_pulse"

  ahp_x butterhp aout_x, khp_cutoff
  ahp_y butterhp aout_y, khp_cutoff
  ahp_z butterhp aout_z, khp_cutoff

  outch 1, ahp_x, 2, ahp_y, 3, ahp_z
endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
