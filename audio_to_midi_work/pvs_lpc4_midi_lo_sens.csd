<CsoundSynthesizer>
<CsOptions>
-opvs_lpc4_midi.wav --midioutfile=pvs_lpc4_midi_lo_sens.mid
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

gifw ftgen 0, 0, 1024, 20, 2, 1             ; Hanning window
giNoteAmps ftgen	0, 0, 128, 2, 0
giActiveEvents1	ftgen	0, 0, 128, 2, 0
giActiveEvents2	ftgen	0, 0, 128, 2, 0

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
  iamp_thresh = ampdbfs(-45) ; spectral amp thresh
  kcentroid_split = 2000

	
	kcps EpochCps a1     ; pitch analysis by epoch filtering and zero cross count
  kcps limit kcps, 10, 2000
  kcps_semi = int(12 * log2(kcps / 440) + 69)
  kcps = cpsmidinn(kcps_semi) ; qunatize to semitones

  ioverlap = ifftsize / 4
  iwinsize = ifftsize
  iwinshape = 1
  f1s pvsanal a1, ifftsize, ioverlap, iwinsize, iwinshape
  kcentroid pvscent f1s
  kcentroid samphold kcentroid, kcentroid

	; generate all harmonics
  krms rms a1
	kcfs_lpc[],krms_lpc,kerr_lpc,kcps_lpc lpcanal a1,1,128,1024,64,gifw
  kerr_threshold = 0.04
  kerr_lpc = kerr_lpc > kerr_threshold ? 1: kerr_lpc
  
  ;fharm pvsosc krms*0.3*(1-kerr_lpc), kcps_lpc, 4, ifftsize, ifftsize/8
  kcps_sh samphold, kcps, (1-kerr_lpc)
  kmedfilter_Hz = 8
  kmedfilter_size = kr*(1/kmedfilter_Hz)
  kcps_filt mediank kcps, kmedfilter_size, kr
  fharm pvsosc krms, kcps_filt*2, 1, ifftsize, ifftsize/8
	; formant spectral envelope
	fenv pvslpc  a1, ifftsize, ifftsize/8, iorder, gifw
  
	fsig pvsfilter fharm, fenv, 1 
  ;fsig pvsbandp fharm, kcps*0.9, kcps*0.95, kcps*1.05, kcps*1.1
  fsig = fharm

	; tables for spectral processing
  iClear	ftgen	1, 0, ifftsize/2, 2, 0
  iAmps	ftgen	2, 0, ifftsize/2, 2, 0
  iAmps_formant	ftgen	3, 0, ifftsize/2, 2, 0
  iFreqs ftgen 4, 0, ifftsize/2, 2, 0
  iFreqs_formant ftgen 5, 0, ifftsize/2, 2, 0
  kAmps[] init ifftsize/2
  kflag pvsftw fsig, iAmps, iFreqs
  if kflag > 0 then
    tablecopy iAmps_formant, iClear
    tablecopy iFreqs_formant, iClear
    kindx = 0
    while kindx < ifftsize do
      kfreq	table kindx, iFreqs
      knote	= round(12 * (log(kfreq/220)/log(2)) + 57)
      kamp table kindx, iAmps
      if kamp > iamp_thresh then
        tablew kamp, kindx, iAmps_formant
        kamp0 table knote, giNoteAmps
        tablew (kamp+kamp0), knote, giNoteAmps			; accumulate amps
        if cpsmidinn(knote) < 5000 then
          tablew cpsmidinn(knote), kindx, iFreqs_formant
        endif
      endif 
      kindx = kindx	+ 1
    od
  endif

  ; midi parms
  krate = 20
  kamp_on = iamp_thresh
  kamp_off = kamp_on*0.99
  klow_note = 24
  khigh_note = 127
  kmindur = 0.0001
  ktime times

  kmetro metro krate
  if kmetro > 0 then
    knote = 0
    
    readnotes:	
    ktimstart1 table knote, giActiveEvents1
    ktimstart2 table knote, giActiveEvents2
    ktimstart max ktimstart1, ktimstart2; as it can be zero in one of them

    kamp table knote, giNoteAmps
    tablew 0, knote, giNoteAmps                          	; reset amp accumulator
    
    if (kamp > kamp_on) && (ktimstart == 0) && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
      ;kvelocity = int(tanh(((kamp*(1/ampdbfs(-10)))^0.3)*1.5)*117)+10
      kvelocity = int(tanh(((kamp*(1/ampdbfs(-10)))^0.5)*2)*117)+10

      if kcentroid < kcentroid_split then
        kinstNum = 201 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, 1		
        tablew ktime, knote, giActiveEvents1			; and add note (onset time) to active events
      else
        if knote > 75 then
          kinstNum = 201 + (knote*0.001) + 0.2
          event "i", kinstNum, 0, -1, kvelocity, knote, 2
          tablew ktime, knote, giActiveEvents2			; and add note (onset time) to active events
        endif
      endif


    endif

    if (ktimstart > 0) && ((ktime-ktimstart) > kmindur) && (kamp < kamp_off) then	; if it is active, have been active for at least min dur, and currently not having enough energy in the frequency band (note)
      if table(knote, giActiveEvents1) > 0 then
        kinstNum = 201 + (knote*0.001)
        event "i", -kinstNum, 0, .1, 0, knote, 1			
        tablew 0, knote, giActiveEvents1				; remove note from active events
      endif
      if table(knote, giActiveEvents2) > 0 then
        kinstNum = 201 + (knote*0.001) + 0.2
        event "i", -kinstNum, 0, .1, 0, knote, 2
        tablew 0, knote, giActiveEvents2				; remove note from active events	
      endif
    endif

    knote = knote + 1
      if knote < 127 goto readnotes
    endif



  pvsftr fsig, iAmps_formant, iFreqs_formant
	a3 pvsynth fsig              
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