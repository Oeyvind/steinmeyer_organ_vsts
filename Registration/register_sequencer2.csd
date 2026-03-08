<Cabbage>
form caption("Register Sequencer") size(1220, 550), colour(30, 35, 40), guiMode("queue"), pluginId("rsq1")

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

groupbox bounds(285, 80, 130, 430), colour(25,35,40), lineThickness("0"){
nslider bounds(5, 5, 30, 20), channel("ch3_outchan"), range(1,16,3, 1, 1), fontSize(13)
label   bounds(5, 25, 30, 15), text("outchan"), fontSize(10)
nslider bounds(40, 5, 30, 20), channel("ch3_numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(40, 25, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(75, 5, 30, 20), channel("ch3_ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(75, 25, 30, 15), text("index"), fontSize(10)

nslider bounds(5, 40, 30, 20), channel("ch3_stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(5, 60, 30, 15), text("%"), fontSize(10)
nslider bounds(40, 40, 30, 20), channel("ch3_rmod3"), range(0,1,0), fontSize(13)
label   bounds(40, 60, 30, 15), text("r%3"), fontSize(10)
nslider bounds(75, 40, 30, 20), channel("ch3_rmod5"), range(0,1,0), fontSize(13)
label   bounds(75, 60, 30, 15), text("r%5"), fontSize(10)

label bounds(5, 78, 110, 12), text("steps ch3"), fontSize(10), align("left")
button bounds(5, 92, 23, 16), text("1:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_1")
label  bounds(33, 90, 90, 18), channel("ch3_steptxt_1"), text("-"), fontSize(10), align("left")
button bounds(5, 117, 23, 16), text("2:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_2")
label  bounds(33, 115, 90, 18), channel("ch3_steptxt_2"), text("-"), fontSize(10), align("left")
button bounds(5, 142, 23, 16), text("3:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_3")
label  bounds(33, 140, 90, 18), channel("ch3_steptxt_3"), text("-"), fontSize(10), align("left")
button bounds(5, 167, 23, 16), text("4:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_4")
label  bounds(33, 165, 90, 18), channel("ch3_steptxt_4"), text("-"), fontSize(10), align("left")
button bounds(5, 192, 23, 16), text("5:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_5")
label  bounds(33, 190, 90, 18), channel("ch3_steptxt_5"), text("-"), fontSize(10), align("left")
button bounds(5, 217, 23, 16), text("6:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_6")
label  bounds(33, 215, 90, 18), channel("ch3_steptxt_6"), text("-"), fontSize(10), align("left")
button bounds(5, 242, 23, 16), text("7:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_7")
label  bounds(33, 240, 90, 18), channel("ch3_steptxt_7"), text("-"), fontSize(10), align("left")
button bounds(5, 267, 23, 16), text("8:"), colour:0("black"), colour:1("green"), channel("ch3_ndex_8")
label  bounds(33, 265, 90, 18), channel("ch3_steptxt_8"), text("-"), fontSize(10), align("left")

button bounds(5, 300, 55, 20), channel("ch3ClearStep"), text("ClrStep")
button bounds(65, 300, 55, 20), channel("ch3ClearAll"), text("ClearAll")
}

groupbox bounds(425, 80, 130, 430), colour(25,35,40), lineThickness("0"){
nslider bounds(5, 5, 30, 20), channel("ch4_outchan"), range(1,16,4, 1, 1), fontSize(13)
label   bounds(5, 25, 30, 15), text("outchan"), fontSize(10)
nslider bounds(40, 5, 30, 20), channel("ch4_numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(40, 25, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(75, 5, 30, 20), channel("ch4_ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(75, 25, 30, 15), text("index"), fontSize(10)

nslider bounds(5, 40, 30, 20), channel("ch4_stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(5, 60, 30, 15), text("%"), fontSize(10)
nslider bounds(40, 40, 30, 20), channel("ch4_rmod3"), range(0,1,0), fontSize(13)
label   bounds(40, 60, 30, 15), text("r%3"), fontSize(10)
nslider bounds(75, 40, 30, 20), channel("ch4_rmod5"), range(0,1,0), fontSize(13)
label   bounds(75, 60, 30, 15), text("r%5"), fontSize(10)

label bounds(5, 78, 110, 12), text("steps ch4"), fontSize(10), align("left")
button bounds(5, 92, 23, 16), text("1:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_1")
label  bounds(33, 90, 90, 18), channel("ch4_steptxt_1"), text("-"), fontSize(10), align("left")
button bounds(5, 117, 23, 16), text("2:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_2")
label  bounds(33, 115, 90, 18), channel("ch4_steptxt_2"), text("-"), fontSize(10), align("left")
button bounds(5, 142, 23, 16), text("3:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_3")
label  bounds(33, 140, 90, 18), channel("ch4_steptxt_3"), text("-"), fontSize(10), align("left")
button bounds(5, 167, 23, 16), text("4:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_4")
label  bounds(33, 165, 90, 18), channel("ch4_steptxt_4"), text("-"), fontSize(10), align("left")
button bounds(5, 192, 23, 16), text("5:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_5")
label  bounds(33, 190, 90, 18), channel("ch4_steptxt_5"), text("-"), fontSize(10), align("left")
button bounds(5, 217, 23, 16), text("6:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_6")
label  bounds(33, 215, 90, 18), channel("ch4_steptxt_6"), text("-"), fontSize(10), align("left")
button bounds(5, 242, 23, 16), text("7:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_7")
label  bounds(33, 240, 90, 18), channel("ch4_steptxt_7"), text("-"), fontSize(10), align("left")
button bounds(5, 267, 23, 16), text("8:"), colour:0("black"), colour:1("green"), channel("ch4_ndex_8")
label  bounds(33, 265, 90, 18), channel("ch4_steptxt_8"), text("-"), fontSize(10), align("left")

button bounds(5, 300, 55, 20), channel("ch4ClearStep"), text("ClrStep")
button bounds(65, 300, 55, 20), channel("ch4ClearAll"), text("ClearAll")
}

groupbox bounds(565, 80, 130, 430), colour(25,35,40), lineThickness("0"){
nslider bounds(5, 5, 30, 20), channel("ch8_outchan"), range(1,16,8, 1, 1), fontSize(13)
label   bounds(5, 25, 30, 15), text("outchan"), fontSize(10)
nslider bounds(40, 5, 30, 20), channel("ch8_numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(40, 25, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(75, 5, 30, 20), channel("ch8_ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(75, 25, 30, 15), text("index"), fontSize(10)

nslider bounds(5, 40, 30, 20), channel("ch8_stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(5, 60, 30, 15), text("%"), fontSize(10)
nslider bounds(40, 40, 30, 20), channel("ch8_rmod3"), range(0,1,0), fontSize(13)
label   bounds(40, 60, 30, 15), text("r%3"), fontSize(10)
nslider bounds(75, 40, 30, 20), channel("ch8_rmod5"), range(0,1,0), fontSize(13)
label   bounds(75, 60, 30, 15), text("r%5"), fontSize(10)

label bounds(5, 78, 110, 12), text("steps ch8"), fontSize(10), align("left")
button bounds(5, 92, 23, 16), text("1:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_1")
label  bounds(33, 90, 90, 18), channel("ch8_steptxt_1"), text("-"), fontSize(10), align("left")
button bounds(5, 117, 23, 16), text("2:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_2")
label  bounds(33, 115, 90, 18), channel("ch8_steptxt_2"), text("-"), fontSize(10), align("left")
button bounds(5, 142, 23, 16), text("3:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_3")
label  bounds(33, 140, 90, 18), channel("ch8_steptxt_3"), text("-"), fontSize(10), align("left")
button bounds(5, 167, 23, 16), text("4:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_4")
label  bounds(33, 165, 90, 18), channel("ch8_steptxt_4"), text("-"), fontSize(10), align("left")
button bounds(5, 192, 23, 16), text("5:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_5")
label  bounds(33, 190, 90, 18), channel("ch8_steptxt_5"), text("-"), fontSize(10), align("left")
button bounds(5, 217, 23, 16), text("6:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_6")
label  bounds(33, 215, 90, 18), channel("ch8_steptxt_6"), text("-"), fontSize(10), align("left")
button bounds(5, 242, 23, 16), text("7:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_7")
label  bounds(33, 240, 90, 18), channel("ch8_steptxt_7"), text("-"), fontSize(10), align("left")
button bounds(5, 267, 23, 16), text("8:"), colour:0("black"), colour:1("green"), channel("ch8_ndex_8")
label  bounds(33, 265, 90, 18), channel("ch8_steptxt_8"), text("-"), fontSize(10), align("left")

button bounds(5, 300, 55, 20), channel("ch8ClearStep"), text("ClrStep")
button bounds(65, 300, 55, 20), channel("ch8ClearAll"), text("ClearAll")
}

label bounds(705, 12, 70, 16), text("Edit Ch"), fontSize(10), align("left")
combobox bounds(775, 10, 120, 22), channel("editorSel"), items("Ch1","Ch2","Ch3","Ch4","Ch8"), value(1)

groupbox bounds(705, 40, 430, 188), channel("ch1EditorBox"), visible(1), colour(25,35,40), lineThickness("1"), text("Step Editor Ch1"){
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

groupbox bounds(705, 40, 430, 188), channel("ch2EditorBox"), visible(0), colour(25,35,40), lineThickness("1"), text("Step Editor Ch2/3/4/8"){
label bounds(10, 15, 330, 14), channel("chxEditorHint"), text("Programs vary by channel"), fontSize(10), align("left")

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
checkbox bounds(110, 104, 48, 18), channel("ch2progSel_27"), text("27"), colour:1(220,200,0)
checkbox bounds(160, 104, 48, 18), channel("ch2progSel_28"), text("28"), colour:1(220,200,0)
checkbox bounds(210, 104, 48, 18), channel("ch2progSel_29"), text("29"), colour:1(220,200,0)
checkbox bounds(260, 104, 48, 18), channel("ch2progSel_30"), text("30"), colour:1(220,200,0)
checkbox bounds(310, 104, 48, 18), channel("ch2progSel_31"), text("31"), colour:1(220,200,0)
checkbox bounds(360, 104, 48, 18), channel("ch2progSel_32"), text("32"), colour:1(220,200,0)

checkbox bounds(10, 127, 48, 18), channel("ch2progSel_33"), text("Ruck"), colour:1(220,200,0)
checkbox bounds(60, 127, 48, 18), channel("ch2progSel_34"), text("101"), colour:1(220,200,0)
checkbox bounds(110, 127, 48, 18), channel("ch2progSel_35"), text("102"), colour:1(220,200,0)
checkbox bounds(160, 127, 48, 18), channel("ch2progSel_36"), text("103"), colour:1(220,200,0)
checkbox bounds(210, 127, 48, 18), channel("ch2progSel_37"), text("104"), colour:1(220,200,0)
checkbox bounds(260, 127, 48, 18), channel("ch2progSel_38"), text("105"), colour:1(220,200,0)
checkbox bounds(310, 127, 48, 18), channel("ch2progSel_39"), text("106"), colour:1(220,200,0)
checkbox bounds(360, 127, 48, 18), channel("ch2progSel_40"), text("107"), colour:1(220,200,0)

checkbox bounds(10, 150, 48, 18), channel("ch2progSel_41"), text("108"), colour:1(220,200,0)
checkbox bounds(60, 150, 48, 18), channel("ch2progSel_42"), text("109"), colour:1(220,200,0)
checkbox bounds(110, 150, 48, 18), channel("ch2progSel_43"), text("110"), colour:1(220,200,0)
checkbox bounds(160, 150, 48, 18), channel("ch2progSel_44"), text("111"), colour:1(220,200,0)
checkbox bounds(210, 150, 48, 18), channel("ch2progSel_45"), text("112"), colour:1(220,200,0)
}

button bounds(705, 236, 80, 25), channel("triggerSave"), text("Save state")
combobox bounds(790, 236, 160, 25), populate("*.pre", "."), channel("recallCombo"), channelType("string")
checkbox bounds(955, 236, 90, 25), channel("allowOverwrite"), text("Overwrite"), value(0)
label bounds(705, 266, 90, 15), text("preset name"), fontSize(10), align("left")
texteditor bounds(795, 264, 155, 22), channel("presetName"), channelType("string"), text("preset_name")
label bounds(955, 266, 180, 15), channel("saveStatus"), text(""), fontSize(10), align("left")
csoundoutput bounds(705, 292, 430, 245)

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

giPrograms_ch3_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_2 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_3 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_4 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_5 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_6 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_7 ftgen 0, 0, 128, 2, 0
giPrograms_ch3_8 ftgen 0, 0, 128, 2, 0
giProg_tables_ch3 ftgen 0, 0, 8, -2, giPrograms_ch3_1, giPrograms_ch3_2, giPrograms_ch3_3, giPrograms_ch3_4, giPrograms_ch3_5, giPrograms_ch3_6, giPrograms_ch3_7, giPrograms_ch3_8

giPrograms_ch4_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_2 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_3 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_4 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_5 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_6 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_7 ftgen 0, 0, 128, 2, 0
giPrograms_ch4_8 ftgen 0, 0, 128, 2, 0
giProg_tables_ch4 ftgen 0, 0, 8, -2, giPrograms_ch4_1, giPrograms_ch4_2, giPrograms_ch4_3, giPrograms_ch4_4, giPrograms_ch4_5, giPrograms_ch4_6, giPrograms_ch4_7, giPrograms_ch4_8

giPrograms_ch5_1 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_2 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_3 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_4 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_5 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_6 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_7 ftgen 0, 0, 128, 2, 0
giPrograms_ch5_8 ftgen 0, 0, 128, 2, 0
; Bank 5 is used by visible sequencer channel 8.
giProg_tables_ch8 ftgen 0, 0, 8, -2, giPrograms_ch5_1, giPrograms_ch5_2, giPrograms_ch5_3, giPrograms_ch5_4, giPrograms_ch5_5, giPrograms_ch5_6, giPrograms_ch5_7, giPrograms_ch5_8

giAllowedPrograms_ch1 ftgen 0, 0, 40, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,99,101,102,103,104,105,106,107,108,109,110,111,112
; Shared editor slots 1..45 for non-ch1 channels.
; ch2/ch4: 1-25, (26-32 hidden), 99, 101-112.
giAllowedPrograms_ch2 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,0,99,101,102,103,104,105,106,107,108,109,110,111,112
; ch3: 1-29, (30-32 hidden), 99, 101-112.
giAllowedPrograms_ch3 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,0,0,0,99,101,102,103,104,105,106,107,108,109,110,111,112
; ch8: 1-32, 99, 101-112.
giAllowedPrograms_ch8 ftgen 0, 0, 45, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,99,101,102,103,104,105,106,107,108,109,110,111,112

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
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab table istep-1, giProg_tables_ch3
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab table istep-1, giProg_tables_ch4
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab table istep-1, giProg_tables_ch8
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
  else
    itab table istep-1, giProg_tables_ch1
    iallowed_tab = giAllowedPrograms_ch1
    iprog_count = 40
  endif
  Sprog_list = ""
  indx = 0
  while indx < iprog_count do
    iprog table indx, iallowed_tab
    if iprog > 0 && table(iprog, itab) > 0 then
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
  elseif ieditor_sel == 3 then
    S_widget sprintf "ch3_steptxt_%i", istep
  elseif ieditor_sel == 4 then
    S_widget sprintf "ch4_steptxt_%i", istep
  elseif ieditor_sel == 8 then
    S_widget sprintf "ch8_steptxt_%i", istep
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
    chnset 3, "ch3_outchan"
    chnset 4, "ch4_outchan"
    chnset 8, "ch8_outchan"
    cabbageSet "outchan", "active(0)"
    cabbageSet "ch2_outchan", "active(0)"
    cabbageSet "ch3_outchan", "active(0)"
    cabbageSet "ch4_outchan", "active(0)"
    cabbageSet "ch8_outchan", "active(0)"
    cabbageSet kstart, "ch1EditorBox", "visible(1)"
    cabbageSet kstart, "ch2EditorBox", "visible(0)"
    event "i", 11, 0, .05, 1
  endif

  k_editor_sel_raw chnget "editorSel"
  k_editor_sel = int(k_editor_sel_raw+0.5)
  if k_editor_sel < 1 then
    k_editor_sel = 1
  endif
  if k_editor_sel > 5 then
    k_editor_sel = 5
  endif

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
      cabbageSet k_editor_changed, "chxEditorHint", "text(\"Programs 1-25. Ruck disabled on Ch4\")"
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
    event "i", 11, 0, .05, k_editor_chan
  endif

  k_ui_poll metro 120

  k_step_btn_sync_busy chnget "stepBtnSyncBusy"
  k_step_btn_vals[] init 8
  k_step_btn_prev[] init 8
  k_step2_btn_vals[] init 8
  k_step2_btn_prev[] init 8
  k_step3_btn_vals[] init 8
  k_step3_btn_prev[] init 8
  k_step4_btn_vals[] init 8
  k_step4_btn_prev[] init 8
  k_step8_btn_vals[] init 8
  k_step8_btn_prev[] init 8
  if k_ui_poll > 0 then
    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep_btn sprintfk "ndex_%i", kbtn_ndx
      kstep_btn_val chnget Sstep_btn
      k_step_btn_vals[kbtn_ndx-1] = kstep_btn_val
      if k_step_btn_vals[kbtn_ndx-1] > 0.5 && k_step_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
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
        chnset 2, "editorSel"
        chnset kbtn_ndx, "ch2_ndex"
        event "i", 20, 0, .01, kbtn_ndx, 2
      endif
      k_step2_btn_prev[kbtn_ndx-1] = k_step2_btn_vals[kbtn_ndx-1]
      kbtn_ndx += 1
    od

    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep3_btn sprintfk "ch3_ndex_%i", kbtn_ndx
      kstep3_btn_val chnget Sstep3_btn
      k_step3_btn_vals[kbtn_ndx-1] = kstep3_btn_val
      if k_step3_btn_vals[kbtn_ndx-1] > 0.5 && k_step3_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
        chnset 3, "editorSel"
        chnset kbtn_ndx, "ch3_ndex"
        event "i", 20, 0, .01, kbtn_ndx, 3
      endif
      k_step3_btn_prev[kbtn_ndx-1] = k_step3_btn_vals[kbtn_ndx-1]
      kbtn_ndx += 1
    od

    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep4_btn sprintfk "ch4_ndex_%i", kbtn_ndx
      kstep4_btn_val chnget Sstep4_btn
      k_step4_btn_vals[kbtn_ndx-1] = kstep4_btn_val
      if k_step4_btn_vals[kbtn_ndx-1] > 0.5 && k_step4_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
        chnset 4, "editorSel"
        chnset kbtn_ndx, "ch4_ndex"
        event "i", 20, 0, .01, kbtn_ndx, 4
      endif
      k_step4_btn_prev[kbtn_ndx-1] = k_step4_btn_vals[kbtn_ndx-1]
      kbtn_ndx += 1
    od

    kbtn_ndx = 1
    while kbtn_ndx <= 8 do
      Sstep8_btn sprintfk "ch8_ndex_%i", kbtn_ndx
      kstep8_btn_val chnget Sstep8_btn
      k_step8_btn_vals[kbtn_ndx-1] = kstep8_btn_val
      if k_step8_btn_vals[kbtn_ndx-1] > 0.5 && k_step8_btn_prev[kbtn_ndx-1] <= 0.5 && k_step_btn_sync_busy < 0.5 then
        chnset 5, "editorSel"
        chnset kbtn_ndx, "ch8_ndex"
        event "i", 20, 0, .01, kbtn_ndx, 8
      endif
      k_step8_btn_prev[kbtn_ndx-1] = k_step8_btn_vals[kbtn_ndx-1]
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
  k_edit_step_ch3 chnget "ch3_ndex"
  k_edit_step_ch4 chnget "ch4_ndex"
  k_edit_step_ch8 chnget "ch8_ndex"
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

  k_step_changed_ch3 changed k_edit_step_ch3
  if k_step_changed_ch3 > 0 then
    event "i", 20, 0, .01, k_edit_step_ch3, 3
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn3 sprintfk "ch3_ndex_%i", kbtn
      if kbtn == k_edit_step_ch3 then
        cabbageSetValue S_btn3, 1, 1
      else
        cabbageSetValue S_btn3, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif

  k_step_changed_ch4 changed k_edit_step_ch4
  if k_step_changed_ch4 > 0 then
    event "i", 20, 0, .01, k_edit_step_ch4, 4
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn4 sprintfk "ch4_ndex_%i", kbtn
      if kbtn == k_edit_step_ch4 then
        cabbageSetValue S_btn4, 1, 1
      else
        cabbageSetValue S_btn4, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif

  k_step_changed_ch8 changed k_edit_step_ch8
  if k_step_changed_ch8 > 0 then
    event "i", 20, 0, .01, k_edit_step_ch8, 8
    chnset 1, "stepBtnSyncBusy"
    kbtn = 1
    while kbtn <= 8 do
      S_btn8 sprintfk "ch8_ndex_%i", kbtn
      if kbtn == k_edit_step_ch8 then
        cabbageSetValue S_btn8, 1, 1
      else
        cabbageSetValue S_btn8, 0, 1
      endif
      kbtn += 1
    od
    event "i", 24, 0, .02
  endif

  k_edit_step = k_edit_step_ch1
  if k_editor_chan == 2 then
    k_edit_step = k_edit_step_ch2
  elseif k_editor_chan == 3 then
    k_edit_step = k_edit_step_ch3
  elseif k_editor_chan == 4 then
    k_edit_step = k_edit_step_ch4
  elseif k_editor_chan == 8 then
    k_edit_step = k_edit_step_ch8
  endif

  k_any_edit init 0
  k_any_edit = 0
  k_ui_sync_busy chnget "uiSyncBusy"
  k_prog_btn_vals[] init 45
  k_prog_btn_prev_ch1[] init 45
  k_prog_btn_prev_ch2[] init 45
  if k_ui_poll > 0 then
    k_prog_count = 40
    if k_editor_chan != 1 then
      k_prog_count = 45
    endif
    kndx = 1
    while kndx <= k_prog_count do
      if k_editor_chan != 1 then
        Sprog_chan sprintfk "ch2progSel_%i", kndx
      else
        Sprog_chan sprintfk "ch1progSel_%i", kndx
      endif
      kval chnget Sprog_chan
      k_prog_btn_vals[kndx-1] = kval
      k_this_changed = 0
      if k_editor_chan != 1 then
        if k_prog_btn_vals[kndx-1] != k_prog_btn_prev_ch2[kndx-1] then
          k_this_changed = 1
        endif
      else
        if k_prog_btn_vals[kndx-1] != k_prog_btn_prev_ch1[kndx-1] then
          k_this_changed = 1
        endif
      endif
      if k_this_changed > 0 then
        if k_editor_chan != 1 then
          k_prog_btn_prev_ch2[kndx-1] = k_prog_btn_vals[kndx-1]
        else
          k_prog_btn_prev_ch1[kndx-1] = k_prog_btn_vals[kndx-1]
        endif
      endif
      if k_this_changed > 0 && k_ui_sync_busy < 0.5 then
        k_any_edit = 1
      endif
      kndx += 1
    od
  endif
  if k_any_edit > 0 && k_ui_sync_busy < 0.5 then
    event "i", 21, 0, .01, k_edit_step, k_editor_chan
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

  k3_clear chnget "ch3ClearStep"
  if changed(k3_clear) == 1 && k3_clear > 0.5 then
    event "i", 30, 0, .01, k_edit_step_ch3, 3
    cabbageSetValue "ch3ClearStep", 0, 1
  endif

  k3_clear_all chnget "ch3ClearAll"
  if changed(k3_clear_all) == 1 && k3_clear_all > 0.5 then
    event "i", 31, 0, .01, k_edit_step_ch3, 3
    cabbageSetValue "ch3ClearAll", 0, 1
  endif

  k4_clear chnget "ch4ClearStep"
  if changed(k4_clear) == 1 && k4_clear > 0.5 then
    event "i", 30, 0, .01, k_edit_step_ch4, 4
    cabbageSetValue "ch4ClearStep", 0, 1
  endif

  k4_clear_all chnget "ch4ClearAll"
  if changed(k4_clear_all) == 1 && k4_clear_all > 0.5 then
    event "i", 31, 0, .01, k_edit_step_ch4, 4
    cabbageSetValue "ch4ClearAll", 0, 1
  endif

  k8_clear chnget "ch8ClearStep"
  if changed(k8_clear) == 1 && k8_clear > 0.5 then
    event "i", 30, 0, .01, k_edit_step_ch8, 8
    cabbageSetValue "ch8ClearStep", 0, 1
  endif

  k8_clear_all chnget "ch8ClearAll"
  if changed(k8_clear_all) == 1 && k8_clear_all > 0.5 then
    event "i", 31, 0, .01, k_edit_step_ch8, 8
    cabbageSetValue "ch8ClearAll", 0, 1
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

  k_num_steps_ch3 chnget "ch3_numsteps"
  k_step_modulo_ch3 chnget "ch3_stepmod"
  kcount_ch3 init 0
  kcount_ch3 = (kcount_ch3+ktrig)%k_num_steps_ch3
  k_step_tick_ch3 changed kcount_ch3

  k_num_steps_ch4 chnget "ch4_numsteps"
  k_step_modulo_ch4 chnget "ch4_stepmod"
  kcount_ch4 init 0
  kcount_ch4 = (kcount_ch4+ktrig)%k_num_steps_ch4
  k_step_tick_ch4 changed kcount_ch4

  k_num_steps_ch8 chnget "ch8_numsteps"
  k_step_modulo_ch8 chnget "ch8_stepmod"
  kcount_ch8 init 0
  kcount_ch8 = (kcount_ch8+ktrig)%k_num_steps_ch8
  k_step_tick_ch8 changed kcount_ch8

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

  k3rand_mod3 chnget "ch3_rmod3"
  k3rand_mod5 chnget "ch3_rmod5"
  if k_step_tick_ch3 > 0 && kcount_ch3%k_step_modulo_ch3 == 0 then
    kr3c random 0, 1
    if kr3c < k3rand_mod3 then
      cabbageSetValue "ch3_stepmod", 3, 1
    else
      kr5c random 0, 1
      if kr5c < k3rand_mod5 then
        cabbageSetValue "ch3_stepmod", 5, 1
      else
        cabbageSetValue "ch3_stepmod", 8, 1
      endif
    endif
  endif

  k4rand_mod3 chnget "ch4_rmod3"
  k4rand_mod5 chnget "ch4_rmod5"
  if k_step_tick_ch4 > 0 && kcount_ch4%k_step_modulo_ch4 == 0 then
    kr3d random 0, 1
    if kr3d < k4rand_mod3 then
      cabbageSetValue "ch4_stepmod", 3, 1
    else
      kr5d random 0, 1
      if kr5d < k4rand_mod5 then
        cabbageSetValue "ch4_stepmod", 5, 1
      else
        cabbageSetValue "ch4_stepmod", 8, 1
      endif
    endif
  endif

  k8rand_mod3 chnget "ch8_rmod3"
  k8rand_mod5 chnget "ch8_rmod5"
  if k_step_tick_ch8 > 0 && kcount_ch8%k_step_modulo_ch8 == 0 then
    kr3e random 0, 1
    if kr3e < k8rand_mod3 then
      cabbageSetValue "ch8_stepmod", 3, 1
    else
      kr5e random 0, 1
      if kr5e < k8rand_mod5 then
        cabbageSetValue "ch8_stepmod", 5, 1
      else
        cabbageSetValue "ch8_stepmod", 8, 1
      endif
    endif
  endif

  kThis_step_ch1[] init 128
  kThis_step_ch2[] init 128
  kThis_step_ch3[] init 128
  kThis_step_ch4[] init 128
  kThis_step_ch8[] init 128
  kIsOn_ch1[] init 128
  kIsOn_ch2[] init 128
  kIsOn_ch3[] init 128
  kIsOn_ch4[] init 128
  kIsOn_ch8[] init 128
  k_any_tick = 0
  if k_step_tick_ch1 > 0 || k_step_tick_ch2 > 0 || k_step_tick_ch3 > 0 || k_step_tick_ch4 > 0 || k_step_tick_ch8 > 0 then
    k_any_tick = 1
  endif
  if k_any_tick > 0 then
    k_play_step_ch1 = (kcount_ch1%k_step_modulo)+1
    k_play_step_ch2 = (kcount_ch2%k_step_modulo_ch2)+1
    k_play_step_ch3 = (kcount_ch3%k_step_modulo_ch3)+1
    k_play_step_ch4 = (kcount_ch4%k_step_modulo_ch4)+1
    k_play_step_ch8 = (kcount_ch8%k_step_modulo_ch8)+1
    cabbageSetValue "ndex", k_play_step_ch1, 1
    cabbageSetValue "ch2_ndex", k_play_step_ch2, 1
    cabbageSetValue "ch3_ndex", k_play_step_ch3, 1
    cabbageSetValue "ch4_ndex", k_play_step_ch4, 1
    cabbageSetValue "ch8_ndex", k_play_step_ch8, 1

    k_editor_sel chnget "editorSel"
    k_editor_sel_i = int(k_editor_sel+0.5)
    if k_editor_sel_i == 2 then
      event "i", 20, 0, .01, k_play_step_ch2, 2
    elseif k_editor_sel_i == 3 then
      event "i", 20, 0, .01, k_play_step_ch3, 3
    elseif k_editor_sel_i == 4 then
      event "i", 20, 0, .01, k_play_step_ch4, 4
    elseif k_editor_sel_i == 5 then
      event "i", 20, 0, .01, k_play_step_ch8, 8
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

    kbutn = 1
    while kbutn <= 8 do
      S_ndx_btn3 sprintfk "ch3_ndex_%i", kbutn
      k_edit_step_ch3 chnget "ch3_ndex"
      if kbutn == k_edit_step_ch3 then
        cabbageSetValue S_ndx_btn3, 1, k_any_tick
      else
        cabbageSetValue S_ndx_btn3, 0, k_any_tick
      endif
      kbutn += 1
    od
    S_ndx_btn3 sprintfk "ch3_ndex_%i", k_play_step_ch3
    cabbageSetValue S_ndx_btn3, 1, k_any_tick

    kbutn = 1
    while kbutn <= 8 do
      S_ndx_btn4 sprintfk "ch4_ndex_%i", kbutn
      k_edit_step_ch4 chnget "ch4_ndex"
      if kbutn == k_edit_step_ch4 then
        cabbageSetValue S_ndx_btn4, 1, k_any_tick
      else
        cabbageSetValue S_ndx_btn4, 0, k_any_tick
      endif
      kbutn += 1
    od
    S_ndx_btn4 sprintfk "ch4_ndex_%i", k_play_step_ch4
    cabbageSetValue S_ndx_btn4, 1, k_any_tick

    kbutn = 1
    while kbutn <= 8 do
      S_ndx_btn8 sprintfk "ch8_ndex_%i", kbutn
      k_edit_step_ch8 chnget "ch8_ndex"
      if kbutn == k_edit_step_ch8 then
        cabbageSetValue S_ndx_btn8, 1, k_any_tick
      else
        cabbageSetValue S_ndx_btn8, 0, k_any_tick
      endif
      kbutn += 1
    od
    S_ndx_btn8 sprintfk "ch8_ndex_%i", k_play_step_ch8
    cabbageSetValue S_ndx_btn8, 1, k_any_tick

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

    reinit progtab_ch3
    progtab_ch3:
    icount3 = i(kcount_ch3)%i(k_step_modulo_ch3)
    iprogtable_ch3 table icount3, giProg_tables_ch3
    copyf2array kThis_step_ch3, iprogtable_ch3
    rireturn

    reinit progtab_ch4
    progtab_ch4:
    icount4 = i(kcount_ch4)%i(k_step_modulo_ch4)
    iprogtable_ch4 table icount4, giProg_tables_ch4
    copyf2array kThis_step_ch4, iprogtable_ch4
    rireturn

    reinit progtab_ch8
    progtab_ch8:
    icount8 = i(kcount_ch8)%i(k_step_modulo_ch8)
    iprogtable_ch8 table icount8, giProg_tables_ch8
    copyf2array kThis_step_ch8, iprogtable_ch8
    rireturn

    kdur chnget "duration"
    if kdur >= 1 then
      kndx = 0
      while kndx < 128 do
        kinstrnum_ch1 = 202+((kndx*0.001)+0.0001)
        kinstrnum_ch2 = 202+((kndx*0.001)+0.0003)
        kinstrnum_ch3 = 202+((kndx*0.001)+0.0005)
        kinstrnum_ch4 = 202+((kndx*0.001)+0.0007)
        kinstrnum_ch8 = 202+((kndx*0.001)+0.0009)
        k_out_chan chnget "outchan"
        k_out_chan_ch2 chnget "ch2_outchan"
        k_out_chan_ch3 chnget "ch3_outchan"
        k_out_chan_ch4 chnget "ch4_outchan"
        k_out_chan_ch8 chnget "ch8_outchan"
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
        if kThis_step_ch3[kndx] > 0.5 && kIsOn_ch3[kndx] < 0.5 then
          event "i", kinstrnum_ch3, 0, -1, kndx, k_out_chan_ch3
          kIsOn_ch3[kndx] = 1
        elseif kThis_step_ch3[kndx] < 0.5 && kIsOn_ch3[kndx] > 0.5 then
          event "i", -kinstrnum_ch3, 0, .1, kndx, k_out_chan_ch3
          kIsOn_ch3[kndx] = 0
        endif
        if kThis_step_ch4[kndx] > 0.5 && kIsOn_ch4[kndx] < 0.5 then
          event "i", kinstrnum_ch4, 0, -1, kndx, k_out_chan_ch4
          kIsOn_ch4[kndx] = 1
        elseif kThis_step_ch4[kndx] < 0.5 && kIsOn_ch4[kndx] > 0.5 then
          event "i", -kinstrnum_ch4, 0, .1, kndx, k_out_chan_ch4
          kIsOn_ch4[kndx] = 0
        endif
        if kThis_step_ch8[kndx] > 0.5 && kIsOn_ch8[kndx] < 0.5 then
          event "i", kinstrnum_ch8, 0, -1, kndx, k_out_chan_ch8
          kIsOn_ch8[kndx] = 1
        elseif kThis_step_ch8[kndx] < 0.5 && kIsOn_ch8[kndx] > 0.5 then
          event "i", -kinstrnum_ch8, 0, .1, kndx, k_out_chan_ch8
          kIsOn_ch8[kndx] = 0
        endif
        kndx += 1
      od
    else
      kndx = 0
      while kndx < 128 do
        kinstrnum_ch1 = 202+((kndx*0.001)+0.0001)
        kinstrnum_ch2 = 202+((kndx*0.001)+0.0003)
        kinstrnum_ch3 = 202+((kndx*0.001)+0.0005)
        kinstrnum_ch4 = 202+((kndx*0.001)+0.0007)
        kinstrnum_ch8 = 202+((kndx*0.001)+0.0009)
        k_out_chan chnget "outchan"
        k_out_chan_ch2 chnget "ch2_outchan"
        k_out_chan_ch3 chnget "ch3_outchan"
        k_out_chan_ch4 chnget "ch4_outchan"
        k_out_chan_ch8 chnget "ch8_outchan"
        if kThis_step_ch1[kndx] > 0 then
          event "i", kinstrnum_ch1, 0, kdur*(1/kbps), kndx, k_out_chan
        endif
        if kThis_step_ch2[kndx] > 0 then
          event "i", kinstrnum_ch2, 0, kdur*(1/kbps), kndx, k_out_chan_ch2
        endif
        if kThis_step_ch3[kndx] > 0 then
          event "i", kinstrnum_ch3, 0, kdur*(1/kbps), kndx, k_out_chan_ch3
        endif
        if kThis_step_ch4[kndx] > 0 then
          event "i", kinstrnum_ch4, 0, kdur*(1/kbps), kndx, k_out_chan_ch4
        endif
        if kThis_step_ch8[kndx] > 0 then
          event "i", kinstrnum_ch8, 0, kdur*(1/kbps), kndx, k_out_chan_ch8
        endif
        kndx += 1
      od
    endif
  endif
endin

instr 12
  k_play chnget "play"
  if changed(k_play) == 1 && k_play < 0.5 then
    chnset 1, "stepBtnSyncBusy"

    k_edit_step chnget "ndex"
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

    k_edit_step2 chnget "ch2_ndex"
    kbtn = 1
    while kbtn <= 8 do
      S_btn2 sprintfk "ch2_ndex_%i", kbtn
      if kbtn == k_edit_step2 then
        cabbageSetValue S_btn2, 1, 1
      else
        cabbageSetValue S_btn2, 0, 1
      endif
      kbtn += 1
    od

    k_edit_step3 chnget "ch3_ndex"
    kbtn = 1
    while kbtn <= 8 do
      S_btn3 sprintfk "ch3_ndex_%i", kbtn
      if kbtn == k_edit_step3 then
        cabbageSetValue S_btn3, 1, 1
      else
        cabbageSetValue S_btn3, 0, 1
      endif
      kbtn += 1
    od

    k_edit_step4 chnget "ch4_ndex"
    kbtn = 1
    while kbtn <= 8 do
      S_btn4 sprintfk "ch4_ndex_%i", kbtn
      if kbtn == k_edit_step4 then
        cabbageSetValue S_btn4, 1, 1
      else
        cabbageSetValue S_btn4, 0, 1
      endif
      kbtn += 1
    od

    k_edit_step8 chnget "ch8_ndex"
    kbtn = 1
    while kbtn <= 8 do
      S_btn8 sprintfk "ch8_ndex_%i", kbtn
      if kbtn == k_edit_step8 then
        cabbageSetValue S_btn8, 1, 1
      else
        cabbageSetValue S_btn8, 0, 1
      endif
      kbtn += 1
    od

    event "i", 24, 0, .02
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
      ; Build absolute load path in the .csd folder and enforce .pre extension.
      S_filename_full = sprintfk:S("%s\\%s.pre", S_path, S_filename)
      printf "RECALL raw='%s' load='%s' csdPath='%s'\n", k_trig, S_filename, S_filename_full, S_path
      ftloadk S_filename_full, 1, 1, giPrograms_ch1_1,giPrograms_ch1_2,giPrograms_ch1_3,giPrograms_ch1_4, giPrograms_ch1_5,giPrograms_ch1_6,giPrograms_ch1_7,giPrograms_ch1_8, giPrograms_ch2_1,giPrograms_ch2_2,giPrograms_ch2_3,giPrograms_ch2_4, giPrograms_ch2_5,giPrograms_ch2_6,giPrograms_ch2_7,giPrograms_ch2_8, giPrograms_ch3_1,giPrograms_ch3_2,giPrograms_ch3_3,giPrograms_ch3_4, giPrograms_ch3_5,giPrograms_ch3_6,giPrograms_ch3_7,giPrograms_ch3_8, giPrograms_ch4_1,giPrograms_ch4_2,giPrograms_ch4_3,giPrograms_ch4_4, giPrograms_ch4_5,giPrograms_ch4_6,giPrograms_ch4_7,giPrograms_ch4_8, giPrograms_ch5_1,giPrograms_ch5_2,giPrograms_ch5_3,giPrograms_ch5_4, giPrograms_ch5_5,giPrograms_ch5_6,giPrograms_ch5_7,giPrograms_ch5_8
      event "i", 11, 0, .05
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
    S_save_filename = sprintfk:S("%s\\%s.pre", S_path, S_preset_name)
    i_exists filevalid S_save_filename
    if i_exists > 0 && k_allow_overwrite < 0.5 then
      S_warn sprintfk "text(\"Exists: %s.pre (check Overwrite or rename)\")", S_preset_name
      cabbageSet 1, "saveStatus", S_warn
    else
      ; Global preset: all steps for all channels (future-proofed to 5 channels).
      ftsavek S_save_filename, 1, 1, giPrograms_ch1_1,giPrograms_ch1_2,giPrograms_ch1_3,giPrograms_ch1_4, giPrograms_ch1_5,giPrograms_ch1_6,giPrograms_ch1_7,giPrograms_ch1_8, giPrograms_ch2_1,giPrograms_ch2_2,giPrograms_ch2_3,giPrograms_ch2_4, giPrograms_ch2_5,giPrograms_ch2_6,giPrograms_ch2_7,giPrograms_ch2_8, giPrograms_ch3_1,giPrograms_ch3_2,giPrograms_ch3_3,giPrograms_ch3_4, giPrograms_ch3_5,giPrograms_ch3_6,giPrograms_ch3_7,giPrograms_ch3_8, giPrograms_ch4_1,giPrograms_ch4_2,giPrograms_ch4_3,giPrograms_ch4_4, giPrograms_ch4_5,giPrograms_ch4_6,giPrograms_ch4_7,giPrograms_ch4_8, giPrograms_ch5_1,giPrograms_ch5_2,giPrograms_ch5_3,giPrograms_ch5_4, giPrograms_ch5_5,giPrograms_ch5_6,giPrograms_ch5_7,giPrograms_ch5_8
      k_skip_next_recall = 1
      cabbageSet 1, "recallCombo", "refreshFiles(1)"
      S_ok sprintfk "text(\"Saved: %s.pre\")", S_preset_name
      cabbageSet 1, "saveStatus", S_ok
    endif
    cabbageSetValue "triggerSave", 0, 1
  endif
endin

instr 11
  istep = 1
  while istep <= 8 do
    RefreshStepLabel istep, 1
    RefreshStepLabel istep, 2
    RefreshStepLabel istep, 3
    RefreshStepLabel istep, 4
    RefreshStepLabel istep, 8
    istep += 1
  od
  ieditor_sel = p4
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
    if ieditor_sel == 5 then
      ieditor_sel = 8
    endif
  endif
  i_edit_step = 1
  if ieditor_sel == 2 then
    i_edit_step chnget "ch2_ndex"
  elseif ieditor_sel == 3 then
    i_edit_step chnget "ch3_ndex"
  elseif ieditor_sel == 4 then
    i_edit_step chnget "ch4_ndex"
  elseif ieditor_sel == 8 then
    i_edit_step chnget "ch8_ndex"
  else
    i_edit_step chnget "ndex"
  endif
  event_i "i", 20, 0, .01, i_edit_step, ieditor_sel
endin

instr 20
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
    if ieditor_sel == 5 then
      ieditor_sel = 8
    endif
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
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab table istep-1, giProg_tables_ch3
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab table istep-1, giProg_tables_ch4
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab table istep-1, giProg_tables_ch8
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
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
      kval = 0
      if kprog > 0 then
        kval table kprog, itab
      endif
      if ieditor_sel != 1 then
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
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
    if ieditor_sel == 5 then
      ieditor_sel = 8
    endif
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
    iprog_count = 45
  elseif ieditor_sel == 3 then
    itab table istep-1, giProg_tables_ch3
    iallowed_tab = giAllowedPrograms_ch3
    iprog_count = 45
  elseif ieditor_sel == 4 then
    itab table istep-1, giProg_tables_ch4
    iallowed_tab = giAllowedPrograms_ch2
    iprog_count = 45
  elseif ieditor_sel == 8 then
    itab table istep-1, giProg_tables_ch8
    iallowed_tab = giAllowedPrograms_ch8
    iprog_count = 45
  else
    itab table istep-1, giProg_tables_ch1
    iallowed_tab = giAllowedPrograms_ch1
    iprog_count = 40
  endif

  indx = 0
  while indx < 128 do
    tablew 0, indx, itab
    indx += 1
  od

  indx = 0
  while indx < iprog_count do
    if ieditor_sel != 1 then
      Sprog_chan sprintf "ch2progSel_%i", indx+1
    else
      Sprog_chan sprintf "ch1progSel_%i", indx+1
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

  RefreshStepLabel istep, ieditor_sel
endin

instr 30
  istep = p4
  ieditor_sel = p5
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
    if ieditor_sel == 5 then
      ieditor_sel = 8
    endif
  endif
  if istep < 1 then
    istep = 1
  endif
  if istep > 8 then
    istep = 8
  endif

  iprog_count = 40
  if ieditor_sel != 1 then
    iprog_count = 45
  endif

  indx = 1
  while indx <= iprog_count do
    if ieditor_sel != 1 then
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
  if ieditor_sel < 1 || (ieditor_sel > 4 && ieditor_sel != 8) then
    ieditor_sel chnget "editorSel"
    ieditor_sel = int(ieditor_sel+0.5)
    if ieditor_sel == 5 then
      ieditor_sel = 8
    endif
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
  elseif ieditor_sel == 3 then
    itab_group = giProg_tables_ch3
  elseif ieditor_sel == 4 then
    itab_group = giProg_tables_ch4
  elseif ieditor_sel == 8 then
    itab_group = giProg_tables_ch8
  else
    itab_group = giProg_tables_ch1
  endif

  istep2 = 0
  while istep2 < 8 do
    itab2 table istep2, itab_group
    indx = 0
    while indx < 128 do
      tablew 0, indx, itab2
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
