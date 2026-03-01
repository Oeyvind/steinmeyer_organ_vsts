<Cabbage>
form caption("Midi granulator 4") size(900, 430), colour(30, 35, 40), guiMode("queue"), pluginId("mgr4")

button  bounds(  5, 10, 50, 30), channel("absdur"), text("absdur"), colour:0("black"), colour:1("green")
;rslider bounds( 65,  5, 50, 50), channel("duration"), text("Duration"), range(0,1,0.5, 0.3, 0.0001)
rslider bounds(115, 5, 50, 50), channel("rdur"), text("Rdur"), range(0,3,0, 0.3, 0.0001)
rslider bounds(165, 5, 50, 50), channel("d_keyfollow"), text("d_kbf"), range(-3,3,0)
rslider bounds(265, 5, 50, 50), channel("rmask"), text("Rmask"), range(0, 1, 0, 0.3)
rslider bounds(315, 5, 50, 50), channel("rpitch"), text("Rpitch"), range(0, 12, 0, 1,1)
;rslider bounds(365, 5, 50, 50), channel("transpose"), text("Transpose"), range(-24, 24, 0, 1, 1)

button  bounds(  5, 70, 50, 20), channel("sync"), text("sync"), colour:0("black"), colour:1("green")
rslider bounds(  5, 90, 30, 30), channel("fallback"), text("fallback"), range(0, 1, 0, 0.3, 0.01)
rslider bounds( 65, 65, 50, 50), channel("sync_rate"), text("s_Tpo"), range(0, 0.5, 0.001, 0.3, 0.0001)
rslider bounds(115, 65, 50, 50), channel("sync_phase"), text("s_Phas"), range(0, 1, 0.0, 0.5, 0.0001)
rslider bounds(165, 65, 50, 50), channel("t_init_offset"), text("Ti_offset"), range(0, 1, 0)
rslider bounds(215, 65, 50, 50), channel("vel_t_offset"), text("Vel_t"), range(0, 1, 0)
rslider bounds(265, 65, 50, 50), channel("rphase"), text("Rphase"), range(0, 1, 0, 0.6)
rslider bounds(315, 65, 50, 50), channel("rtempo"), text("Rtempo"), range(0,1,0, 0.3, 0.0001)
;rslider bounds(365, 65, 50, 50), channel("master_tempo"), text("M_tmpo"), range(1,20,2, 1)

rslider bounds(440,  5, 50, 50), channel("tempo_1"), text("Tpo1"), range(2,22,2,0.5)
rslider bounds(440, 65, 50, 50), channel("tempo_2"), text("Tpo2"), range(2,22,2,0.5)
rslider bounds(440,125, 50, 50), channel("tempo_3"), text("Tpo3"), range(2,22,2,0.5)
rslider bounds(440,185, 50, 50), channel("tempo_4"), text("Tpo4"), range(2,22,2,0.5)
rslider bounds(440,245, 50, 50), channel("tempo_8"), text("Tpo8"), range(2,22,2,0.5)

rslider bounds(500,   5, 50, 50), channel("duration_1"), text("Dur1"), range(0.01,0.3,0.05, 0.3, 0.0001)
rslider bounds(500,  65, 50, 50), channel("duration_2"), text("Dur2"), range(0.01,0.3,0.05, 0.3, 0.0001)
rslider bounds(500, 125, 50, 50), channel("duration_3"), text("Dur3"), range(0.01,0.3,0.05, 0.3, 0.0001)
rslider bounds(500, 185, 50, 50), channel("duration_4"), text("Dur4"), range(0.01,0.3,0.05, 0.3, 0.0001)
rslider bounds(500, 245, 50, 50), channel("duration_8"), text("Dur8"), range(0.01,0.3,0.05, 0.3, 0.0001)

rslider bounds(560,  5, 50, 50), channel("transp_1"), text("Trsp1"), range(-12,12,0, 1, 1)
rslider bounds(560, 65, 50, 50), channel("transp_2"), text("Trsp2"), range(-12,12,0, 1, 1)
rslider bounds(560,125, 50, 50), channel("transp_3"), text("Trsp3"), range(-12,12,0, 1, 1)
rslider bounds(560,185, 50, 50), channel("transp_4"), text("Trsp4"), range(-12,12,0, 1, 1)
rslider bounds(560,245, 50, 50), channel("transp_8"), text("Trsp8"), range(-12,12,0, 1, 1)

checkbox bounds(620, 10, 60, 20), channel("midi_to_1"), text("Mid1")
checkbox bounds(620, 70, 60, 20), channel("midi_to_2"), text("Mid2")
checkbox bounds(620,130, 60, 20), channel("midi_to_3"), text("Mid3")
checkbox bounds(620,190, 60, 20), channel("midi_to_4"), text("Mid4")
checkbox bounds(620,250, 60, 20), channel("midi_to_8"), text("Mid8")

button  bounds(  5, 130, 65, 20), channel("clear_all"), text("clear all"), latched(0), colour:0("green"), colour:1("red")
button  bounds( 75, 130, 65, 20), channel("clear_ch_1"), text("clear_ch_1"), latched(0), colour:0("green"), colour:1("red")
button  bounds(145, 130, 65, 20), channel("clear_ch_2"), text("clear_ch_2"), latched(0), colour:0("green"), colour:1("red")
button  bounds(215, 130, 65, 20), channel("clear_ch_3"), text("clear_ch_3"), latched(0), colour:0("green"), colour:1("red")
button  bounds(285, 130, 65, 20), channel("clear_ch_4"), text("clear_ch_4"), latched(0), colour:0("green"), colour:1("red")
button  bounds(355, 130, 65, 20), channel("clear_ch_8"), text("clear_ch_8"), latched(0), colour:0("green"), colour:1("red")

csoundoutput bounds(0, 155, 425, 150)

label bounds(10, 312, 190, 20), text("Active stream monitor (5 octaves)")
combobox bounds(205, 312, 170, 20), channel("viz_chan"), text("MIDI ch 1","MIDI ch 2","MIDI ch 3","MIDI ch 4","MIDI ch 8"), value(1)

button bounds( 10, 340, 16, 80), channel("viz_36"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds( 26, 340, 16, 80), channel("viz_38"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds( 42, 340, 16, 80), channel("viz_40"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds( 58, 340, 16, 80), channel("viz_41"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds( 74, 340, 16, 80), channel("viz_43"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds( 90, 340, 16, 80), channel("viz_45"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(106, 340, 16, 80), channel("viz_47"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(122, 340, 16, 80), channel("viz_48"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(138, 340, 16, 80), channel("viz_50"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(154, 340, 16, 80), channel("viz_52"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(170, 340, 16, 80), channel("viz_53"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(186, 340, 16, 80), channel("viz_55"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(202, 340, 16, 80), channel("viz_57"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(218, 340, 16, 80), channel("viz_59"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(234, 340, 16, 80), channel("viz_60"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(250, 340, 16, 80), channel("viz_62"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(266, 340, 16, 80), channel("viz_64"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(282, 340, 16, 80), channel("viz_65"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(298, 340, 16, 80), channel("viz_67"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(314, 340, 16, 80), channel("viz_69"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(330, 340, 16, 80), channel("viz_71"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(346, 340, 16, 80), channel("viz_72"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(362, 340, 16, 80), channel("viz_74"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(378, 340, 16, 80), channel("viz_76"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(394, 340, 16, 80), channel("viz_77"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(410, 340, 16, 80), channel("viz_79"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(426, 340, 16, 80), channel("viz_81"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(442, 340, 16, 80), channel("viz_83"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(458, 340, 16, 80), channel("viz_84"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(474, 340, 16, 80), channel("viz_86"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(490, 340, 16, 80), channel("viz_88"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(506, 340, 16, 80), channel("viz_89"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(522, 340, 16, 80), channel("viz_91"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(538, 340, 16, 80), channel("viz_93"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)
button bounds(554, 340, 16, 80), channel("viz_95"), text("",""), latched(1), value(0), colour:0(230,230,230), colour:1(80,220,120)

button bounds( 21, 340, 10, 48), channel("viz_37"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds( 37, 340, 10, 48), channel("viz_39"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds( 69, 340, 10, 48), channel("viz_42"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds( 85, 340, 10, 48), channel("viz_44"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(101, 340, 10, 48), channel("viz_46"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(133, 340, 10, 48), channel("viz_49"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(149, 340, 10, 48), channel("viz_51"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(181, 340, 10, 48), channel("viz_54"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(197, 340, 10, 48), channel("viz_56"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(213, 340, 10, 48), channel("viz_58"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(245, 340, 10, 48), channel("viz_61"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(261, 340, 10, 48), channel("viz_63"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(293, 340, 10, 48), channel("viz_66"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(309, 340, 10, 48), channel("viz_68"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(325, 340, 10, 48), channel("viz_70"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(357, 340, 10, 48), channel("viz_73"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(373, 340, 10, 48), channel("viz_75"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(405, 340, 10, 48), channel("viz_78"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(421, 340, 10, 48), channel("viz_80"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(437, 340, 10, 48), channel("viz_82"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(469, 340, 10, 48), channel("viz_85"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(485, 340, 10, 48), channel("viz_87"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(517, 340, 10, 48), channel("viz_90"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(533, 340, 10, 48), channel("viz_92"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
button bounds(549, 340, 10, 48), channel("viz_94"), text("",""), latched(1), value(0), colour:0(20,20,20), colour:1(255,170,70)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d; -b4 -B8 
</CsOptions>
<CsInstruments>

ksmps = 2
massign -1, 2
pgmassign -1, -1

gimetro_instr = 3
giVoices1 ftgen 0, 0, 127, 2, 0 ; to hold active voices
giVoices2 ftgen 0, 0, 127, 2, 0 ; to hold active voices
giVoices3 ftgen 0, 0, 127, 2, 0 ; to hold active voices
giVoices4 ftgen 0, 0, 127, 2, 0 ; to hold active voices
giVoices8 ftgen 0, 0, 127, 2, 0 ; to hold active voices
giVoices ftgen 0, 0, 8, -2, giVoices1,giVoices2,giVoices3,giVoices4,0,0,0,giVoices8 ; to hold voice table
giVoiceclear ftgen 0, 0, 127, 2, 0 ; empty, to reset active voices

  opcode RhythmPLL3, kkk, kikkkkkk
  ; PLL for rhythmic synchronization
  ; Oeyvind Brandtsegg 2021 oyvind.brandtsegg@ntnu.no
  ; Licence: Creative commons CC BY (use as you like but you *must* credit)
  ; outputs: pulse, phase (ramp), and frequency
  ; inputs: ext clock phase, init frequency, tempo_update, freq adjust gain, phase adjust amount, numpulses (subdivision), kdeviation, kfallback (to init tempo)
  k_ext_phase, ifq, kfq_update, kgain, kphaseadjust, knumpulses, kdev, kfallback xin
  
  ; oscillator
  kfq init ifq
  kfirst init 1
  if changed(kfq_update) > 0 && kfirst == 0 then
    kfq = kfq_update
  endif
  kfirst = 0

  kosc init 0
  kphase_offset init 0
  kosc += (kfq/kr) ; increment ramp value 
  kosc = kosc > 1 ? 0 : kosc ; wrap around
  kosc_phasecorr wrap kosc+kphase_offset, 0, 1; add phase offset
  
  if kfallback > 0 then
    kfq = kfq+((ifq-kfq)*(kfallback^3)*0.0006)
    ;kphaseadjust *= 1-(kfallback^0.5)
  endif

  ; table lookup for sub-beat pulse patterns
  ; defaults to one tick at the beginning of each beat
  ; a table with just a 1 at the beginning is the default
  ; a table with several pulses distributed equally (or randomly) can be used to subdivide the beat
  kone trigger kosc, 0.5, 1 ; downwards trigger when wrapping
  ipulsetab_size = 4096
  itab ftgentmp 0, 0, ipulsetab_size, 2, 0 ; blank table
  itabclear ftgentmp 0, 0, ipulsetab_size, 2, 0 ; blank table
  ipulse = ipulsetab_size
  kupdate init 1
  kupdate += changed(knumpulses)
  kupdate += kdev
  if kupdate > 0 && kone > 0 then
    reinit pulses
    pulses:
    tableicopy itab, itabclear
    ipulse -= ipulsetab_size
    icount = 1
    while ipulse < ipulsetab_size do
      ipulse_offset = ipulsetab_size/limit(i(knumpulses),1,ipulsetab_size)
      irand rnd31 ipulse_offset, 1
      tablew 1, ipulse+(i(kdev)*abs(irand))+ksmps-1, itab, 0, 0, 1
      ipulse += ipulse_offset
      icount += 1
    od
    kupdate = 0
  endif
  avect tablera itab, kosc_phasecorr*4096, 0
  kVect[] init ksmps
  kVect shiftin avect
  ktrig sumarray kVect
  ktrig trigger ktrig, 0.5, 0
  
  ; phase difference detector
  ; we want to calculate the phase difference between internal and external phase
  ; then adjust the internal tempo accordingly
  kdiff_prev init 0
  kdiff = k_ext_phase - kosc ; phase difference
  kfq_adjust_coef = abs(kdiff) > 0.5 ? 1-abs(kdiff) : abs(kdiff) ; adjust most for difference around 0.5, little near 0.0 and near 1.0
  kdiff_diff = kdiff_prev-kdiff ; how much the phase difference increase or decrease
  kdiff_diff = abs(kdiff_diff) > 0.5 ? 0 : kdiff_diff ; skip if it is too large (happens when one of the two has a pphase wrap/reset)
  
  kfq_adjust = (kfq*kfq_adjust_coef*-1*signum(kdiff_diff))
  kfq = kfq+(kfq_adjust*kgain)
  kdiff_prev = kdiff ; update previous diff

  kphase_adjust_coef = kdiff > 0.5 ? kdiff-1 : kdiff ; flip sign around the midpoint
  kphase_adjust_coef = kdiff < -0.5 ? kdiff+1 : kphase_adjust_coef ; same when it goes negative
  kphase_adjust_scaler tonek (1-limit(kdiff_diff*kr*0.5, 0, 1))^3, 0.3 ; only adjust phase when fq is already close
  kphase_adjust_coef *= kphase_adjust_scaler
  kphase_offset tonek kphase_adjust_coef*kphaseadjust, 1
  
  xout ktrig, kosc_phasecorr, kfq
endop

; stop instr for specific channel and clear the corresponding note active table
opcode ClearButton, 0, i
  ichan xin
  Schan sprintf "clear_ch_%i", ichan
  kclear chnget Schan
  iVoicetab table ichan-1, giVoices
  if trigger(kclear,0.5,0) > 0 then
    kndx = 0
    kplaying = 0
    while kndx < 128 do
      kplaying table kndx, iVoicetab
      if table(kndx,iVoicetab) > 0 then
        turnoff2 gimetro_instr+(ichan-1)+(kndx*0.001), 0, 4
      endif
      tablew 0, kndx, iVoicetab
      kndx += 1
    od
  endif
endop

instr 98
  ; visual monitor for active stream notes (5 octaves: MIDI 36..95)
  kviz_sel chnget "viz_chan"
  kviz_ch = (kviz_sel == 5 ? 8 : kviz_sel)

  kvoicetab = giVoices1
  if kviz_ch == 1 then
    kvoicetab = giVoices1
  elseif kviz_ch == 2 then
    kvoicetab = giVoices2
  elseif kviz_ch == 3 then
    kvoicetab = giVoices3
  elseif kviz_ch == 4 then
    kvoicetab = giVoices4
  elseif kviz_ch == 8 then
    kvoicetab = giVoices8
  endif

  kupdate metro 20
  kchan_change changed kviz_ch
  ktrig = (kupdate > 0 || kchan_change > 0 ? 1 : 0)
  if ktrig > 0 then
    knote = 36
    while knote < 96 do
      kactive tablekt knote, kvoicetab
      Skey sprintfk "viz_%d", knote
      cabbageSetValue Skey, (kactive > 0 ? 1 : 0), ktrig
      knote += 1
    od
  endif
endin

instr 1
  ; GUI control
  kclear chnget "clear_all"
  if trigger(kclear,0.5,0) > 0 then
    turnoff2 gimetro_instr, 0, 1
    tablecopy giVoices1, giVoiceclear
    tablecopy giVoices2, giVoiceclear
    tablecopy giVoices3, giVoiceclear
    tablecopy giVoices4, giVoiceclear
    tablecopy giVoices8, giVoiceclear
  endif

  ClearButton 1
  ClearButton 2
  ClearButton 3
  ClearButton 4
  ClearButton 8

; TEST
  ;kinphase phasor 2
  ;chnset kinphase, "ext_phase"

endin

instr 2
  ; midi notes input, 
  ; trigger held notes on noteoff if note held longer than thresh
  ; turn off notes on noteoff if note held shorter than thresh
  inote notnum
  ivel veloc 0, 1
  ichn midichn
  imidi1 chnget "midi_to_1"
  imidi2 chnget "midi_to_2"
  imidi3 chnget "midi_to_3"
  imidi4 chnget "midi_to_4"
  imidi8 chnget "midi_to_8"
  ichn = imidi1 > 0 ? 1 : ichn
  ichn = imidi2 > 0 ? 2 : ichn
  ichn = imidi3 > 0 ? 3 : ichn
  ichn = imidi4 > 0 ? 4 : ichn
  ichn = imidi8 > 0 ? 8 : ichn
  ihold_thresh = 0.3
  instnum = gimetro_instr+(ichn-1)+(inote*0.001)
  iVoicetab table ichn-1, giVoices
  ktime timeinsts
  ktrig lastcycle
  knote = inote ; needed just to force the table update at k-rate
  if ktrig > 0 then
    if ktime >= ihold_thresh then
      event "i", instnum, 0, -1, inote, ivel, ichn
      tablew 1, knote, iVoicetab
      chnset k(instnum), "last_started_voice"
    else
      event "i", -instnum, 0, .1
      tablew 0, knote, iVoicetab
    endif
  endif
endin

instr 3,4,5,6,10

  inote = p4
  ivel = p5
  ichan = p6
  print p1, inote, ichan
  Stranspose sprintf "transp_%i", ichan
  ktranspose chnget Stranspose
  krpitch chnget "rpitch"
  krmask chnget "rmask"
  knote = inote+ktranspose

  ;ktempo_bps chnget "master_tempo"
  Stempo sprintf "tempo_%i", ichan
  ktempo_bps chnget Stempo
  itempo_bps chnget Stempo
  print itempo_bps
  ktempo_bps init itempo_bps ; make sure it is valid at i-time
  ;ktempo_bps_filt tonek ktempo_bps, 0.2
  if changed(ktempo_bps) > 0 then
    ktempo_update = ktempo_bps
  endif
  ktempo_update init itempo_bps
  ;printk2 ktempo_update, p1*2

  ;kdur chnget "duration"
  Sdur sprintf "duration_%i", ichan
  kdur chnget Sdur
  krdur chnget "rdur"
  kdur_keyfollow chnget "d_keyfollow"
  kdur += (knote/100*kdur_keyfollow*kdur)
  kabsdur chnget "absdur"

  kcount_up init 0
  kcount_down init 0
  krtempo chnget "rtempo"
  
  klast_started_voice chnget "last_started_voice"
  k_is_master = p1 == klast_started_voice ? 1 : 0
  kinphase chnget "ext_phase"

  itempo_init_offset = 1; (bypass)chnget "t_init_offset"

  ivelocity_tempo chnget "vel_t_offset"
  ifq = (itempo_init_offset*itempo_bps)+(ivelocity_tempo*ivel*itempo_bps)
  print ifq, itempo_init_offset
  ksync_on chnget "sync"
  kfqgain = chnget:k("sync_rate")*ksync_on*0.002*(1-k_is_master)
  kphaseadjust = chnget:k("sync_phase")*ksync_on*(1-k_is_master)
  kphaseadjust tonek kphaseadjust, 0.1
  krphase chnget "rphase"
  knumpulses = 1
  kfallback chnget "fallback"
  ktrig, kphase, kfq RhythmPLL3 kinphase, ifq, ktempo_update, kfqgain, kphaseadjust, knumpulses, krphase, kfallback
  printk2 int(kfq*10)/10, p1*2
  if k_is_master > 0 then
    chnset kphase, "ext_phase"
  endif
  
  if ktrig > 0 && krtempo > 0 then
    krand_t_init trigger krtempo, 0, 0
    ktempo_update = krand_t_init > 0 ? kfq : ktempo_update ; set base tempo for random dev when initiating random dev
    if ktempo_update > kfq then
      kcount_up += 1
      kcount_down = 1
    else
      kcount_down += 1
      kcount_up = 1
    endif
    ; random tempo adjustment
    if ktempo_update > kfq*(1+krtempo) then
      ktempo_update -= random(limit(kcount_up,kfq*0.1,kfq), kfq*krtempo*1.8)
    elseif ktempo_update < kfq*(1-krtempo) then
      ktempo_update += random(limit(kcount_down,kfq*0.1,kfq), kfq*krtempo*1.8)
    else  
      ktempo_update += random(-kfq*krtempo*0.8,kfq*krtempo*0.8)
    endif
    ktempo_update limit ktempo_update, ktempo_update*(1-(krtempo*0.5)), ktempo_update*(1+krtempo)
    ktempo_update limit ktempo_update, kfq*0.3, 40 ; sanitize
  endif
  
  i_nstrnum = 201+frac(p1)  
  if ktrig > 0 then
    krand_pitch rnd31 1, -0.15; favor smaller deviations
    krand_pitch *= krpitch
    krandur rnd31 1, 1
    kdur = kabsdur > 0 ? limit(kdur, 0,(1/kfq)-0.01) : kdur/kfq
    if random:k(0,1) > krmask then
      event "i", i_nstrnum, 0, kdur+(krandur*kdur*krdur), ivel, knote+krand_pitch, ichan
    endif
  endif

endin

instr 201
  ; midi  output
  ivel = p4*127
  inote = p5
  ichan = p6
  idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
  ;idur    = (p3 < 0.0105 ? 0 : p3)  ; avoid extremely short notes as they won't play
  noteondur ichan, inote, ivel, idur
  a1 oscil ivel, cpsmidinn(inote)
  outs a1, a1

endin

</CsInstruments>
<CsScore>
i1 0 86400
i98 0 86400

</CsScore>
</CsoundSynthesizer>
