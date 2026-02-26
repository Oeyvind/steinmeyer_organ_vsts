<Cabbage>
form caption("Test") size(200, 170), colour(30, 35, 40), guiMode("queue"), pluginId("test")


csoundoutput bounds(0, 70, 200, 100)
<CsoundSynthesizer>
<CsOptions>
;-odac10 -Q11 -b-1 -B-1
;--midioutfile="midi_out_test.mid" -omidi_out_test.wav
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 

</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1

instr 1
  inote = p4
  ivel = p5
  ichan = p6
  ibps = p7
  idur = divz(1, ibps, .1)*p8
  ktrig metro ibps
  print inote, ivel, ichan, ibps, idur
  i_nstrnum = 201+frac(p1)  
  if ktrig > 0 then
    event "i", i_nstrnum, 0, idur, inote, ivel, ichan
  endif
endin

instr 201  
  inote = p4
  ivel = p5
  ichan = p6
  noteondur ichan, inote, ivel, p3
  a1 oscil ivel*0.01, cpsmidinn(inote)
  outs a1, a1
endin

</CsInstruments>
<CsScore>
;  inote = p4
;  ivel = p5
;  ichan = p6
;  ibps = p7
;  idur = p8
i1 0 100 60 90 1 10 0.5
</CsScore>
</CsoundSynthesizer>
