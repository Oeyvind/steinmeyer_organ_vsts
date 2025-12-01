
<CsoundSynthesizer>
<CsOptions>
;-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
gkNotesActive[] init 10
gkNotesSorted[] init 10



instr 200
  ; midi to global array
  inote = p4
  print inote
  gkNotesActive[inote] = inote
  gkNotesSorted[] sortd gkNotesActive
    klen = 0
    while gkNotesSorted[klen] > 0 do
      klen += 1
    od
    printk2 klen
  
  klast lastcycle
  if klast > 0 then
    printarray gkNotesActive
    gkNotesActive[inote] = 0
    gkNotesSorted[] sortd gkNotesActive
    kTest[] slicearray gkNotesSorted, 0, 5
    printarray kTest
  endif
endin


</CsInstruments>
<CsScore>
i200 0 2 1
i200 0 2.1 1
i200 1 2 2
i200 1 2.1 2

</CsScore>
</CsoundSynthesizer>
