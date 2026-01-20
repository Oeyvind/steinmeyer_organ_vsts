<Cabbage>
form caption("Audio to midi lpc combo"), size(400, 610), pluginId("atlm"), colour(10,30,35), guiMode("queue")

nslider bounds( 10, 10, 60, 30), channel("low_note"), text("lownote"), fontSize(15), range(0, 127, 36, 1, 1)
nslider bounds( 80, 10, 60, 30), channel("high_note"), text("highnote"), fontSize(15), range(0, 127, 112, 1, 1)

nslider bounds( 10, 50, 60, 30), channel("rate"), text("rate"), fontSize(15), range(2, 200, 40, 1, 1)
nslider bounds( 80, 50, 60, 30), channel("mindur"), text("mindur"), fontSize(15), range(0, 500, 30, 1, 1)
nslider bounds(150, 50, 60, 30), channel("amp_off"), text("amp_off"), fontSize(15), range(0, 1, 0.9)

hslider bounds(10, 90, 200, 30), channel("spect_thresh"), range(-96, 0, -40, 2, 0.1)
label bounds(220, 90, 100, 30), text("spect thresh"),fontSize(12)
checkbox bounds(215, 97, 15, 15), channel("spect_on"), value(1)
nslider bounds(315, 90, 40, 30), channel("spect_minfreq"), text("minfreq"), fontSize(14), range(20, 5000, 100, 1, 1)
nslider bounds(355, 90, 40, 30), channel("spect_maxfreq"), text("maxfreq"), fontSize(14), range(20, 15000, 3000, 1, 1)
hslider bounds(10, 120, 200, 30), channel("sibl_thresh"), range(-96, 0, -40, 2, 0.1)
label bounds(215, 120, 100, 30), text("sibl thresh"),fontSize(12)
checkbox bounds(215, 127, 15, 15), channel("sibl_on"), value(1)
nslider bounds(315, 120, 40, 30), channel("sibl_minfreq"), text("minfreq"), fontSize(14), range(20, 5000, 100, 1, 1)
nslider bounds(355, 120, 40, 30), channel("sibl_maxfreq"), text("maxfreq"), fontSize(14), range(20, 15000, 3000, 1, 1)

nslider bounds( 10, 150, 60, 30), channel("centroid_split"), text("centr_split"), fontSize(14), range(200, 10000, 1000, 1, 1)
nslider bounds( 80, 150, 60, 30), channel("mchan_spect"), text("mchan spect"), fontSize(14), range(1, 16, 1, 1, 1)
nslider bounds(150, 150, 60, 30), channel("mchan_sibl"), text("mchan sibl"), fontSize(14), range(1, 16, 2, 1, 1)
nslider bounds(220, 150, 60, 30), channel("spect_smooth"), text("smooth"), fontSize(14), range(0, 1, 0.5)
combobox bounds(290, 164, 60, 16), channel("fftsize"), text("fftsize"), items(1024, 2048), value(2)

hslider bounds(10, 190, 200, 30), channel("fund_thresh"), range(-96, 0, -40, 2, 0.1)
label bounds(215, 190, 100, 30), text("fund thresh"),fontSize(12)
checkbox bounds(215, 197, 15, 15), channel("fund_on"), value(1)
hslider bounds(10, 220, 200, 30), channel("form_thresh"), range(-96, 0, -40, 2, 0.1)
label bounds(215, 220, 100, 30), text("form thresh"),fontSize(12)
checkbox bounds(215, 227, 15, 15), channel("form_on"), value(1)
nslider bounds( 10, 250, 60, 30), channel("median_Hz"), text("pitch filt"), fontSize(14), range(2, 20, 8, 1, 1)
nslider bounds( 80, 250, 60, 30), channel("mchan_fund"), text("mchan fund"), fontSize(14), range(1, 16, 3, 1, 1)
nslider bounds(150, 250, 60, 30), channel("mchan_form"), text("mchan form"), fontSize(14), range(1, 16, 4, 1, 1)
nslider bounds( 10, 290, 60, 30), channel("err_thresh"), text("p. err thresh"), fontSize(14), range(0, 1, 0.04)
nslider bounds( 80, 290, 60, 30), channel("max_fq_form"), text("max fq form"), fontSize(14), range(300, 20000, 3000, 1, 1)
checkbox bounds(150, 304, 60, 15), channel("harm_weight")
label bounds(150, 285, 100, 22), text("harm weight"), align("left"), fontSize(10)

csoundoutput bounds(0, 330, 400, 280), text("Csound Output")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0
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

  a1, a2_ ins
  kfftsize chnget "fftsize"
  kFftsizes[] fillarray 1024, 2048
  kfftsize = kFftsizes[kfftsize-1]
  if changed(kfftsize) > 0 then
    reinit set_fftsize
  endif
  set_fftsize:
  ifftsize 	= i(kfftsize)
  ifftsize = ifftsize == 0 ? 2048 : ifftsize
 
  ; GUI parms
  kamp_thresh_spect = ampdbfs(chnget:k("spect_thresh"))  ; spectral amp thresh
  kspect_minfreq chnget "spect_minfreq"
  kspect_maxfreq chnget "spect_maxfreq"
  kspect_on chnget "spect_on"
  kspect_maxfreq = kspect_on == 0 ? 0 : kspect_maxfreq ; bypass by means of zero freq range
  kamp_thresh_sibliant = ampdbfs(chnget:k("sibl_thresh")-15) ; spectral sibliants amp thresh, higher sensitivity
  ksibl_minfreq chnget "sibl_minfreq"
  ksibl_maxfreq chnget "sibl_maxfreq"
  ksibl_on chnget "sibl_on"
  ksibl_maxfreq = ksibl_on == 0 ? 0 : ksibl_maxfreq ; bypass by means of zero freq range
  kspect_smooth chnget "spect_smooth"
  kamp_thresh_fund = ampdbfs(chnget:k("fund_thresh")) ; fundamental amp thresh
  kfund_on chnget "fund_on"
  kamp_thresh_fund = kfund_on == 0 ? 99 : kamp_thresh_fund ; bypass by means of high amp thresh
  kharm_weight chnget "harm_weight" ; harmonics weighted or unweighted
  kamp_thresh_form = ampdbfs(chnget:k("form_thresh")-30-((1-kharm_weight)*18)) ; formant amp thresh, higher sensitivity
  kform_on chnget "form_on"
  kamp_thresh_form = kform_on == 0 ? 99 : kamp_thresh_form ; bypass by means of high amp thresh
  kcentroid_split chnget "centroid_split"
  kerr_threshold = chnget:k("err_thresh")^2 ; pitch track bypass on sibliants threshold. Increased parameter resolution by the exponent 
  kmedfilter_Hz chnget "median_Hz" ; pitch track median filter cutoff
  kmaxfreq_formant chnget "max_fq_form" ; formant max freq
  ; midi parms
  krate chnget "rate"
  kamp_off chnget "amp_off"
  klow_note chnget "low_note"
  khigh_note chnget "high_note"
  kmindur = chnget:k("mindur")*0.001 ; millisecs
  kspect_midichan chnget "mchan_spect"
  ksibl_midichan chnget "mchan_sibl"
  kfund_midichan chnget "mchan_fund"
  kform_midichan chnget "mchan_form"

	kcps EpochCps a1     ; pitch analysis by epoch filtering and zero cross count
  kcps limit kcps, 10, 2000
  kcps_semi = int(12 * log2(kcps / 440) + 69)
  kcps = cpsmidinn(kcps_semi) ; qunatize to semitones

  ioverlap = ifftsize / 4
  iwinsize = ifftsize
  iwinshape = 1
  f1 pvsanal a1, ifftsize, ioverlap, iwinsize, iwinshape
  kcentroid pvscent f1
  kcentroid samphold kcentroid, kcentroid
  fspect pvsmooth f1, 1-kspect_smooth, 1-kspect_smooth
	; lpc, generate fundamental and all harmonics
  krms rms a1
  ifw ftgen 0, 0, 1024, 20, 2, 1             ; Hanning window for lpc (2 instances)
  iorder = 150 ; lpc order

	kcfs_lpc[],krms_lpc,kerr_lpc,kcps_lpc lpcanal a1,1,128,1024,64,ifw
  kerr_lpc_gate = kerr_lpc > kerr_threshold ? 1 : 0
  kcps_sh samphold, kcps, (1-kerr_lpc_gate)
  kmedfilter_size = kr*(1/kmedfilter_Hz)
  kcps_filt mediank kcps_sh, kmedfilter_size, kr
  ffund pvsosc krms, kcps_filt, 4, 1024, 128
  kharmonics = kharm_weight == 1 ? 1 : 3 ; saw (weighted harmonics) or pulse (all same)
  fharm pvsosc krms, kcps_filt, kharmonics, 1024, 128
	fharm_nofund pvsbandp fharm, kcps_filt*1.2, kcps_filt*1.8, kmaxfreq_formant, kmaxfreq_formant*1.2
  
  ; formant spectral envelope
	fenv pvslpc  a1, 1024, 128, iorder, ifw
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
        if (kamp_spect > kamp_thresh_spect) && \
          (kfreq_spect > kspect_minfreq) && (kfreq_spect < kspect_maxfreq) then
          kamp_spect_0 table knote_spect, iNoteAmpsSpectral
          tablew (kamp_spect+kamp_spect_0), knote_spect, iNoteAmpsSpectral		; accumulate amps
        endif 
      else
        if kamp_spect > kamp_thresh_sibliant && \
          (kfreq_spect > ksibl_minfreq) && (kfreq_spect < ksibl_maxfreq) then
          kamp_spect_0 table knote_spect, iNoteAmpsSibliants
          tablew (kamp_spect+kamp_spect_0), knote_spect, iNoteAmpsSibliants		; accumulate amps
        endif 
      endif
      if kamp_fund > kamp_thresh_fund then
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
      if (kamp_fund > kamp_thresh_fund) && (ktimstart_fundamental == 0) \
          && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
        kvelocity = int(tanh(((kamp_fund*(1/ampdbfs(-10)))^0.5)*2)*117)+10
        kinstNum = 201.3 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, kfund_midichan
        tablew ktime, knote, iEventTimeFundamental			; and add note (onset time) to active events
      endif
      if (ktimstart_fundamental > 0) && ((ktime-ktimstart_fundamental) > kmindur) \
          && (kamp_fund < kamp_off*kamp_thresh_fund) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
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

	;a3 pvsynth fformants             
	;a3 dcblock a3*40
  ;asin oscil krms, kcps*2
	;;outs a(kcps/600), a3*0.1
  ;;outs a(kerr_lpc), a3*0.1*(1-(kerr_lpc))
  ;outs a(kerr_lpc), a3*0.1
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
i1  0  86400
e
</CsScore>
</CsoundSynthesizer>