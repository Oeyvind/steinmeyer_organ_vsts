<Cabbage>
form caption("Midi attack Register") size(200, 170), colour(30, 35, 40), guiMode("queue"), pluginId("matp")

rslider bounds( 5,  5, 50, 50), channel("duration"), text("Duration"), range(0,1,0.5, 0.3, 0.0001)
nslider bounds(65, 15, 30, 20), channel("inchan"), range(1,16,1, 1, 1)
label bounds(65, 40, 30, 15), text("inchan"), fontSize(10)
nslider bounds(115, 15, 30, 20), channel("outchan"), range(1,16,1, 1, 1)
label bounds(115, 40, 30, 15), text("outchan"), fontSize(10)
nslider bounds(155, 15, 30, 20), channel("prog"), range(1,127,2, 1, 1)
label bounds(155, 40, 30, 15), text("prog"), fontSize(10)


csoundoutput bounds(0, 70, 200, 100)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
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
  print ichn
  inchan chnget "inchan"
  ioutchan chnget "outchan"
  iprog chnget "prog"
  ;print inote, ichn, inchan
  if ichn == inchan then
    idur chnget "duration"
    instnum = 202
    event_i "i", instnum, 0, idur, iprog, ioutchan
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
