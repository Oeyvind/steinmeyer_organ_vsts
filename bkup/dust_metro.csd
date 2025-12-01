<Cabbage>
form caption("Dust/metro") size(310, 270), colour(30, 35, 40), guiMode("queue"), pluginId("dmt1")
button channel("Play"), bounds(5, 5, 50, 30), text("Play"), colour:0("black"), colour:1("green")

groupbox bounds(5, 40, 300, 120), colour(25,35,40), lineThickness("0"){ 
rslider bounds( 5,  5, 50, 50), channel("duration"), text("Duration"), range(0,2,0.1, 0.3, 0.0001)
nslider bounds(65, 15, 30, 25), channel("base_pitch"), range(36, 72, 48, 1, 1), fontSize(17)
label bounds(65, 40, 30, 15), text("Bpitch"), , fontSize(10)
nslider bounds(115, 15, 30, 25), channel("pitch_range"), range(1,60,1, 1, 1), fontSize(17)
label bounds(115, 40, 30, 15), text("Prange"), fontSize(10)
nslider bounds(155, 15, 30, 25), channel("num_chan"), range(1,5,1, 1, 1), fontSize(17)
label bounds(155, 40, 30, 15), text("nchan"), fontSize(10)
nslider bounds(195, 15, 30, 25), channel("poly_max"), range(1,5,1, 1, 1), fontSize(17)
label bounds(195, 40, 35, 15), text("poly_max"), fontSize(10)
rslider bounds(245,  5, 50, 50), channel("poly_chance"), text("pol_rnd"), range(0,1,0.1)

rslider bounds( 5,  60, 50, 50), channel("dust_freq"), text("dust_freq"), range(0.1,10,0.5, 0.3, 0.01)
nslider bounds(65, 70, 30, 25), channel("min_dust"), range(1, 50, 10, 1, 1), fontSize(17)
label bounds(65, 95, 30, 15), text("min_dust"), , fontSize(10)
button bounds(115, 70, 70, 20), channel("dust_metro_switch"), text("dust/metro"), colour:0("black"), colour:1("green")
nslider bounds(140, 90, 30, 15), channel("switch_counter"), range(-999, 999, 0, 1, 1), fontSize(14)
nslider bounds(195, 70, 30, 25), channel("max_metro"), range(1, 50, 10, 1, 1), fontSize(17)
label bounds(195, 95, 35, 15), text("max_metro"), , fontSize(10)
rslider bounds(245,  60, 50, 50), channel("metro_freq"), text("metro_fq"), range(0.1,10,0.5, 0.3, 0.01)
}
csoundoutput bounds(0, 170, 310, 100)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 64
massign -1, 2
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
  kplay chnget "Play"
  ButtonEvent kplay, 2
endin

instr 2
  ; dust/metro auto switcher
  kcount init 0
  kdust_freq chnget "dust_freq"
  kdust dust 1, kdust_freq
  kdust = kdust > 0 ? 1 : 0
  kmetro_freq chnget "metro_freq"
  kmetro metro kmetro_freq
  
  kmin_dust chnget "min_dust"
  kmax_metro chnget "max_metro"
  kcount_switch init 0
  ktrig init 0
  ktrig_switch init 0
  if ktrig_switch == 0 then
    ktrig = kdust
  else  
    ktrig = kmetro
  endif
  if changed(ktrig_switch) > 0 then
    kcount_switch = ktrig_switch == 0 ? -kmin_dust : -kmax_metro
  endif
  kcount_switch += ktrig
  cabbageSet changed(kcount_switch), "switch_counter", "value", kcount_switch
  if kcount_switch > 0 then
    if ktrig > 0 then
      krandswitch random 0, 1
      krand_thresh = 0.8
      if krandswitch < krand_thresh then
        ktrig_switch = (ktrig_switch+1)%2
        cabbageSet 1, "dust_metro_switch", "value", ktrig_switch
      endif
    endif
  endif
  kpitch rnd31 1, 1
  kpitch_range chnget "pitch_range"
  kbase_pitch chnget "base_pitch"
  kpoly_max chnget "poly_max"
  kpoly_chance chnget "poly_chance"
  if ktrig > 0 then
    kcount += 1
    kvel = 90
    kdur chnget "duration"
    kpoly_count = 0
    while kpoly_count < kpoly_max do
      kpitch random 0, 1
      knote = int(kpitch*kpitch_range)+kbase_pitch
      iChannels[] fillarray 1,2,3,4,8 ; Steinmeyer
      knum_chan chnget "num_chan"
      kchan = floor(random:k(0,knum_chan))
      kchan = iChannels[kchan]
      event "i", 201, 0, kdur, knote, kvel, kchan
      kpoly_count += 1+(random:k(0,divz(1,kpoly_chance,1))+(kpoly_count*0.25))
    od
  endif
endin


instr 201
  ; midi  output
  inote = p4
  ivel = p5
  ichan = p6
  print ichan
  noteondur ichan, inote, ivel, p3
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
