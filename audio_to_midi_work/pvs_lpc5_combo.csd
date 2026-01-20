<Cabbage>
form caption("Audio to midi 3_4 display"), size(600, 610), pluginId("at35"), colour(10,30,35), guiMode("queue")
combobox bounds(15, 5, 50, 16), channel("fftsize"), text(" "), items(512,1024, 2048, 4096, 8192), value(2)
button bounds(70, 5, 90, 16), channel("max_amps"), text("max(/acm)"), colour:0("black"), colour:1("green")
;nslider bounds(170, 5, 30, 16), channel("numband_rel_amp"), range(0,10,1,1,1), fontSize(13)
;label bounds(205, 5, 70, 16), text("n_relamp"), fontSize(11)

;gentable outlineThickness(1), bounds( 300,  0, 300,300), tableNumber(1,2), tablebackgroundColour("white"), tableGridColour(100,100,100,50), tableColour:0(0,200,0,200),tableColour:1(200,0,0,200),channel("ampFFT"), ampRange(0,0.2,-1), outlineThickness(0), sampleRange(0, 128) 
image bounds(300, 0, 300, 300), channel("graph1"), colour(0,0,0) 
button bounds(300, 305, 90, 16), channel("spect_display"), text("spect_display"), colour:0("black"), colour:1("green")
button bounds(300, 325, 90, 16), channel("emphasis"), text("emphasis"), colour:0("black"), colour:1("green")

button bounds(300, 345, 90, 16), channel("unwobble"), text("unwobble"), colour:0("black"), colour:1("green")
button bounds(300, 385, 90, 16), channel("peak_picking"), text("peaks"), colour:0("black"), colour:1("green")

nslider bounds(400, 305, 50, 16), channel("xzoom"), range(1,10,3, 1, 1), fontSize(13)
label bounds(455, 305, 70, 16), text("xzoom"), fontSize(11), align("left")
nslider bounds(400, 325, 50, 16), channel("emph_amount"), range(0,10,0.5), fontSize(13)
label bounds(455, 325, 70, 16), text("emph_amount"), fontSize(11), align("left")

nslider bounds(400, 345, 50, 16), channel("unwobble_thresh"), range(0,1,0.4), fontSize(13)
label bounds(455, 345, 70, 16), text("unwobble_thresh"), fontSize(11), align("left")
nslider bounds(400, 365, 50, 16), channel("unwobble_lolimit"), range(0,1,0.01, 1, 0.001), fontSize(13)
label bounds(455, 365, 70, 16), text("unwobble_lolimit"), fontSize(11), align("left")
nslider bounds(400, 385, 50, 16), channel("numpeaks"), range(0,20,8, 1, 1), fontSize(13)
label bounds(455, 385, 70, 16), text("numpeaks"), fontSize(11), align("left")

hslider bounds(15, 30, 270, 30), channel("lowNote"), text("lowNote"), range(0, 127, 36, 1, 1)
hslider bounds(15, 60, 270, 30), channel("highNote"), text("highNote"), range(0, 127, 112, 1, 1)
hslider bounds(15, 90, 270, 30), channel("ampOn"), text("ampOn"), range(-96, 0, -12, 2, 0.1)
hslider bounds(15, 120, 270, 30), channel("ampOff"), text("ampOff"), range(0.0, 1.0, 0.8, 0.25, 0.0001)
hslider bounds(15, 150, 270, 30), channel("smooth"), text("smooth"), range(0.01, 0.99, 0.5, 0.3, 0.001)
hslider bounds(15, 180, 270, 30), channel("rate"), text("rate"), range(2, 200, 100, 0.35)
hslider bounds(15, 210, 270, 30), channel("mindur"), text("mindur"), range(0, 500, 30)
hslider bounds(15, 240, 270, 30), channel("transpose"), text("transpose"), range(-12, 12, 0, 1, 1)
hslider bounds(15, 270, 270, 30), channel("centroid_split"), text("centr_split"), range(200, 3000, 1000, 1, 1)

csoundoutput bounds(15, 310, 290, 300), text("Csound Output")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

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
	ktime	times	
	kZC	trigger kepochSig, 0, 0		; zero cross
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
	kerr_threshold = 0.04 ; pitch track bypass on sibliants threshold
  kmedfilter_Hz = 8 ; pitch track median filter cutoff
  kharm_weight = 1 ; harmonics weighted or unweighted
  kmaxfreq_formant = 4000 ; formant max freq
  ; midi parms
  krate = 40
  kamp_off = 0.99
  klow_note = 24
  khigh_note = 127
  kmindur = 0.025
  kspect_midichan = 1
  ksibl_midichan = 2
  kfund_midichan = 3
  kform_midichan = 4

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
  kerr_lpc = kerr_lpc > kerr_threshold ? 1: kerr_lpc
  kcps_sh samphold, kcps, (1-kerr_lpc)
  kmedfilter_size = kr*(1/kmedfilter_Hz)
  kcps_filt mediank kcps, kmedfilter_size, kr
  ffund pvsosc krms, kcps_filt, 4, ifftsize, ifftsize/8
  kharmonics = kharm_weight == 1 ? 1 : 3 ; saw (weighted harmonics) or pulse (all same)
  fharm pvsosc krms, kcps_filt, kharmonics, ifftsize, ifftsize/8
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

  ; midi event processing
  kmetro metro krate
  ktime times

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