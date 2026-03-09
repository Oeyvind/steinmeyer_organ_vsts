<Cabbage>
form caption("Register Attacker") size(600, 604), colour(30, 35, 40), guiMode("queue"), pluginId("ratk")

groupbox bounds(10, 10, 110, 104), colour(25,35,40), lineThickness("0"), text("Ch1"){
nslider bounds(10, 18, 56, 20), channel("ch1_duration"), range(0.01,1,0.1,1,0.001), fontSize(11)
label   bounds(70, 20, 30, 12), text("dur"), fontSize(9)
label   bounds(10, 46, 56, 12), text("Programs:"), fontSize(9), align("left")
label   bounds(10, 58, 92, 14), channel("steptxt_1"), text("-"), fontSize(10), align("left")
button  bounds(10, 76, 55, 20), channel("clearStep"), text("Clear")
}

groupbox bounds(126, 10, 110, 104), colour(25,35,40), lineThickness("0"), text("Ch2"){
nslider bounds(10, 18, 56, 20), channel("ch2_duration"), range(0.01,1,0.1,1,0.001), fontSize(11)
label   bounds(70, 20, 30, 12), text("dur"), fontSize(9)
label   bounds(10, 46, 56, 12), text("Programs:"), fontSize(9), align("left")
label   bounds(10, 58, 92, 14), channel("ch2_steptxt_1"), text("-"), fontSize(10), align("left")
button  bounds(10, 76, 55, 20), channel("ch2ClearStep"), text("Clear")
}

groupbox bounds(242, 10, 110, 104), colour(25,35,40), lineThickness("0"), text("Ch3"){
nslider bounds(10, 18, 56, 20), channel("ch3_duration"), range(0.01,1,0.1,1,0.001), fontSize(11)
label   bounds(70, 20, 30, 12), text("dur"), fontSize(9)
label   bounds(10, 46, 56, 12), text("Programs:"), fontSize(9), align("left")
label   bounds(10, 58, 92, 14), channel("ch3_steptxt_1"), text("-"), fontSize(10), align("left")
button  bounds(10, 76, 55, 20), channel("ch3ClearStep"), text("Clear")
}

groupbox bounds(358, 10, 110, 104), colour(25,35,40), lineThickness("0"), text("Ch4"){
nslider bounds(10, 18, 56, 20), channel("ch4_duration"), range(0.01,1,0.1,1,0.001), fontSize(11)
label   bounds(70, 20, 30, 12), text("dur"), fontSize(9)
label   bounds(10, 46, 56, 12), text("Programs:"), fontSize(9), align("left")
label   bounds(10, 58, 92, 14), channel("ch4_steptxt_1"), text("-"), fontSize(10), align("left")
button  bounds(10, 76, 55, 20), channel("ch4ClearStep"), text("Clear")
}

groupbox bounds(474, 10, 110, 104), colour(25,35,40), lineThickness("0"), text("Ch8"){
nslider bounds(10, 18, 56, 20), channel("ch8_duration"), range(0.01,1,0.1,1,0.001), fontSize(11)
label   bounds(70, 20, 30, 12), text("dur"), fontSize(9)
label   bounds(10, 46, 56, 12), text("Programs:"), fontSize(9), align("left")
label   bounds(10, 58, 92, 14), channel("ch8_steptxt_1"), text("-"), fontSize(10), align("left")
button  bounds(10, 76, 55, 20), channel("ch8ClearStep"), text("Clear")
}

label bounds(10, 122, 70, 16), text("Edit Ch"), fontSize(10), align("left")
combobox bounds(80, 120, 120, 22), channel("editorSel"), items("Ch1","Ch2","Ch3","Ch4","Ch8"), value(1)

groupbox bounds(10, 150, 574, 188), channel("ch1EditorBox"), visible(1), colour(25,35,40), lineThickness("1"), text("Step Editor Ch1"){
label bounds(10, 20, 330, 14), text("Programs 1-27. Ruck map: 99 + 101-112"), fontSize(10), align("left")

checkbox bounds(10, 40, 48, 18), channel("ch1progSel_1"), text("1"), colour:1(220,200,0)
checkbox bounds(60, 40, 48, 18), channel("ch1progSel_2"), text("2"), colour:1(220,200,0)
checkbox bounds(110, 40, 48, 18), channel("ch1progSel_3"), text("3"), colour:1(220,200,0)
checkbox bounds(160, 40, 48, 18), channel("ch1progSel_4"), text("4"), colour:1(220,200,0)
checkbox bounds(210, 40, 48, 18), channel("ch1progSel_5"), text("5"), colour:1(220,200,0)
checkbox bounds(260, 40, 48, 18), channel("ch1progSel_6"), text("6"), colour:1(220,200,0)
checkbox bounds(310, 40, 48, 18), channel("ch1progSel_7"), text("7"), colour:1(220,200,0)
checkbox bounds(360, 40, 48, 18), channel("ch1progSel_8"), text("8"), colour:1(220,200,0)

checkbox bounds(10, 63, 48, 18), channel("ch1progSel_9"), text("9"), colour:1(220,200,0)
checkbox bounds(60, 63, 48, 18), channel("ch1progSel_10"), text("10"), colour:1(220,200,0)
checkbox bounds(110, 63, 48, 18), channel("ch1progSel_11"), text("11"), colour:1(220,200,0)
checkbox bounds(160, 63, 48, 18), channel("ch1progSel_12"), text("12"), colour:1(220,200,0)
checkbox bounds(210, 63, 48, 18), channel("ch1progSel_13"), text("13"), colour:1(220,200,0)
checkbox bounds(260, 63, 48, 18), channel("ch1progSel_14"), text("14"), colour:1(220,200,0)
checkbox bounds(310, 63, 48, 18), channel("ch1progSel_15"), text("15"), colour:1(220,200,0)
checkbox bounds(360, 63, 48, 18), channel("ch1progSel_16"), text("16"), colour:1(220,200,0)

checkbox bounds(10, 86, 48, 18), channel("ch1progSel_17"), text("17"), colour:1(220,200,0)
checkbox bounds(60, 86, 48, 18), channel("ch1progSel_18"), text("18"), colour:1(220,200,0)
checkbox bounds(110, 86, 48, 18), channel("ch1progSel_19"), text("19"), colour:1(220,200,0)
checkbox bounds(160, 86, 48, 18), channel("ch1progSel_20"), text("20"), colour:1(220,200,0)
checkbox bounds(210, 86, 48, 18), channel("ch1progSel_21"), text("21"), colour:1(220,200,0)
checkbox bounds(260, 86, 48, 18), channel("ch1progSel_22"), text("22"), colour:1(220,200,0)
checkbox bounds(310, 86, 48, 18), channel("ch1progSel_23"), text("23"), colour:1(220,200,0)
checkbox bounds(360, 86, 48, 18), channel("ch1progSel_24"), text("24"), colour:1(220,200,0)

checkbox bounds(10, 109, 48, 18), channel("ch1progSel_25"), text("25"), colour:1(220,200,0)
checkbox bounds(60, 109, 48, 18), channel("ch1progSel_26"), text("26"), colour:1(220,200,0)
checkbox bounds(110, 109, 48, 18), channel("ch1progSel_27"), text("27"), colour:1(220,200,0)

checkbox bounds(10, 132, 48, 18), channel("ch1progSel_28"), text("Ruck"), colour:1(220,200,0)
checkbox bounds(60, 132, 48, 18), channel("ch1progSel_29"), text("101"), colour:1(220,200,0)
checkbox bounds(110, 132, 48, 18), channel("ch1progSel_30"), text("102"), colour:1(220,200,0)
checkbox bounds(160, 132, 48, 18), channel("ch1progSel_31"), text("103"), colour:1(220,200,0)
checkbox bounds(210, 132, 48, 18), channel("ch1progSel_32"), text("104"), colour:1(220,200,0)
checkbox bounds(260, 132, 48, 18), channel("ch1progSel_33"), text("105"), colour:1(220,200,0)
checkbox bounds(310, 132, 48, 18), channel("ch1progSel_34"), text("106"), colour:1(220,200,0)
checkbox bounds(360, 132, 48, 18), channel("ch1progSel_35"), text("107"), colour:1(220,200,0)

checkbox bounds(10, 155, 48, 18), channel("ch1progSel_36"), text("108"), colour:1(220,200,0)
checkbox bounds(60, 155, 48, 18), channel("ch1progSel_37"), text("109"), colour:1(220,200,0)
checkbox bounds(110, 155, 48, 18), channel("ch1progSel_38"), text("110"), colour:1(220,200,0)
checkbox bounds(160, 155, 48, 18), channel("ch1progSel_39"), text("111"), colour:1(220,200,0)
checkbox bounds(210, 155, 48, 18), channel("ch1progSel_40"), text("112"), colour:1(220,200,0)
}

groupbox bounds(10, 150, 574, 188), channel("ch2EditorBox"), visible(0), colour(25,35,40), lineThickness("1"), text("Step Editor"){
label bounds(10, 20, 330, 14), channel("chxEditorHint"), text("Programs vary by channel"), fontSize(10), align("left")
label bounds(10, 83, 120, 12), channel("ch4GroupLabel2"), text("Solo"), fontSize(10), align("left"), visible(0)

checkbox bounds(10, 40, 48, 18), channel("ch2progSel_1"), text("1"), colour:1(220,200,0)
checkbox bounds(60, 40, 48, 18), channel("ch2progSel_2"), text("2"), colour:1(220,200,0)
checkbox bounds(110, 40, 48, 18), channel("ch2progSel_3"), text("3"), colour:1(220,200,0)
checkbox bounds(160, 40, 48, 18), channel("ch2progSel_4"), text("4"), colour:1(220,200,0)
checkbox bounds(210, 40, 48, 18), channel("ch2progSel_5"), text("5"), colour:1(220,200,0)
checkbox bounds(260, 40, 48, 18), channel("ch2progSel_6"), text("6"), colour:1(220,200,0)
checkbox bounds(310, 40, 48, 18), channel("ch2progSel_7"), text("7"), colour:1(220,200,0)
checkbox bounds(360, 40, 48, 18), channel("ch2progSel_8"), text("8"), colour:1(220,200,0)

checkbox bounds(10, 63, 48, 18), channel("ch2progSel_9"), text("9"), colour:1(220,200,0)
checkbox bounds(60, 63, 48, 18), channel("ch2progSel_10"), text("10"), colour:1(220,200,0)
checkbox bounds(110, 63, 48, 18), channel("ch2progSel_11"), text("11"), colour:1(220,200,0)
checkbox bounds(160, 63, 48, 18), channel("ch2progSel_12"), text("12"), colour:1(220,200,0)
checkbox bounds(210, 63, 48, 18), channel("ch2progSel_13"), text("13"), colour:1(220,200,0)
checkbox bounds(260, 63, 48, 18), channel("ch2progSel_14"), text("14"), colour:1(220,200,0)
checkbox bounds(310, 63, 48, 18), channel("ch2progSel_15"), text("15"), colour:1(220,200,0)
checkbox bounds(360, 63, 48, 18), channel("ch2progSel_16"), text("16"), colour:1(220,200,0)

checkbox bounds(10, 86, 48, 18), channel("ch2progSel_17"), text("17"), colour:1(220,200,0)
checkbox bounds(60, 86, 48, 18), channel("ch2progSel_18"), text("18"), colour:1(220,200,0)
checkbox bounds(110, 86, 48, 18), channel("ch2progSel_19"), text("19"), colour:1(220,200,0)
checkbox bounds(160, 86, 48, 18), channel("ch2progSel_20"), text("20"), colour:1(220,200,0)
checkbox bounds(210, 86, 48, 18), channel("ch2progSel_21"), text("21"), colour:1(220,200,0)
checkbox bounds(260, 86, 48, 18), channel("ch2progSel_22"), text("22"), colour:1(220,200,0)
checkbox bounds(310, 86, 48, 18), channel("ch2progSel_23"), text("23"), colour:1(220,200,0)
checkbox bounds(360, 86, 48, 18), channel("ch2progSel_24"), text("24"), colour:1(220,200,0)

checkbox bounds(10, 109, 48, 18), channel("ch2progSel_25"), text("25"), colour:1(220,200,0)
checkbox bounds(60, 109, 48, 18), channel("ch2progSel_26"), text("26"), colour:1(220,200,0)
checkbox bounds(110, 109, 48, 18), channel("ch2progSel_27"), text("27"), colour:1(220,200,0)
checkbox bounds(160, 109, 48, 18), channel("ch2progSel_28"), text("28"), colour:1(220,200,0)
checkbox bounds(210, 109, 48, 18), channel("ch2progSel_29"), text("29"), colour:1(220,200,0)
checkbox bounds(260, 109, 48, 18), channel("ch2progSel_30"), text("30"), colour:1(220,200,0)
checkbox bounds(310, 109, 48, 18), channel("ch2progSel_31"), text("31"), colour:1(220,200,0)
checkbox bounds(360, 109, 48, 18), channel("ch2progSel_32"), text("32"), colour:1(220,200,0)

checkbox bounds(10, 132, 48, 18), channel("ch2progSel_33"), text("Ruck"), colour:1(220,200,0)
checkbox bounds(60, 132, 48, 18), channel("ch2progSel_34"), text("101"), colour:1(220,200,0)
checkbox bounds(110, 132, 48, 18), channel("ch2progSel_35"), text("102"), colour:1(220,200,0)
checkbox bounds(160, 132, 48, 18), channel("ch2progSel_36"), text("103"), colour:1(220,200,0)
checkbox bounds(210, 132, 48, 18), channel("ch2progSel_37"), text("104"), colour:1(220,200,0)
checkbox bounds(260, 132, 48, 18), channel("ch2progSel_38"), text("105"), colour:1(220,200,0)
checkbox bounds(310, 132, 48, 18), channel("ch2progSel_39"), text("106"), colour:1(220,200,0)
checkbox bounds(360, 132, 48, 18), channel("ch2progSel_40"), text("107"), colour:1(220,200,0)

checkbox bounds(10, 155, 48, 18), channel("ch2progSel_41"), text("108"), colour:1(220,200,0)
checkbox bounds(60, 155, 48, 18), channel("ch2progSel_42"), text("109"), colour:1(220,200,0)
checkbox bounds(110, 155, 48, 18), channel("ch2progSel_43"), text("110"), colour:1(220,200,0)
checkbox bounds(160, 155, 48, 18), channel("ch2progSel_44"), text("111"), colour:1(220,200,0)
checkbox bounds(210, 155, 48, 18), channel("ch2progSel_45"), text("112"), colour:1(220,200,0)
}

button bounds(10, 346, 80, 25), channel("triggerSave"), text("Save state")
combobox bounds(95, 346, 180, 25), populate("atck_*.pre", "."), channel("recallCombo"), channelType("string")
checkbox bounds(280, 346, 90, 25), channel("allowOverwrite"), text("Overwrite"), value(0)
label bounds(10, 376, 90, 15), text("preset name"), fontSize(10), align("left")
texteditor bounds(95, 374, 180, 22), channel("presetName"), channelType("string"), text("preset_name")
label bounds(280, 376, 300, 15), channel("saveStatus"), text(""), fontSize(10), align("left")
csoundoutput bounds(10, 398, 574, 203)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d
</CsOptions>
<CsInstruments>

ksmps = 128
massign -1, 99
pgmassign -1, -1
chn_k "editorSel", 3
gk_editorSel init 1
gk_uiSyncBusy init 0
gk_attackBusy1 init 0
gk_attackBusy2 init 0
gk_attackBusy3 init 0
gk_attackBusy4 init 0
gk_attackBusy8 init 0

giPrograms_ch1_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_1 ftgen 0, 0, 128, 2, 0

giAllowedPrograms_ch1 ftgen 0, 0, 40, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,99,101,102,103,104,105,106,107,108,109,110,111,112
giAllowedPrograms_ch2 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,0,99,101,102,103,104,105,106,107,108,109,110,111,112
giAllowedPrograms_ch3 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,0,0,0,99,101,102,103,104,105,106,107,108,109,110,111,112
giAllowedPrograms_ch4 ftgen 0, 0, 45, -2, 100,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
giAllowedPrograms_ch8 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,99,101,102,103,104,105,106,107,108,109,110,111,112

opcode RefreshStepLabel, 0, i
  ieditor_chan xin
  itab = giPrograms_ch1_1
  iallowed_tab = giAllowedPrograms_ch1
  iprog_count = 40
  S_widget = "steptxt_1"
  if ieditor_chan == 2 then
    itab = giPrograms_ch2_1
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
    S_widget = "ch2_steptxt_1"
  elseif ieditor_chan == 3 then
    itab = giPrograms_ch3_1
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
    S_widget = "ch3_steptxt_1"
  elseif ieditor_chan == 4 then
    itab = giPrograms_ch4_1
    iallowed_tab = giAllowedPrograms_ch4
    iprog_count = 45
    S_widget = "ch4_steptxt_1"
  elseif ieditor_chan == 8 then
    itab = giPrograms_ch5_1
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
    S_widget = "ch8_steptxt_1"
  endif

  Sprog_list = ""
  indx = 0
  while indx < iprog_count do
    iprog table indx, iallowed_tab
    if iprog > 0 && table(iprog, itab) > 0 then
      ilen strlen Sprog_list
      if iprog == 100 then
        Sprog_item = "Fj"
      else
        Sprog_item sprintf "%i", iprog
      endif
      if ilen < 1 then
        Sprog_list = Sprog_item
      else
        Sprog_list strcat Sprog_list, sprintf(" %s", Sprog_item)
      endif
    endif
    indx += 1
  od

  if strlen(Sprog_list) == 0 then
    Sprog_txt = "text(\"-\")"
  else
    Sprog_txt sprintf "text(\"%s\")", Sprog_list
  endif
  cabbageSet S_widget, Sprog_txt
endop

instr 1
  kstart trigger timeinsts(), 0.001, 0
  if kstart > 0 then
    chnset 1, "ch1_duration"
    chnset 1, "ch2_duration"
    chnset 1, "ch3_duration"
    chnset 1, "ch4_duration"
    chnset 1, "ch8_duration"
    event "i", 11, 0, .05, 1
  endif

  k_editor_sel chnget "editorSel"
  gk_editorSel = k_editor_sel

  k_editor_chan = 1
  if k_editor_sel == 2 then
    k_editor_chan = 2
  elseif k_editor_sel == 3 then
    k_editor_chan = 3
  elseif k_editor_sel == 4 then
    k_editor_chan = 4
  elseif k_editor_sel == 5 then
    k_editor_chan = 8
  endif

  k_editor_changed changed k_editor_sel
  if k_editor_changed > 0 then
    if k_editor_chan == 1 then
      cabbageSet k_editor_changed, "ch1EditorBox", "visible(1)"
      cabbageSet k_editor_changed, "ch2EditorBox", "visible(0)"
    else
      cabbageSet k_editor_changed, "ch1EditorBox", "visible(0)"
      cabbageSet k_editor_changed, "ch2EditorBox", "visible(1)"
    endif

    if k_editor_chan == 8 then
      cabbageSet k_editor_changed, "chxEditorHint", "text(\"Programs 1-32. Ruck map: 99 + 101-112\")"
      cabbageSet k_editor_changed, "ch4GroupLabel2", "visible(0)"
      cabbageSet k_editor_changed, "ch2progSel_1", "text(\"1\"), bounds(10,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_2", "text(\"2\"), bounds(60,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_3", "text(\"3\"), bounds(110,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_4", "text(\"4\"), bounds(160,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_5", "text(\"5\"), bounds(210,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_6", "text(\"6\"), bounds(260,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_7", "text(\"7\"), bounds(310,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_8", "text(\"8\"), bounds(360,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_9", "text(\"9\"), bounds(10,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_10", "text(\"10\"), bounds(60,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_11", "text(\"11\"), bounds(110,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_12", "text(\"12\")"
      cabbageSet k_editor_changed, "ch2progSel_13", "text(\"13\")"
      cabbageSet k_editor_changed, "ch2progSel_14", "text(\"14\")"
      cabbageSet k_editor_changed, "ch2progSel_15", "text(\"15\")"
      cabbageSet k_editor_changed, "ch2progSel_16", "text(\"16\")"
      cabbageSet k_editor_changed, "ch2progSel_17", "text(\"17\")"
      cabbageSet k_editor_changed, "ch2progSel_18", "text(\"18\")"
      cabbageSet k_editor_changed, "ch2progSel_19", "text(\"19\")"
      cabbageSet k_editor_changed, "ch2progSel_19", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_20", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_21", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_22", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_23", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_24", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_25", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_12", "bounds(160,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_13", "bounds(210,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_14", "bounds(260,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_15", "bounds(310,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_16", "bounds(360,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_17", "bounds(10,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_18", "bounds(60,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_26", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_27", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_28", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_29", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_30", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_31", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_32", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_33", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_34", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_35", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_36", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_37", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_38", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_39", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_40", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_41", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_42", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_43", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_44", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_45", "visible(1), active(1)"
    elseif k_editor_chan == 3 then
      cabbageSet k_editor_changed, "chxEditorHint", "text(\"Programs 1-29. Ruck map: 99 + 101-112\")"
      cabbageSet k_editor_changed, "ch4GroupLabel2", "visible(0)"
      cabbageSet k_editor_changed, "ch2progSel_1", "text(\"1\"), bounds(10,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_2", "text(\"2\"), bounds(60,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_3", "text(\"3\"), bounds(110,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_4", "text(\"4\"), bounds(160,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_5", "text(\"5\"), bounds(210,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_6", "text(\"6\"), bounds(260,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_7", "text(\"7\"), bounds(310,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_8", "text(\"8\"), bounds(360,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_9", "text(\"9\"), bounds(10,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_10", "text(\"10\"), bounds(60,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_11", "text(\"11\"), bounds(110,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_12", "text(\"12\")"
      cabbageSet k_editor_changed, "ch2progSel_13", "text(\"13\")"
      cabbageSet k_editor_changed, "ch2progSel_14", "text(\"14\")"
      cabbageSet k_editor_changed, "ch2progSel_15", "text(\"15\")"
      cabbageSet k_editor_changed, "ch2progSel_16", "text(\"16\")"
      cabbageSet k_editor_changed, "ch2progSel_17", "text(\"17\")"
      cabbageSet k_editor_changed, "ch2progSel_18", "text(\"18\")"
      cabbageSet k_editor_changed, "ch2progSel_19", "text(\"19\")"
      cabbageSet k_editor_changed, "ch2progSel_19", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_20", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_21", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_22", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_23", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_24", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_25", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_12", "bounds(160,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_13", "bounds(210,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_14", "bounds(260,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_15", "bounds(310,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_16", "bounds(360,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_17", "bounds(10,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_18", "bounds(60,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_26", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_27", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_28", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_29", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_30", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_31", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_32", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_33", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_34", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_35", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_36", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_37", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_38", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_39", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_40", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_41", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_42", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_43", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_44", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_45", "visible(1), active(1)"
    elseif k_editor_chan == 4 then
      cabbageSet k_editor_changed, "chxEditorHint", "text(\"Ch4: Fjernverk + 1-11, Solo 12-18\")"
      cabbageSet k_editor_changed, "ch4GroupLabel2", "visible(1)"
      cabbageSet k_editor_changed, "ch2progSel_1", "text(\"Fjernverk\"), bounds(10,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_2", "text(\"1\"), bounds(60,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_3", "text(\"2\"), bounds(110,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_4", "text(\"3\"), bounds(160,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_5", "text(\"4\"), bounds(210,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_6", "text(\"5\"), bounds(260,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_7", "text(\"6\"), bounds(310,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_8", "text(\"7\"), bounds(360,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_9", "text(\"8\"), bounds(10,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_10", "text(\"9\"), bounds(60,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_11", "text(\"10\"), bounds(110,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_12", "text(\"11\"), bounds(160,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_13", "text(\"12\"), bounds(10,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_14", "text(\"13\"), bounds(60,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_15", "text(\"14\"), bounds(110,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_16", "text(\"15\"), bounds(160,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_17", "text(\"16\"), bounds(210,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_18", "text(\"17\"), bounds(260,99,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_19", "text(\"18\"), bounds(310,99,48,18), visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_20", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_21", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_22", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_23", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_24", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_25", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_26", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_27", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_28", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_29", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_30", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_31", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_32", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_33", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_34", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_35", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_36", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_37", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_38", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_39", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_40", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_41", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_42", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_43", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_44", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_45", "visible(0), active(0)"
    else
      cabbageSet k_editor_changed, "chxEditorHint", "text(\"Programs 1-25. Ruck map: 99 + 101-112\")"
      cabbageSet k_editor_changed, "ch4GroupLabel2", "visible(0)"
      cabbageSet k_editor_changed, "ch2progSel_1", "text(\"1\"), bounds(10,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_2", "text(\"2\"), bounds(60,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_3", "text(\"3\"), bounds(110,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_4", "text(\"4\"), bounds(160,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_5", "text(\"5\"), bounds(210,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_6", "text(\"6\"), bounds(260,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_7", "text(\"7\"), bounds(310,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_8", "text(\"8\"), bounds(360,40,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_9", "text(\"9\"), bounds(10,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_10", "text(\"10\"), bounds(60,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_11", "text(\"11\"), bounds(110,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_12", "text(\"12\"), bounds(160,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_13", "text(\"13\"), bounds(210,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_14", "text(\"14\"), bounds(260,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_15", "text(\"15\"), bounds(310,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_16", "text(\"16\"), bounds(360,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_17", "text(\"17\"), bounds(10,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_18", "text(\"18\"), bounds(60,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_19", "text(\"19\"), bounds(110,86,48,18), visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_19", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_20", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_21", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_22", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_23", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_24", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_25", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_12", "bounds(160,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_13", "bounds(210,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_14", "bounds(260,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_15", "bounds(310,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_16", "bounds(360,63,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_17", "bounds(10,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_18", "bounds(60,86,48,18)"
      cabbageSet k_editor_changed, "ch2progSel_19", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_20", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_21", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_22", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_23", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_24", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_25", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_26", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_27", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_28", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_29", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_30", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_31", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_32", "visible(0), active(0)"
      cabbageSet k_editor_changed, "ch2progSel_33", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_34", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_35", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_36", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_37", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_38", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_39", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_40", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_41", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_42", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_43", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_44", "visible(1), active(1)"
      cabbageSet k_editor_changed, "ch2progSel_45", "visible(1), active(1)"
    endif

    event "i", 20, 0, .02, k_editor_chan
  endif

  k_ui_poll metro 80
  k_prog_btn_vals[] init 45
  k_prog_btn_prev_ch1[] init 45
  k_prog_btn_prev_ch2[] init 45
  k_any_edit = 0
  if k_ui_poll > 0 then
    k_prog_count = 40
    if k_editor_chan != 1 then
      k_prog_count = 45
    endif

    kndx = 1
    while kndx <= k_prog_count do
      if k_editor_chan == 1 then
        Sprog_chan sprintfk "ch1progSel_%i", kndx
      else
        Sprog_chan sprintfk "ch2progSel_%i", kndx
      endif
      kval chnget Sprog_chan
      k_prog_btn_vals[kndx-1] = kval

      k_this_changed = 0
      if k_editor_chan == 1 then
        if k_prog_btn_prev_ch1[kndx-1] != k_prog_btn_vals[kndx-1] then
          k_this_changed = 1
          k_prog_btn_prev_ch1[kndx-1] = k_prog_btn_vals[kndx-1]
        endif
      else
        if k_prog_btn_prev_ch2[kndx-1] != k_prog_btn_vals[kndx-1] then
          k_this_changed = 1
          k_prog_btn_prev_ch2[kndx-1] = k_prog_btn_vals[kndx-1]
        endif
      endif

      if k_this_changed > 0 && gk_uiSyncBusy < 0.5 then
        k_any_edit = 1
      endif

      kndx += 1
    od
  endif

  if k_any_edit > 0 && gk_uiSyncBusy < 0.5 then
    event "i", 21, 0, .01, k_editor_chan
  endif

  k_clear1 chnget "clearStep"
  if changed(k_clear1) == 1 && k_clear1 > 0.5 then
    event "i", 30, 0, .01, 1
    cabbageSetValue "clearStep", 0, 1
  endif

  k_clear2 chnget "ch2ClearStep"
  if changed(k_clear2) == 1 && k_clear2 > 0.5 then
    event "i", 30, 0, .01, 2
    cabbageSetValue "ch2ClearStep", 0, 1
  endif

  k_clear3 chnget "ch3ClearStep"
  if changed(k_clear3) == 1 && k_clear3 > 0.5 then
    event "i", 30, 0, .01, 3
    cabbageSetValue "ch3ClearStep", 0, 1
  endif

  k_clear4 chnget "ch4ClearStep"
  if changed(k_clear4) == 1 && k_clear4 > 0.5 then
    event "i", 30, 0, .01, 4
    cabbageSetValue "ch4ClearStep", 0, 1
  endif

  k_clear8 chnget "ch8ClearStep"
  if changed(k_clear8) == 1 && k_clear8 > 0.5 then
    event "i", 30, 0, .01, 8
    cabbageSetValue "ch8ClearStep", 0, 1
  endif
endin

instr 11
  RefreshStepLabel 1
  RefreshStepLabel 2
  RefreshStepLabel 3
  RefreshStepLabel 4
  RefreshStepLabel 8
  ieditor_sel = p4
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel = 1
  endif
  event_i "i", 20, 0, .01, ieditor_sel
endin

instr 20
  ieditor_sel = p4
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel = 1
  endif

  itab = giPrograms_ch1_1
  iallowed_tab = giAllowedPrograms_ch1
  iprog_count = 40
  if ieditor_sel == 2 then
    itab = giPrograms_ch2_1
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab = giPrograms_ch3_1
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab = giPrograms_ch4_1
    iallowed_tab = giAllowedPrograms_ch4
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab = giPrograms_ch5_1
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
  endif

  gk_uiSyncBusy = 1
  k_once init 1
  if k_once > 0.5 then
    kndx = 0
    while kndx < iprog_count do
      kprog table kndx, iallowed_tab
      kval = 0
      if kprog > 0 then
        kval table kprog, itab
      endif
      if ieditor_sel == 1 then
        Sprog_chan sprintfk "ch1progSel_%i", kndx+1
      else
        Sprog_chan sprintfk "ch2progSel_%i", kndx+1
      endif
      chnset kval, Sprog_chan
      cabbageSetValue Sprog_chan, kval, 1
      kndx += 1
    od
    event "i", 23, 0, .02
    turnoff
  endif
endin

instr 21
  ieditor_sel = p4
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel = 1
  endif

  itab = giPrograms_ch1_1
  iallowed_tab = giAllowedPrograms_ch1
  iprog_count = 40
  if ieditor_sel == 2 then
    itab = giPrograms_ch2_1
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab = giPrograms_ch3_1
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab = giPrograms_ch4_1
    iallowed_tab = giAllowedPrograms_ch4
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab = giPrograms_ch5_1
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
  endif

  indx = 0
  while indx < 128 do
    tablew 0, indx, itab
    indx += 1
  od

  indx = 0
  while indx < iprog_count do
    if ieditor_sel == 1 then
      Sprog_chan sprintf "ch1progSel_%i", indx+1
    else
      Sprog_chan sprintf "ch2progSel_%i", indx+1
    endif
    ival chnget Sprog_chan
    if ival > 0.5 then
      iprog table indx, iallowed_tab
      if iprog > 0 then
        tablew 1, iprog, itab
      endif
    endif
    indx += 1
  od

  RefreshStepLabel ieditor_sel
endin

instr 23
  gk_uiSyncBusy = 0
endin

instr 30
  ieditor_sel = p4
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel = 1
  endif

  itab = giPrograms_ch1_1
  iallowed_tab = giAllowedPrograms_ch1
  iprog_count = 40
  if ieditor_sel == 2 then
    itab = giPrograms_ch2_1
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab = giPrograms_ch3_1
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab = giPrograms_ch4_1
    iallowed_tab = giAllowedPrograms_ch4
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab = giPrograms_ch5_1
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
  endif

  indx = 0
  while indx < 128 do
    tablew 0, indx, itab
    indx += 1
  od

  indx = 1
  while indx <= iprog_count do
    if ieditor_sel == 1 then
      Sprog_chan sprintf "ch1progSel_%i", indx
    else
      Sprog_chan sprintf "ch2progSel_%i", indx
    endif
    chnset 0, Sprog_chan
    cabbageSetValue Sprog_chan, 0, 1
    indx += 1
  od

  RefreshStepLabel ieditor_sel
endin

instr 50
  ; MIDI Program Change -> editor program button mapping.
  k_status, k_chan, k_data1, k_data2 midiin

  if k_status < 192 || k_status > 207 then
    goto done
  endif

  k_editor_sel = gk_editorSel
  k_editor_chan = 1
  if k_editor_sel == 2 then
    k_editor_chan = 2
  elseif k_editor_sel == 3 then
    k_editor_chan = 3
  elseif k_editor_sel == 4 then
    k_editor_chan = 4
  elseif k_editor_sel == 5 then
    k_editor_chan = 8
  endif

  k_prog_onoff = 1
  if (k_data1 % 2) != 0 then
    k_prog_onoff = 0
  endif

  k_iprog = -1

  if k_editor_chan == 1 || k_editor_chan == 2 || k_editor_chan == 3 || k_editor_chan == 8 then
    k_ruck = -999
    if k_editor_chan == 1 then
      k_ruck = 72
    elseif k_editor_chan == 2 then
      k_ruck = 70
    elseif k_editor_chan == 3 then
      k_ruck = 74
    elseif k_editor_chan == 8 then
      k_ruck = 76
    endif

    if k_chan == k_editor_chan && (k_data1 == k_ruck || k_data1 == (k_ruck+1)) then
      k_iprog = 99
    elseif (k_chan == 4 || k_chan == 5) && k_data1 >= 36 && k_data1 <= 59 then
      k_iprog = int((k_data1-36)/2) + 101
    elseif k_chan == k_editor_chan then
      k_iprog = int(k_data1/2) + 1
    endif
  elseif k_editor_chan == 4 then
    if k_chan == 3 && (k_data1 == 58 || k_data1 == 59) then
      k_iprog = 100
    elseif k_chan == 4 then
      k_iprog = int(k_data1/2) + 1
    endif
  endif

  if k_iprog < 0 then
    goto done
  endif

  k_allowed_tab = giAllowedPrograms_ch1
  k_prog_count = 40
  if k_editor_chan == 2 then
    k_allowed_tab = giAllowedPrograms_ch2
    k_prog_count = 45
  elseif k_editor_chan == 3 then
    k_allowed_tab = giAllowedPrograms_ch3
    k_prog_count = 45
  elseif k_editor_chan == 4 then
    k_allowed_tab = giAllowedPrograms_ch4
    k_prog_count = 45
  elseif k_editor_chan == 8 then
    k_allowed_tab = giAllowedPrograms_ch8
    k_prog_count = 45
  endif

  k_idx = 0
  while k_idx < k_prog_count do
    k_map_prog tablekt k_idx, k_allowed_tab
    if int(k_map_prog+0.5) == int(k_iprog+0.5) then
      if k_editor_chan == 1 then
        S_prog_chan sprintfk "ch1progSel_%i", k_idx+1
      else
        S_prog_chan sprintfk "ch2progSel_%i", k_idx+1
      endif
      cabbageSetValue S_prog_chan, k_prog_onoff, 1
      kgoto done
    endif
    k_idx += 1
  od

  done:
endin

instr 60
  ; Trigger only the matching channel program set on note-on.
  k_status, k_chan, k_data1, k_data2 midiin
  k_changed changed k_status, k_chan, k_data1, k_data2
  if k_changed < 0.5 then
    goto done
  endif

  if k_status >= 144 && k_status <= 159 && k_data2 > 0 then
    if k_chan == 1 && gk_attackBusy1 < 0.5 then
      event "i", 61, 0, .01, 1
    elseif k_chan == 2 && gk_attackBusy2 < 0.5 then
      event "i", 61, 0, .01, 2
    elseif k_chan == 3 && gk_attackBusy3 < 0.5 then
      event "i", 61, 0, .01, 3
    elseif k_chan == 4 && gk_attackBusy4 < 0.5 then
      event "i", 61, 0, .01, 4
    elseif k_chan == 8 && gk_attackBusy8 < 0.5 then
      event "i", 61, 0, .01, 8
    endif
  endif

  done:
endin

instr 61
  ich = p4
  iDur = 1
  itab = giPrograms_ch1_1
  ioff = 0.0001
  iout = 1

  if ich == 2 then
    iDur chnget "ch2_duration"
    itab = giPrograms_ch2_1
    ioff = 0.0003
    iout = 2
    gk_attackBusy2 = 1
  elseif ich == 3 then
    iDur chnget "ch3_duration"
    itab = giPrograms_ch3_1
    ioff = 0.0005
    iout = 3
    gk_attackBusy3 = 1
  elseif ich == 4 then
    iDur chnget "ch4_duration"
    itab = giPrograms_ch4_1
    ioff = 0.0007
    iout = 4
    gk_attackBusy4 = 1
  elseif ich == 8 then
    iDur chnget "ch8_duration"
    itab = giPrograms_ch5_1
    ioff = 0.0009
    iout = 8
    gk_attackBusy8 = 1
  else
    iDur chnget "ch1_duration"
    itab = giPrograms_ch1_1
    ioff = 0.0001
    iout = 1
    gk_attackBusy1 = 1
  endif

  if iDur < 0.01 then
    iDur = 0.01
  endif
  event_i "i", 62, iDur, .01, ich

  ip = 0
  while ip < 128 do
    if table(ip, itab) > 0.5 then
      event_i "i", 202 + ((ip*0.001) + ioff), 0, iDur, ip, iout
    endif
    ip += 1
  od
endin

instr 62
  ich = p4
  if ich == 1 then
    gk_attackBusy1 = 0
  elseif ich == 2 then
    gk_attackBusy2 = 0
  elseif ich == 3 then
    gk_attackBusy3 = 0
  elseif ich == 4 then
    gk_attackBusy4 = 0
  elseif ich == 8 then
    gk_attackBusy8 = 0
  endif
endin

instr 10
  k_skip_next_recall init 0

  S_filename, k_trig cabbageGetValue "recallCombo"
  S_path = chnget:S("CSD_PATH")
  k_file_len strlenk S_filename
  if k_trig == 1 then
    if k_skip_next_recall > 0.5 then
      k_skip_next_recall = 0
    elseif k_file_len > 0 then
      S_filename_full = sprintfk:S("%s\\%s.pre", S_path, S_filename)
      ftloadk S_filename_full, 1, 1, giPrograms_ch1_1, giPrograms_ch2_1, giPrograms_ch3_1, giPrograms_ch4_1, giPrograms_ch5_1
      event "i", 11, 0, .05, 1
    endif
  endif

  k_trigger_save cabbageGetValue "triggerSave"
  if changed(k_trigger_save) == 1 && k_trigger_save > 0.5 then
    k_allow_overwrite chnget "allowOverwrite"
    S_preset_name chnget "presetName"
    k_name_len strlenk S_preset_name
    if k_name_len < 1 then
      S_preset_name = "preset_name"
    endif

    S_save_filename = sprintfk:S("%s\\atck_%s.pre", S_path, S_preset_name)
    i_exists filevalid S_save_filename
    if i_exists > 0 && k_allow_overwrite < 0.5 then
      S_warn sprintfk "text(\"Exists: atck_%s.pre (check Overwrite or rename)\")", S_preset_name
      cabbageSet 1, "saveStatus", S_warn
    else
      ftsavek S_save_filename, 1, 1, giPrograms_ch1_1, giPrograms_ch2_1, giPrograms_ch3_1, giPrograms_ch4_1, giPrograms_ch5_1
      k_skip_next_recall = 1
      cabbageSet 1, "recallCombo", "refreshFiles(1)"
      S_ok sprintfk "text(\"Saved: atck_%s.pre\")", S_preset_name
      cabbageSet 1, "saveStatus", S_ok
    endif

    cabbageSetValue "triggerSave", 0, 1
  endif
endin

instr 202
  iprog = p4
  ichan = p5
  iChanMax[] fillarray 27,25,29,18,0,0,0,32
  iRuckSwitchOffset[] fillarray 72,70,74,0,0,0,0,76

  if ichan == 4 && iprog == 127 then
    iprog = 100
  endif

  if iprog == 100 && ichan == 4 then
    iprognum = 58
    ichan = 3
    imax_this_channel = 100
  elseif iprog == 99 && (ichan == 1 || ichan == 2 || ichan == 3 || ichan == 8) then
    iprognum = iRuckSwitchOffset[ichan-1]
    imax_this_channel = 99
  else
    iprognum = (iprog*2)-2
    imax_this_channel = iChanMax[ichan-1]
  endif

  if (iprog <= 113) && (iprog >= 101) && (ichan == 1 || ichan == 2 || ichan == 3 || ichan == 8) then
    iprognum = ((iprog-101)*2)+36
    ichan = 4
    imax_this_channel = 112
  endif

  if iprog <= imax_this_channel then
    midiout_i 192, ichan, iprognum, 0
    klast lastcycle
    if klast > 0 then
      midiout 192, ichan, iprognum+1, 0
    endif
  endif
endin

instr 99
endin

</CsInstruments>
<CsScore>
i1 0 86400
i10 0 86400
i50 0 86400
i60 0 86400
</CsScore>
</CsoundSynthesizer>
