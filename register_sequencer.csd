<Cabbage>
form caption("Register Sequencer") size(500, 300), colour(30, 35, 40), guiMode("queue"), pluginId("rsq1")

button  bounds(  5, 10, 50, 30), channel("play"), text("Play"), colour:0("black"), colour:1("green")
nslider bounds( 65, 10, 30, 20), channel("tempo"), range(30,300,1, 1, 1), fontSize(13)
label   bounds( 65, 30, 30, 15), text("tempo"), fontSize(10)
nslider bounds(100, 10, 30, 20), channel("numsteps"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(100, 30, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(135, 10, 30, 20), channel("ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(135, 30, 30, 15), text("index"), fontSize(10)
nslider bounds(170, 10, 30, 20), channel("outchan"), range(1,16,1, 1, 1), fontSize(13)
label   bounds(170, 30, 30, 15), text("outchan"), fontSize(10)

combobox bounds( 60, 45, 35, 20), channel("tempo_mult"), items(1,2,3,4,5,6,7,8), value(0)
nslider bounds(100, 45, 30, 20), channel("stepmod"), range(1,8,8, 1, 1), fontSize(13)
label   bounds(100, 65, 30, 15), text("%"), fontSize(10)

label bounds(5, 65, 130, 12), text("programs"), fontSize(10), align("left")
button     bounds(5, 82, 23, 16), text("1:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_1")
texteditor bounds(33, 80, 130, 20) fontSize(16), channel("programs_1"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 107, 23, 16), text("2:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_2")
texteditor bounds(33, 105, 130, 20) fontSize(16), channel("programs_2"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 132, 23, 16), text("3:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_3")
texteditor bounds(33, 130, 130, 20) fontSize(16), channel("programs_3"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 157, 23, 16), text("4:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_4")
texteditor bounds(33, 155, 130, 20) fontSize(16), channel("programs_4"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 182, 23, 16), text("5:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_5")
texteditor bounds(33, 180, 130, 20) fontSize(16), channel("programs_5"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 207, 23, 16), text("6:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_6")
texteditor bounds(33, 205, 130, 20) fontSize(16), channel("programs_6"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 232, 23, 16), text("7:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_7")
texteditor bounds(33, 230, 130, 20) fontSize(16), channel("programs_7"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
button     bounds(5, 257, 23, 16), text("8:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_8")
texteditor bounds(33, 255, 130, 20) fontSize(16), channel("programs_8"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)


csoundoutput bounds(205, 0, 295, 250)
button bounds(205, 255, 80, 25), channel("triggerSave"), text("Save state")
combobox bounds(290, 255, 200, 25), populate("*.pre", "."), channel("recallCombo"), channelType("string")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 1
massign -1, 2
pgmassign -1, -1

giPrograms_1 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_2 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_3 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_4 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_5 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_6 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_7 ftgen 0, 0, 128, 2, 0 ; empty
giPrograms_8 ftgen 0, 0, 128, 2, 0 ; empty
giProg_tables ftgen 0, 0, 8, -2, giPrograms_1, giPrograms_2, giPrograms_3, giPrograms_4, giPrograms_5, giPrograms_6, giPrograms_7, giPrograms_8
giPrograms_empty ftgen 0, 0, 128, 2, 0 ; empty


opcode ProgTextTrig, 0, i
  indx xin 
  Schn sprintf "programs_%i", indx
  Sprograms chnget Schn
  kprog_update changed Sprograms
  if kprog_update > 0 then
    Scoreline sprintfk {{i 2 0 .1 %i "%s"}}, indx, Sprograms
    scoreline Scoreline, 1
  endif
endop

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
  ProgTextTrig 1
  ProgTextTrig 2
  ProgTextTrig 3
  ProgTextTrig 4
  ProgTextTrig 5
  ProgTextTrig 6
  ProgTextTrig 7
  ProgTextTrig 8

  kplay chnget "play"
  ButtonEvent kplay, 3
  kplay_off trigger kplay, 0.5, 1
  if kplay_off > 0 then
    turnoff2 202, 0, 1
  endif

endin

instr 2
  iseq_ndx = p4
  Sprograms = p5
  print iseq_ndx
  puts Sprograms, 1
  iprogtable table iseq_ndx-1, giProg_tables
  indx = 0
  while indx < 128 do
    tablew 0, indx, iprogtable ; clear (tablecopy could not be used as it seemds to do the work at the end of the init cycle)
    indx += 1
  od
  icomma strindex Sprograms, ","  
  indx = 0
  while icomma > 0 do  
    Snum strsub Sprograms, 0, icomma
    iprog strtod Snum
    tablew 1, iprog, iprogtable ; write a 1 to the prog position in the table
    Sprograms strsub Sprograms, icomma+1, -1
    icomma strindex Sprograms, ","
    indx += 1
  od
  Snum strsub Sprograms, 0, icomma ; last one, or if no comma
  iprog strtod Snum
  tablew 1, iprog, iprogtable ; write a 1 to the prog position in the table
endin

instr 3
  koutchan chnget "outchan"
  ktempo chnget "tempo" ; bpm
  ktempo_mult chnget "tempo_mult"
  ktempo *= ktempo_mult
  kbps = ktempo/60
  ktrig metro kbps
  knumsteps chnget "numsteps"
  kstepmodulo chnget "stepmod"
  kcount init 0
  kcount = (kcount+ktrig)%knumsteps
  cabbageSetValue "ndex", kcount+1, changed(kcount)
  kThis_step[] init 128
  kLast_step[] init 128
  if changed(kcount) > 0 then
    kbutn = 0
    while kbutn <= 8 do
      Sndx_butn sprintfk "ndex_%i", kbutn
      cabbageSetValue Sndx_butn, 0, changed(kbutn)
      kbutn += 1
    od 
    Sndx_butn sprintfk "ndex_%i", (kcount%kstepmodulo)+1
    cabbageSetValue Sndx_butn, 1, changed(kcount)
    ; check if prog has changed since last count
    reinit progtab
    progtab:
    icount = i(kcount)%i(kstepmodulo)
    print icount
    iprogtable table icount, giProg_tables
    copyf2array kThis_step, iprogtable
    rireturn
    kProg_update[] = kThis_step-kLast_step
    kLast_step = kThis_step
    ; send prog for those who has been updated
    kndx = 0
    while kndx < 128 do
      kinstrnum = 202+(kndx*0.001)
      if kProg_update[kndx] > 0 then
        event "i", kinstrnum, 0, -1, kndx, koutchan 
      elseif kProg_update[kndx] < 0 then
        event "i", -kinstrnum, 0, .1, kndx, koutchan 
      endif
      kndx += 1
    od
  endif

endin


instr 10
  SFilename, kTrig cabbageGetValue "recallCombo"
  SPath = chnget:S("CSD_PATH")
  kFileNumber chnget "filenumber"
  if kTrig == 1 then
    SIgnoreChannels[] init 3
    SIgnoreChannels[0] = "triggerSave"
    SIgnoreChannels[1] = "recallCombo"
    SIgnoreChannels[2] = "ndex"
    SFilenam = sprintfk:S("%s\\%s.pre", SPath, SFilename)
    kOk = cabbageChannelStateRecall:k(SFilenam, SIgnoreChannels)
    Stest sprintfk "test %s", "9,10";cabbageGetValue:k("programs_2")
    cabbageSet 1, "programs_2", "text(\"hello world\")"
  endif
  if changed:k(chnget:k("triggerSave")) == 1 then
    SFilename = sprintfk:S("%s\\PresetTest%d.pre", SPath, kFileNumber)
    printks "%s", 0, SFilename
    kOk = cabbageChannelStateSave:k(SFilename)
    kFileNumber+=1
    chnset kFileNumber, "filenumber"
    cabbageSet 1, "recallCombo", "refreshFiles(1)" 
  endif
endin

instr 202
  ; midi  output
  iprog = p4
  ichan = p5
  print iprog
  print ichan
  iRegOffset[] fillarray  32,59,85,116,0,0,0,0 ; register number offset per midi channel
  iRuckSwitchOffset[] fillarray 72,70,74,0,0,0,0,76 ; special treatment of ruckpositiv enable switches

  if iprog == 99 && (ichan == 1 || ichan == 2 || ichan == 3 || ichan == 8) then ; ruckpos switch
    iprognum = iRuckSwitchOffset[ichan-1] 
    print iprognum
    imax_this_channel = 99
  else
    iprognum = (iprog*2)-2 ; regular progs
    if ichan == 8 then
      imax_this_channel = 32
    else
      imax_this_channel = iRegOffset[ichan] - iRegOffset[ichan-1] 
    endif
  endif

  ; ruckpos registration should send prog change on ch 4, regardless of which manual is coupled to the ruckpos
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
    Swarning sprintf "prog %i out of range for chan %i", iprog, ichan
    puts Swarning, 1
  endif
endin

</CsInstruments>
<CsScore>
i1 0 86400
i10 0 86400

</CsScore>
</CsoundSynthesizer>
