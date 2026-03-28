<Cabbage>
form size(1065, 711), caption("Rope MIDI"), pluginId("rom1"), guiMode("queue"), colour(30,30,30)
; -- Row 1: event-to-MIDI triggers ---------------------------------------------------------
groupbox bounds(417, 5, 270, 82), colour(60,78,90), lineThickness(0){
label bounds(5, 5, 90, 12), text("Wave Osc"), fontSize(10), align("left")
rslider channel("Freq_wav"),     bounds(8,  14, 58, 62), text("Freq"),   range(20, 300, 100, 0.35)
rslider channel("Amp_wav"),      bounds(70, 14, 58, 62), text("Amp"),    range(-50, 6, 0, 3)
rslider channel("detune_wav"),   bounds(132,14, 58, 62), text("Detune"), range(0, 1, 0.1, 0.35)
button  channel("Wave_raw_on"),  bounds(200,14, 60, 26), text("raw"),    colour:0("black"), colour:1("green")
button  channel("Wave_fine_on"), bounds(200,46, 60, 26), text("fine"),   colour:0("black"), colour:1("green")
}

groupbox bounds(5, 634, 300, 72), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 90, 12), text("Stopchord"), fontSize(10), align("left")
label   bounds(8, 17, 52, 14),  text("thresh"), fontSize(11)
nslider channel("stop_activity_thresh"), bounds(8, 32, 50, 22), range(0.01, 1, 0.3)
button  channel("Stopchord"),            bounds(66, 24, 75, 28), text("On"), colour:0("black"), colour:1("green")
label   bounds(153, 17, 40, 14), text("det"), fontSize(11)
nslider channel("detune_stopchord"),     bounds(153, 32, 45, 22), range(0, 1, 0.1)
label   bounds(205, 17, 38, 14), text("amp"), fontSize(11)
nslider channel("amp_stopchord"),        bounds(205, 32, 50, 22), range(-96, -10, -30)
button  channel("stopchord_scalefree"),  bounds(258, 14, 38, 24), text("scale"), colour:0("black"), colour:1("green")
button  channel("stopchord_minmax"),     bounds(258, 42, 38, 24), text("minmax"), colour:0("black"), colour:1("green")
}

groupbox bounds(306, 634, 114, 72), colour(60,78,90), lineThickness(0){
label bounds(5, 5, 90, 12), text("Stop LSYS"), fontSize(10), align("left")
button channel("Stop_LSYS"), bounds(20, 24, 75, 28), text("On"), colour:0("black"), colour:1("green")
}

; -- Row 2: Fader Bank + DCT Bank ---------------------------------------------------------
groupbox bounds(5, 85, 380, 116), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 90, 12), text("Fader Bank"), fontSize(10), align("left")
button   channel("Fader_bank"),          bounds(8, 16, 76, 23), text("On"), colour:0("black"), colour:1("green")
label    bounds(8, 38, 60, 12), text("arp ms"), fontSize(10), align("left")
nslider  channel("faderbank_arp_ms"),    bounds(8, 52, 76, 22), range(0, 100, 0, 1, 1)
label    bounds(8, 76, 60, 12), text("mov arp"), fontSize(10), align("left")
nslider  channel("faderbank_mov_arp"),   bounds(8, 90, 76, 22), range(0, 1, 0, 1, 0.01)
label    bounds(93, 14, 42, 14), text("scale"), fontSize(11)
combobox channel("Fader_bank_scale"),    bounds(93, 28, 110, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(209, 14, 50, 14), text("M.base"), fontSize(11)
nslider  channel("faderbank_basenote"),  bounds(209, 28, 50, 22), range(0, 127, 60, 1, 1)
label    bounds(264, 14, 50, 14), text("M.chan"), fontSize(11)
nslider  channel("faderbank_midichan"),  bounds(264, 28, 50, 22), range(1, 16, 1, 1, 1)
label    bounds(319, 14, 55, 14), text("M.thresh"), fontSize(11)
nslider  channel("faderbank_ampthresh"), bounds(319, 28, 55, 22), range(0.0, 1.0, 0.08, 1, 0.001)
label    bounds(93, 62, 42, 14), text("D.scale"), fontSize(11)
combobox channel("Fader_bank_down_scale"), bounds(93, 76, 110, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(209, 62, 50, 14), text("D.base"), fontSize(11)
nslider  channel("faderbank_down_basenote"), bounds(209, 76, 50, 22), range(0, 127, 48, 1, 1)
label    bounds(264, 62, 50, 14), text("D.chan"), fontSize(11)
nslider  channel("faderbank_down_midichan"), bounds(264, 76, 50, 22), range(1, 16, 1, 1, 1)
label    bounds(319, 62, 55, 14), text("D.thresh"), fontSize(11)
nslider  channel("faderbank_down_ampthresh"), bounds(319, 76, 55, 22), range(-1.0, 0.0, -0.08, 1, 0.001)
}

groupbox bounds(386, 85, 330, 82), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 80, 12), text("DCT Bank"), fontSize(10), align("left")
button   channel("Dct_bank"),         bounds(8, 18, 60, 26), text("On"), colour:0("black"), colour:1("green")
label    bounds(74, 10, 44, 14), text("scale"), fontSize(11)
combobox channel("Dct_bank_scale"),   bounds(74, 24, 100, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(179, 10, 40, 14), text("base"), fontSize(11)
nslider  channel("dct_basenote"),     bounds(179, 24, 46, 22), range(0, 127, 60, 1, 1)
label    bounds(229, 10, 40, 14), text("chan"), fontSize(11)
nslider  channel("dct_midichan"),     bounds(229, 24, 40, 22), range(1, 16, 1, 1, 1)
label    bounds(273, 10, 52, 14), text("thresh"), fontSize(11)
nslider  channel("dct_ampthresh"),    bounds(273, 24, 52, 22), range(0.0, 2.0, 0.3, 1, 0.01)
label    bounds(179, 50, 30, 12), text("att"), fontSize(10), align("left")
nslider  channel("dct_env_att"),      bounds(179, 62, 46, 18), range(0.001, 0.2, 0.01, 0.5, 0.001)
label    bounds(229, 50, 30, 12), text("rel"), fontSize(10), align("left")
nslider  channel("dct_env_rel"),      bounds(229, 62, 46, 18), range(0.05, 2.0, 0.9, 0.5, 0.01)
}

groupbox bounds(718, 85, 342, 116), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 80, 12), text("Hex Grid"), fontSize(10), align("left")
button   channel("Hex_grid"),           bounds(8, 18, 60, 26), text("On"), value(0), colour:0("black"), colour:1("green")
label    bounds(74, 10, 44, 14), text("layout"), fontSize(11)
combobox channel("hexgrid_layout"),     bounds(74, 24, 152, 22), items("Harmonic", "Wicki-Hayden", "Tonnetz", "Harmonetta", "Janko", "Chromatic"), value(1)
label    bounds(230, 10, 40, 14), text("base"), fontSize(11)
nslider  channel("hexgrid_basenote"),   bounds(230, 24, 46, 22), range(0, 127, 60, 1, 1)
label    bounds(280, 10, 36, 14), text("chan"), fontSize(11)
nslider  channel("hexgrid_midichan"),   bounds(280, 24, 40, 22), range(1, 16, 1, 1, 1)
label    bounds(8, 58, 56, 12), text("max dur"), fontSize(10), align("left")
nslider  channel("hexgrid_maxdur"),     bounds(8, 72, 80, 22), range(0.1, 4.0, 0.7, 1, 0.05)
label    bounds(96, 58, 48, 12), text("fields x"), fontSize(10), align("left")
nslider  channel("hexgrid_size_x"),     bounds(96, 72, 58, 22), range(3, 30, 6, 1, 1)
label    bounds(162, 58, 48, 12), text("fields y"), fontSize(10), align("left")
nslider  channel("hexgrid_size_y"),     bounds(162, 72, 58, 22), range(3, 30, 6, 1, 1)
}

; -- Row 3: Distance Grain -----------------------------------------------------------------
groupbox bounds(5, 218, 545, 92), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 95, 12), text("Distance Grain"), fontSize(10), align("left")
button  channel("Distance_grain"),       bounds(8, 20, 80, 28), text("On"), colour:0("black"), colour:1("green")
rslider channel("Grate"),                bounds(98, 14, 58, 62), text("G.rate"),   range(0.5, 20, 4, 0.35)
rslider channel("Gdur"),                 bounds(160,14, 58, 62), text("G.dur"),    range(0.1, 2, 1, 0.35)
rslider channel("G_dist_rate"),          bounds(222,14, 58, 62), text("Dist.rate"),range(0, 10, 0.1)
rslider channel("G_voice_spread"),       bounds(284,14, 58, 62), text("V.spread"), range(0, 7, 0.1)
rslider channel("distgrains_ampthresh"), bounds(354,14, 58, 62), text("M.thresh"), range(-90, 0, -5), markerColour(55,115,220)
label   bounds(420, 14, 52, 14), text("base"), fontSize(11)
nslider channel("distgrains_basenote"), bounds(420, 30, 52, 22), range(0, 127, 45, 1, 1)
label   bounds(478, 14, 56, 14), text("basechan"), fontSize(11)
nslider channel("distgrains_midichan"),  bounds(478, 30, 52, 22), range(1, 16, 1, 1, 1)
}

; -- Row 4: Grain2 (audio + all 4 MIDI voices flowing right) ------
groupbox bounds(5, 318, 1055, 92), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 90, 12), text("Grain2"), fontSize(10), align("left")
button  channel("Grain2"),                  bounds(8, 20, 75, 28), text("On"), colour:0("black"), colour:1("green")
rslider channel("Grainpitch2"),             bounds(93, 14, 58, 62), text("G.pitch"),  range(10, 1000, 100, 0.35)
rslider channel("Grainamp2"),               bounds(155,14, 58, 62), text("Amp"),      range(-50, 6, 0, 3)
rslider channel("Grate2"),                  bounds(217,14, 58, 62), text("G.rate"),   range(0.5, 20, 4, 0.35)
rslider channel("Gdur2"),                   bounds(279,14, 58, 62), text("G.dur"),    range(0.1, 2, 1, 0.35)
rslider channel("G2_pitchmod"),             bounds(341,14, 58, 62), text("Ptch.mod"), range(0, 2, 1, 0.35)
rslider channel("G2_pitch_spread"),         bounds(403,14, 58, 62), text("Ptch.spd"), range(0, 1, 0.1, 0.35)
rslider channel("G2_ratemod"),              bounds(465,14, 58, 62), text("Ratemod"),  range(0, 2, 1, 0.35)
rslider channel("graincloud_ampthresh_1"),  bounds(535,14, 58, 62), text("V1.thr"),   range(-90, 0, -5), markerColour(55,115,220)
nslider channel("graincloud_transpose_1"),  bounds(597,16, 50, 22), range(-24, 24, 0, 1, 1), text("transp")
nslider channel("graincloud_midichan_1"),   bounds(597,46, 50, 22), range(1, 16, 1, 1, 1), text("chan")
rslider channel("graincloud_ampthresh_2"),  bounds(653,14, 58, 62), text("V2.thr"),   range(-90, 0, -5), markerColour(55,115,220)
nslider channel("graincloud_transpose_2"),  bounds(715,16, 50, 22), range(-24, 24, 0, 1, 1), text("transp")
nslider channel("graincloud_midichan_2"),   bounds(715,46, 50, 22), range(1, 16, 2, 1, 1), text("chan")
rslider channel("graincloud_ampthresh_3"),  bounds(771,14, 58, 62), text("V3.thr"),   range(-90, 0, -5), markerColour(55,115,220)
nslider channel("graincloud_transpose_3"),  bounds(833,16, 50, 22), range(-24, 24, 0, 1, 1), text("transp")
nslider channel("graincloud_midichan_3"),   bounds(833,46, 50, 22), range(1, 16, 3, 1, 1), text("chan")
rslider channel("graincloud_ampthresh_4"),  bounds(889,14, 58, 62), text("V4.thr"),   range(-90, 0, -5), markerColour(55,115,220)
nslider channel("graincloud_transpose_4"),  bounds(951,16, 50, 22), range(-24, 24, 0, 1, 1), text("transp")
nslider channel("graincloud_midichan_4"),   bounds(951,46, 50, 22), range(1, 16, 4, 1, 1), text("chan")
}

; -- Row 5: L-System + console ---------------------------------------------------------

groupbox bounds(5, 418, 415, 215), colour(60,78,90), lineThickness(0){ 
nslider channel("generations"), bounds(5,5,40,20), range(1, 10, 3, 1, 1), fontSize(14)
label bounds(5,22,40,18), text("gens"), fontSize(12), align("left")

nslider channel("gen_interval"), bounds(60,5,40,20), range(-12, 12, 3, 1, 1), fontSize(14)
label bounds(60,22,50,18), text("interval"), fontSize(12), align("left")

combobox channel("root"), bounds(115,5,40,20), range(0, 3, 0, 1, 1), items("A", "B", "C", "D")
label bounds(115,22,50,18), text("root"), fontSize(12), align("left")

nslider channel("tempo"), bounds(170,5,40,20), range(10, 300, 120, 1, 1), fontSize(14)
label bounds(170,22,50,18), text("tempo"), fontSize(12), align("left")

nslider channel("perc_gen"), bounds(225,5,40,20), range(0, 4, 1, 1, 1), fontSize(14)
label bounds(225,22,60,18), text("perc_gen"), fontSize(12), align("left")

label bounds(345,5,60,18), text("midi chan"), fontSize(12), align("left")
label bounds(325,20,30,18), text("gen 1"), fontSize(12), align("left")
label bounds(325,40,30,18), text("gen 2"), fontSize(12), align("left")
label bounds(325,60,30,18), text("gen 3"), fontSize(12), align("left")
label bounds(325,80,30,18), text("gen 4"), fontSize(12), align("left")
nslider channel("midichan_gen1"), bounds(360,20,40,18), range(1, 16, 1, 1, 1), fontSize(14)
nslider channel("midichan_gen2"), bounds(360,40,40,18), range(1, 16, 2, 1, 1), fontSize(14)
nslider channel("midichan_gen3"), bounds(360,60,40,18), range(1, 16, 3, 1, 1), fontSize(14)
nslider channel("midichan_gen4"), bounds(360,80,40,18), range(1, 16, 4, 1, 1), fontSize(14)
label bounds(300,105,100,18), text("drum map (ch 10)"), fontSize(12), align("left")
label bounds(325,120,30,18), text("A"), fontSize(12), align("left")
label bounds(325,140,30,18), text("B"), fontSize(12), align("left")
label bounds(325,160,30,18), text("C"), fontSize(12), align("left")
label bounds(325,180,30,18), text("D"), fontSize(12), align("left")
nslider channel("drum_map_A"), bounds(360,120,40,18), range(1, 127, 60, 1, 1), fontSize(14)
nslider channel("drum_map_B"), bounds(360,140,40,18), range(1, 127, 61, 1, 1), fontSize(14)
nslider channel("drum_map_C"), bounds(360,160,40,18), range(1, 127, 62, 1, 1), fontSize(14)
nslider channel("drum_map_D"), bounds(360,180,40,18), range(1, 127, 63, 1, 1), fontSize(14)

nslider channel("interval0"), bounds(5,50,40,20), range(-12, 12, -5, 1, 1), fontSize(14)
label bounds(5,72,40,18), text("intv A"), fontSize(12), align("left")
nslider channel("interval1"), bounds(60,50,40,20), range(-12, 12, 3, 1, 1), fontSize(14)
label bounds(60,72,50,18), text("intv B"), fontSize(12), align("left")
nslider channel("interval2"), bounds(115,50,40,20), range(-12, 12, 1, 1, 1), fontSize(14)
label bounds(115,72,50,18), text("intv C"), fontSize(12), align("left")
nslider channel("interval3"), bounds(170,50,40,20), range(-12, 12, 12, 1, 1), fontSize(14)
label bounds(170,72,50,18), text("intv D"), fontSize(12), align("left")

texteditor bounds(5,95,45,20), channel("rule0"), colour("black"), caretColour("white"), fontColour("white"), text("BB")
label bounds(5,117,50,18), text("rule A"), fontSize(12), align("left")
texteditor bounds(60,95,45,20), channel("rule1"), colour("black"), caretColour("white"), fontColour("white"), text("C")
label bounds(60,117,50,18), text("rule B"), fontSize(12), align("left")
texteditor bounds(115,95,45,20), channel("rule2"), colour("black"), caretColour("white"), fontColour("white"), text("A")
label bounds(115,117,50,18), text("rule C"), fontSize(12), align("left")
texteditor bounds(170,95,45,20), channel("rule3"), colour("black"), caretColour("white"), fontColour("white"), text("BB")
label bounds(170,117,50,18), text("rule D"), fontSize(12), align("left")
button channel("print_rules"), bounds(235,95,50,18), text("print rules"), colour:0("green"), colour:1("red"), latched(0)

checkbox channel("no_genZ_interval"), bounds(5,145,15,15), value(1)
label bounds(23,144,130,18), text("no interval for gen zero"), fontSize(12), align("left")
checkbox channel("sibling_interval"), bounds(5,165,15,15), value(1)
label bounds(23,164,130,18), text("interval from sibling"), fontSize(12), align("left")
checkbox channel("root_note_sibling"), bounds(5,185,15,15), value(1)
label bounds(23,184,130,18), text("root_note_sibling"), fontSize(12), align("left")
}

csoundoutput bounds(430, 573, 625, 133)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0 -M0 -Q0 -+rtmidi=null 
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 16
0dbfs=1

massign -1,102
pgmassign -1, -1

  gknum_faders = 10
  gifadertab_size = 16
  giWaveRaw ftgen 1, 0, gifadertab_size,  7, 0, gifadertab_size, -1 
  giWaveRaw1 ftgen 0, 0, gifadertab_size, -2, 0  ; empty  
  giWaveRaw2 ftgen 0, 0, gifadertab_size, -2, 0  ; empty
  giWaveRaws ftgen 0, 0, 2, -2, giWaveRaw1, giWaveRaw2

  gifine_size = 1024
  giWaveFine ftgen 2, 0, gifine_size,  7, 0, gifine_size, -1 
  giWaveFine1 ftgen 11, 0, gifine_size, -2, 0  ; empty  
  giWaveFine2 ftgen 12, 0, gifine_size, -2, 0  ; empty
  giWaveFines ftgen 0, 0, 2, -2, giWaveFine1, giWaveFine2

  gkXpos[] init 32
  gkXdistance[] init 32
  gkZerocross[] init 32
  gkZerocross_distance[] init 32
  gkDctbins[] init 32
  gkFaderActiveUp[] init 32
  gkFaderActiveDown[] init 32
  gkFaderOnDelayUp[] init 32
  gkFaderOnDelayDown[] init 32
  gkFaderInstrUp[] init 32
  gkFaderInstrDown[] init 32

  gihandle OSCinit 9899 ; set the network port number where we will receive OSC data from Python

  ; classic waveforms
	giSine		ftgen	0, 0, 65537, 10, 1					; sine wave
	giCosine	ftgen	0, 0, 8193, 9, 1, 1, 90					; cosine wave
	giTri		ftgen	0, 0, 8193, 7, 0, 2048, 1, 4096, -1, 2048, 0		; triangle wave 

	; grain envelope tables
	giSigmoRise 	ftgen	0, 0, 8193, 19, 0.5, 1, 270, 1				; rising sigmoid
	giSigmoFall 	ftgen	0, 0, 8193, 19, 0.5, 1, 90, 1				; falling sigmoid
	giExpFall	ftgen	0, 0, 8193, 5, 1, 8193, 0.00001				; exponential decay
	giTriangleWin 	ftgen	0, 0, 8193, 7, 0, 4096, 1, 4096, 0			; triangular window 

opcode ButtonEvent, 0, kij
  kbutton, instrnum, iparm xin ; iparm is optional p4
  ktrigon trigger kbutton, 0.5, 0
  ktrigoff trigger kbutton, 0.5, 1
  if ktrigon > 0 then
    event "i", instrnum, 0, -1, iparm
  endif
  if ktrigoff > 0 then
    event "i", -instrnum, 0, .1
  endif
endop

opcode EnvFollow, k, kkk
  kval, krise, kfall xin
  kA = 0.001^(1/(krise*kr))
  kB = 0.001^(1/(kfall*kr))
  kfilt init 0
  kfilt = (kval>kfilt?(kval+(kA*(kfilt-kval))):(kval+(kB*(kfilt-kval))))
  kval = kfilt
  xout kfilt
endop   

opcode MinArrayThresh, k, k[]k
  kArr[],kthresh xin
  kndx init 0
  kmin init 9999999
  while kndx < lenarray(kArr) do
    if kArr[kndx] > kthresh then
      kmin min kArr[kndx], kmin
    endif
    kndx += 1
  od
  xout kmin
endop


instr 1
  ; GUI control
  kwave_raw_on chnget "Wave_raw_on"
  ButtonEvent kwave_raw_on, 10.1, giWaveRaw

  kwave_fine_on chnget "Wave_fine_on"
  ButtonEvent kwave_fine_on, 10.2, giWaveFine

  kwave_raw_detune_on chnget "Wave_raw_detune_on"
  ButtonEvent kwave_raw_detune_on, 11.1, giWaveRaw

  kwave_fine_detune_on chnget "Wave_fine_detune_on"
  ButtonEvent kwave_fine_detune_on, 11.2, giWaveFine

  kdistance_grain_on chnget "Distance_grain"
  ButtonEvent kdistance_grain_on, 12

  kgrain2_on chnget "Grain2"
  ButtonEvent kgrain2_on, 13

  kdct_bank_on chnget "Dct_bank"
  ButtonEvent kdct_bank_on, 16, giWaveRaw

  kfader_bank_on chnget "Fader_bank"
  ButtonEvent kfader_bank_on, 17, giWaveRaw
  kfader_bank_off trigger kfader_bank_on, 0.5, 1
  if kfader_bank_off > 0 then
    kup_midi_chan chnget "faderbank_midichan"
    kdown_midi_chan chnget "faderbank_down_midichan"
    kidx = 0
    while kidx < gknum_faders do
      gkFaderActiveUp[kidx] = 0
      gkFaderActiveDown[kidx] = 0
      gkFaderOnDelayUp[kidx] = 0
      gkFaderOnDelayDown[kidx] = 0
      gkFaderInstrUp[kidx] = 0
      gkFaderInstrDown[kidx] = 0
      kidx += 1
    od
    event "i", 203, 0, 0.05, int(kup_midi_chan)
    if int(kdown_midi_chan) != int(kup_midi_chan) then
      event "i", 203, 0, 0.05, int(kdown_midi_chan)
    endif
  endif

  knoisebank_on chnget "Noisebank"
  ButtonEvent knoisebank_on, 5

  kstopchord_on chnget "Stopchord"
  ButtonEvent kstopchord_on, 18
  
  kstop_lsys_on chnget "Stop_LSYS"
  ButtonEvent kstop_lsys_on, 20

  ; OSC receive
    khex_grid_on chnget "Hex_grid"
    ButtonEvent khex_grid_on, 21
    khex_grid_off trigger khex_grid_on, 0.5, 1
    if khex_grid_off > 0 then
      khex_chan_off chnget "hexgrid_midichan"
      event "i", 203, 0, 0.05, int(khex_chan_off)
    endif

    klayout_hex chnget "hexgrid_layout"
    khex_boot init 1
    ktrig_hex_layout changed klayout_hex
    ktrig_hex_layout = (ktrig_hex_layout > 0 || khex_boot > 0 ? 1 : 0)
    OSCsend ktrig_hex_layout, "127.0.0.1", 9801, "/hex_layout", "f", klayout_hex

    khex_size_x chnget "hexgrid_size_x"
    khex_size_y chnget "hexgrid_size_y"
    ktrig_hex_size_x changed khex_size_x
    ktrig_hex_size_y changed khex_size_y
    ktrig_hex_size_x = (ktrig_hex_size_x > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_hex_size_y = (ktrig_hex_size_y > 0 || khex_boot > 0 ? 1 : 0)
    OSCsend ktrig_hex_size_x, "127.0.0.1", 9801, "/hex_size_x", "f", khex_size_x
    OSCsend ktrig_hex_size_y, "127.0.0.1", 9801, "/hex_size_y", "f", khex_size_y
    khex_boot = 0

    ; Python startup query: send current grid settings on request.
    khex_query_req init 0
    next_hex_query:
    kmess_hex_query OSClisten gihandle, "hex_query", "i", khex_query_req
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_layout", "f", klayout_hex
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_size_x", "f", khex_size_x
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_size_y", "f", khex_size_y
    if kmess_hex_query > 0 then
      kgoto next_hex_query
    endif

    ; OSC receive
    kOSC_received = 0
  
  kfader_ndx init 0
  kfader_val init 0
  k_num_faders init 0
  ktimethen init 0
  nextmsg_faders:
  kmess OSClisten gihandle, "faders", "fff", kfader_ndx, kfader_val, k_num_faders ; receive OSC data from Python
  kOSC_received += kmess
  if kmess == 0 goto done_faders
  kswitch init 0
  ktab_raw table kswitch, giWaveRaws
  
  tablewkt kfader_val, kfader_ndx, ktab_raw
  if kfader_ndx == k_num_faders-1 then
    kswitch = kswitch == 0 ? 1 : 0
    ktime timeinsts
    kupdate_time limit ktime-ktimethen, 0, 5
    ktimethen = ktime
    event "i", 2, 0, kupdate_time, ktab_raw, k_num_faders
  endif
  kgoto nextmsg_faders 
  done_faders:
  
  knumpeaks init 0
  knumpeaks_median init 0
  knumpeaks_lowpass init 0
  kavg_x_distance init 0
  kavg_x_movement init 0
  kleft_lobe_x init 0
  kright_lobe_x init 0
  kmax_lobe_x init 0
  kshape_centroid_x init 0.5
  kwave_activity init 0
  kwave_amp init 0
  kamp_comp init 0
  kcurvature_rms init 0
  kspectral_centroid init 0
  kshape_centroid init 0.5
  khorizontal_cog_norm init 0.5
  nextmsg_rope_metrics:
    kmess OSClisten gihandle, "rope_metrics", "ffffffffffffffff", knumpeaks, knumpeaks_median, knumpeaks_lowpass, kavg_x_distance, kavg_x_movement, kleft_lobe_x, kright_lobe_x, kmax_lobe_x, kshape_centroid_x, kwave_activity, kwave_amp, kspectral_centroid, kshape_centroid, khorizontal_cog_norm, kamp_comp, kcurvature_rms
    kOSC_received += kmess
    if kmess == 0 goto done_rope_metrics
    chnset knumpeaks, "numpeaks"
    chnset knumpeaks_median, "numpeaks_median"
    chnset knumpeaks_lowpass, "numpeaks_lowpass"
    chnset kavg_x_distance, "avg_x_distance"
    chnset kavg_x_movement, "avg_x_movement"
    chnset kleft_lobe_x, "left_lobe_x"
    chnset kright_lobe_x, "right_lobe_x"
    chnset kmax_lobe_x, "max_lobe_x"
    chnset kshape_centroid_x, "shape_centroid_x"
    chnset kwave_activity, "wave_activity"
    chnset kwave_amp, "wave_amp"
    chnset kamp_comp, "amp_comp"
    chnset kcurvature_rms, "curvature_rms"
    chnset kspectral_centroid, "spectral_centroid"
    chnset kshape_centroid, "shape_centroid"
    chnset khorizontal_cog_norm, "horizontal_cog_norm"
    kgoto nextmsg_rope_metrics
  done_rope_metrics:
 
  kxpos init 0
  kxpos_ndx init 0
  gkXpos *= 0
  nextmsg_xpos:
    kmess OSClisten gihandle, "xpos", "ff", kxpos_ndx, kxpos
    kOSC_received += kmess
    if kmess == 0 goto done_xpos
    gkXpos[kxpos_ndx] = kxpos
    kgoto nextmsg_xpos
  done_xpos:

  kxdistance init 0
  kxdistance_ndx init 0
  gkXdistance *= 0
  nextmsg_xdistance:
    kmess OSClisten gihandle, "xdistance", "ff", kxdistance_ndx, kxdistance
    kOSC_received += kmess
    if kmess == 0 goto done_xdistance
    gkXdistance[kxdistance_ndx] = kxdistance
    kgoto nextmsg_xdistance
  done_xdistance:

  kzerocross init 0
  kzerocross_ndx init 0
  gkZerocross *= 0
  nextmsg_zerocross:
    kmess OSClisten gihandle, "zerocross", "ff", kzerocross_ndx, kzerocross
    kOSC_received += kmess
    if kmess == 0 goto done_zerocross
    gkZerocross[kzerocross_ndx] = kzerocross
    kgoto nextmsg_zerocross
  done_zerocross:

  kzerocross_distance init 0
  kzerocross_distance_ndx init 0
  gkZerocross_distance *= 0
  nextmsg_zerocross_distance:
    kmess OSClisten gihandle, "zerocross_distance", "ff", kzerocross_distance_ndx, kzerocross_distance
    kOSC_received += kmess
    if kmess == 0 goto done_zerocross_distance
    gkZerocross_distance[kzerocross_distance_ndx] = kzerocross_distance
    kgoto nextmsg_zerocross_distance
  done_zerocross_distance:

  kdct_bin init 0
  kdct_bin_ndx init 0
  gkDctbins *= 0
  nextmsg_dct:
    kmess OSClisten gihandle, "dct_bin", "ff", kdct_bin_ndx, kdct_bin
    kOSC_received += kmess
    if kmess == 0 goto done_dct
    gkDctbins[kdct_bin_ndx] = kdct_bin
    kgoto nextmsg_dct
  done_dct:


  Soscreceived = "OK OSC received"
  kOSC_received limit kOSC_received, 0, 1
  puts Soscreceived, kOSC_received

endin


instr 2
  ;write the wave tables with data from the rope tracking (quantized "fader" positions on the rope)
  itab = p4
  inum_faders = p5
  if itab == giWaveRaw2 then
    kndx line 0, p3-1/kr, 1
  else 
    kndx line 1, p3-1/kr, 0
  endif
  
  gifine_size = 1024
  istepsize = floor(gifine_size/(inum_faders+1))
  ilaststep = gifine_size-(istepsize*inum_faders)
  giWaveFine1 ftgen 11, 0, gifine_size, 6, 0, istepsize,  table(0,giWaveRaw1),\
                                              istepsize,  table(1,giWaveRaw1),\
                                              istepsize,  table(2,giWaveRaw1),\
                                              istepsize,  table(3,giWaveRaw1),\
                                              istepsize,  table(4,giWaveRaw1),\
                                              istepsize,  table(5,giWaveRaw1),\
                                              istepsize,  table(6,giWaveRaw1),\
                                              istepsize,  table(7,giWaveRaw1),\
                                              istepsize,  table(8,giWaveRaw1),\
                                              istepsize,  table(9,giWaveRaw1),\
                                              ilaststep,  0
  giWaveFine2 ftgen 12, 0, gifine_size, 6, 0, istepsize,  table(0,giWaveRaw2),\
                                              istepsize,  table(1,giWaveRaw2),\
                                              istepsize,  table(2,giWaveRaw2),\
                                              istepsize,  table(3,giWaveRaw2),\
                                              istepsize,  table(4,giWaveRaw2),\
                                              istepsize,  table(5,giWaveRaw2),\
                                              istepsize,  table(6,giWaveRaw2),\
                                              istepsize,  table(7,giWaveRaw2),\
                                              istepsize,  table(8,giWaveRaw2),\
                                              istepsize,  table(9,giWaveRaw2),\
                                              ilaststep,  0
  ftmorf kndx, giWaveRaws, giWaveRaw
  ftmorf kndx, giWaveFines, giWaveFine
endin


instr 10
  ; hsb oscil waveshaped by rope wave
  itab = p4
  print itab
  kfreq chnget "Freq_wav"
  kfreq *= 0.5
  knumpeaks chnget "numpeaks"
  kavg_x_movement chnget "avg_x_movement"
  kdetune chnget "detune_wav"
  ktone = 0.5+(kavg_x_movement*kdetune)
  kbrite = tonek(knumpeaks, 1)
  ioctfn ftgentmp 0, 0, 1024, -19, 1, 0.5, 270, 0.5
  kamp_dB chnget "Amp_wav"
  kamp = ampdbfs(kamp_dB)
  ;a1 poscil kamp, kfreq
  if changed(kfreq) > 0 then
    reinit generator
  endif
  generator:
  ibasfreq = i(kfreq)
  a1L hsboscil kamp, 0.5, kbrite, ibasfreq, giSine, ioctfn
  a1R hsboscil kamp, ktone, kbrite, ibasfreq, giSine, ioctfn
  ; waveshaping
  icenter = 10/16
  a2L tablei a1L*icenter, itab, 1, icenter, 0 ;
  a2R tablei a1R*icenter, itab, 1, icenter, 0 ;
  a2L dcblock a2L 
  a2R dcblock a2R 
  a2L *= kamp
  a2R *= kamp
  outch 1, a2L*0.3, 2, a2R*0.3
endin

instr 11
  ; detuned sine oscil waveshaped by rope wave
  itab = p4
  print itab
  kfreq chnget "Freq_wavd"
  kavg_x_movement chnget "avg_x_movement"
  knumpeaks chnget "numpeaks"
  kdetune chnget "detune_wavd"
  kfreq1 = kfreq+kfreq*(tonek(knumpeaks+1,2))*kdetune
  kfreq2 = kfreq-kfreq*(tonek(knumpeaks+1,0.7))*kdetune
  kamp_dB chnget "Amp_wavd"
  kamp = ampdbfs(kamp_dB)
  a10 poscil kamp, kfreq
  a11 poscil kamp, kfreq1
  a12 poscil kamp, kfreq2
  a1 sum a10,a11,a12
  a1L = (a10+a11)*0.5
  a1R = (a10+a12)*0.5
  a1 *= 0.33
  if itab = 1 then
    icenter = 10/16
  else
    icenter = 0.5
  endif
  a2 tablei a1*icenter, itab, 1, icenter, 0 ;
  a2L tablei a1L*icenter, itab, 1, icenter, 0 ;
  a2R tablei a1R*icenter, itab, 1, icenter, 0 ;
  a2 dcblock a2  
  a2L dcblock a2L 
  a2R dcblock a2R
  aleft = a2*0.1+a2L*0.9
  aright = a2*0.1+a2R*0.9
  aleft lpf18 aleft, 100+(tonek(knumpeaks+1,2)*600), 0.3, 0.9
  aright lpf18 aright, 100+(tonek(knumpeaks+1,2)*600), 0.3, 0.9
  outch 3, aleft*0.15, 4, aright*0.15
endin

opcode DistanceGrains, a, k[]kkkkkkkkkiii
  kDistance[], kamp, kwavfreq, kgrainrate, kdist_rate, kvoice_spread, kgraindur, kamp_thresh, ktranspose, kchan, ivoice, imaxvoice, iopcode_id xin
  kamp1 = kDistance[ivoice] > 0 ? 1 : 0
  kamp1 EnvFollow kamp1, 0.01, 2
  kamp *= kamp1

  ; grain rate
  kgrainrate tonek kgrainrate*(1+(kDistance[ivoice]*kdist_rate)), 1
  agrainrate = kgrainrate
  async = 0

; distribution 
	kdistribution	= 0; chnget "Distribution"			; grain random distribution in time
	idisttab	ftgentmp	0, 0, 16, 16, 1, 16, -10, 0	; probability distribution for random grain masking

; grain shape
	kduration	= divz(1,kgrainrate,1)*kgraindur*1000; 0.5; chnget "Graindur"		

	ienv_attack	= giSigmoRise 			; grain attack shape (from table)
	ienv_decay	= giSigmoFall 			; grain decay shape (from table)
	ksustain_amount	= 0.0					  ; balance between enveloped time(attack+decay) and sustain level time, 0.0 = no time at sustain level
	ka_d_ratio = 0.1      					; balance between attack time and decay time, 0.0 = zero attack time and full decay time
	kenv2amt = 0                    ; amount of secondary enveloping per grain (e.g. for fof synthesis)
	ienv2tab	= giExpFall 				  ; secondary grain shape (from table), enveloping the whole grain if used

; select source waveforms
	kwaveform	= giSine		; source audio waveform 

; original pitch for each waveform, use if they should be transposed individually
	kwavekey1	= 1
	kwavekey2	= 1
	kwavekey3	= 1
	kwavekey4	= 1
	asamplepos	= 0				

; "master" grain pitch (transpose for all 4 source waveforms)
  kwavfreq	= kwavfreq*semitone(ivoice*kvoice_spread)					; transposition factor (playback speed) of audio inside grains, 
  
; pitch sweep
	ksweepshape		= 0.5						; grain wave pitch sweep shape (sweep speed), 0.5 is linear sweep
	iwavfreqstarttab 	ftgentmp	0, 0, 16, -2, 0, 0,   1		; start freq scalers, per grain
	iwavfreqendtab		ftgentmp	0, 0, 16, -2, 0, 0,   1		; end freq scalers, per grain

; FM of grain pitch (playback speed)
	awavfm = 0

; trainlet parameters (not using trainlets)
	icosine	= giCosine
	kTrainCps	= 100		
	knumpartials = 1	
	kchroma = 1	

	; gain masking table, amplitude for individual grains
	igainmasks	ftgentmp	0, 0, 16, -2, 0, 0, 1

	; channel masking table, output routing for individual grains (zero based, a value of 0.0 routes to output 1)
	ichanmasks	ftgentmp	0, 0, 16, -2,  0, 0,  0.5
	
	; random masking (muting) of individual grains
	krandommask	=0;chnget "RandMask"

	; wave mix masking. 
  iwaveamptab	ftgentmp 0, 0, 32, -2,   0, 0,  1,0,0,0,0

; system parameter
	imax_grains	= 100				; max number of grains per k-period
  iopcode_id += 1
        
	a1,a2,a3,a4,a5,a6,a7,a8	partikkel \					; 					
			agrainrate, \						; grains per second			
			kdistribution, idisttab, async, \			; synchronous/asynchronous		
			kenv2amt, ienv2tab, ienv_attack, ienv_decay, \		; grain envelope (advanced)		
			ksustain_amount, ka_d_ratio, kduration, \		; grain envelope 			
			kamp, \							; amp					
			igainmasks, \						; gain masks (advanced)			
			kwavfreq, \						; grain pitch (playback frequency)	
			ksweepshape, iwavfreqstarttab, iwavfreqendtab, \	; grain pith sweeps (advanced)		
			awavfm, -1, -1, \				; grain pitch FM (advanced)		
			icosine, kTrainCps, knumpartials, kchroma, \		; trainlets				
			ichanmasks, \ 					        ; channel mask (advanced)
			krandommask, \						; random masking of single grains	
			kwaveform, kwaveform, kwaveform, kwaveform, \	; set source waveforms, all set to the live input buffer here
			iwaveamptab, \						; mix source waveforms (remember, we can use different samplepos and transposition for each)
			asamplepos, asamplepos, asamplepos, asamplepos, \	; read position for source waves	
			kwavekey1, kwavekey2, kwavekey3, kwavekey4, \		; individual transpose for each source
			imax_grains, iopcode_id						; system parameter (advanced)
  
  ; midi out
  apulse, aphase partikkelsync iopcode_id
  kSig[] init ksmps
  kSig shiftin apulse
  kpulse = sumarray(kSig) 
  kphase downsamp aphase
  ilen_dist lenarray kDistance
  kactive_count init 0
  kcount_ndx = 0
  while kcount_ndx < ilen_dist do
    if abs(kDistance[kcount_ndx]) > 0.0001 then
      kactive_count += 1
    endif
    kcount_ndx += 1
  od

  if (kpulse > 0) && (kamp > kamp_thresh) then
    knote = (kwavfreq*12)+48
    knote = 12*log2(kwavfreq/440) + 69 + ktranspose
    kvel_norm = limit(abs(kDistance[ivoice]), 0, 1)
    kvel = int(limit(50 + (kvel_norm * 70), 50, 120))
    kmidi_chan chnget "distgrains_midichan"
    kchan_offset = (kactive_count > 0 ? (kactive_count - 1) % 4 : 0)
    kchan2 limit (kmidi_chan + kchan_offset), 1, 16
    event "i", 202, 0, (kduration/1000)+0.01, kvel, knote, kchan2
  endif

  if (ivoice < imaxvoice-1) then
    a1 += DistanceGrains(kDistance, kamp, kwavfreq, kgrainrate, kdist_rate, kvoice_spread, kgraindur, kamp_thresh, ktranspose, kchan, ivoice+1, imaxvoice, iopcode_id)
  endif
  iampscale = 1/imaxvoice
  xout(a1*iampscale)
endop


instr 12
  ; grain rhythm detuned by peak distances
  kbasenote chnget "distgrains_basenote"
  kwavfreq = cpsmidinn(kbasenote)
  kgrainrate chnget "Grate"
  kx_dist chnget "avg_x_distance"
  kgrainrate *= limit(1-(kx_dist)*2, 0.1, 1)
  kgraindur chnget "Gdur"
  kamp = ampdbfs(6)
  kactivity chnget "wave_activity"
  kactivity limit kactivity, 0, 1
  kamp_env EnvFollow kactivity, 0.01, 3
  kamp *= kamp_env
  kdist_rate chnget "G_dist_rate"
  kvoice_spread chnget "G_voice_spread"
  kmidi_amp_thresh chnget "distgrains_ampthresh"
  kmidi_amp_thresh ampdbfs kmidi_amp_thresh
  kmidi_transpose = 0
  kmidi_chan chnget "distgrains_midichan"
  imaxvoice = 5
  iopcode_id1 = 1
  a1 DistanceGrains gkXdistance, kamp, kwavfreq, kgrainrate, kdist_rate, kvoice_spread, kgraindur, kmidi_amp_thresh, kmidi_transpose, kmidi_chan, 0, imaxvoice, iopcode_id1
  outch 9, a1*3, 10, a1*3
endin

opcode Graincloud, aa, kkkkkkkkiii
  kamp, kwavfreq, kpitchmod, kpitch_spread, kgrainrate, kratemod, kdistribution, kgraindur, ivoice, imaxvoice, iopcode_id xin

  ; grain rate
  kgrainrate = kgrainrate*(1+(rspline(-0.5, 1, 0.5, 2)*kratemod))
  agrainrate	= kgrainrate 
  async = 0

; distribution 
	;kdistribution	= 0; chnget "Distribution"			; grain random distribution in time
	idisttab	ftgentmp	0, 0, 16, 16, 1, 16, -10, 0	; probability distribution for random grain masking

; grain shape
	kduration	= divz(1,kgrainrate,1)*kgraindur*1000; 0.5; chnget "Graindur"		

	ienv_attack	= giSigmoRise 			; grain attack shape (from table)
	ienv_decay	= giSigmoFall 			; grain decay shape (from table)
	ksustain_amount	= 0.0					  ; balance between enveloped time(attack+decay) and sustain level time, 0.0 = no time at sustain level
	ka_d_ratio = 0.1      					; balance between attack time and decay time, 0.0 = zero attack time and full decay time
	kenv2amt = 0                    ; amount of secondary enveloping per grain (e.g. for fof synthesis)
	ienv2tab	= giExpFall 				  ; secondary grain shape (from table), enveloping the whole grain if used

; select source waveforms
	kwaveform	= giSine		; source audio waveform 

; original pitch for each waveform, use if they should be transposed individually
; can also be used as a "cycles per second" parameter for single cycle waveforms (assuming that the kwavfreq parameter has a value of 1.0)
	kwavekey1	= 1
	kwavekey2	= 1
	kwavekey3	= 1
	kwavekey4	= 1
	asamplepos	= 0				

; "master" grain pitch (transpose for all 4 source waveforms)
	kwavfreq	= kwavfreq*(1+(rspline(-0.5, 1, 0.5, 2)*kpitchmod))*(1+(ivoice*kpitch_spread))				; transposition factor (playback speed) of audio inside grains, 

; pitch sweep
	ksweepshape		= 0.5						; grain wave pitch sweep shape (sweep speed), 0.5 is linear sweep
	iwavfreqstarttab 	ftgentmp	0, 0, 16, -2, 0, 0,   1		; start freq scalers, per grain
	iwavfreqendtab		ftgentmp	0, 0, 16, -2, 0, 0,   1		; end freq scalers, per grain

; FM of grain pitch (playback speed)
	awavfm = 0

; trainlet parameters (not using trainlets)
	icosine	= giCosine
	kTrainCps	= 100		
	knumpartials = 1	
	kchroma = 1	

	; gain masking table, amplitude for individual grains
	igainmasks	ftgentmp	0, 0, 16, -2, 0, 0, 1

	; channel masking table, output routing for individual grains (zero based, a value of 0.0 routes to output 1)
	ichanmasks	ftgentmp	0, 0, 16, -2,  0, 1,  0, 1
	
	; random masking (muting) of individual grains
	krandommask	=0;chnget "RandMask"

	; wave mix masking. 
  iwaveamptab	ftgentmp 0, 0, 32, -2,   0, 0,  1,0,0,0,0

; system parameter
	imax_grains	= 100				; max number of grains per k-period
  iopcode_id1 = iopcode_id+ivoice
        
	a1,a2	partikkel \					; 					
			agrainrate, \						; grains per second			
			kdistribution, idisttab, async, \			; synchronous/asynchronous		
			kenv2amt, ienv2tab, ienv_attack, ienv_decay, \		; grain envelope (advanced)		
			ksustain_amount, ka_d_ratio, kduration, \		; grain envelope 			
			kamp, \							; amp					
			igainmasks, \						; gain masks (advanced)			
			kwavfreq, \						; grain pitch (playback frequency)	
			ksweepshape, iwavfreqstarttab, iwavfreqendtab, \	; grain pith sweeps (advanced)		
			awavfm, -1, -1, \				; grain pitch FM (advanced)		
			icosine, kTrainCps, knumpartials, kchroma, \		; trainlets				
			ichanmasks, \ 					        ; channel mask (advanced)
			krandommask, \						; random masking of single grains	
			kwaveform, kwaveform, kwaveform, kwaveform, \	; set source waveforms, all set to the live input buffer here
			iwaveamptab, \						; mix source waveforms (remember, we can use different samplepos and transposition for each)
			asamplepos, asamplepos, asamplepos, asamplepos, \	; read position for source waves	
			kwavekey1, kwavekey2, kwavekey3, kwavekey4, \		; individual transpose for each source
			imax_grains, iopcode_id1						; system parameter (advanced)

  ; midi out
  apulse, aphase partikkelsync iopcode_id1
  kSig[] init ksmps
  kSig shiftin apulse
  kpulse = sumarray(kSig) 
  kphase downsamp aphase
  ; midi
  Samp_thresh sprintf "graincloud_ampthresh_%i", ivoice+1
  kamp_thresh chnget Samp_thresh
  kamp_thresh ampdbfs kamp_thresh
  Stranspose sprintf "graincloud_transpose_%i", ivoice+1
  ktranspose chnget Stranspose
  kmidi_chan chnget "graincloud_midichan"
  Schan sprintf "graincloud_midichan_%i", ivoice+1
  ;puts Schan, 1
  kmidi_chan chnget Schan
  if (kpulse > 0) && (kamp > kamp_thresh) && ivoice < 4 then
    knote = (kwavfreq*12)+48
    knote = 12*log2(kwavfreq/440) + 69 + ktranspose
    kvel limit kamp*120, 40, 127
    event "i", 202, 0, (kduration/1000)+0.01, kvel, knote, kmidi_chan
  endif

  if (ivoice < imaxvoice-1) then
    a1a, a2a Graincloud kamp, kwavfreq, kpitchmod, kpitch_spread, kgrainrate, kratemod, kdistribution, kgraindur, ivoice+1, imaxvoice, iopcode_id
    a1 += a1a
    a2 += a2a
  endif
  iampscale = 1/(imaxvoice^0.5)
  xout(a1*iampscale, a2*iampscale)
endop

instr 13
  ; async grain cloud
  kFaders[] tab2array giWaveRaw1
  kminfaders minarray kFaders
  kmaxfaders maxarray kFaders
  kavg_x_movement chnget "avg_x_movement"
  kactivity chnget "wave_activity"
  kactivity limit kactivity, 0, 1
  amp_activity follow2 a(kactivity), 0.1, 4
  kwavfreq chnget "Grainpitch2"
  kamp_dB chnget "Grainamp2"
  kgrainrate chnget "Grate2"
  kgraindur chnget "Gdur2"
  kamp = ampdbfs(kamp_dB)  
  imaxvoice = 4
  kactivity_mod EnvFollow kactivity, 5, 1
  kpitchmod chnget "G2_pitchmod"
  kpitchmod *= 1+(kactivity_mod*3)
  kwavfreq *= 1+(kactivity_mod*2)
  kpitch_spread chnget "G2_pitch_spread"
  kratemod chnget "G2_ratemod"
  knumpeaks chnget "numpeaks"
  ; mod mapping
  kamp *= amp_activity
  kdistribution = knumpeaks/7
  kgrainrate *= (1+(kavg_x_movement*2.5))
  kpitch_spread *= kmaxfaders
  kgraindur *= (kminfaders+1)
  iopcode_id = 20

  a1,a2 Graincloud kamp, kwavfreq, kpitchmod, kpitch_spread, kgrainrate, kratemod, kdistribution, kgraindur, 0, imaxvoice, iopcode_id
  outch 11, a1*1.5, 12, a2*1.5
endin

opcode OscBank, aa, k[]i[]kkkii
  kAmps[], iPitches[], kbasefreq, kchroma, kdetune, ivoice, imaxvoice xin
  if kchroma > 0 then
    kamp = kAmps[ivoice] * (1+((ivoice+1)*kchroma))
  else
    kamp = kAmps[ivoice] + abs(kchroma)
  endif
  ;printk2 kamp, ivoice*2
  kamp tonek kamp, 1  
  kcps = kbasefreq*semitone(iPitches[ivoice])
  kcps1 = kcps+(kcps*rspline(-kdetune, kdetune, 0.3, 0.9))
  a1 poscil kamp, kcps1
  ipan = ivoice/(imaxvoice-1)
  aL = a1*sqrt(1-ipan)
  aR = a1*sqrt(ipan)
  if (ivoice < imaxvoice-1) then
    aLa,aRa OscBank kAmps, iPitches, kbasefreq, kchroma, kdetune, ivoice+1, imaxvoice
    aL += aLa
    aR += aRa
  endif
  xout(aL, aR)
endop

opcode FaderBankMidi, 0, k[]i[]kkkkkiii
  kAmps[], iPitches[], kbase_note, kthreshold, kmidi_chan, karp_ms, kdir, idir, ivoice, imaxvoice xin
  kamp = limit(kAmps[ivoice], 0, 1)
  kthreshold = limit(kthreshold, 0, 1)
  knote = round(kbase_note + iPitches[ivoice])
  kmidi_instr = 202 + (knote * 0.001) + (ivoice * 0.00001) + (idir * 0.000001)
  karp_rank = (kdir >= 0 ? ivoice : (imaxvoice - 1 - ivoice))
  karp_delay = limit(karp_ms, 0, 100) * 0.001 * karp_rank
  if idir == 0 then
    kactive = gkFaderActiveUp[ivoice]
    kstored_delay = gkFaderOnDelayUp[ivoice]
    kstored_instr = gkFaderInstrUp[ivoice]
  else
    kactive = gkFaderActiveDown[ivoice]
    kstored_delay = gkFaderOnDelayDown[ivoice]
    kstored_instr = gkFaderInstrDown[ivoice]
  endif
  kmidi_on trigger kamp, kthreshold, 0
  kmidi_off trigger kamp, kthreshold, 1
  if kmidi_on > 0 then
    ; If this voice is already marked active, force-clear stale note first.
    if (kactive > 0) && (kstored_instr > 0) then
      event "i", -kstored_instr, 0, 0.02
    endif
    kvel limit kamp * 120, 40, 127
    event "i", kmidi_instr, karp_delay, -1, kvel, knote, kmidi_chan
    if idir == 0 then
      gkFaderActiveUp[ivoice] = 1
      gkFaderOnDelayUp[ivoice] = karp_delay
      gkFaderInstrUp[ivoice] = kmidi_instr
    else
      gkFaderActiveDown[ivoice] = 1
      gkFaderOnDelayDown[ivoice] = karp_delay
      gkFaderInstrDown[ivoice] = kmidi_instr
    endif
  elseif kmidi_off > 0 then
    if kactive > 0 then
      koff_instr = (kstored_instr > 0 ? kstored_instr : kmidi_instr)
      koff_delay = max(kstored_delay, 0)
      event "i", -koff_instr, koff_delay, 0.1
      if idir == 0 then
        gkFaderActiveUp[ivoice] = 0
        gkFaderOnDelayUp[ivoice] = 0
        gkFaderInstrUp[ivoice] = 0
      else
        gkFaderActiveDown[ivoice] = 0
        gkFaderOnDelayDown[ivoice] = 0
        gkFaderInstrDown[ivoice] = 0
      endif
    endif
  endif
  if (ivoice < imaxvoice - 1) then
    FaderBankMidi kAmps, iPitches, kbase_note, kthreshold, kmidi_chan, karp_ms, kdir, idir, ivoice + 1, imaxvoice
  endif
endop

opcode DctBankMidi, 0, k[]i[]kkkkkii
  kAmps[], iPitches[], kbase_note, kthreshold, kmidi_chan, katt, krel, ivoice, imaxvoice xin
  kamp = max(kAmps[ivoice], 0)
  ksmooth EnvFollow kamp, katt, krel
  kstate init 0
  knote_on_time init -1
  kmindur = 0.12
  ktime timeinsts
  kon = max(kthreshold, 0)
  koff = max(kon * 0.75, 0)
  knote = round(kbase_note + iPitches[ivoice])
  kmidi_instr = 202 + (knote * 0.001) + (ivoice * 0.00001) + 0.0001
  kmidi_on = 0
  kmidi_off = 0
  if (kstate == 0) && (ksmooth >= kon) then
    kmidi_on = 1
    kstate = 1
    knote_on_time = ktime
  elseif (kstate == 1) && (ksmooth <= koff) && ((ktime - knote_on_time) >= kmindur) then
    kmidi_off = 1
    kstate = 0
  endif
  if kmidi_on > 0 then
    kvel limit ksmooth * 120, 40, 127
    event "i", kmidi_instr, 0, -1, kvel, knote, kmidi_chan
  elseif kmidi_off > 0 then
    event "i", -kmidi_instr, 0, .1
  endif
  if (ivoice < imaxvoice - 1) then
    DctBankMidi kAmps, iPitches, kbase_note, kthreshold, kmidi_chan, katt, krel, ivoice + 1, imaxvoice
  endif
endop

instr 16
  ; DCT bank MIDI mapping (no audio output)
  iPitches[] fillarray 0, 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24
  imaxvoice = 8
  ; MIDI trigger from DCT bins
  kdct_scale chnget "Dct_bank_scale"
  if changed(kdct_scale) > 0 then
    reinit dct_scales
  endif
  dct_scales:
  idct_scale = i(kdct_scale)
  iMidiPitches[] fillarray 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ; semitone
  if idct_scale == 2 then
    iMidiPitches[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24 ; wholetone
  elseif idct_scale == 3 then
    iMidiPitches[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21 ; major
  elseif idct_scale == 4 then
    iMidiPitches[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20 ; minor
  elseif idct_scale == 5 then
    iMidiPitches[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29 ; penta1
  elseif idct_scale == 6 then
    iMidiPitches[] fillarray 0, 2, 5, 7,  9, 12, 14, 17, 19, 21, 24, 26, 29 ; penta2
  endif
  kdct_basenote chnget "dct_basenote"
  kdct_thresh   chnget "dct_ampthresh"
  kdct_midichan chnget "dct_midichan"
  kdct_env_att  chnget "dct_env_att"
  kdct_env_rel  chnget "dct_env_rel"
  DctBankMidi gkDctbins, iMidiPitches, kdct_basenote, kdct_thresh, kdct_midichan, kdct_env_att, kdct_env_rel, 0, imaxvoice
endin


instr 17
  ; fader bank midi 
  itab = p4
  kscale chnget "Fader_bank_scale"
  
  kdown_scale chnget "Fader_bank_down_scale"
  if changed(kscale) + changed(kdown_scale) > 0 then
    reinit scales
  endif
  scales:
  iscale = i(kscale)
  print iscale
  iPitches[] fillarray 0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12 ; semitone
  if iscale == 2 then
    iPitches[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24 ; wholetone
  elseif iscale == 3 then
    iPitches[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21 ; major
  elseif iscale == 4 then
    iPitches[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20 ; minor
  elseif iscale == 5 then
    iPitches[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29 ; penta1
  elseif iscale == 6 then
    iPitches[] fillarray 0, 2, 5, 7, 9, 12, 14, 17, 19, 21, 24, 26, 29 ; penta2
  endif

  idown_scale = i(kdown_scale)
  iPitchesDown[] fillarray 0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12 ; semitone
  if idown_scale == 2 then
    iPitchesDown[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24 ; wholetone
  elseif idown_scale == 3 then
    iPitchesDown[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21 ; major
  elseif idown_scale == 4 then
    iPitchesDown[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20 ; minor
  elseif idown_scale == 5 then
    iPitchesDown[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29 ; penta1
  elseif idown_scale == 6 then
    iPitchesDown[] fillarray 0, 2, 5, 7,  9, 12, 14, 17, 19, 21, 24, 26, 29 ; penta2
  endif

  kFaders[] tab2array giWaveRaw1
  kFadersUp[] = kFaders
  kFadersDown[] = -kFaders
  kFadersUp limit kFadersUp, 0, 1
  kFadersDown limit kFadersDown, 0, 1

  kup_basenote chnget "faderbank_basenote"
  kup_thresh chnget "faderbank_ampthresh"
  kup_midi_chan chnget "faderbank_midichan"
  karp_ms chnget "faderbank_arp_ms"
  kmov_arp chnget "faderbank_mov_arp"
  kwave_move chnget "avg_x_movement"
  karp_dir = (kwave_move >= 0 ? 1 : -1)
  keff_arp_ms = karp_ms + limit(abs(kwave_move) * kmov_arp * 500, 0, 150)
  kdown_basenote chnget "faderbank_down_basenote"
  kdown_thresh_ui chnget "faderbank_down_ampthresh"
  kdown_thresh = abs(kdown_thresh_ui)
  kdown_midi_chan chnget "faderbank_down_midichan"
  imaxvoice = 10
  FaderBankMidi kFadersUp, iPitches, kup_basenote, kup_thresh, kup_midi_chan, keff_arp_ms, karp_dir, 0, 0, imaxvoice
  FaderBankMidi kFadersDown, iPitchesDown, kdown_basenote, kdown_thresh, kdown_midi_chan, keff_arp_ms, karp_dir, 1, 0, imaxvoice
endin

instr 203
  ; Send note-off (velocity 0) for all notes on one channel.
  ichan = int(p4)
  inote = 0
  while inote < 128 do
    event_i "i", 202, 0, 0.02, 0, inote, ichan
    inote += 1
  od
endin


instr 18
  ; stopchord control
  kwave_activity chnget "wave_activity"
  kwave_activity tonek kwave_activity, 1
  kmax_activity init 0
  kmax_activity max kmax_activity, kwave_activity
  kwa_diff diff kwave_activity
  kactivity_thresh chnget "stop_activity_thresh"

  ksig = (kwa_diff < 0) && (kwave_activity < 0.1) && (kmax_activity > kactivity_thresh) ? 1 : 0
  ktrig trigger ksig, 0.5, 0

  kleft_lobe_x chnget "left_lobe_x"
  kright_lobe_x chnget "right_lobe_x"
  kmax_lobe_x chnget "max_lobe_x"
  kshape_centroid_x chnget "shape_centroid_x"

  ; selec1 min or max
  kminmax chnget "stopchord_minmax"
  if kminmax > 0 then
    kcps1 delayk kright_lobe_x*0.8, 1
    kcps2 delayk kshape_centroid_x*0.8, 1
    kcps3 delayk kmax_lobe_x*0.8, 1
  else
    kcps1 delayk kleft_lobe_x, 1
    kcps2 delayk kshape_centroid_x, 1
    kcps3 delayk kmax_lobe_x, 1
  endif
  ; select scale or free
  kscalefree chnget "stopchord_scalefree"
  if ktrig > 0 then
    event "i", 19, 0.2+kshape_centroid_x, 0.2+kmax_activity, kcps1, kcps2, kcps3, kscalefree
    kmax_activity = 0
  endif 

endin

instr 19
  ; stopchord tone gen
  iscalefree = p7
  iScale[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29, 31, 34, 36
  ilenscale lenarray iScale
  if iscalefree > 0 then
    ibasefreq = 220
    icps1 = ibasefreq*semitone(iScale[int(limit(p4*ilenscale-1, 0, ilenscale-1))])
    icps2 = ibasefreq*semitone(iScale[int(limit(p5*ilenscale-1, 0, ilenscale-1))])
    icps3 = ibasefreq*semitone(iScale[int(limit(p6*ilenscale-1, 0, ilenscale-1))])
  else
    icps1 = limit(p4* 400,100, 2000)
    icps2 = limit(p5*1100,100, 2000)
    icps3 = limit(p6*1800,100, 2000)
  endif
  ;print icps1, icps2, icps3
  iamp = ampdbfs(chnget("amp_stopchord"))
  ; random envelope both attack and release
  aenv1   linsegr 0, random(0.05,0.4),   1, 0.1, 0.2, random(0.3,0.5), 0.6, random(2,3.5), 0.01
  aenv2   linsegr 0, random(0.01,0.16), 1, 0.1, 0.2, random(0.3,0.5), 0.6, random(1.8,2.8), 0.01
  aenv3   linsegr 0, random(0.001,0.1), 1, 0.1, 0.2, random(0.3,0.5), 0.6, random(1.4,4.3), 0.01
  amodenv linsegr 1, random(0.01,0.05), 0.1, 1, 0.01, 0.3, 0.01
  kdetune chnget "detune_stopchord"
  kdetune *= 0.1
  kcps1a rspline icps1-(icps1*kdetune), icps1+(icps1*kdetune), 0.25, 0.8
  kcps2a rspline icps2-(icps2*kdetune), icps2+(icps2*kdetune), 0.25, 0.8
  kcps3a rspline icps3-(icps3*kdetune), icps3+(icps3*kdetune), 0.25, 0.8
  kcps1b rspline icps1-(icps1*kdetune), icps1+(icps1*kdetune), 0.25, 0.8
  kcps2b rspline icps2-(icps2*kdetune), icps2+(icps2*kdetune), 0.25, 0.8
  kcps3b rspline icps3-(icps3*kdetune), icps3+(icps3*kdetune), 0.25, 0.8
  a1a poscil aenv1*0.5, kcps1a
  a2a poscil aenv2, kcps2a
  a3a poscil aenv3, kcps3a
  a1b poscil aenv1*0.5, kcps1b
  a2b poscil aenv2, kcps2b
  a3b poscil aenv3, kcps3b
  amod1 = a1a*a2a*amodenv*6
  amod2 = a2b*a3a*amodenv*6
  aleft = a1a+a2a+a3a+amod1
  aright = a1b+a2b+a3b+amod2
  outch 13, aleft*iamp, 14, aright*iamp
endin

instr 20
  ; stopchord LYS
  kwave_activity chnget "wave_activity"
  kwave_activity tonek kwave_activity, 1
  kmax_activity init 0
  kmax_activity max kmax_activity, kwave_activity
  kwa_diff diff kwave_activity
  kactivity_thresh chnget "stop_activity_thresh"

  ksig = (kwa_diff < 0) && (kwave_activity < 0.1) && (kmax_activity > kactivity_thresh) ? 1 : 0
  ktrig trigger ksig, 0.5, 0
  knumpeaks chnget "numpeaks"
  knumpeaks delayk knumpeaks, 1
  ksymbol = knumpeaks%4
  chnset int(ksymbol), "root"

  kleft_lobe_x chnget "left_lobe_x"
  kright_lobe_x chnget "right_lobe_x"
  kmax_lobe_x chnget "max_lobe_x"
  kshape_centroid_x chnget "shape_centroid_x"

  kFaders[] tab2array giWaveRaw1
  kminfaders minarray kFaders
  kmaxfaders maxarray kFaders
  kz0 = gkZerocross[0]
  kz0 delayk kz0, 1
  kright_lobe_x delayk kright_lobe_x, 0.5
  kshape_centroid_x delayk kshape_centroid_x, 0.5
  kmax_lobe_x delayk kmax_lobe_x, 0.5
  kmaxfaders delayk kmaxfaders, 1
  ktempo1 = 90
  ktempo2 = 40
  if ktrig > 0 then
    if kright_lobe_x > 0.6 then
      chnset ktempo1, "tempo"
    else
      chnset ktempo2, "tempo"
    endif
    event "i", 102, 0, 1+(kmaxfaders*2), 48+int(((kshape_centroid_x+kz0)*0.5)*24), 90
    kmax_activity = 0
  endif 

endin

#include "lsys_cs_midi.inc"

;***************************************************
instr 21
  ; Hex Grid MIDI: forward OSC note-on/off from Python to instr 202
  khex_basenote chnget "hexgrid_basenote"
  khex_midichan chnget "hexgrid_midichan"
  khex_maxdur   chnget "hexgrid_maxdur"

  ; Poll hex note-on  (/hex_note_on ii: semitone_offset, velocity)
  khex_offset init 0
  khex_vel    init 64
  next_hex_on:
  kmess_on OSClisten gihandle, "hex_note_on", "ii", khex_offset, khex_vel
  if kmess_on > 0 then
    knote limit (khex_basenote + khex_offset), 0, 127
    kmidi_instr = 202 + (knote * 0.001) + 0.0002
    kvel limit khex_vel, 1, 127
    event "i", kmidi_instr, 0, khex_maxdur, kvel, knote, khex_midichan
    kgoto next_hex_on
  endif

  ; Poll hex note-off  (/hex_note_off i: semitone_offset)
  khex_offset_off init 0
  next_hex_off:
  kmess_off OSClisten gihandle, "hex_note_off", "i", khex_offset_off
  if kmess_off > 0 then
    knote_off limit (khex_basenote + khex_offset_off), 0, 127
    kmidi_instr_off = 202 + (knote_off * 0.001) + 0.0002
    event "i", -kmidi_instr_off, 0, 0.1
    kgoto next_hex_off
  endif
endin

;***************************************************
instr 202
  ; midi  output
    ivel = int(p4)
    inote = int(p5)
    ichan = int(p6)
    printf "note %i, vel %i, chan %i, dur %.2f\n", 1, inote, ivel, ichan, p3

    idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    ;idur    = (p3 < 0.05 ? 0.05 : p3)  ; avoid extremely short notes as they won't play

    noteondur ichan, inote, ivel, idur
    
endin
;***************************************************

</CsInstruments>  
<CsScore>
i1 0 84600
</CsScore>
</CsoundSynthesizer>
