<CsoundSynthesizer>
<CsOptions>
-opvs_lpc4_midi.wav --midioutfile=pvs_lpc4_midi_lo_sens.mid
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1


; epoch filtering udo
	opcode EpochCps, k,a
	a1 xin 
	setksmps 8
	a20 butterbp a1, 20, 5
	a20 dcblock2 a20*40
	aepochSig	butlp a20, 200
	kepochSig	downsamp aepochSig
	kepochRms	rms aepochSig

  ; count epoch zero crossings
	ktime		times	
	kZC		trigger kepochSig, 0, 0		; zero cross
	kprevZCtim init 0
	kinterval1 init 0
	kinterval2 init 0
	kinterval3 init 0
	kinterval4 init 0
	if kZC > 0 then
	  kZCtim = ktime				; get time between zero crossings
	  kinterval4 = kinterval3
	  kinterval3 = kinterval2
	  kinterval2 = kinterval1
	  kinterval1 = kZCtim-kprevZCtim
	  kprevZCtim = kZCtim
	endif
	kmax max kinterval1, kinterval2, kinterval3, kinterval4
	kmin min kinterval1, kinterval2, kinterval3, kinterval4
	kZCmedi = (kinterval1+kinterval2+kinterval3+kinterval4-kmax-kmin)/2
	kepochZCcps	divz 1, kZCmedi, 1
	kepochZCcps mediank kepochZCcps, 40, 40
  xout kepochZCcps
	endop

instr 1

	a1 diskin "fox.wav", 1, 0, 1            ; then the fox
	ifftsize = 1024
	iorder = 150 ; lpc order
  kamp_thresh_spect = ampdbfs(-45) ; spectral amp thresh
  kamp_thresh_sibliant = ampdbfs(-45) ; spectral sibliants amp thresh
  kamp_thresh_form = ampdbfs(-45) ; formant amp thresh
  kcentroid_split = 2000
	
	kcps EpochCps a1     ; pitch analysis by epoch filtering and zero cross count
  kcps limit kcps, 10, 2000
  kcps_semi = int(12 * log2(kcps / 440) + 69)
  kcps = cpsmidinn(kcps_semi) ; qunatize to semitones

  ioverlap = ifftsize / 4
  iwinsize = ifftsize
  iwinshape = 1
  fspect pvsanal a1, ifftsize, ioverlap, iwinsize, iwinshape
  kcentroid pvscent fspect
  kcentroid samphold kcentroid, kcentroid

	; lpc, generate fundamental and all harmonics
  krms rms a1
  ifw ftgen 0, 0, 1024, 20, 2, 1             ; Hanning window for lpc (2 instances)
	kcfs_lpc[],krms_lpc,kerr_lpc,kcps_lpc lpcanal a1,1,128,1024,64,ifw
  kerr_threshold = 0.04
  kerr_lpc = kerr_lpc > kerr_threshold ? 1: kerr_lpc
  
  kcps_sh samphold, kcps, (1-kerr_lpc)
  kmedfilter_Hz = 8
  kmedfilter_size = kr*(1/kmedfilter_Hz)
  kcps_filt mediank kcps, kmedfilter_size, kr
  ffund pvsosc krms, kcps_filt, 4, ifftsize, ifftsize/8
  kharm_weight = 1
  kharmonics = kharm_weight == 1 ? 1 : 3 ; saw (weighted harmonics) or pulse (all same)
  fharm pvsosc krms, kcps_filt, kharmonics, ifftsize, ifftsize/8
  kmaxfreq_formant = 4000
	fharm_nofund pvsbandp fharm, kcps_filt*1.2, kcps_filt*1.8, kmaxfreq_formant, kmaxfreq_formant*1.2
  
  ; formant spectral envelope
	fenv pvslpc  a1, ifftsize, ifftsize/8, iorder, ifw
	fformants pvsfilter fharm_nofund, fenv, 1 
  
  ; tables for spectral processing
  iAmps_spect	ftgen	0, 0, ifftsize/2, 2, 0
  iFreqs_spect ftgen 0, 0, ifftsize/2, 2, 0
  iAmps_fund ftgen	0, 0, ifftsize/2, 2, 0
  iFreqs_fund ftgen 0, 0, ifftsize/2, 2, 0
  iAmps_form ftgen	0, 0, ifftsize/2, 2, 0
  iFreqs_form ftgen 0, 0, ifftsize/2, 2, 0
  
  ; tables for midi note amplitudes
  iNoteAmpsClear ftgen	0, 0, 128, 2, 0
  iNoteAmpsFundamental ftgen	0, 0, 128, 2, 0
  iNoteAmpsFormants ftgen	0, 0, 128, 2, 0
  iNoteAmpsSpectral ftgen	0, 0, 128, 2, 0
  iNoteAmpsSibliants ftgen	0, 0, 128, 2, 0
  iEventTimeFundamental ftgen	0, 0, 128, 2, 0
  iEventTimeFormants ftgen	0, 0, 128, 2, 0
  iEventTimeSpectral ftgen	0, 0, 128, 2, 0
  iEventTimeSibliants ftgen	0, 0, 128, 2, 0

  kflag pvsftw fspect, iAmps_spect, iFreqs_spect
  kfl_ pvsftw ffund, iAmps_fund, iFreqs_fund
  kfl_ pvsftw fformants, iAmps_form, iFreqs_form

  if kflag > 0 then
    tablecopy iNoteAmpsFundamental, iNoteAmpsClear
    tablecopy iNoteAmpsFormants, iNoteAmpsClear
    tablecopy iNoteAmpsSpectral, iNoteAmpsClear
    tablecopy iNoteAmpsSibliants, iNoteAmpsClear

    kindx = 0
    while kindx < ifftsize do
      kfreq_spect	table kindx, iFreqs_spect
      knote_spect	= round(12 * (log(kfreq_spect/440)/log(2)) + 69)
      kfreq_fund table kindx, iFreqs_fund
      knote_fund = round(12 * (log(kfreq_fund/440)/log(2)) + 69)
      kfreq_form table kindx, iFreqs_form
      knote_form = round(12 * (log(kfreq_form/440)/log(2)) + 69)

      kamp_spect table kindx, iAmps_spect
      kamp_fund table kindx, iAmps_fund
      kamp_form table kindx, iAmps_form
  
      if kcentroid < kcentroid_split then
        if kamp_spect > kamp_thresh_spect then
          kamp_spect_0 table knote_spect, iNoteAmpsSpectral
          tablew (kamp_spect+kamp_spect_0), knote_spect, iNoteAmpsSpectral		; accumulate amps
        endif 
      else
        if kamp_spect > kamp_thresh_sibliant then
          kamp_spect_0 table knote_spect, iNoteAmpsSibliants
          tablew (kamp_spect+kamp_spect_0), knote_spect, iNoteAmpsSibliants		; accumulate amps
        endif 
      endif
      if kamp_fund > kamp_thresh_form then
        kamp_fund_0 table knote_fund, iNoteAmpsFundamental
        tablew (kamp_fund+kamp_fund_0), knote_fund, iNoteAmpsFundamental		; accumulate amps
      endif 
      if kamp_form > kamp_thresh_form then
        kamp_form_0 table knote_form, iNoteAmpsFormants
        tablew (kamp_form+kamp_form_0), knote_form, iNoteAmpsFormants		; accumulate amps
      endif 
      kindx = kindx	+ 1
    od
  endif

  ; midi parms
  krate = 40
  kamp_off = 0.99
  klow_note = 24
  khigh_note = 127
  kmindur = 0.025
  ktime times
  kspect_midichan = 1
  ksibl_midichan = 2
  kfund_midichan = 3
  kform_midichan = 4

  kmetro metro krate
  if kmetro > 0 then
    knote = 0
    while knote < 128 do
      ktimstart_spectral table knote, iEventTimeSpectral
      kamp_spect table knote, iNoteAmpsSpectral
      if (kamp_spect > kamp_thresh_spect) && (ktimstart_spectral == 0) \
          && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
        kvelocity = int(tanh(((kamp_spect*(1/ampdbfs(-10)))^0.5)*2)*117)+10
        kinstNum = 201.1 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, kspect_midichan
        tablew ktime, knote, iEventTimeSpectral			; and add note (onset time) to active events
      endif
      if (ktimstart_spectral > 0) && ((ktime-ktimstart_spectral) > kmindur) \
          && (kamp_spect < kamp_off*kamp_thresh_spect) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
        kinstNum = 201.1 + (knote*0.001)
        event "i", -kinstNum, 0, .1, 0, knote, kspect_midichan
        tablew 0, knote, iEventTimeSpectral				; remove note from active events
      endif
      knote = knote + 1
    od
  endif

  if kmetro > 0 then
    knote = 0
    while knote < 128 do
      ktimstart_sibliants table knote, iEventTimeSibliants
      kamp_sibl table knote, iNoteAmpsSibliants
      if (kamp_sibl > kamp_thresh_sibliant) && (ktimstart_sibliants == 0) \
          && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
        kvelocity = int(tanh(((kamp_sibl*(1/ampdbfs(-10)))^0.5)*2)*117)+10
        kinstNum = 201.2 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, ksibl_midichan
        tablew ktime, knote, iEventTimeSibliants			; and add note (onset time) to active events
      endif
      if (ktimstart_sibliants > 0) && ((ktime-ktimstart_sibliants) > kmindur) \
          && (kamp_sibl < kamp_off*kamp_thresh_sibliant) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
        kinstNum = 201.2 + (knote*0.001)
        event "i", -kinstNum, 0, .1, 0, knote, ksibl_midichan
        tablew 0, knote, iEventTimeSibliants				; remove note from active events
      endif
      knote = knote + 1
    od
  endif

  if kmetro > 0 then
    knote = 0
    while knote < 128 do
      ktimstart_fundamental table knote, iEventTimeFundamental
      kamp_fund table knote, iNoteAmpsFundamental
      if (kamp_fund > kamp_thresh_form) && (ktimstart_fundamental == 0) \
          && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
        kvelocity = int(tanh(((kamp_fund*(1/ampdbfs(-10)))^0.5)*2)*117)+10
        kinstNum = 201.3 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, kfund_midichan
        tablew ktime, knote, iEventTimeFundamental			; and add note (onset time) to active events
      endif
      if (ktimstart_fundamental > 0) && ((ktime-ktimstart_fundamental) > kmindur) \
          && (kamp_fund < kamp_off*kamp_thresh_form) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
        kinstNum = 201.3 + (knote*0.001)
        event "i", -kinstNum, 0, .1, 0, knote, kfund_midichan
        tablew 0, knote, iEventTimeFundamental				; remove note from active events
      endif
      knote = knote + 1
    od
  endif

  if kmetro > 0 then
    knote = 0
    while knote < 128 do
      ktimstart_formant table knote, iEventTimeFormants
      kamp_form table knote, iNoteAmpsFormants
      if (kamp_form > kamp_thresh_form) && (ktimstart_formant == 0) \
          && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
        kvelocity = int(tanh(((kamp_form*(1/ampdbfs(-10)))^0.5)*2)*117)+10
        kinstNum = 201.4 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, kform_midichan
        tablew ktime, knote, iEventTimeFormants			; and add note (onset time) to active events
      endif
      if (ktimstart_formant > 0) && ((ktime-ktimstart_formant) > kmindur) \
          && (kamp_form < kamp_off*kamp_thresh_form) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
        kinstNum = 201.4 + (knote*0.001)
        event "i", -kinstNum, 0, .1, 0, knote, kform_midichan
        tablew 0, knote, iEventTimeFormants				; remove note from active events
      endif
      knote = knote + 1
    od
  endif

	a3 pvsynth fformants             
	a3 dcblock a3*40
  asin oscil krms, kcps*2
	;outs a(kcps/600), a3*0.1
  ;outs a(kerr_lpc), a3*0.1*(1-(kerr_lpc))
  outs a(kerr_lpc), a3*0.1
endin


;***************************************************
; midi out instrument
;***************************************************
instr	201

  idur		= (p3 < 0 ? 999 : p3)	; use very long duration for realtime events, noteondur will create note off when instrument stops
  ivel		= p4
  inum		= p5
;  print inum, ivel
  ichn		= p6
  noteondur ichn, inum, ivel, idur
endin
;***************************************************

</CsInstruments>
<CsScore>
i1  0  10 
e
</CsScore>
</CsoundSynthesizer>