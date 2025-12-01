<Cabbage>
form caption("Midi granulator") size(300, 450), colour(30, 35, 40), guiMode("queue"), pluginId("mgr2")

groupbox bounds(5, 5, 300, 45), colour(75,85,90), lineThickness("0"){ 
button channel("absdur"), bounds(5, 5, 50, 30), text("absdur"), colour:0("black"), colour:1("green")
nslider bounds(70,5,50,20), channel("duration"), range(0.0,1,0.5, 1, 0.0001), fontSize(14)
label bounds(70, 25, 50, 10), text("duration"), align("left")
nslider bounds(130,5,35,20), channel("d_keyfollow"), range(-3,3,0.5), fontSize(14)
label bounds(130, 25, 35, 10), text("d_kflw"), align("left")
nslider bounds(180,5,35,20), channel("tempo_bps"), range(0.1,100,2), fontSize(14)
label bounds(180, 25, 35, 10), text("tempo_bps"), align("left")
nslider bounds(220,5,35,20), channel("r_tempo"), range(0.0,1,0), fontSize(14)
label bounds(220, 25, 35, 10), text("r_tempo"), align("left")
}



csoundoutput bounds(0, 250, 300, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -B1 -b1
</CsOptions>
<CsInstruments>

ksmps = 1
massign -1, 2


  opcode RhythmPLL, kkk, kikkkkkk
  ; PLL for rhythmic synchronization
  ; Oeyvind Brandtsegg 2021 oyvind.brandtsegg@ntnu.no
  ; Licence: Creative commons CC BY (use as you like but you *must* credit)
  ; outputs: pulse, phase (ramp), and frequency
  ; inputs: ext clock pulse, init frequency, freq adjust gain, phase adjust gain, tempo adjust shape, tempo multiplier, kfallback
  ; kfallback sets the oscillator to not sync, but slowly fall back to the ifq
  k1trig, ifq2, kfq2_update, kgain, kphasegain, kadjustshape, ktempomultiplier, kfallback xin

    ; oscillator
    kfq2 init ifq2
    if changed(kfq2_update) > 0 then
      kfq2 = kfq2_update
      ;printk2 kfq2, 20
    endif
    kosc2 init 0
    kosc2 += (kfq2/kr) ; increment ramp value
    kosc2 = kosc2 > 1 ? 0 : kosc2 ; wrap around
    k2trig trigger kosc2, 0.5, 1 ; downwards trigger when wrapping
    k2trig_add trigger (kosc2*ktempomultiplier)%1, 0.5, 1; multi trigger 

    ; phase difference detector
    kcount init 0
    k2_prevphase init 0
    kdiff init 0
    kdifflag init 0
    kdiff_old init 0
    kskip init 1
    if k1trig > 0 then
      if kskip == 0 then
        kdiff = (kosc2+kcount)-k2_prevphase ; get phase difference
        kdifflag = (kdiff <= 0 ? kdiff : 0)
        kdiff = (kdiff <= 0.1 ? kdiff+1 : kdiff) ; if clocks tick at exactly the same time, the counter will be late
        kphasecorr = wrap(kosc2,-0.5,0.5)*-1
      endif
      kskip = 0
      kcount = kdifflag != 0 ? -1 : 0 ; recap after the "synchronous tick"-saving trick above
      k2_prevphase = kosc2
    endif
    if k2trig > 0 then
      kcount += 1
    endif

    ; calculate the error correction values
    kfact = divz(1,kdiff,1)^kadjustshape ; the tempo adjustment factor
    kerr = ((kfact-1)*kgain*k1trig)+1
    kphaserr = kfq2*kphasecorr*k1trig*kphasegain
    kfq2 = (kfq2*kerr)+kphaserr
    if kfallback > 0 then
      kfq2 = kfq2+((ifq2-kfq2)*kgain*(10/kr))
    endif
  xout k2trig+k2trig_add, kosc2, kfq2
endop

instr 1
  ; GUI control
  
endin


instr 2
  ; midi notes input
  inum notnum
  ivel veloc
  ichn midichn
  i_nstrnum = 3+(inum/1000)
  event_i "i", i_nstrnum, 0, -1, inum, ivel, ichn
  koff lastcycle
  if koff > 0 then
    event "i", -i_nstrnum, 0, .01
  endif
  
endin

instr 3
  inote = p4
  ivel = p5
  ichan = p6
  print inote, ichan
  kdur chnget "duration"
  kdur_keyfollow chnget "d_keyfollow"
  kdur += (inote/100*kdur_keyfollow*kdur)
  kabsdur chnget "absdur"
  ktempo_bps chnget "tempo_bps"
  kdur = kabsdur > 0 ? kdur : kdur/ktempo_bps
  ;printk2 kdur

  ;ktrig metro ktempo_bps
  kcount_up init 0
  kcount_down init 0
  in_tempo = i(ktempo_bps)
  ;print in_tempo
  krwidth chnget "r_tempo";0.4;linseg 0.7, 5, 0.0, 5, 0, 5, 0.8
  kin_tempo = ktempo_bps
  ktempo init i(ktempo_bps);init in_tempo
  
  kintrig = 0
  ifq = 10
  kfqgain = 0
  kphasegain = 0
  ksync_shape = 0
  ktempo_multiplier = 1
  kfallback = 0
  ktrig, kphase, kfq RhythmPLL kintrig, ifq, ktempo, kfqgain, kphasegain, ksync_shape, ktempo_multiplier, kfallback
  
  if ktrig > 0 then
    if ktempo > kin_tempo then
      kcount_up += 1
      kcount_down = 1
    else
      kcount_down += 1
      kcount_up = 1
    endif
    ; random tempo adjustment
    if ktempo > kin_tempo*(1+krwidth) then
      ktempo -= random(limit(kcount_up,kin_tempo*0.1,kin_tempo), kin_tempo*krwidth*1.8)
    elseif ktempo < kin_tempo*(1-krwidth) then
      ktempo += random(limit(kcount_down,kin_tempo*0.1,kin_tempo), kin_tempo*krwidth*1.8)
    else  
      ktempo += random(-kin_tempo*krwidth*0.8,kin_tempo*krwidth*0.8)
    endif
    ktempo limit ktempo, 1, kin_tempo*2
  endif
  

  i_nstrnum = 201+frac(p1)  
  if ktrig > 0 then
    event "i", i_nstrnum, 0, kdur, ivel, inote, ichan
  endif

endin

instr 201
  ; midi  output
    ivel = p4
    inote = p5
    ichan = p6
    idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    idur    = (p3 < 0.0105 ? 0 : p3)  ; avoid extremely short notes as they won't play
    noteondur2 ichan, inote, ivel, p3
    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
