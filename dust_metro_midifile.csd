<Cabbage>
form caption("Dust/metro with midi file read") size(600, 670), colour(30, 35, 40), guiMode("queue"), pluginId("dmt2")
button channel("Play"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")

groupbox bounds(5, 40, 375, 120), colour(25,35,40), lineThickness("0"){ 
rslider bounds( 5,  5, 50, 50), channel("duration"), text("Duration"), range(0,2,0.1, 0.3, 0.0001)
nslider bounds(65, 15, 30, 25), channel("base_pitch"), range(36, 72, 48, 1, 1), fontSize(17)
label bounds(65, 40, 30, 15), text("Bpitch"), , fontSize(10)
nslider bounds(115, 15, 30, 25), channel("pitch_range"), range(1,60,1, 1, 1), fontSize(17)
label bounds(115, 40, 30, 15), text("Prange"), fontSize(10)
nslider bounds(155, 15, 30, 25), channel("num_chan"), range(1,5,1, 1, 1), fontSize(17)
label bounds(155, 40, 30, 15), text("nchan"), fontSize(10)
nslider bounds(195, 15, 30, 25), channel("poly_max"), range(1,5,1, 1, 1), fontSize(17)
label bounds(195, 40, 35, 15), text("poly_max"), fontSize(10)
rslider bounds(245,  5, 50, 50), channel("poly_chance"), text("pol_rnd"), range(0,1,0.1)

rslider bounds( 5,  60, 50, 50), channel("dust_freq"), text("dust_freq"), range(0.1,10,0.5, 0.3, 0.01)
nslider bounds(65, 70, 30, 25), channel("min_dust"), range(1, 50, 10, 1, 1), fontSize(17)
label bounds(65, 95, 30, 15), text("min_dust"), , fontSize(10)
button bounds(115, 65, 70, 20), channel("dust_metro_switch"), text("dust/metro"), colour:0("black"), colour:1("green")
nslider bounds(140, 90, 30, 15), channel("switch_counter"), range(-999, 999, 0, 1, 1), fontSize(14)
nslider bounds(195, 70, 30, 25), channel("max_metro"), range(1, 50, 10, 1, 1), fontSize(17)
label bounds(195, 95, 35, 15), text("max_metro"), , fontSize(10)
rslider bounds(245,  60, 50, 50), channel("metro_freq"), text("metro_fq"), range(0.1,10,0.5, 0.3, 0.01)

button bounds(300, 40, 70, 20), channel("rand_midi_switch"), text("rand/midi"), colour:0("black"), colour:1("green")
button bounds(300, 65, 70, 20), channel("midi_oct_shift"), text("oct_shift"), colour:0("black"), colour:1("green")
button bounds(300, 90, 70, 20), channel("orig_rhythm"), text("orig_rhythm"), colour:0("black"), colour:1("green")
}

groupbox bounds(5, 170, 375, 75), colour(25,35,40), lineThickness("0"){ 
checkbox bounds(8, 10, 80, 25) channel("play"), text("Play")
checkbox bounds(8, 40, 80, 25) channel("loop"), text("Loop")
rslider bounds(95, 8, 50, 50) channel("transpose") range(-24, 24, 0, 1, 1), text("Transp")
rslider bounds(155, 8, 50, 50) channel("speed") range(0.5, 2, 1, 1, 0.001), text("Speed")
button bounds(210, 10, 60, 25) channel("reset"), text("Reset")
checkbox bounds(210, 40, 60, 25) channel("midifile_monitor"), text("Monitor")
combobox bounds(280, 10, 80, 25) channel("midifile"), items("988-aria", "Shi05M", "Beet_5th")
}
csoundoutput bounds(0, 250, 600, 420)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
massign -1, 2
pgmassign -1, -1
gkNotesActive[] init 127
gkNotesSorted[] init 127

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



instr 1
  ; GUI control
  kplay chnget "Play"
  ButtonEvent kplay, 2
endin

instr 2
  ; dust/metro auto switcher
  kcount init 0
  kdust_freq chnget "dust_freq"
  kdust dust 1, kdust_freq
  kdust = kdust > 0 ? 1 : 0
  kmetro_freq chnget "metro_freq"
  kmetro metro kmetro_freq
  
  kmin_dust chnget "min_dust"
  kmax_metro chnget "max_metro"
  kcount_switch init 0
  ktrig init 0
  ktrig_switch init 0
  if ktrig_switch == 0 then
    ktrig = kdust
  else  
    ktrig = kmetro
  endif
  if changed(ktrig_switch) > 0 then
    kcount_switch = ktrig_switch == 0 ? -kmin_dust : -kmax_metro
  endif
  kcount_switch += ktrig
  cabbageSet changed(kcount_switch), "switch_counter", "value", kcount_switch
  if kcount_switch > 0 then
    if ktrig > 0 then
      krandswitch random 0, 1
      krand_thresh = 0.8
      if krandswitch < krand_thresh then
        ktrig_switch = (ktrig_switch+1)%2
        cabbageSet 1, "dust_metro_switch", "value", ktrig_switch
      endif
    endif
  endif
  kpitch rnd31 1, 1
  kpitch_range chnget "pitch_range"
  kbase_pitch chnget "base_pitch"
  kpoly_max_ chnget "poly_max"
  kpoly_chance chnget "poly_chance"
  korig_rhythm chnget "orig_rhythm"
  krand_midi chnget "rand_midi_switch"
  korig_rhythm *= krand_midi ; only active when using midi recorded pitches 
  kmidi_oct_shift chnget "midi_oct_shift"
  if korig_rhythm > 0 then
    ktrig changed2 gkNotesSorted
  endif
  if ktrig > 0 then
    kcount += 1
    kvel = 90
    kdur chnget "duration"
    kpoly_count = 0
    klen = 0
    while gkNotesSorted[klen] > 0 do
      klen += 1
    od
    if korig_rhythm > 0 then
      kpoly_max limit kpoly_max_, 1, klen
    else  
      kpoly_max = kpoly_max_
    endif
    while kpoly_count < kpoly_max do
      kpitch random 0, 1
      krandnote = int(kpitch*kpitch_range)+kbase_pitch
      koct = floor(krandnote/12)
      if krand_midi == 0 then
        knote = krandnote
      elseif korig_rhythm > 0 then ; keep original rhythm, play them in order
        knote = gkNotesSorted[kpoly_count]
        if kmidi_oct_shift > 0 then
          koct_shift = koct-floor(knote/12)
          knote += (koct_shift*12)
        endif
      else ; follow midi, but select randomly from available midi guide notes
        knote = gkNotesSorted[floor(random(0,klen-0.01))]
        if kmidi_oct_shift > 0 then
          koct_shift = koct-floor(knote/12)
          knote += (koct_shift*12)
        endif
      endif
      iChannels[] fillarray 1,2,3,4,8 ; Steinmeyer
      knum_chan chnget "num_chan"
      kchan = floor(random:k(0,knum_chan))
      kchan = iChannels[kchan]
      event "i", 201, 0, kdur, knote, kvel, kchan
      kpoly_count += 1+(random:k(0,divz(1,kpoly_chance,1))+(kpoly_count*0.25))
    od
  endif
endin

instr 3
  kfile chnget "midifile"
  kfile limit kfile, 1, 99
  printk2 kfile
  Sfiles[] fillarray "988-aria_type0.mid", "Shi05M_type0.mid", "Beet_5th_type0.mid"
  SCsdPath chnget "CSD_PATH"
  if changed(kfile) > 0 then
    event "i", -4, 0, .1
    Sfile = Sfiles[kfile-1]
    Smidifile sprintfk "%s/%s", SCsdPath, Sfile
    Scoreline sprintfk {{i4 0 -1 "%s"}}, Smidifile
    scoreline Scoreline, 1
  endif

endin

instr 4
  Smidifile = p4
  puts Smidifile, 1
  cabbageMidiFileInfo Smidifile
  kEventIndex = 0
  kRes, kResetTrigger cabbageGetValue "reset"
  if kResetTrigger > 0 then
    gkNotesActive *= 0
    gkNotesSorted *= 0
    ktest sumarray gkNotesActive
    printk2 ktest
  endif
  kStatus[], kChan[], kNote[], kVel[], kNumEvents, kTrig cabbageMidiFileReader Smidifile, 0, cabbageGetValue("play"), cabbageGetValue("loop"), cabbageGetValue("speed"), kResetTrigger, 0
  //printing this many events can have a serious impact on performance..
  //printk2 kNumEvents
  imidiout_instr = 200
  imonitorout_instr = 201
  kmonitor chnget "midifile_monitor"
  if kTrig == 1 then
      while kEventIndex < kNumEvents do
            if (kStatus[kEventIndex] == 128 || kVel[kEventIndex] == 0) then            //note off
                kfrac_instr = kNote[kEventIndex]*0.001
                turnoff2 imidiout_instr, 1, 1
                turnoff2 imonitorout_instr, 1, 1
            elseif (kStatus[kEventIndex] == 144) then        //note on 
                kfrac_instr = kNote[kEventIndex]*0.001    
                event "i", imidiout_instr, 0, 10, kNote[kEventIndex]+cabbageGetValue:k("transpose"), kVel[kEventIndex]
                if kmonitor > 0 then
                  event "i", imonitorout_instr, 0, 10, kNote[kEventIndex]+cabbageGetValue:k("transpose"), kVel[kEventIndex]       
                endif
            endif
          kEventIndex += 1
      od
  endif
endin

instr 200
  ; midi to global array
  inote = p4
  itime times
  ;print inote, itime
  kfirst init 1
  if kfirst > 0 then
    gkNotesActive[inote] = inote
    gkNotesSorted[] sortd gkNotesActive
    kfirst = 0
  endif
  
  klast lastcycle
  if klast > 0 then
    gkNotesActive[inote] = 0
    ktime times
    gkNotesSorted[] sortd gkNotesActive
    klen = 0
    while gkNotesSorted[klen] > 0 do
      klen += 1
    od
  endif
endin

instr 201
  ; midi  output
  inote = p4
  ivel = p5;*127
  ichan = p6
  print inote, ichan
  ;print p3
  noteondur ichan, inote, ivel, p3
endin

</CsInstruments>
<CsScore>
i1 0 86400
i3 0 -1 ; midi file selector

</CsScore>
</CsoundSynthesizer>
