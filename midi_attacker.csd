<Cabbage>
form caption("Midi attacker") size(200, 170), colour(30, 35, 40), guiMode("queue"), pluginId("matk")

rslider bounds( 5,  5, 50, 50), channel("duration"), text("Duration"), range(0,1,0.5, 0.3, 0.0001)
rslider bounds(65, 5, 50, 50), channel("transpose"), text("Transpose"), range(-24, 24, 0, 1, 1)
nslider bounds(115, 15, 30, 20), channel("inchan"), range(1,16,1, 1, 1)
label bounds(115, 40, 30, 15), text("inchan"), fontSize(10)
nslider bounds(155, 15, 30, 20), channel("outchan"), range(1,16,2, 1, 1)
label bounds(155, 40, 30, 15), text("outchan"), fontSize(10)

;rslider bounds(115, 5, 50, 50), channel("rdur"), text("Rdur"), range(0,3,0, 0.3, 0.0001)
;rslider bounds(165, 5, 50, 50), channel("d_keyfollow"), text("d_kbf"), range(-3,3,0)

csoundoutput bounds(0, 70, 200, 100)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
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
  ;print inote, ichn, inchan
  if ichn == inchan then
    idur chnget "duration"
    itranspose chnget "transpose"
    instnum = 201
    event_i "i", instnum, 0, idur, inote+itranspose, ivel, ioutchan
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
