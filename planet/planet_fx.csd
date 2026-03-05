<Cabbage>
form caption("Binary Star Trajectory Sonifier") size(980, 430), pluginId("bstr"), guiMode("queue"), colour(30,40,40)

checkbox bounds(20, 16, 110, 30), channel("on_off"), text("Instrument Off", "Instrument On"), value(0)
label bounds(220, 16, 60, 20), text("Presets"), fontSize(11)
button bounds(285, 12, 90, 28), channel("preset_stable_1"), text("Stable 1", "Stable 1"), latched(0)
button bounds(380, 12, 90, 28), channel("preset_stable_2"), text("Stable 2", "Stable 2"), latched(0)
button bounds(475, 12, 90, 28), channel("preset_chaotic"), text("Chaotic", "Chaotic"), latched(0)
button bounds(570, 12, 90, 28), channel("preset_tight"), text("Tight", "Tight"), latched(0)
checkbox bounds(670, 16, 120, 30), channel("direct_on"), text("Direct Off", "Direct On"), value(1)
checkbox bounds(670, 52, 120, 26), channel("fx_filter_on"), text("Filter Off", "Filter On"), value(1)
checkbox bounds(670, 114, 120, 26), channel("fx_cross_on"), text("Cross Off", "Cross On"), value(0)
checkbox bounds(670, 184, 120, 26), channel("fx_morph_on"), text("Morph Off", "Morph On"), value(0)
checkbox bounds(670, 254, 120, 26), channel("fx_mode_on"), text("Mode Off", "Mode On"), value(0)

rslider bounds(20, 60, 90, 90), channel("km1"),   text("Mass 1"),   range(0.01, 20, 2.7, 0.5, 0.001)
rslider bounds(110, 60, 90, 90), channel("km2"),  text("Mass 2"),   range(0.01, 20, 1.65, 0.5, 0.001)
rslider bounds(200, 60, 90, 90), channel("ksep"), text("Separation"), range(0.01, 20, 6.2, 0.5, 0.001)
rslider bounds(300, 60, 90, 90), channel("kamp"), text("Amp"), range(0, 1, 0.05, 0.5, 0.0001)
nslider bounds(390, 90, 90, 24), channel("safety_thresh"), text("Safety"), range(1, 100, 2, 1, 0.01)
rslider bounds(485, 60, 90, 90), channel("hp_cutoff"), text("HP Hz"), range(20, 2000, 20, 0.5, 1)
rslider bounds(760, 44, 72, 64), channel("filter_depth"), text("Pvsfilter depth"), range(0, 1, 1, 0.5, 0.001)
checkbox bounds(838, 52, 100, 26), channel("filter_swap"), text("F Normal", "F Swapped"), value(0)
rslider bounds(760, 108, 72, 64), channel("cross_kamp1"), text("F Ctrl 1"), range(0, 1, 1, 0.5, 0.001)
rslider bounds(838, 108, 72, 64), channel("cross_kamp2"), text("F Ctrl 2"), range(0, 1, 1, 0.5, 0.001)
rslider bounds(760, 180, 72, 60), channel("morph_kampint"), text("M AmpInt"), range(0, 1, 0.5, 0.5, 0.001)
rslider bounds(838, 180, 72, 60), channel("morph_kfrqint"), text("M FrqInt"), range(0, 1, 0.5, 0.5, 0.001)
nslider bounds(760, 252, 72, 24), channel("mode_partials"), text("Partials"), range(1, 10, 6, 1, 1)
rslider bounds(838, 252, 72, 60), channel("mode_q"), text("Mode Q"), range(1, 80, 20, 0.5, 0.1)
nslider bounds(760, 288, 72, 24), channel("trace_low_hz"), text("Trace Low"), range(20, 800, 80, 1, 1)
rslider bounds(760, 324, 72, 60), channel("trace_smooth"), text("Trace Sm"), range(0, 1, 0.2, 0.5, 0.001)
rslider bounds(838, 324, 72, 60), channel("mode_tonek"), text("Mode Slew"), range(1, 20, 6, 0.5, 0.1)

rslider bounds(20, 160, 62, 90), channel("ix"),  text("Init X"),  range(-20, 20, 4.2, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(90, 160, 62, 90), channel("iy"),  text("Init Y"),  range(-20, 20, 2.1, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(161, 160, 62, 90), channel("iz"),  text("Init Z"),  range(-20, 20, -2.5, 0.5, 0.001), trackerColour(50,95,185)
rslider bounds(231, 160, 62, 90), channel("ivx"), text("Vel X"),   range(-2, 2, 0.2, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(302, 160, 62, 90), channel("ivy"), text("Vel Y"),   range(-2, 2, 0.35, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(372, 160, 62, 90), channel("ivz"), text("Vel Z"),   range(-2, 2, 0.3, 0.5, 0.0001), trackerColour(50,95,185)
rslider bounds(443, 160, 62, 90), channel("ih"),    text("Step h"),   range(0.00001, 1, 0.2, 0.5, 0.00001), trackerColour(50,95,185)
rslider bounds(513, 160, 62, 90), channel("ifric"), text("Friction"), range(-0.01, 0.01, 0, 0.5, 0.000001), trackerColour(50,95,185)
csoundoutput bounds(10, 270, 590, 150)
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

opcode ModeBankRecursive, a, akkk[]ii
  ain, kmode_q, kmode_tonek, kModeFreqs[], iidx, imax xin
  aresult init 0

  if iidx >= imax then
    aresult = 0
  else
    asub ModeBankRecursive ain, kmode_q, kmode_tonek, kModeFreqs, iidx + 1, imax
    kfreq_raw = kModeFreqs[iidx]
    if kfreq_raw > 0 && kfreq_raw < 1e8 then
      kfreq tonek kfreq_raw, kmode_tonek
      kfreq = limit(kfreq, 20, (sr * 0.5) - 10)
      kq_gain = 1 / sqrt(max(kmode_q, 1))
      amode mode ain, kfreq, kmode_q
      aresult = (amode * kq_gain * 0.8) + asub
    else
      aresult = asub
    endif
  endif
  xout aresult
endop

opcode CountActiveBinsRecursive, k, k[]ii
  kModeFreqs[], iidx, imax xin
  kresult init 0

  if iidx >= imax then
    kresult = 0
  else
    ksub CountActiveBinsRecursive kModeFreqs, iidx + 1, imax
    if kModeFreqs[iidx] > 0 && kModeFreqs[iidx] < 1e8 then
      kresult = 1 + ksub
    else
      kresult = ksub
    endif
  endif
  xout kresult
endop

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
      event "i", 3, 0, -1
    else
      turnoff2 2, 0, 1
      turnoff2 3, 0, 1
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
  kdirect_on chnget "direct_on"
  ksafety_thresh chnget "safety_thresh"
  khp_cutoff chnget "hp_cutoff"

  ax, ay, az planet km1, km2, ksep, ix, iy, iz, \
                 ivx, ivy, ivz, ih, ifric
  
  ; Sustain at full level while note is active, release only on turnoff.
  aenv madsr 0.05, 0.0, 1.0, 0.05
  aout_x = ax * kamp * aenv
  aout_y = ay * kamp * aenv
  aout_z = az * kamp * aenv

  krms_x rms aout_x
  krms_y rms aout_y
  krms_z rms aout_z
  kpeak_lvl = max(max(krms_x, krms_y), krms_z)
  ksafety_pulse trigger kpeak_lvl, ksafety_thresh, 0
  chnset ksafety_pulse, "safety_pulse"

  ahp_x butterhp aout_x, khp_cutoff
  ahp_y butterhp aout_y, khp_cutoff
  ahp_z butterhp aout_z, khp_cutoff

  chnset ahp_x, "planet_l"
  chnset ahp_y, "planet_r"

  outch 1, ahp_x * kdirect_on, 2, ahp_y * kdirect_on

endin

instr 3
  xtratim 0.1

  ain_l inch 1
  ain_r inch 2
  aplanet_l chnget "planet_l"
  aplanet_r chnget "planet_r"

  kfx_filter_on chnget "fx_filter_on"
  kfx_cross_on chnget "fx_cross_on"
  kfx_morph_on chnget "fx_morph_on"
  kfx_mode_on chnget "fx_mode_on"
  kfilter_swap chnget "filter_swap"
  kfilter_depth chnget "filter_depth"
  kcross_kamp1 chnget "cross_kamp1"
  kcross_kamp2 chnget "cross_kamp2"
  kmorph_kampint chnget "morph_kampint"
  kmorph_kfrqint chnget "morph_kfrqint"
  kmode_partials chnget "mode_partials"
  ktrace_low_hz chnget "trace_low_hz"
  ktrace_smooth chnget "trace_smooth"
  kmode_tonek chnget "mode_tonek"
  kmode_q_raw chnget "mode_q"
  kmode_q = limit(kmode_q_raw, 1, 80)
  
  ifft = 1024
  ihop = 256
  iwinsize = 1024
  iwintype = 1
  ihigh_full_hz = (sr * 0.5) - 120
  ihigh_cut_hz = (sr * 0.5) - 10
  klow_full_hz = ktrace_low_hz
  klow_cut_hz = max(20, klow_full_hz - 60)

  flive_l pvsanal ain_l, ifft, ihop, iwinsize, iwintype
  flive_r pvsanal ain_r, ifft, ihop, iwinsize, iwintype
  alive_mono = (ain_l + ain_r) * 0.5
  flive_m pvsanal alive_mono, ifft, ihop, iwinsize, iwintype
  ftrace_bp pvsbandp flive_m, klow_cut_hz, klow_full_hz, ihigh_full_hz, ihigh_cut_hz
  ftrace_src pvsmooth ftrace_bp, ktrace_smooth, ktrace_smooth
  fplanet_l pvsanal aplanet_l, ifft, ihop, iwinsize, iwintype
  fplanet_r pvsanal aplanet_r, ifft, ihop, iwinsize, iwintype
  kBins[] init 513
  ftrace, kBins[] pvstrace ftrace_src, kmode_partials, 1

  if kfilter_swap < 0.5 then
    ffilt_l pvsfilter fplanet_l, flive_l, kfilter_depth
    ffilt_r pvsfilter fplanet_r, flive_r, kfilter_depth
  else
    ffilt_l pvsfilter flive_l, fplanet_l, kfilter_depth
    ffilt_r pvsfilter flive_r, fplanet_r, kfilter_depth
  endif
  fcross_l pvscross flive_l, fplanet_l, kcross_kamp1, kcross_kamp2
  fcross_r pvscross flive_r, fplanet_r, kcross_kamp1, kcross_kamp2
  fmorph_l pvsmorph flive_l, fplanet_l, kmorph_kampint, kmorph_kfrqint
  fmorph_r pvsmorph flive_r, fplanet_r, kmorph_kampint, kmorph_kfrqint

  across_l pvsynth fcross_l
  across_r pvsynth fcross_r
  afilt_l pvsynth ffilt_l
  afilt_r pvsynth ffilt_r
  amorph_l pvsynth fmorph_l
  amorph_r pvsynth fmorph_r

  kmode_partials = limit(kmode_partials, 1, 10)
  kModeFreqs[] init 10
  kidx = 0
  while kidx < 10 do
    if kidx < kmode_partials && kBins[kidx] > 0 then
      kModeFreqs[kidx] = limit((kBins[kidx] * sr) / ifft, 20, (sr * 0.5) - 10)
    else
      kModeFreqs[kidx] = 1e9
    endif
    kidx = kidx + 1
  od

  ; Sort ascending so recursive filter index assignment is more stable.
  ki = 0
  while ki < 9 do
    kj = 0
    while kj < (9 - ki) do
      if kModeFreqs[kj] > kModeFreqs[kj + 1] then
        ktmp = kModeFreqs[kj]
        kModeFreqs[kj] = kModeFreqs[kj + 1]
        kModeFreqs[kj + 1] = ktmp
      endif
      kj = kj + 1
    od
    ki = ki + 1
  od

  amode_l_sum ModeBankRecursive aplanet_l, kmode_q, kmode_tonek, kModeFreqs, 0, 10
  amode_r_sum ModeBankRecursive aplanet_r, kmode_q, kmode_tonek, kModeFreqs, 0, 10
  kactive_modes CountActiveBinsRecursive kModeFreqs, 0, 10

  if kactive_modes > 0 then
    amode_l = amode_l_sum / kactive_modes
    amode_r = amode_r_sum / kactive_modes
  else
    amode_l = 0
    amode_r = 0
  endif

  afilt_l = afilt_l * (1+(ampdbfs(15)*kfilter_depth))
  afilt_r = afilt_r * (1+(ampdbfs(15)*kfilter_depth))
  across_l = across_l * ampdbfs(-8)
  across_r = across_r * ampdbfs(-8)

  aout_l = (afilt_l * kfx_filter_on) + (across_l * kfx_cross_on) + (amorph_l * kfx_morph_on) + (amode_l * kfx_mode_on)
  aout_r = (afilt_r * kfx_filter_on) + (across_r * kfx_cross_on) + (amorph_r * kfx_morph_on) + (amode_r * kfx_mode_on)
  kactive = max(1, kfx_filter_on + kfx_cross_on + kfx_morph_on + kfx_mode_on)

  outch 1, aout_l / kactive, 2, aout_r / kactive
endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
