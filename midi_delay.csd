<Cabbage>
form caption("Midi delay") size(205, 230), colour(30, 35, 40), guiMode("queue"), pluginId("mdly")

nslider bounds(5, 15, 30, 25), channel("inchan"), range(1,16,1, 1, 1)
label bounds(5, 40, 40, 15), text("inchan"), fontSize(11)
nslider bounds(55, 15, 40, 25), channel("outchan"), range(1,16,2, 1, 1)
label bounds(55, 40, 40, 15), text("outchan"), fontSize(11)
nslider bounds(105, 15, 40, 25), channel("bpm"), range(10,999,120,1,1)
label bounds(105, 40, 40, 15), text("bpm"), fontSize(11)

nslider bounds(5, 65, 40, 25), channel("dly_min"), range(1,32,1,1,1)
label bounds(5, 90, 40, 15), text("dly_min"), fontSize(11)
nslider bounds(55, 65, 40, 25), channel("dly_max"), range(1,32,4,1,1)
label bounds(55, 90, 40, 15), text("dly_max"), fontSize(11)
nslider bounds(105, 65, 40, 25), channel("duration"), range(0,1,1)
label bounds(105, 90, 40, 15), text("duration"), fontSize(11)
nslider bounds(155, 65, 40, 25), channel("transpose"), range(-12,12,0,1,1)
label bounds(155, 90, 40, 15), text("transp"), fontSize(11)


csoundoutput bounds(0, 130, 205, 100)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -b-1 -B-1
</CsOptions>
<CsInstruments>

ksmps = 1
massign -1, 2
pgmassign -1, -1


instr 1
  ; GUI control

endin

instr 2
  ; midi notes input, 
  ; same note with short duration in another channel
  
  inote notnum
  ivel veloc 0, 1
  ichn midichn
  inchan chnget "inchan"
  ioutchan chnget "outchan"
  ibpm chnget "bpm"
  idly_min chnget "dly_min"
  idly_max chnget "dly_max"
  idly_secs = (60.0/ibpm) * int(random(idly_min, idly_max+0.999))
  ;print inote, ichn, inchan
  idur chnget "duration"
  itranspose chnget "transpose"
  if ichn == inchan then
    instnum = 201+((inote+itranspose)*0.001) 
    event_i "i", instnum, idly_secs, -1, inote+itranspose, ivel, ioutchan
    kdur timeinsts
    klast lastcycle
    if klast > 0.0 then
      event "i", -instnum, idly_secs-(kdur*(1-idur)), .1
    endif
  endif
endin


instr 201
  ; midi  output
  inote = p4
  ivel = p5*127
  ichan = p6
  print inote, ivel
  print p3
  print ichan
  idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
  ;idur    = (p3 < 0.0105 ? 0 : p3)  ; avoid extremely short notes as they won't play
  noteondur ichan, inote, ivel, idur
    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
