
<CsoundSynthesizer>
<CsOptions>
-n -d --midioutfile=test2.mid
</CsOptions>
<CsInstruments>

ksmps = 1


instr 2
  ivoice = p4
  knote = 60
  kdur = 0.1
  ktempo_bps = 27
  ktrig metro ktempo_bps
  if ktrig > 0 then
    kvel = 90
    kchan = 1
    event "i", 201, 0, kdur/ktempo_bps, kvel, knote, kchan
  endif

endin

instr 201
  ; midi  output
    ivel = p4
    inote = p5
    ichan = p6
    ;midiout_i 144, ichan, inote, ivel
    ;kflag lastcycle
    ;if kflag > 0 then
    ;  midiout 128, ichan, inote, 0
    ;endif
    ;idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    ;idur    = (p3 < 0.05 ? 0.05 : p3)  ; avoid extremely short notes as they won't play
    noteondur2 ichan, inote, ivel, p3
    
endin

</CsInstruments>
<CsScore>
i2 0 5
</CsScore>
</CsoundSynthesizer>
