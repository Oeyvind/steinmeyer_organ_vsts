<Cabbage>
form caption("Register Sequencer") size(530, 300), colour(30, 35, 40), guiMode("queue"), pluginId("rsq2")

button  bounds(  5, 10, 50, 30), channel("play"), text("Play"), colour:0("black"), colour:1("green")
nslider bounds( 65, 10, 30, 20), channel("tempo"), range(30,300,1, 1, 1), fontSize(13)
label   bounds( 65, 30, 30, 15), text("tempo"), fontSize(10)
nslider bounds(135, 10, 30, 20), channel("ndex"), range(1,8,1, 1, 1), fontSize(13)
label   bounds(135, 30, 30, 15), text("index"), fontSize(10)

combobox bounds(100, 10, 35, 20), channel("tempo_mult"), items(1,2,3,4,5,6,7,8), value(0)
label    bounds(100, 30, 30, 15), text("div"), fontSize(10)

groupbox bounds(5, 80, 205, 120), colour(25,35,40), lineThickness("0"){ 
label   bounds(5, 3, 30, 15), text("numsteps"), fontSize(10)
nslider bounds(5, 18, 30, 20), channel("numsteps_ch1"), range(1,8,8, 1, 1), fontSize(14)
label    bounds(45, 3, 30, 15), text("%"), fontSize(10)
nslider  bounds(45, 18, 30, 20), channel("stepmod_ch1"), range(1,8,8, 1, 1), fontSize(13)
label    bounds(85, 3, 30, 15), text("r%3"), fontSize(10)
nslider  bounds(85, 18, 30, 20), channel("rmod3_ch1"), range(0,1,0), fontSize(13)
label    bounds(125, 3, 30, 15), text("r%5"), fontSize(10)
nslider  bounds(125, 18, 30, 20), channel("rmod5_ch1"), range(0,1,0), fontSize(13)

label   bounds(165, 3, 30, 15), text("chan"), fontSize(10)
nslider bounds(165, 18, 30, 20), channel("out_ch1"), range(1,16,1, 1, 1), fontSize(13)

label bounds(5, 40, 60, 12), text("step"), fontSize(10), align("left")
label bounds(35, 40, 60, 12), text("nump"), fontSize(10), align("left")
label bounds(70, 40, 90, 12), text("programs"), fontSize(10), align("left")

button     bounds(5, 62, 23, 16), text("1:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_ch1_1")
nslider    bounds(35, 60, 28, 20) fontSize(16), channel("numprograms_ch1_step_1"), range(1,4,1,1,1), fontSize(14)
nslider    bounds(70, 60, 28, 20) fontSize(16), channel("programs_ch1_s1_1"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(100, 60, 28, 20) fontSize(16), channel("programs_ch1_s1_2"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(130, 60, 28, 20) fontSize(16), channel("programs_ch1_s1_3"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(160, 60, 28, 20) fontSize(16), channel("programs_ch1_s1_4"), range(1,256,1,1,1), fontSize(14)

button     bounds(5, 85, 23, 16), text("2:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_ch1_2")
nslider    bounds(35, 83, 28, 20) fontSize(16), channel("numprograms_ch1_step_2"), range(1,4,1,1,1), fontSize(14)
nslider    bounds(70, 83, 28, 20) fontSize(16), channel("programs_ch1_s2_1"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(100, 83, 28, 20) fontSize(16), channel("programs_ch1_s2_2"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(130, 83, 28, 20) fontSize(16), channel("programs_ch1_s2_3"), range(1,256,1,1,1), fontSize(14)
nslider    bounds(160, 83, 28, 20) fontSize(16), channel("programs_ch1_s2_4"), range(1,256,1,1,1), fontSize(14)
}
;texteditor bounds(33, 80, 130, 20) fontSize(16), channel("programs_1"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 107, 23, 16), text("2:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_2")
;texteditor bounds(33, 105, 130, 20) fontSize(16), channel("programs_2"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 132, 23, 16), text("3:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_3")
;texteditor bounds(33, 130, 130, 20) fontSize(16), channel("programs_3"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 157, 23, 16), text("4:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_4")
;texteditor bounds(33, 155, 130, 20) fontSize(16), channel("programs_4"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 182, 23, 16), text("5:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_5")
;texteditor bounds(33, 180, 130, 20) fontSize(16), channel("programs_5"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 207, 23, 16), text("6:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_6")
;texteditor bounds(33, 205, 130, 20) fontSize(16), channel("programs_6"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 232, 23, 16), text("7:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_7")
;texteditor bounds(33, 230, 130, 20) fontSize(16), channel("programs_7"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
;button     bounds(5, 257, 23, 16), text("8:"), colour:0("black"), colour:1("green"), active(0), channel("ndex_8")
;texteditor bounds(33, 255, 130, 20) fontSize(16), channel("programs_8"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)


csoundoutput bounds(235, 0, 295, 250)

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



instr 202
  ; midi  output
  iprog = p4
  ichan = p5
  print iprog
  print ichan
  iRegOffset[] fillarray 32,59,85,127,134,0,0,0, 32 ; register number offset per midi channel
  iRuckSwitchOffset[] fillarray 74,70,72,76 ; special treatment of ruckpositiv enable switches
  if iprog >= 35 && ichan == 1 then ; ruckpos switches
    iprognum = (iprog*2)
    imax_this_channel = 99
  else
    iprognum = (iprog*2)-2
    imax_this_channel = iRegOffset[ichan] - iRegOffset[ichan-1] 
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
