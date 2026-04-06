<Cabbage>
form size(1112, 739), caption("Rope MIDI"), pluginId("rom1"), guiMode("queue"), colour(30,30,30)
; -- Row 1: event-to-MIDI triggers ---------------------------------------------------------
groupbox bounds(855, 644, 252, 72), colour(60,78,90), lineThickness(0){
label bounds(5, 5, 90, 12), text("Wave Osc"), fontSize(10), align("left")
rslider channel("Freq_wav"),     bounds(8,  14, 54, 52), text("Freq"),   range(20, 300, 100, 0.35)
rslider channel("Amp_wav"),      bounds(66, 14, 54, 52), text("Amp"),    range(-50, 6, 0, 3)
rslider channel("detune_wav"),   bounds(124,14, 54, 52), text("Detune"), range(0, 1, 0.1, 0.35)
button  channel("Wave_raw_on"),  bounds(186,14, 58, 24), text("raw"),    colour:0("black"), colour:1("green")
button  channel("Wave_fine_on"), bounds(186,42, 58, 24), text("fine"),   colour:0("black"), colour:1("green")
}

groupbox bounds(430, 644, 300, 72), colour(60,78,90), lineThickness(0){
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

groupbox bounds(736, 644, 114, 72), colour(60,78,90), lineThickness(0){
label bounds(5, 5, 90, 12), text("Stop LSYS"), fontSize(10), align("left")
button channel("Stop_LSYS"), bounds(20, 24, 75, 28), text("On"), colour:0("black"), colour:1("green")
}

; -- Row 2: Fader Bank + Peak Notes -------------------------------------------------------
groupbox bounds(5, 5, 380, 116), colour(60,78,90), lineThickness(0){
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

groupbox bounds(386, 5, 342, 116), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 80, 12), text("Hex Grid"), fontSize(10), align("left")
button   channel("Hex_grid"),           bounds(8, 18, 60, 26), text("On"), value(0), colour:0("black"), colour:1("green")
button   channel("hexgrid_peak_mode"),  bounds(72, 18, 52, 26), text("Peaks"), value(0), colour:0("black"), colour:1("green")
label    bounds(128, 10, 44, 14), text("layout"), fontSize(11)
combobox channel("hexgrid_layout"),     bounds(128, 24, 98, 22), items("Harmonic", "Wicki-Hayden", "Tonnetz", "Harmonetta", "Janko", "Chromatic"), value(1)
label    bounds(230, 10, 40, 14), text("base"), fontSize(11)
nslider  channel("hexgrid_basenote"),   bounds(230, 24, 46, 22), range(0, 127, 60, 1, 1)
label    bounds(280, 10, 36, 14), text("chan"), fontSize(11)
nslider  channel("hexgrid_midichan"),   bounds(280, 24, 40, 22), range(1, 16, 1, 1, 1)
label    bounds(8, 58, 56, 12), text("max dur"), fontSize(10), align("left")
nslider  channel("hexgrid_maxdur"),     bounds(8, 72, 80, 22), range(0.1, 4.0, 0.7, 1, 0.05)
label    bounds(96, 58, 48, 12), text("fields x"), fontSize(10), align("left")
nslider  channel("hexgrid_size_x"),     bounds(96, 72, 58, 22), range(2, 30, 6, 1, 1)
label    bounds(162, 58, 48, 12), text("fields y"), fontSize(10), align("left")
nslider  channel("hexgrid_size_y"),     bounds(162, 72, 58, 22), range(2, 30, 6, 1, 1)
}

groupbox bounds(732, 5, 380, 116), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 100, 12), text("Peak Notes"), fontSize(10), align("left")
button   channel("Peak_notes"),               bounds(8, 16, 76, 23), text("On"), colour:0("black"), colour:1("green")
label    bounds(8, 58, 56, 12), text("max dur"), fontSize(10), align("left")
nslider  channel("peaknotes_maxdur"),         bounds(8, 72, 80, 22), range(0.1, 4.0, 0.7, 1, 0.05)
label    bounds(93, 14, 42, 14), text("U.scale"), fontSize(11)
combobox channel("Peak_notes_scale"),         bounds(93, 28, 110, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(209, 14, 50, 14), text("U.base"), fontSize(11)
nslider  channel("peaknotes_basenote"),       bounds(209, 28, 50, 22), range(0, 127, 60, 1, 1)
label    bounds(264, 14, 50, 14), text("U.chan"), fontSize(11)
nslider  channel("peaknotes_midichan"),       bounds(264, 28, 50, 22), range(1, 16, 1, 1, 1)
label    bounds(319, 14, 55, 14), text("U.thresh"), fontSize(11)
nslider  channel("peaknotes_ampthresh"),      bounds(319, 28, 55, 22), range(0.0, 1.0, 0.02, 1, 0.001)
label    bounds(93, 62, 42, 14), text("D.scale"), fontSize(11)
combobox channel("Peak_notes_down_scale"),    bounds(93, 76, 110, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(209, 62, 50, 14), text("D.base"), fontSize(11)
nslider  channel("peaknotes_down_basenote"),  bounds(209, 76, 50, 22), range(0, 127, 48, 1, 1)
label    bounds(264, 62, 50, 14), text("D.chan"), fontSize(11)
nslider  channel("peaknotes_down_midichan"),  bounds(264, 76, 50, 22), range(1, 16, 1, 1, 1)
label    bounds(319, 62, 55, 14), text("D.thresh"), fontSize(11)
nslider  channel("peaknotes_down_ampthresh"), bounds(319, 76, 55, 22), range(0.0, 1.0, 0.02, 1, 0.001)
}

; -- Row 3: Distance Grain -----------------------------------------------------------------
groupbox bounds(5, 122, 545, 92), colour(60,78,90), lineThickness(0){
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

groupbox bounds(555, 122, 505, 92), colour(60,78,90), lineThickness(0){
label    bounds(5, 5, 120, 12), text("Rope Rhythm"), fontSize(10), align("left")
button   channel("Rope_rhythm"),          bounds(8, 20, 80, 28), text("On"), colour:0("black"), colour:1("green")
label    bounds(96, 10, 36, 12), text("bpm"), fontSize(10), align("left")
nslider  channel("rope_rhythm_bpm"),      bounds(96, 24, 56, 22), range(30, 240, 120, 1, 1)
label    bounds(158, 10, 44, 12), text("scale"), fontSize(10), align("left")
combobox channel("Rope_rhythm_scale"),    bounds(158, 24, 110, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label    bounds(274, 10, 42, 12), text("base"), fontSize(10), align("left")
nslider  channel("rope_rhythm_basenote"), bounds(274, 24, 52, 22), range(0, 127, 60, 1, 1)
label    bounds(332, 10, 56, 12), text("chan"), fontSize(10), align("left")
nslider  channel("rope_rhythm_midichan"), bounds(332, 24, 52, 22), range(1, 16, 1, 1, 1)
}

; -- Row 4: Grain2 (audio + all 4 MIDI voices flowing right) ------
groupbox bounds(5, 215, 264, 92), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 120, 12), text("SpatialCent MIDI"), fontSize(10), align("left")
button  channel("Horiz_cog_note"),          bounds(8, 20, 80, 28), text("On"), colour:0("black"), colour:1("green")
label   bounds(96, 14, 52, 14), text("base"), fontSize(11)
nslider channel("horizcog_basenote"),       bounds(96, 30, 52, 22), range(0, 127, 60, 1, 1)
label   bounds(154, 14, 42, 14), text("chan"), fontSize(11)
nslider channel("horizcog_midichan"),       bounds(154, 30, 42, 22), range(1, 16, 1, 1, 1)
label   bounds(202, 14, 52, 14), text("range"), fontSize(11)
nslider channel("horizcog_range"),          bounds(202, 30, 52, 22), range(0, 48, 12, 1, 1)
label   bounds(96, 54, 52, 12), text("floor"), fontSize(10), align("left")
nslider channel("shapecent_floor"),         bounds(96, 68, 74, 20), range(0.0, 1.00, 0.035, 1, 0.001)
label   bounds(176, 54, 52, 12), text("gamma"), fontSize(10), align("left")
nslider channel("shapecent_gamma"),         bounds(176, 68, 78, 20), range(0.25, 12.0, 2.15, 1, 0.01)
label   bounds(8, 54, 76, 12), text("off.pow"), fontSize(10), align("left")
nslider channel("shapecent_offpow"),        bounds(8, 68, 82, 20), range(0.25, 12.0, 1.0, 1, 0.01)
}

groupbox bounds(274, 215, 264, 92), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 120, 12), text("Vert COG MIDI"), fontSize(10), align("left")
button  channel("Vert_cog_note"),           bounds(8, 20, 80, 28), text("On"), colour:0("black"), colour:1("green")
label   bounds(96, 14, 52, 14), text("base"), fontSize(11)
nslider channel("vertcog_basenote"),        bounds(96, 30, 52, 22), range(0, 127, 60, 1, 1)
label   bounds(154, 14, 42, 14), text("chan"), fontSize(11)
nslider channel("vertcog_midichan"),        bounds(154, 30, 42, 22), range(1, 16, 1, 1, 1)
label   bounds(202, 14, 52, 14), text("range"), fontSize(11)
nslider channel("vertcog_range"),           bounds(202, 30, 52, 22), range(0, 48, 12, 1, 1)
}

groupbox bounds(5, 308, 1055, 92), colour(60,78,90), lineThickness(0){
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

groupbox bounds(5, 401, 1055, 92), colour(60,78,90), lineThickness(0){
label   bounds(5, 5, 90, 12), text("Grain3"), fontSize(10), align("left")
button  channel("Grain3"),                  bounds(8, 20, 75, 28), text("On"), colour:0("black"), colour:1("green")
label   bounds(8, 50, 75, 12), text("scale"), fontSize(9)
combobox channel("Grain3_scale"),            bounds(8, 62, 75, 22), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
rslider channel("Grain3_rate"),            bounds(93, 14, 58, 62), text("G.rate"), range(0.5, 20, 4, 0.35)
button  channel("Grain3_rate_update"),     bounds(93, 76, 58, 14), text("update"), value(1), colour:0("black"), colour:1("green")
rslider channel("Grain3_dur"),             bounds(155,14, 58, 62), text("G.dur"),  range(0.1, 2, 1, 0.35)
rslider channel("Grain3_randdev"),         bounds(217,14, 58, 62), text("R.dev"),  range(0.0, 1.0, 0.15, 1, 0.001)
rslider channel("Grain3_sync_rate"),       bounds(279,14, 58, 62), text("S.rate"), range(0.0, 0.5, 0.07, 0.5, 0.0001)
rslider channel("Grain3_sync_phase"),      bounds(341,14, 58, 62), text("S.phase"),range(0.0, 0.5, 0.04, 0.5, 0.0001)
button  channel("Grain3_sync_on"),         bounds(217,76, 244, 14), text("sync"), value(1), colour:0("black"), colour:1("green")
rslider channel("Grain3_pitchdev_amt"),    bounds(403,14, 58, 62), text("P.dev"),  range(0.0, 7.0, 0.0, 1, 0.001)
rslider channel("Grain3_pitchdev_shape"),  bounds(465,14, 58, 62), text("P.shape"),range(0.0, 1.0, 0.5, 1, 0.001)
label   bounds(560, 8, 48, 12), text("V1 note"), fontSize(10), align("left")
nslider channel("grain3_basenote_1"),      bounds(560, 24, 46, 22), range(0, 127, 60, 1, 1)
label   bounds(560, 50, 42, 12), text("V1 ch"), fontSize(10), align("left")
nslider channel("grain3_midichan_1"),      bounds(560, 66, 46, 22), range(1, 16, 1, 1, 1)
label   bounds(610, 50, 30, 12), text("thr"), fontSize(10), align("left")
nslider channel("grain3_activitythresh_1"), bounds(610, 66, 46, 22), range(0.0, 1.0, 0.05, 1, 0.001)
label   bounds(680, 8, 48, 12), text("V2 note"), fontSize(10), align("left")
nslider channel("grain3_basenote_2"),      bounds(680, 24, 46, 22), range(0, 127, 64, 1, 1)
label   bounds(680, 50, 42, 12), text("V2 ch"), fontSize(10), align("left")
nslider channel("grain3_midichan_2"),      bounds(680, 66, 46, 22), range(1, 16, 2, 1, 1)
label   bounds(730, 50, 30, 12), text("thr"), fontSize(10), align("left")
nslider channel("grain3_activitythresh_2"), bounds(730, 66, 46, 22), range(0.0, 1.0, 0.05, 1, 0.001)
label   bounds(800, 8, 48, 12), text("V3 note"), fontSize(10), align("left")
nslider channel("grain3_basenote_3"),      bounds(800, 24, 46, 22), range(0, 127, 67, 1, 1)
label   bounds(800, 50, 42, 12), text("V3 ch"), fontSize(10), align("left")
nslider channel("grain3_midichan_3"),      bounds(800, 66, 46, 22), range(1, 16, 3, 1, 1)
label   bounds(850, 50, 30, 12), text("thr"), fontSize(10), align("left")
nslider channel("grain3_activitythresh_3"), bounds(850, 66, 46, 22), range(0.0, 1.0, 0.05, 1, 0.001)
label   bounds(920, 8, 48, 12), text("V4 note"), fontSize(10), align("left")
nslider channel("grain3_basenote_4"),      bounds(920, 24, 46, 22), range(0, 127, 71, 1, 1)
label   bounds(920, 50, 42, 12), text("V4 ch"), fontSize(10), align("left")
nslider channel("grain3_midichan_4"),      bounds(920, 66, 46, 22), range(1, 16, 4, 1, 1)
label   bounds(970, 50, 30, 12), text("thr"), fontSize(10), align("left")
nslider channel("grain3_activitythresh_4"), bounds(970, 66, 46, 22), range(0.0, 1.0, 0.05, 1, 0.001)
}

; -- Row 5: L-System + console ---------------------------------------------------------

groupbox bounds(5, 516, 415, 215), colour(60,78,90), lineThickness(0){ 
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

csoundoutput bounds(430, 522, 625, 116)
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
  gkFaderActiveUp[] init 32
  gkFaderActiveDown[] init 32
  gkFaderOnDelayUp[] init 32
  gkFaderOnDelayDown[] init 32
  gkFaderInstrUp[] init 32
  gkFaderInstrDown[] init 32
  gkPeakBinUpActive[] init 10
  gkPeakBinDownActive[] init 10
  gkPeakBinUpVel[] init 10
  gkPeakBinDownVel[] init 10
  gkPeakBinUpOnTrig[] init 10
  gkPeakBinDownOnTrig[] init 10
  gkPeakBinUpOffTrig[] init 10
  gkPeakBinDownOffTrig[] init 10
  gkGr3RateState[] init 4

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

opcode NormMidiNote, 0, kkkkki
  knorm, kbasenote, knoterange, kmidi_chan, kvel, iident xin
  knorm limit knorm, 0, 1
  knoterange = max(knoterange, 0)
  knote = round(kbasenote + (knorm * knoterange))
  kmidi_instr = 202 + (knote * 0.001) + (iident * 0.0001)
  kactive init 0
  kactive_note init -1
  kactive_instr init 0
  kactive_chan init -1
  if (kactive == 0) then
    event "i", kmidi_instr, 0, -1, kvel, knote, kmidi_chan
    kactive = 1
    kactive_note = knote
    kactive_instr = kmidi_instr
    kactive_chan = kmidi_chan
  elseif (knote != kactive_note) || (kmidi_chan != kactive_chan) then
    event "i", -kactive_instr, 0, 0.05
    event "i", kmidi_instr, 0, -1, kvel, knote, kmidi_chan
    kactive_note = knote
    kactive_instr = kmidi_instr
    kactive_chan = kmidi_chan
  endif
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

  krope_rhythm_on chnget "Rope_rhythm"
  ButtonEvent krope_rhythm_on, 22

  khoriz_cog_on chnget "Horiz_cog_note"
  ButtonEvent khoriz_cog_on, 24
  khoriz_cog_off trigger khoriz_cog_on, 0.5, 1
  if khoriz_cog_off > 0 then
    khoriz_cog_chan chnget "horizcog_midichan"
    event "i", 203, 0, 0.05, int(khoriz_cog_chan)
  endif

  kvert_cog_on chnget "Vert_cog_note"
  ButtonEvent kvert_cog_on, 25
  kvert_cog_off trigger kvert_cog_on, 0.5, 1
  if kvert_cog_off > 0 then
    kvert_cog_chan chnget "vertcog_midichan"
    event "i", 203, 0, 0.05, int(kvert_cog_chan)
  endif

  kpeak_notes_on chnget "Peak_notes"
  ButtonEvent kpeak_notes_on, 23
  kpeak_notes_off trigger kpeak_notes_on, 0.5, 1
  if kpeak_notes_off > 0 then
    kup_peak_chan chnget "peaknotes_midichan"
    kdown_peak_chan chnget "peaknotes_down_midichan"
    gkPeakBinUpActive *= 0
    gkPeakBinDownActive *= 0
    gkPeakBinUpVel *= 0
    gkPeakBinDownVel *= 0
    gkPeakBinUpOnTrig *= 0
    gkPeakBinDownOnTrig *= 0
    gkPeakBinUpOffTrig *= 0
    gkPeakBinDownOffTrig *= 0
    event "i", 203, 0, 0.05, int(kup_peak_chan)
    if int(kdown_peak_chan) != int(kup_peak_chan) then
      event "i", 203, 0, 0.05, int(kdown_peak_chan)
    endif
  endif

  kgrain2_on chnget "Grain2"
  ButtonEvent kgrain2_on, 13

  kgrain3_on chnget "Grain3"
  ButtonEvent kgrain3_on, 26

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
    khex_peak_mode chnget "hexgrid_peak_mode"
    kpeak_notes_mode chnget "Peak_notes"
    kshapecent_floor chnget "shapecent_floor"
    kshapecent_gamma chnget "shapecent_gamma"
    kshapecent_offpow chnget "shapecent_offpow"
    ktrig_hex_size_x changed khex_size_x
    ktrig_hex_size_y changed khex_size_y
    ktrig_hex_peak_mode changed khex_peak_mode
    ktrig_peak_notes_mode changed kpeak_notes_mode
    ktrig_shapecent_floor changed kshapecent_floor
    ktrig_shapecent_gamma changed kshapecent_gamma
    ktrig_shapecent_offpow changed kshapecent_offpow
    ktrig_hex_size_x = (ktrig_hex_size_x > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_hex_size_y = (ktrig_hex_size_y > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_hex_peak_mode = (ktrig_hex_peak_mode > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_peak_notes_mode = (ktrig_peak_notes_mode > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_shapecent_floor = (ktrig_shapecent_floor > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_shapecent_gamma = (ktrig_shapecent_gamma > 0 || khex_boot > 0 ? 1 : 0)
    ktrig_shapecent_offpow = (ktrig_shapecent_offpow > 0 || khex_boot > 0 ? 1 : 0)
    OSCsend ktrig_hex_size_x, "127.0.0.1", 9801, "/hex_size_x", "f", khex_size_x
    OSCsend ktrig_hex_size_y, "127.0.0.1", 9801, "/hex_size_y", "f", khex_size_y
    OSCsend ktrig_hex_peak_mode, "127.0.0.1", 9801, "/hex_peak_mode", "f", khex_peak_mode
    OSCsend ktrig_peak_notes_mode, "127.0.0.1", 9801, "/peaknotes_mode", "f", kpeak_notes_mode
    OSCsend ktrig_shapecent_floor, "127.0.0.1", 9801, "/shapecent_floor", "f", kshapecent_floor
    OSCsend ktrig_shapecent_gamma, "127.0.0.1", 9801, "/shapecent_gamma", "f", kshapecent_gamma
    OSCsend ktrig_shapecent_offpow, "127.0.0.1", 9801, "/shapecent_offpow", "f", kshapecent_offpow
    khex_boot = 0

    ; Python startup query: send current grid settings on request.
    khex_query_req init 0
    next_hex_query:
    kmess_hex_query OSClisten gihandle, "hex_query", "i", khex_query_req
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_layout", "f", klayout_hex
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_size_x", "f", khex_size_x
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_size_y", "f", khex_size_y
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/hex_peak_mode", "f", khex_peak_mode
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/peaknotes_mode", "f", kpeak_notes_mode
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/shapecent_floor", "f", kshapecent_floor
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/shapecent_gamma", "f", kshapecent_gamma
    OSCsend kmess_hex_query, "127.0.0.1", 9801, "/shapecent_offpow", "f", kshapecent_offpow
    if kmess_hex_query > 0 then
      kgoto next_hex_query
    endif

    ; OSC receive
    kOSC_received = 0

  ; Parse peak-note events from Python centrally in instr 1.
  gkPeakBinUpOnTrig *= 0
  gkPeakBinDownOnTrig *= 0
  gkPeakBinUpOffTrig *= 0
  gkPeakBinDownOffTrig *= 0

  kpk_bin init 0
  kpk_ispos init 0
  kpk_vel init 64
  kpk_guard init 0
  nextmsg_peakbank_on:
  if kpk_guard >= 256 then
    kgoto done_peakbank_on
  endif
  kmess_pk_on OSClisten gihandle, "peakbank_on", "iii", kpk_bin, kpk_ispos, kpk_vel
  kOSC_received += kmess_pk_on
  if kmess_pk_on == 0 goto done_peakbank_on
  kpk_bidx = limit(int(kpk_bin), 0, gknum_faders - 1)
  kpk_vel_clamped = limit(int(kpk_vel), 1, 127)
  if kpk_ispos > 0 then
    gkPeakBinUpOnTrig[kpk_bidx] = 1
    gkPeakBinUpActive[kpk_bidx] = 1
    gkPeakBinUpVel[kpk_bidx] = kpk_vel_clamped
  else
    gkPeakBinDownOnTrig[kpk_bidx] = 1
    gkPeakBinDownActive[kpk_bidx] = 1
    gkPeakBinDownVel[kpk_bidx] = kpk_vel_clamped
  endif
  kpk_guard += 1
  kgoto nextmsg_peakbank_on
  done_peakbank_on:

  kpk_bin_off init 0
  kpk_ispos_off init 0
  kpk_guard_off init 0
  nextmsg_peakbank_off:
  if kpk_guard_off >= 256 then
    kgoto done_peakbank_off
  endif
  kmess_pk_off OSClisten gihandle, "peakbank_off", "ii", kpk_bin_off, kpk_ispos_off
  kOSC_received += kmess_pk_off
  if kmess_pk_off == 0 goto done_peakbank_off
  kpk_bidx_off = limit(int(kpk_bin_off), 0, gknum_faders - 1)
  if kpk_ispos_off > 0 then
    if gkPeakBinUpActive[kpk_bidx_off] > 0 then
      gkPeakBinUpOffTrig[kpk_bidx_off] = 1
    endif
    gkPeakBinUpActive[kpk_bidx_off] = 0
    gkPeakBinUpVel[kpk_bidx_off] = 0
  else
    if gkPeakBinDownActive[kpk_bidx_off] > 0 then
      gkPeakBinDownOffTrig[kpk_bidx_off] = 1
    endif
    gkPeakBinDownActive[kpk_bidx_off] = 0
    gkPeakBinDownVel[kpk_bidx_off] = 0
  endif
  kpk_guard_off += 1
  kgoto nextmsg_peakbank_off
  done_peakbank_off:
  
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
  kvertical_cog_norm init 0.5
  nextmsg_rope_metrics:
    kmess OSClisten gihandle, "rope_metrics", "ffffffffffffffff", knumpeaks, knumpeaks_median, knumpeaks_lowpass, kavg_x_distance, kavg_x_movement, kleft_lobe_x, kright_lobe_x, kmax_lobe_x, kshape_centroid_x, kwave_activity, kwave_amp, kspectral_centroid, kshape_centroid, kvertical_cog_norm, kamp_comp, kcurvature_rms
    kOSC_received += kmess
    if kmess == 0 goto done_rope_metrics
    chnset knumpeaks, "numpeaks"
    chnset knumpeaks, "numpeaks_raw"
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
    chnset kvertical_cog_norm, "vertical_cog_norm"
    kgoto nextmsg_rope_metrics
  done_rope_metrics:

  kshape_state_id init 5
  kshape_state_conf init 0
  nextmsg_shape_state:
    kmess_shape_state OSClisten gihandle, "shape_state", "ff", kshape_state_id, kshape_state_conf
    kOSC_received += kmess_shape_state
    if kmess_shape_state == 0 goto done_shape_state
    chnset kshape_state_id, "shape_state_id"
    chnset kshape_state_conf, "shape_state_conf"
    kgoto nextmsg_shape_state
  done_shape_state:

  ; Auto-sync Grain3 whenever rope shape classifier reports periodic (state id 3).
  kshape_state_now chnget "shape_state_id"
  kgrain3_sync_auto = (int(round(kshape_state_now)) == 3 ? 1 : 0)
  chnset kgrain3_sync_auto, "Grain3_sync_on"
 
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
  gkGr3MasterPulse init 0
  ftmorf kndx, giWaveRaws, giWaveRaw
  ftmorf kndx, giWaveFines, giWaveFine
endin

opcode RhythmPLL, kkk, kkkkkkk
  ; Phase-locked loop for rhythmic synchronization.
  k1trig, kfq2, kgain, kphasegain, kin2, kosc2, k2trig xin

  if kin2 == 0 then
    kfq2 init i(kfq2)
    kosc2 init 0
    kosc2 += (kfq2/kr)
    kosc2 = kosc2 > 1 ? 0 : kosc2
    k2trig trigger kosc2, 0.5, 1
  endif

  kcount init 0
  k2_prevphase init 0
  kdiff init 0
  kdifflag init 0
  kskip init 1
  if k1trig > 0 then
    if kskip == 0 then
      kdiff = (kosc2 + kcount) - k2_prevphase
      kdifflag = (kdiff <= 0 ? kdiff : 0)
      kdiff = (kdiff <= 0.1 ? kdiff + 1 : kdiff)
      kphasecorr = wrap(kosc2, -0.5, 0.5) * -1
    endif
    kskip = 0
    kcount = (kdifflag != 0 ? -1 : 0)
    k2_prevphase = kosc2
  endif
  if k2trig > 0 then
    kcount += 1
  endif

  kfact = divz(1, kdiff, 1)
  kerr = ((kfact - 1) * kgain * k1trig) + 1
  kphaserr = kfq2 * kphasecorr * k1trig * kphasegain
  kfq2 = (kfq2 * kerr) + kphaserr
  xout k2trig, kosc2, kfq2
endop


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
    kvel = 80
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
  if iopcode_id >= 30 then
    kranddev chnget "Grain3_randdev"
    kcurvature_mod chnget "curvature_rms"
    kcurvature_mod limit kcurvature_mod, 0, 2
    kcurvature_randdev = kcurvature_mod * 0.25
    kcurvature_randdev limit kcurvature_randdev, 0, 0.5
    kranddev = kranddev + kcurvature_randdev
    kranddev limit kranddev, 0, 1
    ksync_rate_amt chnget "Grain3_sync_rate"
    ksync_phase_amt chnget "Grain3_sync_phase"
    ksync_on chnget "Grain3_sync_on"
    ksync_on = (ksync_on >= 0.5 ? 1 : 0)
    kranddev_eff = (ksync_on > 0 ? 0 : kranddev)
    kupdate_rate chnget "Grain3_rate_update"
    kupdate_rate = (kupdate_rate >= 0.5 ? 1 : 0)
    knumpeaks_mult chnget "numpeaks_median"
    knumpeaks_mult = max(1, knumpeaks_mult)
    knumpeaks_changed changed knumpeaks_mult
    kforce_update = ((ksync_on > 0) && (knumpeaks_changed > 0) ? 1 : 0)
    kupdate_rate_eff = (kupdate_rate > 0 || kforce_update > 0 ? 1 : 0)
    kbase_rate = max(0.02, kgrainrate)
    kmin_rate = kbase_rate * 0.25
    kmax_rate = kbase_rate * 4.0
    if kupdate_rate_eff > 0 then
      gkGr3RateState[ivoice] = kbase_rate
    elseif gkGr3RateState[ivoice] <= 0 then
      gkGr3RateState[ivoice] = kbase_rate
    endif
    kwork_rate = (kupdate_rate_eff > 0 ? kbase_rate : gkGr3RateState[ivoice])
    if kranddev_eff > 0.0001 then
      ; random spline trajectory constrained to the allowed [0.25x, 4x] range
      ktraj_rate rspline kmin_rate, kmax_rate, 0.6 + (kranddev_eff * 2.5), 1.4 + (kranddev_eff * 7.5)
      ktarget_rate = (1 - kranddev_eff) * kbase_rate + (kranddev_eff * ktraj_rate)
      kslew = 0.03 + (kranddev_eff * 0.12)
      kwork_rate = kwork_rate + ((ktarget_rate - kwork_rate) * kslew)
    endif
    kwork_rate limit kwork_rate, kmin_rate, kmax_rate
    if ivoice == 0 then
      kgrainrate = max(0.02, kwork_rate)
      kgrainrate limit kgrainrate, kmin_rate, kmax_rate
      gkGr3MasterPulse metro kgrainrate
    else
      if kupdate_rate_eff > 0 then
        kgrainrate = kbase_rate
      elseif ksync_on == 0 then
        kgrainrate = kwork_rate
      else
        kpll_phase init 0
        kpll_pulse init 0
        kpll_pulse, kpll_phase, kgrainrate RhythmPLL gkGr3MasterPulse, kwork_rate, ksync_rate_amt, ksync_phase_amt, 0, kpll_phase, kpll_pulse
        kgrainrate = max(0.02, kgrainrate)
        kgrainrate limit kgrainrate, kmin_rate, kmax_rate
      endif
    endif
    gkGr3RateState[ivoice] = kgrainrate
  else
    kgrainrate = kgrainrate*(1+(rspline(-0.5, 1, 0.5, 2)*kratemod))
  endif
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
  if iopcode_id >= 30 then
    ; Scale quantization setup: reinit scale degrees array when scale selection changes.
    kgr3_scale chnget "Grain3_scale"
    kgr3_root  chnget "grain3_basenote_1"
    if changed(kgr3_scale) > 0 then
      reinit gr3_scale_init
    endif
    gr3_scale_init:
    iScaleDeg[] fillarray 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
    ideg_len = 12
    igr3_scale_i = i(kgr3_scale)
    if igr3_scale_i == 2 then
      iScaleDeg[] fillarray 0, 2, 4, 6, 8, 10
      ideg_len = 6
    elseif igr3_scale_i == 3 then
      iScaleDeg[] fillarray 0, 2, 4, 5, 7, 9, 11
      ideg_len = 7
    elseif igr3_scale_i == 4 then
      iScaleDeg[] fillarray 0, 2, 3, 5, 7, 8, 10
      ideg_len = 7
    elseif igr3_scale_i == 5 then
      iScaleDeg[] fillarray 0, 3, 5, 7, 10
      ideg_len = 5
    elseif igr3_scale_i == 6 then
      iScaleDeg[] fillarray 0, 2, 5, 7, 9
      ideg_len = 5
    endif
    rireturn
    Sbase sprintf "grain3_basenote_%i", ivoice+1
    Schan sprintf "grain3_midichan_%i", ivoice+1
    Sthr sprintf "grain3_activitythresh_%i", ivoice+1
    knote chnget Sbase
    kmidi_chan chnget Schan
    kactivity_thresh chnget Sthr
    kactivity_thresh limit kactivity_thresh, 0, 1
    kwave_activity chnget "wave_activity"
    kwave_activity limit kwave_activity, 0, 1
    if (kpulse > 0) && ivoice < 4 && (kwave_activity >= kactivity_thresh) then
      kpitch_dev_amt chnget "Grain3_pitchdev_amt"
      kpitch_dev_shape chnget "Grain3_pitchdev_shape"
      kvertical_cog_norm chnget "vertical_cog_norm"
      kvertical_cog_norm limit kvertical_cog_norm, 0, 1
      kcog_pitch_dev = abs(kvertical_cog_norm - 0.5) * 8.0
      kpitch_dev_amt = kpitch_dev_amt + kcog_pitch_dev
      if ksync_on > 0 then
        kpitch_dev_amt = 0
      endif
      kpitch_dev_shape limit kpitch_dev_shape, 0, 1
      if kpitch_dev_shape <= 0.5 then
        ; shape: 0.0 -> krpow -0.05, 0.5 -> krpow -0.95
        krpow = -0.05 - ((kpitch_dev_shape / 0.5) * 0.90)
      else
        ; shape: just above 0.5 -> krpow +0.95, 1.0 -> krpow +0.05
        krpow = 0.95 - (((kpitch_dev_shape - 0.5) / 0.5) * 0.90)
      endif
      ksemi_dev rnd31 kpitch_dev_amt, krpow
      knote = round(knote + ksemi_dev)
      knote limit knote, 0, 127
      ; Quantize to Grain3 scale (no-op when scale = 1 semitone/chromatic)
      if igr3_scale_i > 1 then
        ; Root class: voice-1 base note modulo 12, used as lowest scale base.
        kroot_pc = round(kgr3_root)
        kroot_pc = kroot_pc % 12
        if kroot_pc < 0 then
          kroot_pc = kroot_pc + 12
        endif
        ; Search nearest repeated scale note across neighboring octaves.
        kbase_oct = floor((knote - kroot_pc) / 12)
        kbest_note = knote
        kbest_dist = 999
        koct_off = -1
        while koct_off <= 1 do
          koct = kbase_oct + koct_off
          kbase = kroot_pc + (koct * 12)
          kqi = 0
          while kqi < ideg_len do
            kcand = kbase + iScaleDeg[kqi]
            kdist = abs(kcand - knote)
            if kdist < kbest_dist then
              kbest_dist = kdist
              kbest_note = kcand
            endif
            kqi = kqi + 1
          od
          koct_off = koct_off + 1
        od
        knote = kbest_note
        knote limit knote, 0, 127
      endif
      kvel = 90
      event "i", 202, 0, (kduration/1000)+0.01, kvel, knote, kmidi_chan
    endif
  else
    if (kpulse > 0) && (kamp > kamp_thresh) && ivoice < 4 then
      knote = (kwavfreq*12)+48
      knote = 12*log2(kwavfreq/440) + 69 + ktranspose
      kvel limit kamp*240, 40, 127
      event "i", 202, 0, (kduration/1000)+0.01, kvel, knote, kmidi_chan
    endif
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

instr 26
  ; clean 4-voice grain cloud with fixed amp/pitch and per-voice MIDI note/channel.
  kamp = 1
  kwavfreq = 220
  kgrainrate_base chnget "Grain3_rate"
  kamp_comp chnget "amp_comp"
  kamp_comp limit kamp_comp, 0, 2
  kamp_comp_rate_mult = 1 + (kamp_comp * 2)
  knumpeaks_mult chnget "numpeaks_median"
  knumpeaks_mult = max(1, knumpeaks_mult)
  kgrainrate = kgrainrate_base * kamp_comp_rate_mult * knumpeaks_mult
  kgrainrate limit kgrainrate, 0.02, 120
  kcurvature_rms_g3 chnget "curvature_rms"
  kgrainrate = kgrainrate * (0.5 + kcurvature_rms_g3)
  kgrainrate limit kgrainrate, 0.02, 120
  kgraindur chnget "Grain3_dur"
  kpitchmod = 0
  kpitch_spread = 0
  kratemod = 0
  kdistribution = 0
  imaxvoice = 4
  iopcode_id = 30

  a1,a2 Graincloud kamp, kwavfreq, kpitchmod, kpitch_spread, kgrainrate, kratemod, kdistribution, kgraindur, 0, imaxvoice, iopcode_id
  outch 15, a1*1.2, 16, a2*1.2
endin


instr 22
  ; Rope rhythm MIDI: phase-locked base pulse with numpeaks subdivisions.
  k_bpm chnget "rope_rhythm_bpm"
  k_basenote chnget "rope_rhythm_basenote"
  k_midichan chnget "rope_rhythm_midichan"
  k_scale chnget "Rope_rhythm_scale"
  k_numpeaks chnget "numpeaks_raw"
  k_target_subdiv = max(0, int(round(k_numpeaks)))

  if changed(k_scale) > 0 then
    reinit rope_scales
  endif
  rope_scales:
  i_scale = i(k_scale)
  iMidiPitches[] fillarray 0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12 ; semitone
  if i_scale == 2 then
    iMidiPitches[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24 ; wholetone
  elseif i_scale == 3 then
    iMidiPitches[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21 ; major
  elseif i_scale == 4 then
    iMidiPitches[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20 ; minor
  elseif i_scale == 5 then
    iMidiPitches[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29 ; penta1
  elseif i_scale == 6 then
    iMidiPitches[] fillarray 0, 2, 5, 7,  9, 12, 14, 17, 19, 21, 24, 26, 29 ; penta2
  endif

  ; Global transport: do not reset phase when numpeaks changes.
  k_base_cps = max(k_bpm, 1) / 60.0
  k_phase phasor k_base_cps
  k_phase_prev init 0
  k_downbeat = (k_phase < k_phase_prev ? 1 : 0)

  k_started init 0
  k_play_subdiv init 1
  k_suppress_rest init 0
  k_emit_degree init -1

  ; Start only when first peak arrives, and always align starts/increases to next downbeat.
  if k_downbeat > 0 then
    k_suppress_rest = 0
    k_emit_degree = -1
    if (k_started == 0) && (k_target_subdiv > 0) then
      k_started = 1
      k_play_subdiv = max(1, k_target_subdiv)
    elseif k_started > 0 then
      if k_target_subdiv <= 0 then
        ; Straight rope: no notes until peaks return.
        k_play_subdiv = 1
      else
        ; On downbeat, apply any pending subdivision changes.
        k_play_subdiv = max(1, k_target_subdiv)
      endif
    endif
    if (k_started > 0) && (k_target_subdiv > 0) then
      k_emit_degree = 0
    endif
  endif

  ; Subdivision triggers: rising threshold crossings at j/N (j=1..N-1).
  if (k_started > 0) && (k_play_subdiv > 1) && (k_suppress_rest == 0) then
    k_ndx = 1
    while k_ndx < k_play_subdiv do
      k_thresh = k_ndx / k_play_subdiv
      k_sub_trig = ((k_phase_prev < k_thresh) && (k_phase >= k_thresh) ? 1 : 0)
      if k_sub_trig > 0 then
        if k_ndx < k_target_subdiv then
          k_emit_degree = k_ndx
        else
          k_suppress_rest = 1
        endif
      endif
      k_ndx += 1
    od
  endif

  if (k_started > 0) && (k_target_subdiv > 0) && (k_emit_degree >= 0) && (k_suppress_rest == 0) then
    i_len lenarray iMidiPitches
    k_degree = k_emit_degree
    if k_play_subdiv <= 1 then
      k_note = k_basenote
    else
      k_scale_idx = k_degree % i_len
      k_oct = int(k_degree / i_len)
      k_note = k_basenote + iMidiPitches[k_scale_idx] + (12 * k_oct)
    endif
    k_note limit k_note, 0, 127
    k_interval = 60.0 / max(1.0, (k_bpm * max(1, k_play_subdiv)))
    k_dur = max(0.04, k_interval * 0.9)
    k_vel = 92
    event "i", 202, 0, k_dur, k_vel, k_note, k_midichan
    k_emit_degree = -1
  endif

  k_phase_prev = k_phase
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

instr 23
  ; Peak Notes MIDI from fader values: one max-up and one max-down voice.
  kscale chnget "Peak_notes_scale"
  kdown_scale chnget "Peak_notes_down_scale"
  if changed(kscale) + changed(kdown_scale) > 0 then
    reinit peak_scales
  endif
  peak_scales:
  iscale = i(kscale)
  iPitches[] fillarray 0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12
  if iscale == 2 then
    iPitches[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24
  elseif iscale == 3 then
    iPitches[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21
  elseif iscale == 4 then
    iPitches[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20
  elseif iscale == 5 then
    iPitches[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29
  elseif iscale == 6 then
    iPitches[] fillarray 0, 2, 5, 7,  9, 12, 14, 17, 19, 21, 24, 26, 29
  endif

  idown_scale = i(kdown_scale)
  iPitchesDown[] fillarray 0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12
  if idown_scale == 2 then
    iPitchesDown[] fillarray 0, 2, 4, 6,  8, 10, 12, 14, 16, 18, 20, 22, 24
  elseif idown_scale == 3 then
    iPitchesDown[] fillarray 0, 2, 4, 5,  7,  9, 11, 12, 14, 16, 17, 19, 21
  elseif idown_scale == 4 then
    iPitchesDown[] fillarray 0, 2, 3, 5,  7,  8, 10, 12, 14, 15, 17, 18, 20
  elseif idown_scale == 5 then
    iPitchesDown[] fillarray 0, 3, 5, 7, 10, 12, 15, 17, 19, 22, 24, 27, 29
  elseif idown_scale == 6 then
    iPitchesDown[] fillarray 0, 2, 5, 7,  9, 12, 14, 17, 19, 21, 24, 26, 29
  endif

  kup_basenote chnget "peaknotes_basenote"
  kup_midi_chan chnget "peaknotes_midichan"
  kdown_basenote chnget "peaknotes_down_basenote"
  kdown_midi_chan chnget "peaknotes_down_midichan"
  kpeak_maxdur chnget "peaknotes_maxdur"
  kpeak_maxdur limit kpeak_maxdur, 0.05, 10
  kup_thresh chnget "peaknotes_ampthresh"
  kdown_thresh chnget "peaknotes_down_ampthresh"
  kup_thresh limit kup_thresh, 0.001, 1
  kdown_thresh limit kdown_thresh, 0.001, 1

  kFaders[] tab2array giWaveRaw
  kmax_up, kmax_up_idx maxarray kFaders
  kmin_down, kmin_down_idx minarray kFaders
  kmax_up = (kmax_up > 0 ? kmax_up : 0)
  kmax_down = (kmin_down < 0 ? -kmin_down : 0)
  kmax_down_idx = (kmin_down < 0 ? kmin_down_idx : -1)


  kUpActive init 0
  kUpIdxActive init -1
  kUpInstrActive init 0
  kUpAmpLast init 0
  kDownActive init 0
  kDownIdxActive init -1
  kDownInstrActive init 0
  kDownAmpLast init 0
  kpeak_vel_scale = 95
  kpeak_vel_min = 35
  kpeak_vel_max = 110

  ; Up side: keep one active note (the strongest positive fader).
  if (kmax_up_idx >= 0) && (kmax_up >= kup_thresh) then
    kup_note = round(kup_basenote + iPitches[kmax_up_idx])
    kup_instr = 202 + (kup_note * 0.001) + (kmax_up_idx * 0.00001) + 0.00003
    kup_vel limit (kmax_up * kpeak_vel_scale), kpeak_vel_min, kpeak_vel_max
    if (kUpActive == 0) then
      event "i", kup_instr, 0, kpeak_maxdur, kup_vel, kup_note, kup_midi_chan
      kUpActive = 1
      kUpIdxActive = kmax_up_idx
      kUpInstrActive = kup_instr
      kUpAmpLast = kmax_up
    elseif (kUpIdxActive != kmax_up_idx) then
      event "i", -kUpInstrActive, 0, 0.05
      event "i", kup_instr, 0, kpeak_maxdur, kup_vel, kup_note, kup_midi_chan
      kUpIdxActive = kmax_up_idx
      kUpInstrActive = kup_instr
      kUpAmpLast = kmax_up
    elseif abs(kmax_up - kUpAmpLast) >= kup_thresh then
      event "i", -kUpInstrActive, 0, 0.02
      event "i", kup_instr, 0, kpeak_maxdur, kup_vel, kup_note, kup_midi_chan
      kUpInstrActive = kup_instr
      kUpAmpLast = kmax_up
    endif
  else
    if kUpActive > 0 then
      event "i", -kUpInstrActive, 0, 0.05
      kUpActive = 0
      kUpIdxActive = -1
      kUpInstrActive = 0
      kUpAmpLast = 0
    endif
  endif

  ; Down side: keep one active note (the strongest negative fader).
  if (kmax_down_idx >= 0) && (kmax_down >= kdown_thresh) then
    kdown_note = round(kdown_basenote + iPitchesDown[kmax_down_idx])
    kdown_instr = 202 + (kdown_note * 0.001) + (kmax_down_idx * 0.00001) + 0.00004
    kdown_vel limit (kmax_down * kpeak_vel_scale), kpeak_vel_min, kpeak_vel_max
    if (kDownActive == 0) then
      event "i", kdown_instr, 0, kpeak_maxdur, kdown_vel, kdown_note, kdown_midi_chan
      kDownActive = 1
      kDownIdxActive = kmax_down_idx
      kDownInstrActive = kdown_instr
      kDownAmpLast = kmax_down
    elseif (kDownIdxActive != kmax_down_idx) then
      event "i", -kDownInstrActive, 0, 0.05
      event "i", kdown_instr, 0, kpeak_maxdur, kdown_vel, kdown_note, kdown_midi_chan
      kDownIdxActive = kmax_down_idx
      kDownInstrActive = kdown_instr
      kDownAmpLast = kmax_down
    elseif abs(kmax_down - kDownAmpLast) >= kdown_thresh then
      event "i", -kDownInstrActive, 0, 0.02
      event "i", kdown_instr, 0, kpeak_maxdur, kdown_vel, kdown_note, kdown_midi_chan
      kDownInstrActive = kdown_instr
      kDownAmpLast = kmax_down
    endif
  else
    if kDownActive > 0 then
      event "i", -kDownInstrActive, 0, 0.05
      kDownActive = 0
      kDownIdxActive = -1
      kDownInstrActive = 0
      kDownAmpLast = 0
    endif
  endif
endin

instr 24
  ; Spatial centroid (x) from Python descriptor.
  khoriz_norm chnget "shape_centroid_x"
  khoriz_base chnget "horizcog_basenote"
  khoriz_range chnget "horizcog_range"
  khoriz_chan chnget "horizcog_midichan"
  NormMidiNote khoriz_norm, khoriz_base, khoriz_range, khoriz_chan, 78, 24
endin

instr 25
  ; Vertical center-of-gravity (rope mean y) to MIDI note.
  kvert_norm chnget "vertical_cog_norm"
  kvert_norm = 1 - kvert_norm
  kvert_base chnget "vertcog_basenote"
  kvert_range chnget "vertcog_range"
  kvert_chan chnget "vertcog_midichan"
  NormMidiNote kvert_norm, kvert_base, kvert_range, kvert_chan, 78, 25
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
