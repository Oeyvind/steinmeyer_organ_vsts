<Cabbage>
form caption("Midi Velocity Register") size(300, 270), colour(30, 35, 40), guiMode("queue"), pluginId("mvep")

nslider bounds(5, 14, 30, 22), channel("inchan"), range(1,16,1, 1, 1), fontSize(14)
label bounds(5, 40, 30, 15), text("inchan"), fontSize(10)
texteditor bounds(65, 15, 130, 20) fontSize(16), channel("programs"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(65, 40, 130, 10), text("programs"), fontSize(10), align("left")

csoundoutput bounds(0, 70, 300, 200)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 1
massign -1, 3
pgmassign -1, -1

giPgmarray[] init 10

instr 1
  ; GUI control
  Sprograms chnget "programs"
  kprog_update changed Sprograms
  if kprog_update > 0 then
    event "i", 2, 0, .1
  endif
endin

instr 2
  ; set programs in array
  Sprograms chnget "programs"
  puts Sprograms, 1
  icomma strindex Sprograms, ","
  
  indx = 0
  while icomma > 0 do  
    Snum strsub Sprograms, 0, icomma
    iprog strtod Snum
    print iprog
    giPgmarray[indx] = iprog
    Sprograms strsub Sprograms, icomma+1, -1
    puts Sprograms, 1
    icomma strindex Sprograms, ","
    indx += 1
    if icomma == -1 then; last one
      Snum strsub Sprograms, 0, icomma
      iprog strtod Snum
      print iprog
      giPgmarray[indx] = iprog
    endif
    print indx, icomma
  od
  chnset indx+1, "num_progs"
  ;if kcomma_init > 0 then
  ;  Snum strsubk Spitches, kcomma+1, -1
  ;  if strlenk(Snum) > 0 then
  ;    Snum strcpy "-1" ; inits
  ;    kpitch strtodk Snum
  ;    gkPitches[kndx] = kpitch
  ;  endif
  ;  chnset kndx+1, "num_pitches"
  ;  cabbageSetValue "num_pitches", kndx+1
  ;endif
  printarray giPgmarray

endin

instr 3
  ; midi notes input, 
  ; set organ registers according to velocity
  
  inote notnum
  ivel veloc 0, 1
  ichn midichn
  print ichn
  inchan chnget "inchan"
  if ichn == inchan then
    inum_progs chnget "num_progs"
    iprog = giPgmarray[floor(ivel*(inum_progs+0.9))]
    instnum = 202
    event_i "i", instnum, 0, -1, iprog, inchan
    klast lastcycle
    if klast > 0 then
      event "i", -instnum, 0, .1, iprog, inchan
    endif
  endif
endin


instr 202
  ; midi  output
  iprog = p4
  ichan = p5
  print iprog
  print ichan
  iRegOffset[] fillarray 32,59,85,127,134,0,0,0, 32 ; register number offset per midi channel
  iprognum = (iprog*2)-2;+iRegOffset[ichan-1]-2
  imax_this_channel = iRegOffset[ichan] - iRegOffset[ichan-1] 
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

</CsScore>
</CsoundSynthesizer>
