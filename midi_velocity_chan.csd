<Cabbage>
form caption("Midi Velocity Channelizer") size(200, 320), colour(30, 35, 40), guiMode("queue"), pluginId("mvec")

nslider bounds(5, 14, 30, 22), channel("inchan"), range(1,16,1, 1, 1), fontSize(14)
label bounds(5, 40, 30, 15), text("inchan"), fontSize(10)
nslider bounds(45, 14, 30, 22), channel("outchan1"), range(1,16,1, 1, 1), fontSize(14)
label bounds(45, 40, 30, 15), text("ochn1"), fontSize(10)
nslider bounds(85, 14, 30, 22), channel("outchan2"), range(1,16,2, 1, 1), fontSize(14)
label bounds(85, 40, 30, 15), text("ochn2"), fontSize(10)
nslider bounds(125, 14, 30, 22), channel("outchan3"), range(1,16,3, 1, 1), fontSize(14)
label bounds(125, 40, 30, 15), text("ochn3"), fontSize(10)
nslider bounds(165, 14, 30, 22), channel("outchan4"), range(1,16,4, 1, 1), fontSize(14)
label bounds(165, 40, 30, 15), text("ochn4"), fontSize(10)

checkbox bounds(5, 66, 65, 18), channel("switch")
label bounds(5, 90, 65, 15), text("switch/stack"), fontSize(10)
nslider bounds(85, 64, 30, 22), channel("thresh2"), range(1,127,40, 1, 1), fontSize(14)
label bounds(85, 90, 30, 15), text("thresh2"), fontSize(10)
nslider bounds(125, 64, 30, 22), channel("thresh3"), range(1,127,70, 1, 1), fontSize(14)
label bounds(125, 90, 30, 15), text("thresh3"), fontSize(10)
nslider bounds(165, 64, 30, 22), channel("thresh4"), range(1,127,100, 1, 1), fontSize(14)
label bounds(165, 90, 30, 15), text("thresh4"), fontSize(10)

csoundoutput bounds(0, 110, 200, 200)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
massign -1, 3
pgmassign -1, -1


instr 1
  ; GUI control
endin

instr 2

endin

instr 3
  ; midi notes input, 
  ; set output channel according to velocity
  inote notnum
  ivel veloc 0, 127
  ichn midichn
  inchan chnget "inchan"
  if ichn == inchan then
    ioutchan1 chnget "outchan1"
    ioutchan2 chnget "outchan2"
    ioutchan3 chnget "outchan3"
    ioutchan4 chnget "outchan4"
    ithresh2 chnget "thresh2"
    ithresh3 chnget "thresh3"
    ithresh4 chnget "thresh4"
    ioutchan = ioutchan1
    ioutchan = ivel > ithresh2 ? ioutchan2 : ioutchan
    ioutchan = ivel > ithresh3 ? ioutchan3 : ioutchan
    ioutchan = ivel > ithresh4 ? ioutchan4 : ioutchan
    iswitch chnget "switch"
    klast lastcycle
    if iswitch > 0 then
      instnum = 201+(inote*0.001)+(ioutchan*0.00001)
      event_i "i", instnum, 0, -1, ivel, inote, ioutchan  
      if klast > 0 then
        event "i", -instnum, 0, .1
      endif
    else
      iChans[] fillarray ioutchan1, ioutchan2, ioutchan3, ioutchan4
      inumvoice = 1
      inumvoice = ivel > ithresh2 ? 2 : inumvoice
      inumvoice = ivel > ithresh3 ? 3 : inumvoice
      inumvoice = ivel > ithresh4 ? 4 : inumvoice
      indx = 0
      while indx < inumvoice do
        ioutchan = iChans[indx]
        instnum = 201+(inote*0.001)+(ioutchan*0.00001)
        indx += 1
        event_i "i", instnum, 0, -1, ivel, inote, ioutchan  
      od 
      if klast > 0 then
        kndx = 0
        while kndx < inumvoice do
          koutchan = iChans[kndx]
          printk2 koutchan
          kinstnum = 201+(inote*0.001)+(koutchan*0.00001)
          kndx += 1
          event "i", -kinstnum, 0, .1
        od
      endif
    endif
  endif
endin


instr 201
  ; midi  output
  ivel = p4
  inote = p5
  ichan = p6
  printf "note %i, chan %i\n", 1, inote, ichan
  idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
  noteondur ichan, inote, ivel, idur  
endin


</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
