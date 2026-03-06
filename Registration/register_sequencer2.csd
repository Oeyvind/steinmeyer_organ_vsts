<Cabbage>
form caption("Register Sequencer") size(1220, 520), colour(30, 35, 40), guiMode("queue"), pluginId("rsq1")

button  bounds(  5, 10, 50, 30), channel("play"), text("Play"), colour:0("black"), colour:1("green")
nslider bounds( 65, 10, 30, 20), channel("tempo"), range(30,300,120, 1, 1), fontSize(13)
label   bounds( 65, 30, 30, 15), text("tempo"), fontSize(10)

nslider bounds(5, 45, 40, 20), channel("duration"), range(0,1,1), fontSize(13)
label   bounds(5, 60, 40, 15), text("duration"), fontSize(10)
combobox bounds( 60, 45, 35, 20), channel("tempo_mult"), items(1,2,3,4,5,6,7,8), value(1)

groupbox bounds(5, 80, 130, 430), colour(25,35,40), lineThickness("0"){
nslider bounds(5, 5, 30, 20), channel("outchan"), range(1,16,1, 1, 1), fontSize(13)
label   bounds(5, 25, 30, 15), text("outchan"), fontSize(10)
nslider bounds(40, 5, 30, 20), channel("numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(40, 25, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(75, 5, 30, 20), channel("ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(75, 25, 30, 15), text("index"), fontSize(10)

nslider bounds(5, 40, 30, 20), channel("stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(5, 60, 30, 15), text("%"), fontSize(10)
nslider bounds(40, 40, 30, 20), channel("rmod3"), range(0,1,0), fontSize(13)
label   bounds(40, 60, 30, 15), text("r%3"), fontSize(10)
nslider bounds(75, 40, 30, 20), channel("rmod5"), range(0,1,0), fontSize(13)
label   bounds(75, 60, 30, 15), text("r%5"), fontSize(10)

label bounds(5, 78, 110, 12), text("steps"), fontSize(10), align("left")
button bounds(5, 92, 23, 16), text("1:"), colour:0("black"), colour:1("green"), channel("ndex_1")
label  bounds(33, 90, 90, 18), channel("steptxt_1"), text("-"), fontSize(10), align("left")
button bounds(5, 117, 23, 16), text("2:"), colour:0("black"), colour:1("green"), channel("ndex_2")
label  bounds(33, 115, 90, 18), channel("steptxt_2"), text("-"), fontSize(10), align("left")
button bounds(5, 142, 23, 16), text("3:"), colour:0("black"), colour:1("green"), channel("ndex_3")
label  bounds(33, 140, 90, 18), channel("steptxt_3"), text("-"), fontSize(10), align("left")
button bounds(5, 167, 23, 16), text("4:"), colour:0("black"), colour:1("green"), channel("ndex_4")
label  bounds(33, 165, 90, 18), channel("steptxt_4"), text("-"), fontSize(10), align("left")
button bounds(5, 192, 23, 16), text("5:"), colour:0("black"), colour:1("green"), channel("ndex_5")
label  bounds(33, 190, 90, 18), channel("steptxt_5"), text("-"), fontSize(10), align("left")
button bounds(5, 217, 23, 16), text("6:"), colour:0("black"), colour:1("green"), channel("ndex_6")
label  bounds(33, 215, 90, 18), channel("steptxt_6"), text("-"), fontSize(10), align("left")
button bounds(5, 242, 23, 16), text("7:"), colour:0("black"), colour:1("green"), channel("ndex_7")
label  bounds(33, 240, 90, 18), channel("steptxt_7"), text("-"), fontSize(10), align("left")
button bounds(5, 267, 23, 16), text("8:"), colour:0("black"), colour:1("green"), channel("ndex_8")
label  bounds(33, 265, 90, 18), channel("steptxt_8"), text("-"), fontSize(10), align("left")

button bounds(5, 300, 55, 20), channel("clearStep"), text("ClrStep")
button bounds(65, 300, 55, 20), channel("clearAll"), text("ClearAll")
}

groupbox bounds(145, 80, 130, 430), colour(25,35,40), lineThickness("0"){
nslider bounds(5, 5, 30, 20), channel("ch2_outchan"), range(1,16,2, 1, 1), fontSize(13)
label   bounds(5, 25, 30, 15), text("outchan"), fontSize(10)
nslider bounds(40, 5, 30, 20), channel("ch2_numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(40, 25, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(75, 5, 30, 20), channel("ch2_ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(75, 25, 30, 15), text("index"), fontSize(10)

nslider bounds(5, 40, 30, 20), channel("ch2_stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(5, 60, 30, 15), text("%"), fontSize(10)
nslider bounds(40, 40, 30, 20), channel("ch2_rmod3"), range(0,1,0), fontSize(13)
label   bounds(40, 60, 30, 15), text("r%3"), fontSize(10)
nslider bounds(75, 40, 30, 20), channel("ch2_rmod5"), range(0,1,0), fontSize(13)
label   bounds(75, 60, 30, 15), text("r%5"), fontSize(10)

label bounds(5, 78, 110, 12), text("steps ch2"), fontSize(10), align("left")
button bounds(5, 92, 23, 16), text("1:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_1")
label  bounds(33, 90, 90, 18), channel("ch2_steptxt_1"), text("-"), fontSize(10), align("left")
button bounds(5, 117, 23, 16), text("2:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_2")
label  bounds(33, 115, 90, 18), channel("ch2_steptxt_2"), text("-"), fontSize(10), align("left")
button bounds(5, 142, 23, 16), text("3:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_3")
label  bounds(33, 140, 90, 18), channel("ch2_steptxt_3"), text("-"), fontSize(10), align("left")
button bounds(5, 167, 23, 16), text("4:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_4")
label  bounds(33, 165, 90, 18), channel("ch2_steptxt_4"), text("-"), fontSize(10), align("left")
button bounds(5, 192, 23, 16), text("5:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_5")
label  bounds(33, 190, 90, 18), channel("ch2_steptxt_5"), text("-"), fontSize(10), align("left")
button bounds(5, 217, 23, 16), text("6:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_6")
label  bounds(33, 215, 90, 18), channel("ch2_steptxt_6"), text("-"), fontSize(10), align("left")
button bounds(5, 242, 23, 16), text("7:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_7")
label  bounds(33, 240, 90, 18), channel("ch2_steptxt_7"), text("-"), fontSize(10), align("left")
button bounds(5, 267, 23, 16), text("8:"), colour:0("black"), colour:1("green"), channel("ch2_ndex_8")
label  bounds(33, 265, 90, 18), channel("ch2_steptxt_8"), text("-"), fontSize(10), align("left")

button bounds(5, 300, 55, 20), channel("ch2ClearStep"), text("ClrStep")
button bounds(65, 300, 55, 20), channel("ch2ClearAll"), text("ClearAll")
}

label bounds(295, 12, 70, 16), text("Edit Ch"), fontSize(10), align("left")
combobox bounds(365, 10, 60, 22), channel("editorSel"), items(1,2), value(1)

groupbox bounds(295, 40, 430, 220), channel("ch1EditorBox"), visible(1), colour(25,35,40), lineThickness("1"), text("Step Editor Ch1"){
label bounds(10, 15, 330, 14), text("Programs 1-27. Ruck map: 99 + 101-112"), fontSize(10), align("left")

checkbox bounds(10, 35, 48, 18), channel("ch1progSel_1"), text("1"), colour:1(220,200,0)
checkbox bounds(60, 35, 48, 18), channel("ch1progSel_2"), text("2"), colour:1(220,200,0)
checkbox bounds(110, 35, 48, 18), channel("ch1progSel_3"), text("3"), colour:1(220,200,0)
checkbox bounds(160, 35, 48, 18), channel("ch1progSel_4"), text("4"), colour:1(220,200,0)
checkbox bounds(210, 35, 48, 18), channel("ch1progSel_5"), text("5"), colour:1(220,200,0)
checkbox bounds(260, 35, 48, 18), channel("ch1progSel_6"), text("6"), colour:1(220,200,0)
checkbox bounds(310, 35, 48, 18), channel("ch1progSel_7"), text("7"), colour:1(220,200,0)
checkbox bounds(360, 35, 48, 18), channel("ch1progSel_8"), text("8"), colour:1(220,200,0)

checkbox bounds(10, 58, 48, 18), channel("ch1progSel_9"), text("9"), colour:1(220,200,0)
checkbox bounds(60, 58, 48, 18), channel("ch1progSel_10"), text("10"), colour:1(220,200,0)
checkbox bounds(110, 58, 48, 18), channel("ch1progSel_11"), text("11"), colour:1(220,200,0)
checkbox bounds(160, 58, 48, 18), channel("ch1progSel_12"), text("12"), colour:1(220,200,0)
checkbox bounds(210, 58, 48, 18), channel("ch1progSel_13"), text("13"), colour:1(220,200,0)
checkbox bounds(260, 58, 48, 18), channel("ch1progSel_14"), text("14"), colour:1(220,200,0)
checkbox bounds(310, 58, 48, 18), channel("ch1progSel_15"), text("15"), colour:1(220,200,0)
checkbox bounds(360, 58, 48, 18), channel("ch1progSel_16"), text("16"), colour:1(220,200,0)

checkbox bounds(10, 81, 48, 18), channel("ch1progSel_17"), text("17"), colour:1(220,200,0)
checkbox bounds(60, 81, 48, 18), channel("ch1progSel_18"), text("18"), colour:1(220,200,0)
checkbox bounds(110, 81, 48, 18), channel("ch1progSel_19"), text("19"), colour:1(220,200,0)
checkbox bounds(160, 81, 48, 18), channel("ch1progSel_20"), text("20"), colour:1(220,200,0)
checkbox bounds(210, 81, 48, 18), channel("ch1progSel_21"), text("21"), colour:1(220,200,0)
checkbox bounds(260, 81, 48, 18), channel("ch1progSel_22"), text("22"), colour:1(220,200,0)
checkbox bounds(310, 81, 48, 18), channel("ch1progSel_23"), text("23"), colour:1(220,200,0)
checkbox bounds(360, 81, 48, 18), channel("ch1progSel_24"), text("24"), colour:1(220,200,0)

checkbox bounds(10, 104, 48, 18), channel("ch1progSel_25"), text("25"), colour:1(220,200,0)
checkbox bounds(60, 104, 48, 18), channel("ch1progSel_26"), text("26"), colour:1(220,200,0)
checkbox bounds(110, 104, 48, 18), channel("ch1progSel_27"), text("27"), colour:1(220,200,0)

checkbox bounds(10, 127, 48, 18), channel("ch1progSel_28"), text("Ruck"), colour:1(220,200,0)
checkbox bounds(60, 127, 48, 18), channel("ch1progSel_29"), text("101"), colour:1(220,200,0)
checkbox bounds(110, 127, 48, 18), channel("ch1progSel_30"), text("102"), colour:1(220,200,0)
checkbox bounds(160, 127, 48, 18), channel("ch1progSel_31"), text("103"), colour:1(220,200,0)
checkbox bounds(210, 127, 48, 18), channel("ch1progSel_32"), text("104"), colour:1(220,200,0)
checkbox bounds(260, 127, 48, 18), channel("ch1progSel_33"), text("105"), colour:1(220,200,0)
checkbox bounds(310, 127, 48, 18), channel("ch1progSel_34"), text("106"), colour:1(220,200,0)
checkbox bounds(360, 127, 48, 18), channel("ch1progSel_35"), text("107"), colour:1(220,200,0)

checkbox bounds(10, 150, 48, 18), channel("ch1progSel_36"), text("108"), colour:1(220,200,0)
checkbox bounds(60, 150, 48, 18), channel("ch1progSel_37"), text("109"), colour:1(220,200,0)
checkbox bounds(110, 150, 48, 18), channel("ch1progSel_38"), text("110"), colour:1(220,200,0)
checkbox bounds(160, 150, 48, 18), channel("ch1progSel_39"), text("111"), colour:1(220,200,0)
checkbox bounds(210, 150, 48, 18), channel("ch1progSel_40"), text("112"), colour:1(220,200,0)
}

groupbox bounds(295, 40, 430, 220), channel("ch2EditorBox"), visible(0), colour(25,35,40), lineThickness("1"), text("Step Editor Ch2"){
label bounds(10, 15, 330, 14), text("Programs 1-26. Ruck map: 99 + 101-112"), fontSize(10), align("left")

checkbox bounds(10, 35, 48, 18), channel("ch2progSel_1"), text("1"), colour:1(220,200,0)
checkbox bounds(60, 35, 48, 18), channel("ch2progSel_2"), text("2"), colour:1(220,200,0)
checkbox bounds(110, 35, 48, 18), channel("ch2progSel_3"), text("3"), colour:1(220,200,0)
checkbox bounds(160, 35, 48, 18), channel("ch2progSel_4"), text("4"), colour:1(220,200,0)
checkbox bounds(210, 35, 48, 18), channel("ch2progSel_5"), text("5"), colour:1(220,200,0)
checkbox bounds(260, 35, 48, 18), channel("ch2progSel_6"), text("6"), colour:1(220,200,0)
checkbox bounds(310, 35, 48, 18), channel("ch2progSel_7"), text("7"), colour:1(220,200,0)
checkbox bounds(360, 35, 48, 18), channel("ch2progSel_8"), text("8"), colour:1(220,200,0)

checkbox bounds(10, 58, 48, 18), channel("ch2progSel_9"), text("9"), colour:1(220,200,0)
checkbox bounds(60, 58, 48, 18), channel("ch2progSel_10"), text("10"), colour:1(220,200,0)
checkbox bounds(110, 58, 48, 18), channel("ch2progSel_11"), text("11"), colour:1(220,200,0)
checkbox bounds(160, 58, 48, 18), channel("ch2progSel_12"), text("12"), colour:1(220,200,0)
checkbox bounds(210, 58, 48, 18), channel("ch2progSel_13"), text("13"), colour:1(220,200,0)
checkbox bounds(260, 58, 48, 18), channel("ch2progSel_14"), text("14"), colour:1(220,200,0)
checkbox bounds(310, 58, 48, 18), channel("ch2progSel_15"), text("15"), colour:1(220,200,0)
checkbox bounds(360, 58, 48, 18), channel("ch2progSel_16"), text("16"), colour:1(220,200,0)

checkbox bounds(10, 81, 48, 18), channel("ch2progSel_17"), text("17"), colour:1(220,200,0)
checkbox bounds(60, 81, 48, 18), channel("ch2progSel_18"), text("18"), colour:1(220,200,0)
checkbox bounds(110, 81, 48, 18), channel("ch2progSel_19"), text("19"), colour:1(220,200,0)
checkbox bounds(160, 81, 48, 18), channel("ch2progSel_20"), text("20"), colour:1(220,200,0)
checkbox bounds(210, 81, 48, 18), channel("ch2progSel_21"), text("21"), colour:1(220,200,0)
checkbox bounds(260, 81, 48, 18), channel("ch2progSel_22"), text("22"), colour:1(220,200,0)
checkbox bounds(310, 81, 48, 18), channel("ch2progSel_23"), text("23"), colour:1(220,200,0)
checkbox bounds(360, 81, 48, 18), channel("ch2progSel_24"), text("24"), colour:1(220,200,0)

checkbox bounds(10, 104, 48, 18), channel("ch2progSel_25"), text("25"), colour:1(220,200,0)
checkbox bounds(60, 104, 48, 18), channel("ch2progSel_26"), text("26"), colour:1(220,200,0)

checkbox bounds(10, 127, 48, 18), channel("ch2progSel_27"), text("Ruck"), colour:1(220,200,0)
checkbox bounds(60, 127, 48, 18), channel("ch2progSel_28"), text("101"), colour:1(220,200,0)
checkbox bounds(110, 127, 48, 18), channel("ch2progSel_29"), text("102"), colour:1(220,200,0)
checkbox bounds(160, 127, 48, 18), channel("ch2progSel_30"), text("103"), colour:1(220,200,0)
checkbox bounds(210, 127, 48, 18), channel("ch2progSel_31"), text("104"), colour:1(220,200,0)
checkbox bounds(260, 127, 48, 18), channel("ch2progSel_32"), text("105"), colour:1(220,200,0)
checkbox bounds(310, 127, 48, 18), channel("ch2progSel_33"), text("106"), colour:1(220,200,0)
checkbox bounds(360, 127, 48, 18), channel("ch2progSel_34"), text("107"), colour:1(220,200,0)

checkbox bounds(10, 150, 48, 18), channel("ch2progSel_35"), text("108"), colour:1(220,200,0)
checkbox bounds(60, 150, 48, 18), channel("ch2progSel_36"), text("109"), colour:1(220,200,0)
checkbox bounds(110, 150, 48, 18), channel("ch2progSel_37"), text("110"), colour:1(220,200,0)
checkbox bounds(160, 150, 48, 18), channel("ch2progSel_38"), text("111"), colour:1(220,200,0)
checkbox bounds(210, 150, 48, 18), channel("ch2progSel_39"), text("112"), colour:1(220,200,0)
}

csoundoutput bounds(295, 270, 870, 240)
button bounds(720, 20, 80, 25), channel("triggerSave"), text("Save state")
combobox bounds(805, 20, 160, 25), populate("*.pre", "."), channel("recallCombo"), channelType("string")
nslider bounds(720, 50, 40, 20), channel("filenumber"), range(0,999,0,1,1,1), fontSize(13)
label bounds(765, 50, 130, 15), text("preset index"), fontSize(10), align("left")
checkbox bounds(900, 50, 65, 18), channel("debugSafe"), text("Debug"), value(0)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d
</CsOptions>
<CsInstruments>

ksmps = 128
massign -1, 99
pgmassign -1, -1

giPrograms_ch1_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_2 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_3 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_4 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_5 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_6 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_7 ftgen 0, 0, 128, 2, 0
giPrograms_ch1_8 ftgen 0, 0, 128, 2, 0
giProg_tables_ch1 ftgen 0, 0, 8, -2, giPrograms_ch1_1, giPrograms_ch1_2, giPrograms_ch1_3, giPrograms_ch1_4, giPrograms_ch1_5, giPrograms_ch1_6, giPrograms_ch1_7, giPrograms_ch1_8

giPrograms_ch2_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_2 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_3 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_4 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_5 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_6 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_7 ftgen 0, 0, 128, 2, 0
giPrograms_ch2_8 ftgen 0, 0, 128, 2, 0
giProg_tables_ch2 ftgen 0, 0, 8, -2, giPrograms_ch2_1, giPrograms_ch2_2, giPrograms_ch2_3, giPrograms_ch2_4, giPrograms_ch2_5, giPrograms_ch2_6, giPrograms_ch2_7, giPrograms_ch2_8

giAllowedPrograms_ch1 ftgen 0, 0, 40, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,99,101,102,103,104,105,106,107,108,109,110,111,112
giAllowedPrograms_ch2 ftgen 0, 0, 39, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,99,101,102,103,104,105,106,107,108,109,110,111,112

opcode ButtonEvent, 0, kij
  kbutton, instrnum, iparm xin
  ktrigon trigger kbutton, 0.5, 0
  ktrigoff trigger kbutton, 0.5, 1
  if ktrigon > 0 then
    event "i", instrnum, 0, -1, iparm
  endif
  if ktrigoff > 0 then
    event "i", -instrnum, 0, .1
  endif
endop

opcode RefreshStepLabel, 0, ii
  istep, ieditor_sel xin
  itab = 0
  iallowed_tab = 0
  iprog_count = 0
  if ieditor_sel == 2 then
    itab table istep-1, giProg_tables_ch2
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 39
  else
    itab table istep-1, giProg_tables_ch1
    iallowed_tab = giAllowedPrograms_ch1
    iprog_count = 40
  endif
  Sprog_list = ""
  indx = 0
  while indx < iprog_count do
    iprog table indx, iallowed_tab
    if table(iprog, itab) > 0 then
      ilen strlen Sprog_list
      if ilen < 1 then
        Sprog_list sprintf "%i", iprog
      else
        Sprog_list strcat Sprog_list, sprintf(" %i", iprog)
      endif
    endif
    indx += 1
  od
  if strlen(Sprog_list) == 0 then
    Sprog_txt = "text(\"-\")"
  else
    Sprog_txt sprintf "text(\"%s\")", Sprog_list
  endif
  if ieditor_sel == 2 then
    S_widget sprintf "ch2_steptxt_%i", istep
  else
    S_widget sprintf "steptxt_%i", istep
  endif
  cabbageSet S_widget, Sprog_txt
endop

instr 1
  kstart trigger timeinsts(), 0.001, 0
  if kstart > 0 then
    chnset 1, "outchan"
    chnset 2, "ch2_outchan"
    cabbageSet "outchan", "active(0)"
    cabbageSet "ch2_outchan", "active(0)"
    cabbageSet kstart, "ch1EditorBox", "visible(1)"
    cabbageSet kstart, "ch2EditorBox", "visible(0)"
    event "i", 11, 0, .05, 1
  endif

  k_editor_sel_raw chnget "editorSel"
  k_editor_sel = int(k_editor_sel_raw+0.5)
  if k_editor_sel < 1 then
    k_editor_sel = 1
  endif
  if k_editor_sel > 2 then
    k_editor_sel = 2
  endif
  k_editor_changed changed k_editor_sel
  if k_editor_changed > 0 then
    if k_editor_sel == 1 then
      cabbageSet k_editor_changed, "ch1EditorBox", "visible(1)"
      cabbageSet k_editor_changed, "ch2EditorBox", "visible(0)"
    else
      cabbageSet k_editor_changed, "ch1EditorBox", "visible(0)"
      cabbageSet k_editor_changed, "ch2EditorBox", "visible(1)"
    endif
    event "i", 11, 0, .05, k_editor_sel
  endif

  k_debug chnget "debugSafe"
  k_ui_poll metro 120

  k_step_btn_sync_busy chnget "stepBtnSyncBusy"
  k_step_btn_vals[] init 8
  k_step_btn_prev[] init 8
  k_step2_btn_vals[] init 8
  k_step2_btn_prev[] init 8
  if k_ui_poll > 0 then
    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep_btn sprintfk "ndex_%i", kbtn_ndx
      kstep_btn_val chnget Sstep_btn
      k_step_btn_vals[kbtn_ndx-1] = kstep_btn_val
      if k_step_btn_vals[kbtn_ndx-1] > 0.5 && k_step_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
        if k_debug > 0.5 then
          event "i", 90, 0, 0.1, 1, kbtn_ndx, kstep_btn_val
        endif
        chnset 1, "editorSel"
        chnset kbtn_ndx, "ndex"
        event "i", 20, 0, .01, kbtn_ndx, 1
      endif
      k_step_btn_prev[kbtn_ndx-1] = k_step_btn_vals[kbtn_ndx-1]
      kbtn_ndx += 1
    od

    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep2_btn sprintfk "ch2_ndex_%i", kbtn_ndx
      kstep2_btn_val chnget Sstep2_btn
      k_step2_btn_vals[kbtn_ndx-1] = kstep2_btn_val
      if k_step2_btn_vals[kbtn_ndx-1] > 0.5 && k_step2_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
        if k_debug > 0.5 then
          event "i", 90, 0, 0.1, 1, kbtn_ndx, kstep2_btn_val
        endif
        chnset 2, "editorSel"
        chnset kbtn_ndx, "ch2_ndex"
        event "i", 20, 0, .01, kbtn_ndx, 2
      endif
      k_step2_btn_prev[kbtn_ndx-1] = k_step2_btn_vals[kbtn_ndx-1]
      kbtn_ndx += 1
    od
  endif

  k_play chnget "play"
  ButtonEvent k_play, 3
  kplay_off trigger k_play, 0.5, 1
  if kplay_off > 0 then
    turnoff2 202, 0, 1
  endif

  k_edit_step_ch1 chnget "ndex"
  k_edit_step_ch2 chnget "ch2_ndex"
  k_step_changed_ch1 changed k_edit_step_ch1
  if k_step_changed_ch1 > 0 then
    event "i", 20, 0, .01, k_edit_step_ch1, 1
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn sprintfk "ndex_%i", kbtn
      if kbtn == k_edit_step_ch1 then
        cabbageSetValue S_btn, 1, 1
      else
        cabbageSetValue S_btn, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif

  k_step_changed_ch2 changed k_edit_step_ch2
  if k_step_changed_ch2 > 0 then
    event "i", 20, 0, .01, k_edit_step_ch2, 2
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn2 sprintfk "ch2_ndex_%i", kbtn
      if kbtn == k_edit_step_ch2 then
        cabbageSetValue S_btn2, 1, 1
      else
        cabbageSetValue S_btn2, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif

  k_edit_step = k_edit_step_ch1
  if k_editor_sel == 2 then
    k_edit_step = k_edit_step_ch2
  endif

  k_any_edit init 0
  k_any_edit = 0
  k_ui_sync_busy chnget "uiSyncBusy"
  k_prog_btn_vals[] init 40
  k_prog_btn_prev_ch1[] init 40
  k_prog_btn_prev_ch2[] init 40
  if k_ui_poll > 0 then
    k_prog_count = 40
    if k_editor_sel == 2 then
      k_prog_count = 39
    endif
    kndx = 1
    while kndx <= k_prog_count do
      if k_editor_sel == 2 then
        Sprog_chan sprintfk "ch2progSel_%i", kndx
      else
        Sprog_chan sprintfk "ch1progSel_%i", kndx
      endif
      kval chnget Sprog_chan
      k_prog_btn_vals[kndx-1] = kval
      k_this_changed = 0
      if k_editor_sel == 2 then
        if k_prog_btn_vals[kndx-1] != k_prog_btn_prev_ch2[kndx-1] then
          k_this_changed = 1
        endif
      else
        if k_prog_btn_vals[kndx-1] != k_prog_btn_prev_ch1[kndx-1] then
          k_this_changed = 1
        endif
      endif
      if k_this_changed > 0 then
        if k_editor_sel == 2 then
          k_prog_btn_prev_ch2[kndx-1] = k_prog_btn_vals[kndx-1]
        else
          k_prog_btn_prev_ch1[kndx-1] = k_prog_btn_vals[kndx-1]
        endif
      endif
      if k_this_changed > 0 && k_ui_sync_busy < 0.5 then
        k_any_edit = 1
      endif
      if k_this_changed > 0 && k_ui_sync_busy < 0.5 && k_debug > 0.5 then
        event "i", 90, 0, 0.1, 2, kndx, kval
      endif
      kndx += 1
    od
  endif
  if k_any_edit > 0 && k_ui_sync_busy < 0.5 then
    event "i", 21, 0, .01, k_edit_step, k_editor_sel
  endif

  k_clear chnget "clearStep"
  if changed(k_clear) == 1 && k_clear > 0.5 then
    event "i", 30, 0, .01, k_edit_step_ch1, 1
    cabbageSetValue "clearStep", 0, 1
  endif

  k_clear_all chnget "clearAll"
  if changed(k_clear_all) == 1 && k_clear_all > 0.5 then
    event "i", 31, 0, .01, k_edit_step_ch1, 1
    cabbageSetValue "clearAll", 0, 1
  endif

  k2_clear chnget "ch2ClearStep"
  if changed(k2_clear) == 1 && k2_clear > 0.5 then
    event "i", 30, 0, .01, k_edit_step_ch2, 2
    cabbageSetValue "ch2ClearStep", 0, 1
  endif

  k2_clear_all chnget "ch2ClearAll"
  if changed(k2_clear_all) == 1 && k2_clear_all > 0.5 then
    event "i", 31, 0, .01, k_edit_step_ch2, 2
    cabbageSetValue "ch2ClearAll", 0, 1
  endif
endin

instr 90
  isrc = p4
  i_idx = p5
  ival = p6
  i_step chnget "ndex"
  if isrc == 1 then
    printf_i "DBG stepBtn: step=%d val=%d editStepBefore=%d\n", 1, i_idx, int(ival+0.5), i_step
  elseif isrc == 2 then
    ieditor_sel chnget "editorSel"
    if int(ieditor_sel+0.5) == 2 then
      i_prog table i_idx-1, giAllowedPrograms_ch2
    else
      i_prog table i_idx-1, giAllowedPrograms_ch1
    endif
    printf_i "DBG progBtn: editorIdx=%d prog=%d val=%d step=%d\n", 1, i_idx, i_prog, int(ival+0.5), i_step
  endif
endin

instr 3
  ktempo chnget "tempo"
  ktempo_mult chnget "tempo_mult"
  ktempo *= ktempo_mult
  kbps = ktempo/60
  ktrig metro kbps
  k_num_steps chnget "numsteps"
  k_step_modulo chnget "stepmod"
  kcount_ch1 init 0
  kcount_ch1 = (kcount_ch1+ktrig)%k_num_steps
  k_step_tick_ch1 changed kcount_ch1

  k_num_steps_ch2 chnget "ch2_numsteps"
  k_step_modulo_ch2 chnget "ch2_stepmod"
  kcount_ch2 init 0
  kcount_ch2 = (kcount_ch2+ktrig)%k_num_steps_ch2
  k_step_tick_ch2 changed kcount_ch2

  krand_mod3 chnget "rmod3"
  krand_mod5 chnget "rmod5"
  if k_step_tick_ch1 > 0 && kcount_ch1%k_step_modulo == 0 then
    kr3 random 0, 1
    if kr3 < krand_mod3 then
      cabbageSetValue "stepmod", 3, 1
    else
      kr5 random 0, 1
      if kr5 < krand_mod5 then
        cabbageSetValue "stepmod", 5, 1
      else
        cabbageSetValue "stepmod", 8, 1
      endif
    endif
  endif

  k2rand_mod3 chnget "ch2_rmod3"
  k2rand_mod5 chnget "ch2_rmod5"
  if k_step_tick_ch2 > 0 && kcount_ch2%k_step_modulo_ch2 == 0 then
    kr3b random 0, 1
    if kr3b < k2rand_mod3 then
      cabbageSetValue "ch2_stepmod", 3, 1
    else
      kr5b random 0, 1
      if kr5b < k2rand_mod5 then
        cabbageSetValue "ch2_stepmod", 5, 1
      else
        cabbageSetValue "ch2_stepmod", 8, 1
      endif
    endif
  endif

  kThis_step_ch1[] init 128
  kThis_step_ch2[] init 128
  kIsOn_ch1[] init 128
  kIsOn_ch2[] init 128
  k_any_tick = 0
  if k_step_tick_ch1 > 0 || k_step_tick_ch2 > 0 then
    k_any_tick = 1
  endif
  if k_any_tick > 0 then
    k_play_step_ch1 = (kcount_ch1%k_step_modulo)+1
    k_play_step_ch2 = (kcount_ch2%k_step_modulo_ch2)+1
    cabbageSetValue "ndex", k_play_step_ch1, 1
    cabbageSetValue "ch2_ndex", k_play_step_ch2, 1
    k_editor_sel chnget "editorSel"
    if int(k_editor_sel+0.5) == 2 then
      event "i", 20, 0, .01, k_play_step_ch2, 2
    else
      event "i", 20, 0, .01, k_play_step_ch1, 1
    endif

    chnset 1, "stepBtnSyncBusy"
    kbutn = 1
    while kbutn <= 8 do
      S_ndx_btn sprintfk "ndex_%i", kbutn
      k_edit_step_ch1 chnget "ndex"
      if kbutn == k_edit_step_ch1 then
        cabbageSetValue S_ndx_btn, 1, k_any_tick
      else
        cabbageSetValue S_ndx_btn, 0, k_any_tick
      endif
      kbutn += 1
    od
    kbutn = 1
    while kbutn <= 8 do
      S_ndx_btn2 sprintfk "ch2_ndex_%i", kbutn
      k_edit_step_ch2 chnget "ch2_ndex"
      if kbutn == k_edit_step_ch2 then
        cabbageSetValue S_ndx_btn2, 1, k_any_tick
      else
        cabbageSetValue S_ndx_btn2, 0, k_any_tick
      endif
      kbutn += 1
    od
    S_ndx_btn sprintfk "ndex_%i", k_play_step_ch1
    cabbageSetValue S_ndx_btn, 1, k_any_tick
    S_ndx_btn2 sprintfk "ch2_ndex_%i", k_play_step_ch2
    cabbageSetValue S_ndx_btn2, 1, k_any_tick
    event "i", 24, 0, .02

    reinit progtab_ch1
    progtab_ch1:
    icount = i(kcount_ch1)%i(k_step_modulo)
    iprogtable_ch1 table icount, giProg_tables_ch1
    copyf2array kThis_step_ch1, iprogtable_ch1
    rireturn

    reinit progtab_ch2
    progtab_ch2:
    icount2 = i(kcount_ch2)%i(k_step_modulo_ch2)
    iprogtable_ch2 table icount2, giProg_tables_ch2
    copyf2array kThis_step_ch2, iprogtable_ch2
    rireturn

    kdur chnget "duration"
    if kdur >= 1 then
      kndx = 0
      while kndx < 128 do
        kinstrnum_ch1 = 202+((kndx*0.001)+0.0001)
        kinstrnum_ch2 = 202+((kndx*0.001)+0.0005)
        k_out_chan chnget "outchan"
        k_out_chan_ch2 chnget "ch2_outchan"
        if kThis_step_ch1[kndx] > 0.5 && kIsOn_ch1[kndx] < 0.5 then
          event "i", kinstrnum_ch1, 0, -1, kndx, k_out_chan
          kIsOn_ch1[kndx] = 1
        elseif kThis_step_ch1[kndx] < 0.5 && kIsOn_ch1[kndx] > 0.5 then
          event "i", -kinstrnum_ch1, 0, .1, kndx, k_out_chan
          kIsOn_ch1[kndx] = 0
        endif
        if kThis_step_ch2[kndx] > 0.5 && kIsOn_ch2[kndx] < 0.5 then
          event "i", kinstrnum_ch2, 0, -1, kndx, k_out_chan_ch2
          kIsOn_ch2[kndx] = 1
        elseif kThis_step_ch2[kndx] < 0.5 && kIsOn_ch2[kndx] > 0.5 then
          event "i", -kinstrnum_ch2, 0, .1, kndx, k_out_chan_ch2
          kIsOn_ch2[kndx] = 0
        endif
        kndx += 1
      od
    else
      kndx = 0
      while kndx < 128 do
        kinstrnum_ch1 = 202+((kndx*0.001)+0.0001)
        kinstrnum_ch2 = 202+((kndx*0.001)+0.0005)
        k_out_chan chnget "outchan"
        k_out_chan_ch2 chnget "ch2_outchan"
        if kThis_step_ch1[kndx] > 0 then
          event "i", kinstrnum_ch1, 0, kdur*(1/kbps), kndx, k_out_chan
        endif
        if kThis_step_ch2[kndx] > 0 then
          event "i", kinstrnum_ch2, 0, kdur*(1/kbps), kndx, k_out_chan_ch2
        endif
        kndx += 1
      od
    endif
  endif
endin

instr 12
  k_play chnget "play"
  if changed(k_play) == 1 && k_play < 0.5 then
    k_edit_step chnget "ndex"
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn sprintfk "ndex_%i", kbtn
      if kbtn == k_edit_step then
        cabbageSetValue S_btn, 1, 1
      else
        cabbageSetValue S_btn, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif
endin

instr 10
  S_filename, k_trig cabbageGetValue "recallCombo"
  S_path = chnget:S("CSD_PATH")
  k_file_number chnget "filenumber"
  k_editor_sel chnget "editorSel"
  k_editor_sel = int(k_editor_sel)
  if k_editor_sel < 1 then
    k_editor_sel = 1
  endif
  if k_editor_sel > 2 then
    k_editor_sel = 2
  endif
  if k_trig == 1 then
    S_filename_full = sprintfk:S("%s\\%s.pre", S_path, S_filename)
    ; Load only the currently selected editor bank (8 tables) to avoid legacy 8-table file mismatch errors.
    if k_editor_sel == 2 then
      ftloadk S_filename_full, 1, 1, giPrograms_ch2_1,giPrograms_ch2_2,giPrograms_ch2_3,giPrograms_ch2_4, giPrograms_ch2_5,giPrograms_ch2_6, giPrograms_ch2_7,giPrograms_ch2_8
    else
      ftloadk S_filename_full, 1, 1, giPrograms_ch1_1,giPrograms_ch1_2,giPrograms_ch1_3,giPrograms_ch1_4, giPrograms_ch1_5,giPrograms_ch1_6, giPrograms_ch1_7,giPrograms_ch1_8
    endif
    event "i", 11, 0, .05, k_editor_sel
  endif

  k_trigger_save cabbageGetValue "triggerSave"
  if changed:k(chnget:k("triggerSave")) == 1 then
    ; Save selected editor bank to a dedicated file suffix.
    if k_editor_sel == 2 then
      S_filename = sprintfk:S("%s\\preset%i_ch2.pre", S_path, k_file_number)
      ftsavek S_filename, 1, 1, giPrograms_ch2_1,giPrograms_ch2_2,giPrograms_ch2_3,giPrograms_ch2_4, giPrograms_ch2_5,giPrograms_ch2_6, giPrograms_ch2_7,giPrograms_ch2_8
    else
      S_filename = sprintfk:S("%s\\preset%i_ch1.pre", S_path, k_file_number)
      ftsavek S_filename, 1, 1, giPrograms_ch1_1,giPrograms_ch1_2,giPrograms_ch1_3,giPrograms_ch1_4, giPrograms_ch1_5,giPrograms_ch1_6, giPrograms_ch1_7,giPrograms_ch1_8
    endif
    k_file_number += 1
    chnset k_file_number, "filenumber"
    cabbageSet 1, "recallCombo", "refreshFiles(1)"
  endif
endin

instr 11
  istep = 1
  while istep <= 8 do
    RefreshStepLabel istep, 1
    RefreshStepLabel istep, 2
    istep += 1
  od
  ieditor_sel = p4
  if ieditor_sel < 1 || ieditor_sel > 2 then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
  endif
  i_edit_step chnget "ndex"
  event_i "i", 20, 0, .01, i_edit_step, ieditor_sel
endin

instr 20
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || ieditor_sel > 2 then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
  endif
  if istep < 1 then
    istep = 1
  endif
  if istep > 8 then
    istep = 8
  endif

  chnset 1, "uiSyncBusy"

  itab = 0
  iallowed_tab = 0
  iprog_count = 0
  if ieditor_sel == 2 then
    itab table istep-1, giProg_tables_ch2
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 39
  else
    itab table istep-1, giProg_tables_ch1
    iallowed_tab = giAllowedPrograms_ch1
    iprog_count = 40
  endif

  k_once init 1
  if k_once > 0.5 then
    kndx = 0
    while kndx < iprog_count do
      kprog table kndx, iallowed_tab
      kval table kprog, itab
      if ieditor_sel == 2 then
        Sprog_chan sprintfk "ch2progSel_%i", kndx+1
      else
        Sprog_chan sprintfk "ch1progSel_%i", kndx+1
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
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || ieditor_sel > 2 then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
  endif
  if istep < 1 then
    istep = 1
  endif
  if istep > 8 then
    istep = 8
  endif

  itab = 0
  iallowed_tab = 0
  iprog_count = 0
  if ieditor_sel == 2 then
    itab table istep-1, giProg_tables_ch2
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 39
  else
    itab table istep-1, giProg_tables_ch1
    iallowed_tab = giAllowedPrograms_ch1
    iprog_count = 40
  endif

  indx = 0
  while indx < 128 do
    tableiw 0, indx, itab
    indx += 1
  od

  indx = 0
  while indx < iprog_count do
    if ieditor_sel == 2 then
      Sprog_chan sprintf "ch2progSel_%i", indx+1
    else
      Sprog_chan sprintf "ch1progSel_%i", indx+1
    endif
    ival chnget Sprog_chan
    if ival > 0.5 then
      iprog table indx, iallowed_tab
      tableiw 1, iprog, itab
    endif
    indx += 1
  od

  RefreshStepLabel istep, ieditor_sel
endin

instr 30
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || ieditor_sel > 2 then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
  endif
  if istep < 1 then
    istep = 1
  endif
  if istep > 8 then
    istep = 8
  endif

  iprog_count = 40
  if ieditor_sel == 2 then
    iprog_count = 39
  endif

  indx = 1
  while indx <= iprog_count do
    if ieditor_sel == 2 then
      Sprog_chan sprintf "ch2progSel_%i", indx
    else
      Sprog_chan sprintf "ch1progSel_%i", indx
    endif
    chnset 0, Sprog_chan
    cabbageSetValue Sprog_chan, 0, 1
    indx += 1
  od

  event_i "i", 21, 0, .01, istep, ieditor_sel
  event_i "i", 20, 0, .01, istep, ieditor_sel
endin

instr 31
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || ieditor_sel > 2 then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
  endif
  if istep < 1 then
    istep = 1
  endif
  if istep > 8 then
    istep = 8
  endif

  itab_group = 0
  if ieditor_sel == 2 then
    itab_group = giProg_tables_ch2
  else
    itab_group = giProg_tables_ch1
  endif

  istep2 = 0
  while istep2 < 8 do
    itab2 table istep2, itab_group
    indx = 0
    while indx < 128 do
      tableiw 0, indx, itab2
      indx += 1
    od
    istep2 += 1
  od

  ; Clear all steps in selected editor bank.
  ; No copy-from-source behavior anymore.

  event_i "i", 11, 0, .05, ieditor_sel
endin

instr 23
  ; Release UI sync lock after checkbox channels are updated.
  chnset 0, "uiSyncBusy"
endin

instr 24
  ; Release step-button sync lock after programmatic button updates.
  chnset 0, "stepBtnSyncBusy"
endin

instr 202
  iprog = p4
  ichan = p5
  print iprog, ichan
  iRegOffset[] fillarray 32,59,85,116,0,0,0,0
  iRuckSwitchOffset[] fillarray 72,70,74,0,0,0,0,76

  if iprog == 99 && (ichan == 1 || ichan == 2 || ichan == 3 || ichan == 8) then
    iprognum = iRuckSwitchOffset[ichan-1]
    imax_this_channel = 99
  else
    iprognum = (iprog*2)-2
    if ichan == 8 then
      imax_this_channel = 32
    else
      imax_this_channel = iRegOffset[ichan] - iRegOffset[ichan-1]
    endif
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
  else
    S_warning sprintf "prog %i out of range for chan %i", iprog, ichan
    puts S_warning, 1
  endif
endin

instr 99
  ; Dummy target for incoming MIDI note assignment.
endin

</CsInstruments>
<CsScore>
i1 0 86400
i10 0 86400
i12 0 86400

</CsScore>
</CsoundSynthesizer>
