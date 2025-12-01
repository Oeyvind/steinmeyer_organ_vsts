<Cabbage>
form caption("Barlow/PLL/dust with pitch path") size(630, 600), colour(30, 35, 40), guiMode("queue"), pluginId("bpd1")

button channel("Play_Master"), bounds(5, 5, 50, 30), text("Play_M"), colour:0("black"), colour:1("green")
combobox bounds(60,5,60,20), channel("meter"), items("3/4","6/8","12/8","4/4","4/4_2", "Clave1", "Clave2"), value(1)
label bounds(60, 25, 55, 10), text("meter"), align("left")
nslider bounds(125,5,35,20), channel("meter_len"), range(1,16,12, 1, 1), fontSize(14)
label bounds(125, 25, 35, 10), text("m_len"), align("left")
texteditor bounds(175, 5, 130, 20) fontSize(16), channel("pitches"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(175, 25, 35, 10), text("pitches"), align("left")
nslider bounds(310,5,35,20), channel("num_pitches"), range(1,16,1, 1, 1), fontSize(14)
label bounds(310, 25, 35, 10), text("num_pitches"), align("left")
button channel("Chords"), bounds(350, 5, 50, 30), text("Chords"), colour:0("black"), colour:1("green")

nslider bounds(410,5,35,20), channel("sync_shape"), range(0.1,4,1), fontSize(14)
label bounds(410, 25, 35, 10), text("sync_shape"), align("left")

groupbox bounds(5, 50, 620, 90), colour(75,85,90), lineThickness("0"){ 
button channel("Play_1"), bounds(5, 5, 50, 30), text("Play_1"), colour:0("black"), colour:1("green")
combobox bounds(60,5,40,20), channel("master_1"), items("1","2","3","4"), value(1)
label bounds(60, 25, 40, 10), text("master"), align("left")
nslider bounds(110,5,45,20), channel("tempo_1"), range(20,960,120, 1, 0.1), fontSize(13)
label bounds(110, 25, 50, 10), text("tempo"), align("left")
nslider bounds(155,5,45,20), channel("tempoo_1"), range(20,960,120, 1, 0.1), fontSize(13), fontColour(0,255,0)
combobox bounds(205,5,50,20), channel("t_mult_1"), items("1","2","3","4","5","6","7","8"), value(1)
label bounds(205, 25, 50, 10), text("t_mult"), align("left")

nslider bounds(270,5,45,20), channel("sync_strength_1"), range(0,1,0.1), fontSize(13)
label bounds(270, 25, 50, 10), text("sync_strength"), align("left")
nslider bounds(330,5,45,20), channel("rand_indisp_balance_1"), range(0,1,0.1), fontSize(13)
label bounds(330, 25, 50, 10), text("r_indisp_bal"), align("left")
nslider bounds(395,5,45,20), channel("base_rand_1"), range(0,1,0.1), fontSize(13)
label bounds(395, 25, 50, 10), text("base_rand"), align("left")
nslider bounds(460,5,45,20), channel("mask_level_1"), range(0,1,0.1), fontSize(13)
label bounds(460, 25, 50, 10), text("mask_level"), align("left")
nslider bounds(525,5,45,20), channel("count_sync_strength_1"), range(0,1,0.1), fontSize(13)
label bounds(525, 25, 50, 10), text("count_snc_str"), align("left")

nslider bounds(5,50,45,20), channel("basepitch_1"), range(0,96,60,1,1), fontSize(13)
label bounds(5, 70, 50, 10), text("basepitch"), align("left")
nslider bounds(60,50,45,20), channel("pitchrange_1"), range(-60,60,-5), fontSize(13)
label bounds(60, 70, 50, 10), text("pitchrange"), align("left")
nslider bounds(110,50,45,20), channel("gravity_1"), range(0,1,0), fontSize(13)
label bounds(110, 70, 50, 10), text("gravity"), align("left")
nslider bounds(160,50,45,20), channel("p_grid_balance_1"), range(0,1,0), fontSize(13)
label bounds(160, 70, 50, 10), text("grid_balance"), align("left")
texteditor bounds(210, 50, 130, 20) fontSize(16), channel("pitch_path_1"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(210, 70, 35, 10), text("pitch_path"), align("left")
nslider bounds(345,50,35,20), channel("num_pitches_1"), range(1,16,1, 1, 1), fontSize(14)
label bounds(345, 70, 35, 10), text("num_pitches"), align("left")
button channel("localpitch_1"), bounds(395, 50, 50, 30), text("local"), colour:0("black"), colour:1("green")
nslider bounds(450,50,35,20), channel("chan_1"), range(1,16,1, 1, 1), fontSize(14)
label bounds(450, 70, 35, 10), text("chan"), align("left")
button channel("dust_metro_1"), bounds(500, 50, 50, 30), text("dust"), colour:0("black"), colour:1("green")
nslider bounds(555,50,50,20), channel("dur_1"), range(0.001,1, 1, 0.001), fontSize(14)
label bounds(560, 70, 50, 10), text("dur"), align("left")
}

groupbox bounds(5, 140, 620, 90), colour(75,85,90), lineThickness("0"){ 
button channel("Play_2"), bounds(5, 5, 50, 30), text("Play_2"), colour:0("black"), colour:1("green")
combobox bounds(60,5,40,20), channel("master_2"), items("1","2","3","4"), value(1)
label bounds(60, 25, 40, 10), text("master"), align("left")
nslider bounds(110,5,45,20), channel("tempo_2"), range(20,960,120, 1, 0.1), fontSize(13)
label bounds(110, 25, 50, 10), text("tempo"), align("left")
nslider bounds(155,5,45,20), channel("tempoo_2"), range(20,960,120, 1, 0.1), fontSize(13), fontColour(0,255,0)
combobox bounds(205,5,50,20), channel("t_mult_2"), items("1","2","3","4","5","6","7","8"), value(1)
label bounds(205, 25, 50, 10), text("t_mult"), align("left")

nslider bounds(270,5,45,20), channel("sync_strength_2"), range(0,1,0.1), fontSize(13)
label bounds(270, 25, 50, 10), text("sync_strength"), align("left")
nslider bounds(330,5,45,20), channel("rand_indisp_balance_2"), range(0,1,0.1), fontSize(13)
label bounds(330, 25, 50, 10), text("r_indisp_bal"), align("left")
nslider bounds(395,5,45,20), channel("base_rand_2"), range(0,1,0.1), fontSize(13)
label bounds(395, 25, 50, 10), text("base_rand"), align("left")
nslider bounds(460,5,45,20), channel("mask_level_2"), range(0,1,0.1), fontSize(13)
label bounds(460, 25, 50, 10), text("mask_level"), align("left")
nslider bounds(525,5,45,20), channel("count_sync_strength_2"), range(0,1,0.1), fontSize(13)
label bounds(525, 25, 50, 10), text("count_snc_str"), align("left")

nslider bounds(5,50,45,20), channel("basepitch_2"), range(0,96,60,1,1), fontSize(13)
label bounds(5, 70, 50, 10), text("basepitch"), align("left")
nslider bounds(60,50,45,20), channel("pitchrange_2"), range(-60,60,-5), fontSize(13)
label bounds(60, 70, 50, 10), text("pitchrange"), align("left")
nslider bounds(110,50,45,20), channel("gravity_2"), range(0,1,0), fontSize(13)
label bounds(110, 70, 50, 10), text("gravity"), align("left")
nslider bounds(160,50,45,20), channel("p_grid_balance_2"), range(0,1,0), fontSize(13)
label bounds(160, 70, 50, 10), text("grid_balance"), align("left")
texteditor bounds(210, 50, 130, 20) fontSize(16), channel("pitch_path_2"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(210, 70, 35, 10), text("pitch_path"), align("left")
nslider bounds(345,50,35,20), channel("num_pitches_2"), range(1,16,1, 1, 1), fontSize(14)
label bounds(345, 70, 35, 10), text("num_pitches"), align("left")
button channel("localpitch_2"), bounds(395, 50, 50, 30), text("local"), colour:0("black"), colour:1("green")
nslider bounds(450,50,35,20), channel("chan_2"), range(1,16,1, 1, 1), fontSize(14)
label bounds(450, 70, 35, 10), text("chan"), align("left")
button channel("dust_metro_2"), bounds(500, 50, 50, 30), text("dust"), colour:0("black"), colour:1("green")
nslider bounds(555,50,50,20), channel("dur_2"), range(0.001,1, 1, 0.001), fontSize(14)
label bounds(560, 70, 50, 10), text("dur"), align("left")
}

groupbox bounds(5, 230, 620, 90), colour(75,85,90), lineThickness("0"){ 
button channel("Play_3"), bounds(5, 5, 50, 30), text("Play_3"), colour:0("black"), colour:1("green")
combobox bounds(60,5,40,20), channel("master_3"), items("1","2","3","4"), value(1)
label bounds(60, 25, 40, 10), text("master"), align("left")
nslider bounds(110,5,45,20), channel("tempo_3"), range(20,960,120, 1, 0.1), fontSize(13)
label bounds(110, 25, 50, 10), text("tempo"), align("left")
nslider bounds(155,5,45,20), channel("tempoo_3"), range(20,960,120, 1, 0.1), fontSize(13), fontColour(0,255,0)
combobox bounds(205,5,50,20), channel("t_mult_3"), items("1","2","3","4","5","6","7","8"), value(1)
label bounds(205, 25, 50, 10), text("t_mult"), align("left")

nslider bounds(270,5,45,20), channel("sync_strength_3"), range(0,1,0.1), fontSize(13)
label bounds(270, 25, 50, 10), text("sync_strength"), align("left")
nslider bounds(330,5,45,20), channel("rand_indisp_balance_3"), range(0,1,0.1), fontSize(13)
label bounds(330, 25, 50, 10), text("r_indisp_bal"), align("left")
nslider bounds(395,5,45,20), channel("base_rand_3"), range(0,1,0.1), fontSize(13)
label bounds(395, 25, 50, 10), text("base_rand"), align("left")
nslider bounds(460,5,45,20), channel("mask_level_3"), range(0,1,0.1), fontSize(13)
label bounds(460, 25, 50, 10), text("mask_level"), align("left")
nslider bounds(525,5,45,20), channel("count_sync_strength_3"), range(0,1,0.1), fontSize(13)
label bounds(525, 25, 50, 10), text("count_snc_str"), align("left")

nslider bounds(5,50,45,20), channel("basepitch_3"), range(0,96,60,1,1), fontSize(13)
label bounds(5, 70, 50, 10), text("basepitch"), align("left")
nslider bounds(60,50,45,20), channel("pitchrange_3"), range(-60,60,-5), fontSize(13)
label bounds(60, 70, 50, 10), text("pitchrange"), align("left")
nslider bounds(110,50,45,20), channel("gravity_3"), range(0,1,0), fontSize(13)
label bounds(110, 70, 50, 10), text("gravity"), align("left")
nslider bounds(160,50,45,20), channel("p_grid_balance_3"), range(0,1,0), fontSize(13)
label bounds(160, 70, 50, 10), text("grid_balance"), align("left")
texteditor bounds(210, 50, 130, 20) fontSize(16), channel("pitch_path_3"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(210, 70, 35, 10), text("pitch_path"), align("left")
nslider bounds(345,50,35,20), channel("num_pitches_3"), range(1,16,1, 1, 1), fontSize(14)
label bounds(345, 70, 35, 10), text("num_pitches"), align("left")
button channel("localpitch_3"), bounds(395, 50, 50, 30), text("local"), colour:0("black"), colour:1("green")
nslider bounds(450,50,35,20), channel("chan_3"), range(1,16,1, 1, 1), fontSize(14)
label bounds(450, 70, 35, 10), text("chan"), align("left")
button channel("dust_metro_3"), bounds(500, 50, 50, 30), text("dust"), colour:0("black"), colour:1("green")
nslider bounds(555,50,50,20), channel("dur_3"), range(0.001,1, 1, 0.001), fontSize(14)
label bounds(560, 70, 50, 10), text("dur"), align("left")
}

groupbox bounds(5, 320, 620, 90), colour(75,85,90), lineThickness("0"){ 
button channel("Play_4"), bounds(5, 5, 50, 30), text("Play_4"), colour:0("black"), colour:1("green")
combobox bounds(60,5,40,20), channel("master_4"), items("1","2","3","4"), value(1)
label bounds(60, 25, 40, 10), text("master"), align("left")
nslider bounds(110,5,45,20), channel("tempo_4"), range(20,960,120, 1, 0.1), fontSize(13)
label bounds(110, 25, 50, 10), text("tempo"), align("left")
nslider bounds(155,5,45,20), channel("tempoo_4"), range(20,960,120, 1, 0.1), fontSize(13), fontColour(0,255,0)
combobox bounds(205,5,50,20), channel("t_mult_4"), items("1","2","3","4","5","6","7","8"), value(1)
label bounds(205, 25, 50, 10), text("t_mult"), align("left")

nslider bounds(270,5,45,20), channel("sync_strength_4"), range(0,1,0.1), fontSize(13)
label bounds(270, 25, 50, 10), text("sync_strength"), align("left")
nslider bounds(330,5,45,20), channel("rand_indisp_balance_4"), range(0,1,0.1), fontSize(13)
label bounds(330, 25, 50, 10), text("r_indisp_bal"), align("left")
nslider bounds(395,5,45,20), channel("base_rand_4"), range(0,1,0.1), fontSize(13)
label bounds(395, 25, 50, 10), text("base_rand"), align("left")
nslider bounds(460,5,45,20), channel("mask_level_4"), range(0,1,0.1), fontSize(13)
label bounds(460, 25, 50, 10), text("mask_level"), align("left")
nslider bounds(525,5,45,20), channel("count_sync_strength_4"), range(0,1,0.1), fontSize(13)
label bounds(525, 25, 50, 10), text("count_snc_str"), align("left")

nslider bounds(5,50,45,20), channel("basepitch_4"), range(0,96,60,1,1), fontSize(13)
label bounds(5, 70, 50, 10), text("basepitch"), align("left")
nslider bounds(60,50,45,20), channel("pitchrange_4"), range(-60,60,-5), fontSize(13)
label bounds(60, 70, 50, 10), text("pitchrange"), align("left")
nslider bounds(110,50,45,20), channel("gravity_4"), range(0,1,0), fontSize(13)
label bounds(110, 70, 50, 10), text("gravity"), align("left")
nslider bounds(160,50,45,20), channel("p_grid_balance_4"), range(0,1,0), fontSize(13)
label bounds(160, 70, 50, 10), text("grid_balance"), align("left")
texteditor bounds(210, 50, 130, 20) fontSize(16), channel("pitch_path_4"), fontColour(255, 255, 255), colour(0, 0, 0), caretColour("white"), fontSize(14)
label bounds(210, 70, 35, 10), text("pitch_path"), align("left")
nslider bounds(345,50,35,20), channel("num_pitches_4"), range(1,16,1, 1, 1), fontSize(14)
label bounds(345, 70, 35, 10), text("num_pitches"), align("left")
button channel("localpitch_4"), bounds(395, 50, 50, 30), text("local"), colour:0("black"), colour:1("green")
nslider bounds(450,50,35,20), channel("chan_4"), range(1,16,1, 1, 1), fontSize(14)
label bounds(450, 70, 35, 10), text("chan"), align("left")
button channel("dust_metro_4"), bounds(500, 50, 50, 30), text("dust"), colour:0("black"), colour:1("green")
nslider bounds(555,50,50,20), channel("dur_4"), range(0.001,1, 1, 0.001), fontSize(14)
label bounds(560, 70, 50, 10), text("dur"), align("left")
}

csoundoutput bounds(0, 455, 500, 140)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

gkIndispensabilities[] init 16
gkPitches[] init 16

opcode PitchPath, k,kk[]kkkkk
  kinput, kPath[], kseq_length, kpitchrange, kbasepitch, kgravity, kp_grid_balance xin
  ; make local path (= path spread to all octaves)
  kLocalpath[] init 127
  kinit init 0
  if kinit == 0 then
    kseq_wrap = 12; wrap every octave, might wrap at other interval for more advanced grids
    knumiter = ceil(kpitchrange/kseq_wrap)
    kmaxitems = kseq_length*knumiter
    knumitems = kmaxitems
    kndx = 0
    kiteration = 0
    while kndx <= kmaxitems do
      kiteration = floor(kndx/kseq_length)
      kvalue = kPath[(kndx%kseq_length)]+(kseq_wrap*kiteration)
      if kvalue <= kpitchrange then
        kLocalpath[kndx] = kvalue
        knumitems = kndx
      endif
      kndx += 1
    od 
    kinit = 1
  endif
  ; quantize notes
  knote_quant = kLocalpath[int(kinput*knumitems)] + kbasepitch
  knote_raw = (kinput*kpitchrange) + kbasepitch
  Sdebug sprintfk "in %f nitems %i raw %i, quant %i", kinput, knumitems, knote_raw, knote_quant
  puts Sdebug, changed(knote_raw, kinput)+1
  ; gravity draws note nearer to determined pitch grid
  knote = int((knote_quant*(kgravity))+(knote_raw*(1-kgravity)))
  ; grid_balance lets a certain percentage of notes stick to the determined pitch grid
  kpass_prcnt rnd31 0.5, 1
  kpass_prcnt += 0.5
  knote = kpass_prcnt >= (1-kp_grid_balance) ? knote_quant : knote
  xout knote
endop

opcode RhythmPLL, kkk, kikkkkk
  ; PLL for rhythmic synchronization
  ; Oeyvind Brandtsegg 2021 oyvind.brandtsegg@ntnu.no
  ; Licence: Creative commons CC BY (use as you like but you *must* credit)
  ; outputs: pulse, phase (ramp), and frequency
  ; inputs: ext clock pulse, init frequency, freq adjust gain, phase adjust gain, tempo adjust shape, tempo multiplier, kfallback
  ; kfallback sets the oscillator to not sync, but slowly fall back to the ifq
  k1trig, ifq2, kgain, kphasegain, kadjustshape, ktempomultiplier, kfallback xin

    ; oscillator
    kfq2 init ifq2
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

  iIndispensabilities34[] fillarray 12,1,7,4, 10,2,8,5, 11,3,9,6, 0,0,0,0 ; pad to 16
  iIndispensabilities68[] fillarray 12,1,7,3,9,5, 11,2,8,4,10,6, 0,0,0,0 ; pad to 16
  iIndispensabilities12[] fillarray 12,1,5,9, 3,7,11,2, 6,10,4,5, 0,0,0,0 ; pad to 16
  iIndispensabilities16[] fillarray 16,1,9,5, 13,3,11,7, 15,1,10,6, 14,4,12,8 ; 16ths
  iIndispensabilities8[] fillarray 8,1,5,3, 7,2,6,4, 0,0,0,0, 0,0,0,0  ; 8ths
  iIndispensabilitiesClave8[] fillarray 8,1,3, 6,2,4, 7,5, 0,0,0,0, 0,0,0,0 ; 8ths clave
  iIndispensabilitiesClave16[] fillarray 16,3,9,4,11,6, 14,4,10,5,12,7, 15,5,13,8 ; 8ths clave
  kmeter_select chnget "meter"
  if changed(kmeter_select) > 0 then
    if kmeter_select == 1 then
      gkIndispensabilities = iIndispensabilities34
    elseif kmeter_select == 2 then
      gkIndispensabilities = iIndispensabilities68
    elseif kmeter_select == 3 then
      gkIndispensabilities = iIndispensabilities12
    elseif kmeter_select == 3 then
      gkIndispensabilities = iIndispensabilities16
    elseif kmeter_select == 3 then
      gkIndispensabilities = iIndispensabilities8
    elseif kmeter_select == 3 then
      gkIndispensabilities = iIndispensabilitiesClave8
    else
      gkIndispensabilities =iIndispensabilitiesClave16
    endif
    ;printarray gkIndispensabilities
  endif

  kmeter_len chnget "meter_len"
  Spitches chnget "pitches"
  Spitches strcpy "0,3,5"; just init something
  puts Spitches, changed(Spitches)+1
  kcomma strindexk Spitches, ","
  kcomma_init = 0

  kndx = 0
  if (changed(Spitches) > 0) then
    while kcomma > 0 do
      kcomma_init = 1  
      Snum strsubk Spitches, 0, kcomma
      kpitch strtodk Snum
      gkPitches[kndx] = kpitch
      kndx += 1
      Spitches strsubk Spitches, kcomma+1, -1
      kcomma strindexk Spitches, ","
      ;printk2 kcomma
      ;puts Spitches, kndx+1
      ;printk2 kndx, 10
    od
    if kcomma_init > 0 then
      Snum strsubk Spitches, kcomma+1, -1
      if strlenk(Snum) > 0 then
        Snum strcpy "-1" ; inits
        kpitch strtodk Snum
        gkPitches[kndx] = kpitch
      endif
      chnset kndx+1, "num_pitches"
      cabbageSetValue "num_pitches", kndx+1
    endif
     printarray gkPitches
  endif

  ; GUI control
  kplay_master chnget "Play_Master"
  kplay1 chnget "Play_1"
  ButtonEvent kplay1*kplay_master, 2.1, 1

  kplay2 chnget "Play_2"
  ButtonEvent kplay2*kplay_master, 2.2, 2

  kplay3 chnget "Play_3"
  ButtonEvent kplay3*kplay_master, 2.3, 3

  kplay4 chnget "Play_4"
  ButtonEvent kplay4*kplay_master, 2.4, 4
  
endin


instr 2
  ivoice = p4
  Strig_out_chn sprintf "trig_chn_%i", ivoice
  Smaster sprintf "master_%i", ivoice
  kmaster chnget Smaster
  if changed(kmaster) > 0 then
    reinit master_select
  endif
  master_select:
  imaster = i(kmaster)
  Strig_in_chn sprintf "trig_chn_%i", imaster
  kintrig chnget Strig_in_chn
  Sinfo sprintf "voice %i, master %i", ivoice, imaster
  puts Sinfo, 1
  rireturn
  if ivoice == kmaster then
    kintrig = 0
    kfallback = 1
  else  
    kfallback = 0
  endif
  Stempo sprintf "tempo_%i", ivoice
  ktempo_bpm chnget Stempo
  if changed(ktempo_bpm) > 0 then
    reinit set_tempo
  endif
  set_tempo:
  ifq = i(ktempo_bpm)/60 ; the frequency of our slave rhythm generator
  Ssyncstrength sprintf "sync_strength_%i", ivoice
  ksyncstrength chnget Ssyncstrength
  kfqgain = 0.05*ksyncstrength ; adjust this according to how fast we want the clocks to synchronize
  kphasegain = 0.05*ksyncstrength ; adjust this according to how strong we want the phase synchronization to be
  ksync_shape chnget "sync_shape"
  Stempomult sprintf "t_mult_%i", ivoice
  ktempo_multiplier chnget Stempomult
  printk2 kfallback, ivoice*5
  kmetro, kphase, kfq RhythmPLL kintrig, ifq, kfqgain, kphasegain, ksync_shape, ktempo_multiplier, kfallback
  kdust dust 1, kfq
  Sdust_metro sprintf "dust_metro_%i", ivoice
  kdust_metro chnget Sdust_metro
  if kdust_metro > 0 then
    kmetro = kdust
  endif
  Stempoo sprintf "tempoo_%i", ivoice
  if kmetro > 0 then
    cabbageSetValue Stempoo, kfq*60
  endif
  rireturn
  chnset kmetro, Strig_out_chn

  kcount init 0
  kmax_arr maxarray gkIndispensabilities
  kindisp_thisbeat divz gkIndispensabilities[int(kcount)], kmax_arr, 1
  Scount_in sprintf "counter_%i", imaster
  kcount_in chnget Scount_in  

  irpow = 1 
  krand_indisp rnd31, 1, irpow
  Srand_indisp_balance sprintf "rand_indisp_balance_%i", ivoice
  krand_indisp_balance chnget Srand_indisp_balance
  Sbase_rand sprintf "base_rand_%i", ivoice
  kbase_rand chnget Sbase_rand 
  ; REFINE THIS
  kindisp_soft = (kindisp_thisbeat*(1-krand_indisp_balance)) + ; indisp this beat 
                 ((((krand_indisp+1)*kindisp_thisbeat) +   ; random dev from indisp this beat
                   (krand_indisp*kbase_rand)) *            ; pure random 
                   krand_indisp_balance)
  Smask sprintf "mask_level_%i", ivoice
  kmask chnget Smask
  kbeat = kindisp_soft > kmask ? 1 : 0

  knum_pitches chnget "num_pitches"
  Snum_pitches sprintf "num_pitches_%i", ivoice
  knum_pitches_1 chnget Snum_pitches
  kchords chnget "Chords"

  Sbasepitch sprintfk "basepitch_%i", ivoice
  kbasepitch chnget Sbasepitch
  Spitchrange sprintf "pitchrange_%i", ivoice
  kpitchrange chnget Spitchrange
  Sgravity sprintf "gravity_%i", ivoice
  kgravity chnget Sgravity
  Sp_grid_balance sprintf "p_grid_balance_%i", ivoice
  kp_grid_balance chnget Sp_grid_balance

  kPath_1[] init 16 ; sus
  kpath_length init 3
  Spitchp_chn sprintf "pitch_path_%i", ivoice
  Spitchpath chnget Spitchp_chn
  Spitchpath strcpy "0,3,5,12"; just init something
  puts Spitchpath, changed(Spitchpath)+1
  kcomma strindexk Spitchpath, ","
  kcomma_init = 0
  kndx = 0
  
  if (changed(Spitchpath) > 0) then
    while kcomma > 0 do
      kcomma_init = 1  
      Snum strsubk Spitchpath, 0, kcomma
      kpitch strtodk Snum
      kPath_1[kndx] = kpitch
      kndx += 1
      Spitchpath strsubk Spitchpath, kcomma+1, -1
      kcomma strindexk Spitchpath, ","
    od
    if kcomma_init > 0 then
      Snum strsubk Spitchpath, kcomma+1, -1
      if strlenk(Snum) > 0 then
        Snum strcpy "-1" ; inits
        kpitch strtodk Snum
        kPath_1[kndx] = kpitch
      endif
      chnset kndx+1, Snum_pitches
      cabbageSetValue Snum_pitches, kndx+1
      kpath_length = kndx+1
    endif
     printarray kPath_1
  endif
  
  Slocalpitch sprintf "localpitch_%i", ivoice
  klocalpitch chnget Slocalpitch
  Sdur sprintf "dur_%i", ivoice
  kdur chnget Sdur
  Schan sprintf "chan_%i", ivoice
  kchan chnget Schan
  if (kbeat*kmetro) > 0 && kchords == 0 then
    if klocalpitch > 0 then
      ; pitch path
      krand rnd31 0.5, 1
      krand += 0.5
      knote PitchPath krand, kPath_1, kpath_length, kpitchrange, kbasepitch, kgravity, kp_grid_balance 
      ;printk2 knote
      ; STACKED pitch paths
      ;knote PitchPath (knote-kbasepitch)/kpitchrange, kPath2, kpitchrange, kbasepitch, kgravity2
      ;knote PitchPath (knote-kbasepitch)/kpitchrange, kPath3, kpitchrange, kbasepitch, kgravity3 
    else
      ; sequence
      knote = kbasepitch+gkPitches[kcount%knum_pitches];24+(ivoice*12)+p8+kcount
    endif
    kvel = 60+(kindisp_soft*30)
    event "i", 201, 0, kdur, kvel, knote, kchan
  endif

  if (kbeat*kmetro) > 0 && kchords > 0 then
    kpitchindex = 0
    while kpitchindex <= knum_pitches do
      kvel = 60+(kindisp_soft*30)
      knote = kbasepitch+gkPitches[kpitchindex%knum_pitches];24+(ivoice*12)+p8+kcount
      event "i", 201, 0, kdur, kvel, knote, kchan
      kpitchindex += 1
    od
  endif

  kmeter_len chnget "meter_len"
  kcount = (kcount+kmetro) %kmeter_len
  Scount_sync_strength sprintf "count_sync_strength_%i", ivoice
  kcount_sync_strength chnget Scount_sync_strength
  kdiff = (kcount_in+1)-kcount ; for count sync
  if imaster != 0 then
    if abs(kdiff) > kmeter_len/2 then
      kdiff = kmeter_len-abs(kdiff)
    endif
    kcount = (kcount+kmetro*(kdiff*kcount_sync_strength)) %kmeter_len
  endif
  Scount_out sprintf "counter_%i", ivoice
  chnset kcount, Scount_out

endin

instr 201
  ; midi  output
    ivel = p4
    inote = p5
    ichan = p6

    idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    ;idur    = (p3 < 0.05 ? 0.05 : p3)  ; avoid extremely short notes as they won't play

    noteondur ichan, inote, ivel, idur
    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
