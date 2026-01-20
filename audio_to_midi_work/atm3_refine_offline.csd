
<CsoundSynthesizer>
<CsOptions>
-oatm3.wav --midioutfile=atm3.mid
</CsOptions>
<CsInstruments>


sr = 44100  
ksmps = 32
nchnls = 2	
0dbfs = 1

giNoteAmps	ftgen	0, 0, 128, 2, 0
giNoteAmpsDisplay	ftgen	1, 0, 128, 2, 0
giAmpsDisplay	ftgen	2, 0, 2048, 2, 0

giActiveEvents1	ftgen	0, 0, 128, 2, 0
giActiveEvents2	ftgen	0, 0, 128, 2, 0
;giTempEvents	ftgen	0, 0, 128, 2, 0
;giZeroEvents	ftgen	0, 0, 128, 2, 0

giSine	ftgen	0, 0, 65536, 10, 1			; sine wave

opcode Peakpicker, k[]k[], ik[]i
  inumpeaks, kArr[], iminvalue xin
  ; arrays to hold the peaks
  kPeakValues[] init inumpeaks
  kPeakIndices[] init inumpeaks
  ; search for peaks one by one
  isize lenarray kArr
  kpeak_num = 0
  kmax = iminvalue+1
  kbreak = 0
  while kmax > iminvalue && kpeak_num < inumpeaks && kbreak == 0 do
    ;printk2 kpeak_num, 20
    kmax, kndx maxarray kArr
    kPeakValues[kpeak_num] = kmax
    kPeakIndices[kpeak_num] = kndx
    kleft limit kndx, 1, isize-1
    while kArr[kleft-1] < kArr[kleft] && kleft > 1 do
      kleft -= 1
    od
    kright limit kndx, 0, isize-2
    while kArr[(kright+1)] < kArr[kright] && kright < isize-2 do
      kright += 1
    od
    ;Stest sprintfk "max %f.2 ndx %i, left %i, right %i", kmax, kndx, kleft, kright
    ;puts Stest, kmax
    if kleft== kright then
      kbreak = 1
    endif
    while kleft <= kright do
      kArr[kleft] = iminvalue
      kleft += 1
    od
    kpeak_num += 1
  od
  xout kPeakValues, kPeakIndices
endop



;*********************************************************************
; analyze pvs
; write to tables
; zero temp_events
; iterate over tables freq/amp in sync
; if amp > On
; if minfreq<freq<maxfreq
; freq to midi note 
; add note to temp_events
; if note not in active_events
; generate event[note,vel] and add to active_events

; iterate over active_events
; if event not in temp_events
; stop event and remove from active_events

;*********************************************************************
instr	1
  a1,a2	ins
  chnset a1, "audioIn"
endin

;*********************************************************************
instr	9

  ;a1 chnget "audioIn"
  a1 diskin "fox.wav", 1, 0, 1            ; then the fox
  outs a1, a1
  ktime times
  kfftsize = 1024
  ;kFftsizes[] fillarray 512, 1024, 2048, 4096, 8192
  ;kfftsize = kFftsizes[kfftsize-1]
  ;printk2 kfftsize
  
  kamp_on_dB = -15
  kamp_on = ampdbfs(kamp_on_dB)
  kamp_off = 0.95
  kamp_off = kamp_on*kamp_off
  klow_note = 24
  khigh_note = 127
  kmindur = 0.01
  ;kmindur = kmindur /1000
  krate = 20
  ktranspose = 0
  kcentroid_split = 2000
  kmax_accum = 0
  
  kemphasis = 1; "emphasis"
  kemph_amount = 1;chnget "emph_amount"
  kunwobble =1;  "unwobble"
  kunwobble_thresh = 0.4; "unwobble_thresh"
  kunwobble_lolimit = 0.01; "unwobble_lolimit"
  kpeak_pick = 0;chnget "peak_picking"
  knum_peaks = 20;chnget "numpeaks"

  iemphasis ftgen 0, 0, 128, -7, 0, 32, 0, 16, 0.1, 16, 0.4, 16, 1, 48, 1; 36, 1, 12, 2, 12, 3, 12, 4, 12, 5, 12, 6, 32, 6 ; like "pre emphasis", per midi note

  if changed(kfftsize, knum_peaks) > 0 then
    reinit set_fftsize
  endif
  set_fftsize:
  ifftsize 	= i(kfftsize)
  ifftsize = ifftsize == 0 ? 2048 : ifftsize
  iAmps0	ftgen	0, 0, ifftsize/2, 2, 0
  iAmps	ftgen	0, 0, ifftsize/2, 2, 0
  iFreqs ftgen	0, 0, ifftsize/2, 2, 0
  kAmps[] init ifftsize/2

  ioverlap = ifftsize / 4
  iwinsize = ifftsize
  iwinshape = 1
  f1s pvsanal a1, ifftsize, ioverlap, iwinsize, iwinshape
  ksmooth chnget "smooth"
  ;f1s pvsmooth f1, ksmooth, ksmooth
  kcentroid pvscent f1s
  kcentroid samphold kcentroid, kcentroid
  kflag pvsftw f1s, iAmps0, iFreqs

  ; unwobblify
  if kflag > 0 then
    kndx = 0
    while kndx < ifftsize/2 do
      kold table kndx, iAmps
      knew table kndx, iAmps0
      kdiff = abs(knew-kold)
      if kunwobble > 0 then
        if kdiff > kunwobble_thresh*max(kold,knew) || knew < kunwobble_lolimit then
          tablew knew, kndx, iAmps
        endif
      else
        tablew knew, kndx, iAmps
      endif
      kndx += 1
    od
  endif


  if kflag > 0 then
    if kpeak_pick > 0 then
      copyf2array kAmps, iAmps
      inumpeaks limit i(knum_peaks), 1, 20
      iminvalue = 0
      kPeakValues[], kPeakIndices[] Peakpicker inumpeaks, kAmps, iminvalue
    else  
      kPeakValues *= 0
      kPeakIndices *= 0
    endif
    kindx = 0
    kpeakindex = 0
    while kindx < ifftsize do
      kfreq	table kindx, iFreqs
      knote	= round(12 * (log(kfreq/220)/log(2)) + 57 + ktranspose)
      ;if (knote > klowNote) && (knote < khighNote) then
      kamp table kindx, iAmps
      tablew kamp, kindx, giAmpsDisplay
      if kpeak_pick > 0 then
        kpeakamp = 0
        if kPeakIndices[kpeakindex] == kindx then
          kpeakamp = kPeakValues[kpeakindex]
          kpeakindex += 1
          kpeakindex limit kpeakindex, 0, inumpeaks-1
          tablew kpeakamp, knote, giNoteAmps			
        endif
      else
        kamp0 table knote, giNoteAmps
        if kmax_accum == 0 then
          tablew (kamp+kamp0), knote, giNoteAmps			; accumulate amps
        else
          kmax_amp max kamp, kamp0
          tablew kmax_amp, knote, giNoteAmps			; max of amps
        endif
      endif 
      kindx = kindx	+ 1
    od
    
  endif
  
  ;****
  kmetro metro krate
  if kmetro > 0 then
    knote = 0
  readnotes:	

    ktimstart1 table knote, giActiveEvents1
    ktimstart2 table knote, giActiveEvents2
    ktimstart max ktimstart1, ktimstart2; as it can be zero in one of them
    kamp table knote, giNoteAmps
    ; do emphasis here
    if kemphasis == 1 then
      kemph table knote, iemphasis
      kamp *= ((1+kemph)*kemph_amount)
    endif
    tablew kamp, knote, giNoteAmpsDisplay
    tablew 0, knote, giNoteAmps                          	; reset amp accumulator
    
    if (kamp > kamp_on) && (ktimstart == 0) && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
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

endin

;***************************************************
; midi out instrument
;***************************************************
instr	201
  ;print p1
  ; midi file out 
  ; (set name for midi outfile on commandline e.g. --midioutfile=test.mid)

  idur		= (p3 < 0 ? 999 : p3)	; use very long duration for realtime events, noteondur will create note off when instrument stops
  ivel		= p4
  inum		= p5
  print inum, ivel
  ichn		= p6
  noteondur ichn, inum, ivel, idur
endin
;***************************************************
</CsInstruments>
<CsScore>
i9 0 10
e
</CsScore>
</CsoundSynthesizer>
