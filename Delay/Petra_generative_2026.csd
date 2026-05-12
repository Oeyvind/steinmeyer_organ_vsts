<Cabbage>
form caption("Petra Generative 2026") size(930, 510), colour(30, 35, 40), guiMode("queue"), pluginId("pg26")

groupbox bounds(10, 10, 360, 175), text("Midi delay")
groupbox bounds(260, 18, 100, 55), text("Global")
nslider bounds(280, 35, 60, 20), channel("global_bpm"), range(60,300,120,1,1)
label bounds(280, 55, 60, 12), text("bpm"), fontSize(10)
nslider bounds(20, 35, 30, 25), channel("inchan"), range(1,16,1, 1, 1)
label bounds(20, 60, 40, 15), text("inchan"), fontSize(11)
nslider bounds(70, 35, 60, 25), channel("bpm"), range(10,999,120,1,1)
label bounds(70, 60, 40, 15), text("bpm"), fontSize(11)
checkbox bounds(135, 35, 20, 20), channel("delay_bpm_sync"), value(0), text("")
label bounds(132, 58, 28, 12), text("sync"), fontSize(9)

nslider bounds(20, 85, 40, 25), channel("outchan"), range(1,16,2, 1, 1)
label bounds(20, 110, 40, 15), text("chan_1"), fontSize(11)
nslider bounds(70, 85, 40, 25), channel("dly_min"), range(1,32,1,1,1)
label bounds(70, 110, 40, 15), text("dly_min"), fontSize(11)
nslider bounds(120, 85, 40, 25), channel("dly_max"), range(1,32,4,1,1)
label bounds(120, 110, 40, 15), text("dly_max"), fontSize(11)
nslider bounds(170, 85, 40, 25), channel("duration"), range(0,1,1)
label bounds(170, 110, 40, 15), text("duration"), fontSize(11)
nslider bounds(220, 85, 40, 25), channel("transpose"), range(-12,12,0,1,1)
label bounds(220, 110, 40, 15), text("transp"), fontSize(11)
checkbox bounds(270, 85, 120, 25), channel("tap1_enable"), value(1), text("tap1 enable")

nslider bounds(20, 135, 40, 25), channel("outchan2"), range(1,16,3, 1, 1)
label bounds(20, 160, 40, 15), text("chan_2"), fontSize(11)
nslider bounds(70, 135, 40, 25), channel("dly2_min"), range(1,32,1,1,1)
label bounds(70, 160, 40, 15), text("dly2_mn"), fontSize(11)
nslider bounds(120, 135, 40, 25), channel("dly2_max"), range(1,32,4,1,1)
label bounds(120, 160, 40, 15), text("dly2_mx"), fontSize(11)
nslider bounds(170, 135, 40, 25), channel("duration2"), range(0,1,1)
label bounds(170, 160, 40, 15), text("dur2"), fontSize(11)
nslider bounds(220, 135, 40, 25), channel("transpose2"), range(-12,12,0,1,1)
label bounds(220, 160, 40, 15), text("trsp2"), fontSize(11)
checkbox bounds(270, 135, 120, 25), channel("tap2_enable"), value(1), text("tap2 enable")

groupbox bounds(10, 190, 570, 185), text("Gen")
button bounds(20, 215, 65, 20), channel("gen_manual_trig"), text("manual trig"), colour:0(90,90,70), colour:1(14,142,0), latched(0)
nslider bounds(90, 215, 45, 20), channel("gen_manual_nevents"), range(1,32,4,1,1), fontSize(14)
label bounds(138, 220, 32, 12), text("n-evts"), fontSize(10)
checkbox bounds(20, 245, 70, 25), channel("gen_enable"), value(0), text("auto")
combobox bounds(95, 245, 60, 25), channel("gen_inchan"), value(17), items("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","all")
label bounds(95, 270, 60, 15), text("in chan"), fontSize(11)
nslider bounds(160, 245, 65, 25), channel("note_density_meter"), range(0,20,0,1,0.01)
label bounds(160, 270, 65, 15), text("ev/s"), fontSize(11)
label bounds(235, 230, 110, 15), text("r-events  trig"), fontSize(11)
nslider bounds(230, 245, 55, 25), channel("gen_eps_min"), range(0.1,20,2,1,0.1)
label bounds(230, 270, 55, 15), text("eps_min"), fontSize(11)
nslider bounds(290, 245, 55, 25), channel("gen_eps_max"), range(0.1,20,8,1,0.1)
label bounds(290, 270, 55, 15), text("eps_max"), fontSize(11)
label bounds(350, 230, 105, 15), text("-nevents scaling-"), fontSize(11)
checkbox bounds(350, 245, 55, 25), channel("gen_scale_tempo"), value(1), text("tvar")
nslider bounds(410, 245, 45, 25), channel("gen_scale_density"), range(0,3,1,1,0.01)
label bounds(410, 270, 45, 15), text("dens"), fontSize(11)
checkbox bounds(465, 245, 45, 25), channel("gen_mono_mode"), value(0), text("mono")
nslider bounds(515, 245, 45, 25), channel("gen_bpm"), range(60,300,120,1,1)
label bounds(515, 270, 45, 15), text("bpm"), fontSize(11)
checkbox bounds(528, 225, 20, 20), channel("gen_bpm_sync"), value(0), text("")
label bounds(526, 215, 24, 12), text("sync"), fontSize(8)

nslider bounds(20, 305, 35, 25), channel("gen_outchan"), range(1,16,2,1,1)
label bounds(20, 330, 40, 15), text("chan_g"), fontSize(11)
nslider bounds(60, 305, 35, 25), channel("gen_dly_min"), range(1,32,1,1,1)
label bounds(60, 330, 35, 15), text("min"), fontSize(11)
nslider bounds(100, 305, 35, 25), channel("gen_dly_max"), range(1,32,4,1,1)
label bounds(100, 330, 35, 15), text("max"), fontSize(11)
label bounds(67, 345, 60, 15), text("-delay-"), fontSize(11)
nslider bounds(140, 305, 35, 25), channel("gen_min"), range(1,10,1,1,1)
label bounds(140, 330, 35, 15), text("min"), fontSize(11)
nslider bounds(180, 305, 35, 25), channel("gen_max"), range(1,10,4,1,1)
label bounds(180, 330, 35, 15), text("max"), fontSize(11)
nslider bounds(220, 305, 35, 25), channel("gen_max_eff"), range(1,120,4,1,1)
label bounds(220, 330, 35, 15), text("eff"), fontSize(11)
label bounds(145, 345, 70, 15), text("-nevents-"), fontSize(11)
combobox bounds(260, 305, 60, 25), channel("gen_mult"), value(2), items("slow", "medium", "fast")
label bounds(260, 330, 60, 15), text("g_mult"), fontSize(11)
combobox bounds(325, 305, 65, 25), channel("tempo_var"), value(1), items("unit", "1 and 2", "1 and 3", "1_2_3")
label bounds(325, 330, 65, 15), text("tempo_var"), fontSize(11)
button latched(1), bounds(400,305,15,15), channel("gen_dur_mode"), text(""), colour:0(90,90,70), colour:1(14,142,0), value(0)
label bounds(395,330,25,11), text("abs"), fontSize(11)
nslider bounds(420,305,45,25), channel("gen_dur_rel"), range(0.1,0.99,0.9,1,0.01), identChannel("gen_dur_rel_id")
label bounds(420,330,45,11), channel("gen_dur_rel_lbl"), text("rel dur"), fontSize(11)
nslider bounds(420,305,45,25), channel("gen_dur_abs"), range(10,500,200,1,1), identChannel("gen_dur_abs_id"), visible(0)
label bounds(420,330,45,11), channel("gen_dur_abs_lbl"), text("abs ms"), fontSize(11), visible(0)
combobox bounds(470,305,75,25), channel("gen_phrase_shape"), value(1), items("rSelect", "desc", "asc", "expand", "alt", "arc")
label bounds(470,330,75,11), text("shape"), fontSize(11)
label bounds(470,345,75,11), channel("gen_phrase_lbl"), text(""), fontSize(10)

groupbox bounds(590, 190, 325, 185), text("Ornament")

nslider bounds(850,245,55,25), channel("orn_hold_sec"), range(0.1,3.0,0.8,1,0.01)
label bounds(850,270,55,15), text("hold s"), fontSize(10)
nslider bounds(790,245,55,25), channel("orn_range"), range(0,24,4,1,1)
label bounds(790,270,55,15), text("+/-st"), fontSize(10)
nslider bounds(730,245,55,25), channel("orn_transp"), range(-12,12,0,1,1)
label bounds(730,270,55,15), text("transp"), fontSize(10)
checkbox bounds(670,245,55,25), channel("orn_enable"), value(0), text("orn")
label bounds(670,270,55,15), text("enable"), fontSize(10)
combobox bounds(610,245,55,25), channel("orn_inchan"), value(17), items("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","all")
label bounds(610,270,55,15), text("in ch"), fontSize(10)

nslider bounds(730,305,55,25), channel("orn_dur_rel"), range(0.1,1.0,1.0,1,0.01)
label bounds(730,330,55,15), text("dur rel"), fontSize(10)
combobox bounds(790,305,55,25), channel("orn_mult"), value(1), items("x1","x2","x3","x4")
label bounds(790,330,55,15), text("mult"), fontSize(10)
nslider bounds(850,305,55,25), channel("orn_bpm"), range(60,300,120,1,1)
label bounds(850,330,55,15), text("bpm"), fontSize(10)
checkbox bounds(868,345,20,20), channel("orn_bpm_sync"), value(0), text("")
label bounds(866,360,24,12), text("sync"), fontSize(8)
combobox bounds(670,305,55,25), channel("orn_mode"), value(1), items("all","high")
label bounds(670,330,55,15), text("notes"), fontSize(10)
combobox bounds(610,305,55,25), channel("orn_outchan"), value(2), items("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16")
label bounds(610,330,55,15), text("out ch"), fontSize(10)
label bounds(610,345,80,11), channel("orn_held_lbl"), text("held 0 hi -"), fontSize(10)
label bounds(695,345,80,11), channel("orn_act_lbl"), text("orn idle"), fontSize(10)

groupbox bounds(380, 10, 410, 175), text("FollowMe")
button latched(1), bounds(395,35,45,15), channel("record_enable"), text(""), colour:0(90,90,70), colour:1(14,142,0), value(0)
label bounds(395,50,45,11), text("Rec"), align("left")
combobox bounds(450,35,60,15), channel("record_chan"), items("1", "2", "3", "4", "all"), value(5)
label bounds(450,50,60,11), text("Rec chan")
button bounds(515,35,45,15), channel("clear"), text(""), colour:0(90,90,70), colour:1(14,142,0), latched(0)
label bounds(515,50,45,11), text("Clear")
nslider bounds(578,35,47,15), channel("follow_bpm"), range(60,300,120,1,1), fontSize(13)
label bounds(578,50,47,11), text("bpm")
checkbox bounds(630,35,20,15), channel("follow_bpm_sync"), value(0), text("")
label bounds(628,50,24,11), text("sync")
combobox bounds(655,35,60,15), channel("rhythmtype"), items("combo", "8th", "16th")
label bounds(655,50,55,11), text("Rhythm")
nslider bounds(720,35,50,15), channel("rmask"), range(0.0,1.0,0), fontSize(13)
label bounds(720,50,45,11), text("rmask")

button latched(1), bounds(395,75,45,15), channel("On"), text(""), colour:0(90,90,70), colour:1(14,142,0)
label bounds(395,90,45,11), text("Play"), align("left")
combobox bounds(450,75,60,15), channel("play1_chan"), items("1", "2", "3", "4", "source"), value(5)
label bounds(450,90,60,11), text("Play chan")
combobox bounds(710,75,70,15), channel("follow_event_mode"), items("use_all", "use_N_last", "N_from_M"), value(2)
label bounds(710,90,70,11), text("mode"), fontSize(9)
checkbox bounds(515,75,20,20), channel("v1_oct_up"), value(0), text("")
checkbox bounds(540,75,20,20), channel("v1_oct_down"), value(0), text("")
label bounds(515,96,20,10), text("up"), fontSize(8)
label bounds(540,96,30,10), text("down"), fontSize(8)
label bounds(565,81,40,10), text("Oct v1"), fontSize(9)

button latched(1), bounds(395,115,45,15), channel("voice2_enable"), text(""), colour:0(90,90,70), colour:1(14,142,0)
label bounds(395,130,70,11), text("Play v2"), align("left")
combobox bounds(450,115,60,15), channel("play2_chan"), items("1", "2", "3", "4", "source"), value(5)
label bounds(450,130,60,11), text("V2 chan")
button latched(1), bounds(395,150,45,15), channel("transp_enable"), text(""), colour:0(90,90,70), colour:1(14,142,0)
label bounds(395,165,60,11), text("Transp"), align("left")
combobox bounds(450,150,60,15), channel("transp_chan"), items("1", "2", "3", "4", "all"), value(5)
label bounds(450,165,60,11), text("Transp chan")
label bounds(515,150,55,15), channel("transp_amt_lbl"), text("tr +0"), fontSize(11)
label bounds(515,165,55,11), text("semis"), fontSize(10)
label bounds(575,150,50,15), channel("dur_state_lbl"), text("dur 0.50"), fontSize(11)
label bounds(575,165,50,11), text("mult"), fontSize(10)
nslider bounds(720,115,60,15), channel("use_n_last"), range(1,99,16,1,1), fontSize(13)
label bounds(720,130,65,11), channel("follow_n_lbl"), text("N")
nslider bounds(720,145,60,15), channel("use_m_from"), range(1,99,1,1,1), fontSize(13), visible(0)
label bounds(720,160,65,11), channel("follow_m_lbl"), text("M"), visible(0)
checkbox bounds(515,115,20,20), channel("v2_oct_up"), value(0), text("")
checkbox bounds(540,115,20,20), channel("v2_oct_down"), value(0), text("")
label bounds(515,136,20,10), text("up"), fontSize(8)
label bounds(540,136,30,10), text("down"), fontSize(8)
label bounds(565,121,40,10), text("Oct v2"), fontSize(9)

groupbox bounds(793, 10, 127, 175), text("Repeater")
button latched(1), bounds(803, 35, 45, 15), channel("rep_enable"), text(""), colour:0(90,90,70), colour:1(14,142,0), value(0)
label bounds(803, 52, 45, 11), text("on")
combobox bounds(853, 35, 47, 15), channel("rep_chan"), value(1), items("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","any")
label bounds(853, 52, 47, 11), text("ch")
nslider bounds(803, 72, 60, 15), channel("rep_bpm"), range(60,300,120,1,1), fontSize(13)
label bounds(803, 89, 40, 11), text("bpm")
checkbox bounds(873, 72, 20, 15), channel("rep_bpm_sync"), value(0), text("")
label bounds(871, 89, 24, 11), text("sync"), fontSize(9)
combobox bounds(803, 112, 50, 15), channel("rep_mult"), value(1), items("x1","x2","x3","x4")
label bounds(803, 129, 50, 11), text("mult")
nslider bounds(803, 149, 50, 15), channel("rep_dur_rel"), range(0.1,0.9,0.5,1,0.01), fontSize(13)
label bounds(803, 166, 50, 11), text("dur rel")
nslider bounds(858, 149, 50, 15), channel("rep_transp"), range(-24,24,0,1,1), fontSize(13)
label bounds(858, 166, 50, 11), text("transp")

csoundoutput bounds(10, 380, 900, 120)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -b-1 -B-1
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1

massign -1, 311
pgmassign -1, -1

gimaxseqlen = 99
gkNotes[][] init gimaxseqlen, 3
gknoterecindex init 0
gkseqlen init 0
gkclearflag init 0
gknoteplayindex init 0
gkrecordcount init 0
gkornHeld[] init 128
gitime = 0

; rhythm state transition matrix
giryt1 ftgen 0, 0, 4, -2, 1
giryt2 ftgen 0, 0, 4, -2, 2,2
giryt3 ftgen 0, 0, 4, -2, 4,4,2
giryt4 ftgen 0, 0, 4, -2, 2,4,4
giryt5 ftgen 0, 0, 4, -2, 2,2
giryt6 ftgen 0, 0, 4, -2, 4,4,4,4
giryt7 ftgen 0, 0, 4, -2, 2,4,4
giryt8 ftgen 0, 0, 4, -2, 4,4,2
giryt9 ftgen 0, 0, 4, -2, 3,3,3
giryt10 ftgen 0, 0, 4, -2, 1.5,3
giryt11 ftgen 0, 0, 4, -2, 2,2
giryt12 ftgen 0, 0, 8, -2, 5,5,5,5,5
giryt1to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt9,giryt10,giryt11,giryt12,giryt3,giryt4,giryt6,giryt7
giryt2to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt9,giryt10,giryt11,giryt12,giryt3,giryt4,giryt6,giryt7
giryt3to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt4to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt5to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt6to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt12,giryt6,giryt7,giryt12,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt7to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt8to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8
giryt9to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt4,giryt4,giryt6,giryt7,giryt9,giryt9,giryt9,giryt9,giryt10,giryt10,giryt10,giryt10,giryt11,giryt11
giryt10to ftgen 0, 0, 16, -2, giryt1,giryt4,giryt4,giryt4,giryt6,giryt9,giryt9,giryt9,giryt9,giryt10,giryt10,giryt10,giryt10,giryt10,giryt11,giryt11
giryt11to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt2,giryt4,giryt4,giryt9,giryt9,giryt9,giryt9,giryt10,giryt10,giryt10,giryt10,giryt11,giryt11,giryt12
giryt12to ftgen 0, 0, 16, -2, giryt1,giryt2,giryt4,giryt6,giryt1,giryt2,giryt4,giryt6,giryt1,giryt2,giryt4,giryt6,giryt1,giryt2,giryt4,giryt6
girhythms ftgen 0, 0, 16, -2, giryt1,giryt2,giryt3,giryt4,giryt5,giryt6,giryt7,giryt8,giryt9,giryt10,giryt11,giryt12,0,0,0,0
girhythmto ftgen 0, 0, 16, -2, giryt1to,giryt2to,giryt3to,giryt4to,giryt5to,giryt6to,giryt7to,giryt8to,giryt9to,giryt10to,giryt11to,giryt12to,0,0,0,0

instr 101
  chnset 0, "note_density"
  cabbageSetValue "note_density_meter", 0
  cabbageSetValue "gen_max_eff", 0
  chnset 0, "transp_state"
  chnset 0.5, "dur_state"
  chnset 0, "last_midi_event_time"
  chnset -9999, "last_phrase_select_time"
  chnset 0, "phrase_reselect_armed"
  chnset 0, "gen_phrase_sel"
  chnset 0, "gen_traj_last"
  chnset 0, "gen_phrase_serial"
  chnset -1, "orn_highest_note"
  chnset -1000, "orn_last_evt_time"
  chnset 0, "orn_evt_count"
  chnset 120, "global_bpm"
  chnset 120, "gen_bpm"
  chnset 120, "orn_bpm"
  chnset 120, "follow_bpm"
  chnset 60, "last_midi_note"
  chnset 0.7, "last_midi_vel"
  chnset 1, "last_midi_chan"
  chnset 0, "rep_enable"
  chnset 120, "rep_bpm"
  chnset 0, "rep_bpm_sync"
  chnset 0, "rep_transp"
  chnset 0, "delay_bpm_sync"
  chnset 0, "gen_bpm_sync"
  chnset 0, "orn_bpm_sync"
  chnset 0, "follow_bpm_sync"
  chnset 0, "v1_oct_up"
  chnset 0, "v1_oct_down"
  chnset 0, "v2_oct_up"
  chnset 0, "v2_oct_down"
  chnset 2, "follow_event_mode"
  chnset 1, "use_m_from"
  chnset -1, "last_count"
  iidx = 0
  while iidx < 20 do
    Sslot sprintf "evt_%d", iidx
    chnset -1000, Sslot
    iidx += 1
  od
endin

instr 301
  kenable chnget "On"
  kenable_on trigger kenable, 0.5, 0
  kenable_off trigger kenable, 0.5, 1
  igeneratorinstr = 321
  if kenable_on > 0 then
    event "i", igeneratorinstr+0.1, 0, -1, 1
    event "i", igeneratorinstr+0.2, 0, -1, 2
  endif
  if kenable_off > 0 then
    event "i", -(igeneratorinstr+0.1), 0, .1
    event "i", -(igeneratorinstr+0.2), 0, .1
  endif

  kclear chnget "clear"
  Sclear = "clear recording"
  if kclear > 0 then
    puts Sclear, gkseqlen
    gknoterecindex = 0
    gkseqlen = 0
    gkrecordcount = 0
    gkclearflag = 1
    gkrhythmindex = 0
  endif

  ktransp_enable chnget "transp_enable"
  if ktransp_enable == 0 then
    chnset 0, "transp_state"
  endif
  ktransp_state chnget "transp_state"
  kdur_state chnget "dur_state"
  ktrig_transp_lbl = changed(ktransp_state) + changed(ktransp_enable)
  if ktrig_transp_lbl > 0 then
    Stransp sprintfk "text(\"tr %+d\")", int(ktransp_state)
    cabbageSet 1, "transp_amt_lbl", Stransp
  endif
  ktrig_dur_lbl = changed(kdur_state)
  if ktrig_dur_lbl > 0 then
    Sdur sprintfk "text(\"dur %.2f\")", kdur_state
    cabbageSet 1, "dur_state_lbl", Sdur
  endif

  kgen_phrase_shape chnget "gen_phrase_shape"
  kgen_traj_last chnget "gen_traj_last"
  ktrig_phrase = changed(kgen_traj_last) + changed(kgen_phrase_shape)
  if ktrig_phrase > 0 then
    if kgen_phrase_shape > 1 then
      cabbageSet 1, "gen_phrase_lbl", "text(\"\")"
    elseif kgen_traj_last == 0 then
      cabbageSet 1, "gen_phrase_lbl", "text(\"->desc\")"
    elseif kgen_traj_last == 1 then
      cabbageSet 1, "gen_phrase_lbl", "text(\"->asc\")"
    elseif kgen_traj_last == 2 then
      cabbageSet 1, "gen_phrase_lbl", "text(\"->expand\")"
    elseif kgen_traj_last == 3 then
      cabbageSet 1, "gen_phrase_lbl", "text(\"->alt\")"
    else
      cabbageSet 1, "gen_phrase_lbl", "text(\"->arc\")"
    endif
  endif

  kgen_dur_mode chnget "gen_dur_mode"
  ktrig_dur = changed(kgen_dur_mode)
  cabbageSet ktrig_dur, "gen_dur_abs", "visible", kgen_dur_mode
  cabbageSet ktrig_dur, "gen_dur_abs_lbl", "visible", kgen_dur_mode
  cabbageSet ktrig_dur, "gen_dur_rel", "visible", 1-kgen_dur_mode
  cabbageSet ktrig_dur, "gen_dur_rel_lbl", "visible", 1-kgen_dur_mode

  kfollow_mode chnget "follow_event_mode"
  kfollow_mode_init init 1
  ktrig_follow_mode = changed(kfollow_mode) + kfollow_mode_init
  kfollow_mode_init = 0
  kshow_n = (kfollow_mode > 1 ? 1 : 0)
  kshow_m = (kfollow_mode == 3 ? 1 : 0)
  cabbageSet ktrig_follow_mode, "use_n_last", "visible", kshow_n
  cabbageSet ktrig_follow_mode, "follow_n_lbl", "visible", kshow_n
  cabbageSet ktrig_follow_mode, "use_m_from", "visible", kshow_m
  cabbageSet ktrig_follow_mode, "follow_m_lbl", "visible", kshow_m
endin

instr 303
  khigh = -1
  kheld_count = 0
  kidx = 0
  while kidx < 128 do
    if gkornHeld[kidx] > 0 then
      khigh = kidx
      kheld_count += 1
    endif
    kidx += 1
  od
  chnset khigh, "orn_highest_note"

  ktrig_held_lbl = changed(kheld_count) + changed(khigh)
  if ktrig_held_lbl > 0 then
    if khigh >= 0 then
      Sheld sprintfk "text(\"held %d hi %d\")", kheld_count, khigh
    else
      Sheld sprintfk "text(\"held %d hi -\")", kheld_count
    endif
    cabbageSet 1, "orn_held_lbl", Sheld
  endif

  korn_enable chnget "orn_enable"
  klast_evt chnget "orn_last_evt_time"
  ktime_now times
  kactive = (korn_enable > 0.5 && kheld_count > 0 && (ktime_now - klast_evt) < 0.6 ? 1 : 0)
  ktrig_act = changed(kactive) + changed(korn_enable)
  if ktrig_act > 0 then
    if korn_enable <= 0.5 then
      cabbageSet 1, "orn_act_lbl", "text(\"orn off\")"
    elseif kactive > 0 then
      cabbageSet 1, "orn_act_lbl", "text(\"orn active\")"
    else
      cabbageSet 1, "orn_act_lbl", "text(\"orn idle\")"
    endif
  endif
endin

instr 304
  ; manual gen trigger: fires one phrase with last MIDI note on button press
  ktrig_btn chnget "gen_manual_trig"
  kfire = changed(ktrig_btn) * ktrig_btn
  if kfire > 0 then
    kbpm_local chnget "gen_bpm"
    kbpm_sync chnget "gen_bpm_sync"
    kglobal_bpm chnget "global_bpm"
    kbpm = (kbpm_sync > 0.5 ? kglobal_bpm : kbpm_local)
    koutchan chnget "gen_outchan"
    klast_note chnget "last_midi_note"
    klast_vel chnget "last_midi_vel"
    kmanual_n chnget "gen_manual_nevents"
    ; mirror rSelect phrase shape randomisation from instr 302
    kphrase_shape chnget "gen_phrase_shape"
    if kphrase_shape <= 1 then
      knew_mode = int(random:k(0, 4.999))
      chnset knew_mode, "gen_phrase_sel"
      chnset knew_mode, "gen_traj_last"
    endif
    event "i", 401, 0, -1, klast_note, klast_vel, koutchan, kbpm, kmanual_n
  endif
endin

instr 305
  ; Repeater: latches last midi note on enable rising edge, repeats at set tempo
  krep_enable chnget "rep_enable"
  kenable_trig = changed(krep_enable) * krep_enable
  klatch_note init 60
  klatch_vel  init 0.7
  klatch_chan init 1
  if kenable_trig > 0 then
    klatch_note chnget "last_midi_note"
    klatch_vel  chnget "last_midi_vel"
    klatch_chan chnget "last_midi_chan"
  endif
  if krep_enable < 0.5 kgoto rep305_end
  krep_bpm_local chnget "rep_bpm"
  krep_bpm_sync  chnget "rep_bpm_sync"
  kglobal_bpm    chnget "global_bpm"
  kbpm = (krep_bpm_sync > 0.5 ? kglobal_bpm : krep_bpm_local)
  krep_mult_mode chnget "rep_mult"
  krep_mult = krep_mult_mode
  if krep_mult < 1 then
    krep_mult = 1
  endif
  krate = (kbpm * krep_mult) / 60
  if krate < 0.001 then
    krate = 0.001
  endif
  ktrig_rep metro krate
  if ktrig_rep > 0 then
    krep_dur_rel chnget "rep_dur_rel"
    kdur = (1.0 / krate) * krep_dur_rel
    krep_chan chnget "rep_chan"
    kout_chan = (krep_chan >= 17 ? klatch_chan : krep_chan)
    krep_transp chnget "rep_transp"
    kout_note = limit(klatch_note + int(krep_transp), 0, 127)
    event "i", 404, 0, kdur, kout_note, klatch_vel, int(kout_chan)
  endif
rep305_end:
endin

instr 302
  kgen_phrase_shape chnget "gen_phrase_shape"
  ktime_now times
  if kgen_phrase_shape <= 1 then
    klast_evt chnget "last_midi_event_time"
    ksilence = ktime_now - klast_evt
    ktrig_silence = trigger(ksilence, 1.0, 0)
    if ktrig_silence > 0 then
      knew_mode = int(random:k(0, 4.999))
      chnset knew_mode, "gen_phrase_sel"
      chnset knew_mode, "gen_traj_last"
      chnset ktime_now, "last_phrase_select_time"
    endif
  else
    kfixed_mode = kgen_phrase_shape - 2
    chnset kfixed_mode, "gen_phrase_sel"
    chnset kfixed_mode, "gen_traj_last"
  endif
endin

instr 311
  ; unified MIDI input: records FollowMe data and feeds delay engine
  inote notnum
  ivel01 veloc 0, 1
  ichn midichn
  inchan chnget "inchan"
  idelay_bpm_local chnget "bpm"
  idelay_bpm_sync chnget "delay_bpm_sync"
  iglobal_bpm chnget "global_bpm"
  ibpm = (idelay_bpm_sync > 0.5 ? iglobal_bpm : idelay_bpm_local)
  ioutchan chnget "outchan"
  idly_min chnget "dly_min"
  idly_max chnget "dly_max"
  idly_secs = (60.0/ibpm) * int(random(idly_min, idly_max+0.999))
  idur chnget "duration"
  itranspose chnget "transpose"
  itap1_enable chnget "tap1_enable"
  itap2_enable chnget "tap2_enable"
  ioutchan2 chnget "outchan2"
  idly2_min chnget "dly2_min"
  idly2_max chnget "dly2_max"
  idly2_delta_secs = (60.0/ibpm) * int(random(idly2_min, idly2_max+0.999))
  idly2_secs = idly_secs + idly2_delta_secs
  idur2 chnget "duration2"
  itranspose2 chnget "transpose2"
  iorn_inchan chnget "orn_inchan"
  iorn_track = (iorn_inchan == 17 || ichn == iorn_inchan ? 1 : 0)
  itransp_chan chnget "transp_chan"
  itransp_enable chnget "transp_enable"
  ihold_dur = (itransp_enable > 0.5 && (itransp_chan == 5 || ichn == itransp_chan) ? 1 : 0)
  idelay_track = (ichn == inchan && (itap1_enable > 0.5 || itap2_enable > 0.5) ? 1 : 0)
  ikeep_alive = (ihold_dur > 0 || iorn_track > 0 || idelay_track > 0 ? 1 : 0)
  xtratim 1/kr
  ktime timeinsts
  krel release
  korn_registered init 0
  if iorn_track > 0 && korn_registered == 0 then
    gkornHeld[inote] = 1
    korn_registered = 1
  endif
  if krel > 0 && korn_registered > 0 then
    gkornHeld[inote] = 0
  endif
  if krel > 0 && itransp_enable > 0.5 && (itransp_chan == 5 || ichn == itransp_chan) then
    kdur_state limit ktime, 0.1, 1
    chnset kdur_state, "dur_state"
  endif

  irecord_enable chnget "record_enable"
  ichan_select chnget "record_chan"
  iskip_record = (irecord_enable <= 0.5 || (ichan_select != 5 && ichn != ichan_select) ? 1 : 0)
  knote_on_done init 0
  if knote_on_done == 0 then
    ktime_now times
    chnset ktime_now, "last_midi_event_time"
    chnset inote, "last_midi_note"
    chnset ivel01, "last_midi_vel"
    chnset ichn, "last_midi_chan"

    if itransp_enable > 0 then
      if itransp_chan == 5 || ichn == itransp_chan then
        chnset wrap(inote%12, -5, 7), "transp_state"
      endif
    endif

    if iskip_record <= 0 then
      ithresh = 0.050
      itime times
      idelta = itime - gitime
      if idelta > ithresh then
        gitime = itime
        ichord = 0
      else
        ichord = 1
      endif
      gkNotes[gknoterecindex][0] = inote
      gkNotes[gknoterecindex][1] = ichord
      gkNotes[gknoterecindex][2] = ichn
      gkNotes[wrap(gknoterecindex+1, 0, gimaxseqlen)][1] = 0
      gkseqlen = gknoterecindex
      if gkrecordcount < gimaxseqlen then
        gkrecordcount += 1
      endif
      gknoterecindex = wrap(gknoterecindex+1, 0, gimaxseqlen)
      gkclearflag = 0
    endif

    event_i "i", 102, 0, p3, inote, ivel01, ichn
    knote_on_done = 1
  endif

  if idelay_track > 0 && ivel01 > 0 then
    kdur timeinsts
    klast lastcycle
    if itap1_enable > 0.5 then
      instnum = 201 + ((inote + itranspose) * 0.001)
      if knote_on_done == 1 then
        ; event_i only fires at init pass, so this schedules the delayed note-on once.
        event_i "i", instnum, idly_secs, -1, inote + itranspose, ivel01, ioutchan
      endif
      if klast > 0.0 then
        event "i", -instnum, idly_secs - (kdur * (1 - idur)), .1
      endif
      if itap2_enable > 0.5 then
        instnum2 = 201.5 + ((inote + itranspose2) * 0.001)
        if knote_on_done == 1 then
          event_i "i", instnum2, idly2_secs, -1, inote + itranspose2, ivel01, ioutchan2
        endif
        if klast > 0.0 then
          event "i", -instnum2, idly2_secs - (kdur * (1 - idur2)), .1
        endif
      endif
    endif
  endif

  if ikeep_alive <= 0 then
    turnoff
  endif

  korn_enable chnget "orn_enable"
  if iorn_track > 0 && krel <= 0 && korn_enable > 0.5 then
    korn_hold chnget "orn_hold_sec"
    if ktime >= korn_hold then
      korn_bpm chnget "orn_bpm"
      korn_bpm_sync chnget "orn_bpm_sync"
      kglobal_bpm chnget "global_bpm"
      if korn_bpm_sync > 0.5 then
        korn_bpm = kglobal_bpm
      endif
      korn_mult_mode chnget "orn_mult"
      korn_mult = korn_mult_mode
      if korn_mult < 1 then
        korn_mult = 1
      endif
      korn_rate = (korn_bpm * korn_mult) / 60
      if korn_rate < 0.001 then
        korn_rate = 0.001
      endif
      korn_mode chnget "orn_mode"
      if korn_mode == 2 then
        khigh chnget "orn_highest_note"
        if inote != khigh kgoto end311
      endif
      ktrig_orn metro korn_rate
      if ktrig_orn > 0 then
        korn_range chnget "orn_range"
        korn_transp chnget "orn_transp"
        korn_dur_rel chnget "orn_dur_rel"
        korn_outchan chnget "orn_outchan"
        krand int random:k(-korn_range, korn_range + 0.999)
        knote_orn limit (inote + int(korn_transp) + krand), 0, 127
        kdur_orn = (1 / korn_rate) * korn_dur_rel
        event "i", 403, 0, kdur_orn, knote_orn, ivel01, int(korn_outchan)
        klast_orn_time times
        chnset klast_orn_time, "orn_last_evt_time"
        korn_evt_count chnget "orn_evt_count"
        chnset (korn_evt_count + 1), "orn_evt_count"
      endif
    endif
  endif
end311:
endin

instr 102
  ; gen processing from unified MIDI input note-ons
  inote = p4
  ivel = p5
  ichn = p6
  igen_bpm_local chnget "gen_bpm"
  igen_bpm_sync chnget "gen_bpm_sync"
  iglobal_bpm chnget "global_bpm"
  ibpm = (igen_bpm_sync > 0.5 ? iglobal_bpm : igen_bpm_local)
  igen_inchan chnget "gen_inchan"
  if (igen_inchan == 17 || ichn == igen_inchan) && ivel > 0 then
    igen_enable chnget "gen_enable"
    igen_outchan chnget "gen_outchan"
    ieps_min chnget "gen_eps_min"
    ieps_max chnget "gen_eps_max"
    if ieps_min < 0.001 then
      ieps_min = 0.001
    endif
    if ieps_max < ieps_min then
      itemp_eps = ieps_min
      ieps_min = ieps_max
      ieps_max = itemp_eps
      if ieps_min < 0.001 then
        ieps_min = 0.001
      endif
    endif

    inow times
    ivalid_times[] init 20
    ivalid_count = 0
    iidx = 0
    while iidx < 20 do
      Sslot sprintf "evt_%d", iidx
      itime chnget Sslot
      if itime > -999 then
        if (inow - itime) <= 2.0 then
          ivalid_times[ivalid_count] = itime
          ivalid_count += 1
        endif
      endif
      iidx += 1
    od
    if ivalid_count >= 20 then
      ikeep_count = 19
      ikeep_start = ivalid_count - 19
    else
      ikeep_count = ivalid_count
      ikeep_start = 0
    endif

    iidx = 0
    while iidx < 20 do
      Sslot sprintf "evt_%d", iidx
      chnset -1000, Sslot
      iidx += 1
    od

    iwrite = 0
    while iwrite < ikeep_count do
      Sslot sprintf "evt_%d", iwrite
      chnset ivalid_times[ikeep_start+iwrite], Sslot
      iwrite += 1
    od
    Sslot sprintf "evt_%d", ikeep_count
    chnset inow, Sslot
    iwindow_count = ikeep_count + 1

    idensity = iwindow_count/2.0
    chnset idensity, "note_density"
    cabbageSetValue "note_density_meter", idensity
    if idensity >= ieps_max then
      iprob = 1
    elseif idensity >= ieps_min then
      idenom = ieps_max - ieps_min
      if idenom < 0.0001 then
        idenom = 0.0001
      endif
      iprob = 0.25 + (0.75 * ((idensity - ieps_min) / idenom))
    else
      iprob = 0
    endif
    if iprob < 0 then
      iprob = 0
    elseif iprob > 1 then
      iprob = 1
    endif

    if igen_enable > 0.5 then
      if random(0, 1) < iprob then
        event_i "i", 401, 0, -1, inote, ivel, igen_outchan, ibpm
      endif
    endif
  endif

endin

instr 201
  inote = p4
  ivel = p5 * 127
  ichan = p6
  idur = (p3 < 0 ? 999 : p3)
  noteondur ichan, inote, ivel, idur
endin

instr 321
  ivoice = p4
  if gkclearflag == 1 kgoto end
  if gkrecordcount <= 0 kgoto end

  kfollow_mode chnget "follow_event_mode"
  kuse_n_last chnget "use_n_last"
  kuse_m_from chnget "use_m_from"
  kuse_n_last = limit(kuse_n_last, 1, gimaxseqlen)
  kuse_m_from = limit(kuse_m_from, 1, gimaxseqlen)

  if kfollow_mode == 1 then
    kwindow_len = gkrecordcount
    kwindow_start = gknoterecindex - kwindow_len
    if kwindow_start < 0 then
      kwindow_start += gimaxseqlen
    endif
    kwindow_end = wrap(kwindow_start + kwindow_len - 1, 0, gimaxseqlen)
  elseif kfollow_mode == 2 then
    kwindow_len = int(kuse_n_last)
    kwindow_len = kwindow_len > gkrecordcount ? gkrecordcount : kwindow_len
    kwindow_start = gknoterecindex - kwindow_len
    if kwindow_start < 0 then
      kwindow_start += gimaxseqlen
    endif
    kwindow_end = wrap(kwindow_start + kwindow_len - 1, 0, gimaxseqlen)
  else
    kwindow_len = int(kuse_n_last)
    kwindow_len = kwindow_len > gkrecordcount ? gkrecordcount : kwindow_len
    km_offset = int(kuse_m_from) - 1
    km_max = gkrecordcount - 1
    km_offset = km_offset < 0 ? 0 : km_offset
    km_offset = km_offset > km_max ? km_max : km_offset
    kwindow_end = wrap(gknoterecindex - 1 - km_offset, 0, gimaxseqlen)
    kwindow_start = kwindow_end - kwindow_len + 1
    while kwindow_start < 0 do
      kwindow_start += gimaxseqlen
    od
  endif

  kin_window = (kwindow_start <= kwindow_end ? (gknoteplayindex >= kwindow_start && gknoteplayindex <= kwindow_end ? 1 : 0) : (gknoteplayindex >= kwindow_start || gknoteplayindex <= kwindow_end ? 1 : 0))
  if kin_window == 0 then
    gknoteplayindex = kwindow_start
  endif

  kfollow_bpm chnget "follow_bpm"
  kfollow_bpm_sync chnget "follow_bpm_sync"
  kglobal_bpm chnget "global_bpm"
    kbpm = (kfollow_bpm_sync > 0.5 ? kglobal_bpm : kfollow_bpm)
    kfollow_eff_bpm = kbpm * 0.5
    krhytmOne metro (kfollow_eff_bpm/60)
  krhythmto init table(int(random(0,11.99)), girhythmto)
  if krhytmOne > 0 then
    krhythmnum = int(random:k(0,11.99))
    krhythmtab tablekt int(random:k(0,11.99)), table(krhythmnum, girhythmto)
    krhythmindex = 0
  endif
  ksubdiv tablekt krhythmindex, krhythmtab
  ksubdiv = ksubdiv == 0 ? 1 : ksubdiv
  krhythmtype chnget "rhythmtype"
  if krhythmtype == 1 then
      krate = ksubdiv * kfollow_eff_bpm / 60
  else
      krate = (krhythmtype - 1) * 4 * kfollow_eff_bpm / 60
  endif
  ktrig metro krate

  kvoice2 chnget "voice2_enable"
  if kvoice2 == 0 && ivoice == 2 then
    kgoto end
  endif

  krmask chnget "rmask"
  ktransp_state chnget "transp_state"
  kdur_state chnget "dur_state"
  kv1_oct_up chnget "v1_oct_up"
  kv1_oct_down chnget "v1_oct_down"
  kv2_oct_up chnget "v2_oct_up"
  kv2_oct_down chnget "v2_oct_down"
  kv1_oct = (kv1_oct_up > 0.5 ? 12 : 0) + (kv1_oct_down > 0.5 ? -12 : 0)
  kv2_oct = (kv2_oct_up > 0.5 ? 12 : 0) + (kv2_oct_down > 0.5 ? -12 : 0)
  kskip init 0
  kskipnext init 0
  if ktrig == 1 then
    kin_window = (kwindow_start <= kwindow_end ? (gknoteplayindex >= kwindow_start && gknoteplayindex <= kwindow_end ? 1 : 0) : (gknoteplayindex >= kwindow_start || gknoteplayindex <= kwindow_end ? 1 : 0))
    if kin_window == 0 then
      gknoteplayindex = kwindow_start
    endif
    kvoice2_noteindex = (gknoteplayindex - 1) % gimaxseqlen
    kvoice2_in_window = (kwindow_start <= kwindow_end ? (kvoice2_noteindex >= kwindow_start && kvoice2_noteindex <= kwindow_end ? 1 : 0) : (kvoice2_noteindex >= kwindow_start || kvoice2_noteindex <= kwindow_end ? 1 : 0))
    if kvoice2_in_window == 0 then
      kvoice2_noteindex = kwindow_end
    endif
    knote = gkNotes[gknoteplayindex][0]
    knote = ivoice == 2 ? gkNotes[kvoice2_noteindex][0] - 12 + kv2_oct : knote + kv1_oct
    ksrc_chan = gkNotes[gknoteplayindex][2]
    kplay1_chan chnget "play1_chan"
    kplay2_chan chnget "play2_chan"
    kchan = ivoice == 2 ? (kplay2_chan == 5 ? ksrc_chan : kplay2_chan) : (kplay1_chan == 5 ? ksrc_chan : kplay1_chan)
    if ivoice == 1 then
      gknoteplayindex = wrap(gknoteplayindex + 1, 0, gimaxseqlen)
      kin_window = (kwindow_start <= kwindow_end ? (gknoteplayindex >= kwindow_start && gknoteplayindex <= kwindow_end ? 1 : 0) : (gknoteplayindex >= kwindow_start || gknoteplayindex <= kwindow_end ? 1 : 0))
      if kin_window == 0 then
        gknoteplayindex = kwindow_start
      endif
    endif
    krhythmindex += 1
    if knote > 0 then
      kvel = 90
      kdur = (1 / krate) * kdur_state
      kdur = kskipnext > 0 ? kdur * (1 + 4 * krmask) : kdur
      if kskip == 0 then
        if ivoice == 1 || (ivoice == 2 && kvoice2 == 1) then
          event "i", 399, 0, kdur, kvel, knote + ktransp_state, kchan
        endif
        if ivoice == 1 then
          while gkNotes[gknoteplayindex][1] > 0 do
            knote = gkNotes[limit(gknoteplayindex, 0, gimaxseqlen)][0] + kv1_oct
            ksrc_chord_chan = gkNotes[gknoteplayindex][2]
            kchan = kplay1_chan == 5 ? ksrc_chord_chan : kplay1_chan
            event "i", 399, 0, kdur, kvel, knote + ktransp_state, kchan
            gknoteplayindex = wrap(gknoteplayindex + 1, 0, gimaxseqlen)
            kin_window = (kwindow_start <= kwindow_end ? (gknoteplayindex >= kwindow_start && gknoteplayindex <= kwindow_end ? 1 : 0) : (gknoteplayindex >= kwindow_start || gknoteplayindex <= kwindow_end ? 1 : 0))
            if kin_window == 0 then
              gknoteplayindex = kwindow_start
              kgoto after_chord_loop
            endif
          od
after_chord_loop:
        endif
      endif
      kskip = kskipnext
      kskipnext = random:k(0,1) >= krmask ? 0 : 1
    endif
  endif
end:
endin

instr 399
  iamp = p4
  idB_range = 70
  ivel = pow((1 + (iamp / idB_range)), 2) * 127
  inote = p5
  ichan = p6
  idur = (p3 < 0 ? 999 : p3)
  idur = (p3 < 0.1 ? 0.1 : p3)
  noteondur ichan, inote, ivel, idur
endin

instr 401
  inote = p4
  ivel = p5
  ioutchan = p6
  ibpm_init = p7
  imanual_n = p8
  igen_min chnget "gen_min"
  igen_max chnget "gen_max"
  if igen_min > igen_max then
    itemp = igen_min
    igen_min = igen_max
    igen_max = itemp
  endif

  igen_mult_mode chnget "gen_mult"
  if igen_mult_mode == 1 then
    ibase_mult = 2
  elseif igen_mult_mode == 2 then
    ibase_mult = 4
  else
    ibase_mult = 8
  endif

  itempo_var_mode chnget "tempo_var"
  if itempo_var_mode == 1 then
    itempo_var = 1
  elseif itempo_var_mode == 2 then
    itempo_var = (int(random(0, 1.999)) == 0 ? 1 : 2)
  elseif itempo_var_mode == 3 then
    itempo_pick = int(random(0, 2.999))
    if itempo_pick == 0 then
      itempo_var = 1
    elseif itempo_pick == 1 then
      itempo_var = 1.5
    else
      itempo_var = 2
    endif
  else
    itempo_pick = int(random(0, 3.999))
    if itempo_pick == 0 then
      itempo_var = 1
    elseif itempo_pick == 1 then
      itempo_var = 1.5
    elseif itempo_pick == 2 then
      itempo_var = 2
    else
      itempo_var = 3
    endif
  endif

  igen_dly_min chnget "gen_dly_min"
  igen_dly_max chnget "gen_dly_max"
  if igen_dly_min > igen_dly_max then
    itemp2 = igen_dly_min
    igen_dly_min = igen_dly_max
    igen_dly_max = itemp2
  endif
  if imanual_n > 0 then
    igen_dly_secs = 0
  else
    igen_dly_secs = (60.0/ibpm_init) * int(random(igen_dly_min, igen_dly_max + 0.999))
  endif

  iscale_tempo chnget "gen_scale_tempo"
  if iscale_tempo > 0.5 then
    itempo_scale = itempo_var
  else
    itempo_scale = 1
  endif

  ieps_min chnget "gen_eps_min"
  ieps_max chnget "gen_eps_max"
  if ieps_min < 0.001 then
    ieps_min = 0.001
  endif
  if ieps_max < ieps_min then
    itemp_eps = ieps_min
    ieps_min = ieps_max
    ieps_max = itemp_eps
    if ieps_min < 0.001 then
      ieps_min = 0.001
    endif
  endif

  idensity chnget "note_density"
  idens_norm = (idensity - ieps_min) / (ieps_max - ieps_min + 0.0001)
  if idens_norm < 0 then
    idens_norm = 0
  elseif idens_norm > 1 then
    idens_norm = 1
  endif

  iscale_density chnget "gen_scale_density"
  idensity_scale = 1 + (iscale_density * idens_norm)
  igen_max_scaled = int((igen_max * itempo_scale * idensity_scale) + 0.999)
  if igen_max_scaled < igen_min then
    igen_max_scaled = igen_min
  endif
  cabbageSetValue "gen_max_eff", igen_max_scaled

  if imanual_n > 0 then
    igen_count = imanual_n
  else
    igen_count = int(random(igen_min, igen_max_scaled + 0.999))
  endif

  igen_dur_mode chnget "gen_dur_mode"
  igen_dur_rel chnget "gen_dur_rel"
  igen_dur_abs_ms chnget "gen_dur_abs"
  igen_phrase_shape chnget "gen_phrase_shape"
  if igen_phrase_shape <= 1 then
    itraj_mode chnget "gen_phrase_sel"
  else
    itraj_mode = igen_phrase_shape - 2
  endif
  chnset itraj_mode, "gen_traj_last"
  iexpand_dir = (int(random(0, 1.999)) == 0 ? -1 : 1)
  iexpand_base = int(random(2, 4.999))
  ialt_dir = (int(random(0, 1.999)) == 0 ? -1 : 1)
  imin_note = 36
  imax_note = 96
  iapex = int(igen_count * 0.667)
  iprev_note = inote

  igen_mono chnget "gen_mono_mode"
  iphrase_serial chnget "gen_phrase_serial"
  if igen_mono > 0.5 then
    iphrase_serial += 1
    chnset iphrase_serial, "gen_phrase_serial"
  endif

  ; build note sequence into local array at i-rate
  inotes[] init igen_count
  iidx = 0
  while iidx < igen_count do
    if iidx < 3 then
      irand_step = int(random(-1, 1.999))
      igen_note = iprev_note + irand_step
    else
      if itraj_mode == 0 then
        igen_note = iprev_note - 1
        if random(0, 1) > 0.8 then
          igen_note = igen_note - 1
        endif
      elseif itraj_mode == 1 then
        igen_note = iprev_note + 1
        if random(0, 1) > 0.8 then
          igen_note = igen_note + 1
        endif
      elseif itraj_mode == 2 then
        iint = iexpand_base + (iidx - 3)
        if random(0, 1) > 0.7 then
          iint = iint + int(random(1, 3.999))
        endif
        igen_note = iprev_note + (iint * iexpand_dir)
      elseif itraj_mode == 3 then
        ialt_step = int(random(1, 3.999))
        igen_note = iprev_note + (ialt_step * ialt_dir)
        ialt_dir = -ialt_dir
      else
        if iidx < iapex then
          igen_note = iprev_note + 2
          if random(0, 1) > 0.7 then
            igen_note = igen_note + 1
          endif
        else
          igen_note = iprev_note - 1
          if random(0, 1) > 0.8 then
            igen_note = igen_note - 1
          endif
        endif
      endif
    endif

    while igen_note < imin_note || igen_note > imax_note do
      if igen_note < imin_note then
        igen_note = imin_note + (imin_note - igen_note)
      elseif igen_note > imax_note then
        igen_note = imax_note - (igen_note - imax_note)
      endif
    od
    iprev_note = igen_note
    inotes[iidx] = igen_note
    iidx += 1
  od

  ; k-rate event firing: re-reads BPM each k-cycle so tempo changes take effect mid-phrase
  kevent_idx init 0
  knext_fire  init igen_dly_secs
  ktime timeinsts

  kgen_bpm_local chnget "gen_bpm"
  kgen_bpm_sync  chnget "gen_bpm_sync"
  kglobal_bpm    chnget "global_bpm"
  kbpm = (kgen_bpm_sync > 0.5 ? kglobal_bpm : kgen_bpm_local)
  kstep_secs = (60.0 / kbpm) / (ibase_mult * itempo_var)

  if kevent_idx < igen_count && ktime >= knext_fire then
    kfire_note = inotes[kevent_idx]
    if igen_dur_mode > 0.5 then
      kdur = igen_dur_abs_ms / 1000.0
    else
      kdur = kstep_secs * igen_dur_rel
    endif
    if igen_mono > 0.5 then
      kcurrent_serial chnget "gen_phrase_serial"
      if kcurrent_serial == iphrase_serial then
        event "i", 402, 0, kdur, kfire_note, ivel, ioutchan
      endif
    else
      event "i", 402, 0, kdur, kfire_note, ivel, ioutchan
    endif
    knext_fire = knext_fire + kstep_secs
    kevent_idx += 1
    if kevent_idx >= igen_count then
      turnoff
    endif
  endif
endin

instr 402
  inote = p4
  ivel_norm = p5
  ichan = p6
  ivel_midi = ivel_norm * 127
  idur = (p3 < 0 ? 999 : p3)
  noteondur ichan, inote, ivel_midi, idur
endin

instr 403
  inote = p4
  ivel_norm = p5
  ichan = p6
  ivel_midi = ivel_norm * 127
  idur = (p3 < 0 ? 999 : p3)
  noteondur ichan, inote, ivel_midi, idur
endin

instr 404
  inote = p4
  ivel_norm = p5
  ichan = p6
  ivel_midi = ivel_norm * 127
  idur = (p3 < 0 ? 999 : p3)
  noteondur ichan, inote, ivel_midi, idur
endin

</CsInstruments>
<CsScore>
i101 0 86400
i301 0 86400
i302 0 86400
i303 0 86400
i304 0 86400
i305 0 86400
</CsScore>
</CsoundSynthesizer>
