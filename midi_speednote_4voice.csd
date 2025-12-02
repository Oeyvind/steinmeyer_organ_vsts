<Cabbage>
form caption("Speednote") size(300, 450), colour(30, 35, 40), guiMode("queue"), pluginId("spn1")

groupbox bounds(5, 5, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_1"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_1"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_1"), range(0.01,1,0.5), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_1"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_1"), range(0.1,100,2), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}

groupbox bounds(5, 50, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_2"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_2"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_2"), range(0.01,1,0.5), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_2"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_2"), range(0.1,100,2), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}

groupbox bounds(5, 100, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_3"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_3"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_3"), range(0.01,1,0.5), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_3"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_3"), range(0.1,100,2), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}

groupbox bounds(5, 150, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_4"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_4"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_4"), range(0.01,1,0.5), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_4"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_4"), range(0.1,100,2), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}

groupbox bounds(5, 200, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_5"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_5"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_5"), range(0.01,1,0.5), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_5"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_5"), range(0.1,100,2), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}


csoundoutput bounds(0, 250, 300, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
pgmassign -1, -1

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
  kplay1 chnget "Play_1"
  ButtonEvent kplay1, 2.001, 1
  kplay2 chnget "Play_2"
  ButtonEvent kplay2, 2.002, 2
  kplay3 chnget "Play_3"
  ButtonEvent kplay3, 2.003, 3
  kplay4 chnget "Play_4"
  ButtonEvent kplay4, 2.004, 4
  kplay5 chnget "Play_5"
  ButtonEvent kplay5, 2.005, 5

endin

instr 2
  ivoice = p4
  Snotenum sprintf "notenum_%i", ivoice
  Sduration sprintf "duration_%i", ivoice
  Stempo sprintf "tempo_bps_%i", ivoice
  knote chnget Snotenum
  kdur chnget Sduration
  ktempo_bps chnget Stempo
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
    ichan = p60
    idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    idur    = (p3 < 0.0105 ? 0 : p3)  ; avoid extremely short notes as they won't play
    noteondur2 ichan, inote, ivel, p3
    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
