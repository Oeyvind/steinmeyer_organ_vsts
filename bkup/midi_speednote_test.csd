<Cabbage>
form caption("Speednote") size(300, 200), colour(30, 35, 40), guiMode("queue"), pluginId("spn1")

groupbox bounds(5, 5, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("Play_1"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")
nslider bounds(75,5,35,20), channel("notenum_1"), range(1,128,60, 1, 1), fontSize(14)
label bounds(75, 25, 35, 10), text("notenum"), align("left")
nslider bounds(125,5,35,20), channel("duration_1"), range(0.0,1,0.1), fontSize(14)
label bounds(125, 25, 35, 10), text("duration"), align("left")
nslider bounds(175,5,35,20), channel("channel_1"), range(1,16,1,1,1), fontSize(14)
label bounds(175, 25, 35, 10), text("channel"), align("left")
nslider bounds(225,5,35,20), channel("tempo_bps_1"), range(0.1,100,15), fontSize(14)
label bounds(225, 25, 35, 10), text("tempo_bps"), align("left")
}

csoundoutput bounds(0, 50, 300, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 1

instr 1
  ; GUI control
  kbutton chnget "Play_1"
  ktrigon trigger kbutton, 0.5, 0
  ktrigoff trigger kbutton, 0.5, 1
  instrnum = 2
  if ktrigon > 0 then
    event "i", instrnum, 0, -1
  endif
  if ktrigoff > 0 then
    event "i", -instrnum, 0, .1
  endif

endin

instr 2
  knote chnget "notenum_1"
  kdur chnget "duration_1"
  ktempo_bps chnget "tempo_bps_1"
  ktrig metro ktempo_bps
  printk2 kdur/ktempo_bps
  printk2 1/kr, 10
  printk2 1/512, 20
  if ktrig > 0 then
    kvel = 90
    kchan = 1
    event "i", 201, 0, kdur/ktempo_bps, kvel, knote, kchan
  endif

endin

instr 201
    ivel = p4
    inote = p5
    ichan = p6
    noteondur2 ichan, inote, ivel, p3    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
