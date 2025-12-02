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
;-odac23 -iadc23 -Q12
-n -d -+rtmidi=NULL -M0 -Q0 -m0
</CsOptions>
<CsInstruments>


;sr = 44100  
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


opcode svgGraph, 0, Skiik[]k[]
  SChannel, kupdate, ixzoom, iNumCols, kPeakValues[], kPeakIndices[] xin
  iBounds[] cabbageGet SChannel, "bounds"
  irange = (iBounds[3]-iBounds[1])*ixzoom
  
  if kupdate > 0 then
    SPath strcpyk ""
    kndx = 0
    kpeakindex = 0
    while kndx <= iNumCols do
      knoteamp table kndx, giNoteAmpsDisplay
      kfamp table kndx, giAmpsDisplay
      kpeakamp = 0
      kpeak_detected = 0
      if kPeakIndices[kpeakindex] == kndx then
        kpeakamp = kPeakValues[kpeakindex]*irange
        kpeak_detected = irange
        kpeakindex += 1
        kpeakindex limit kpeakindex, 0, lenarray(kPeakIndices)-1
      endif
      knoteamp *= irange
      kfamp *= irange
      SPath strcatk SPath, sprintfk({{
      <line x1="%d" y1="%d" x2="%d" y2="%d" style="stroke:rgb(200,0,0);stroke-width:2" />
      }}, (iBounds[2]/iNumCols)*kndx, iBounds[3], (iBounds[2]/iNumCols)*kndx, iBounds[3]-kfamp) 
      SPath strcatk SPath, sprintfk({{
      <line x1="%d" y1="%d" x2="%d" y2="%d" style="stroke:rgb(0,200,0);stroke-width:2" />
      }}, (iBounds[2]/iNumCols)*kndx, iBounds[3], (iBounds[2]/iNumCols)*kndx, iBounds[3]-knoteamp) 
      SPath strcatk SPath, sprintfk({{
      <line x1="%d" y1="%d" x2="%d" y2="%d" style="stroke:rgb(232, 253, 7);stroke-width:2" />
      }}, (iBounds[2]/iNumCols)*kndx, iBounds[3], (iBounds[2]/iNumCols)*kndx, iBounds[3]-kpeakamp) 
      SPath strcatk SPath, sprintfk({{
      <line x1="%d" y1="%d" x2="%d" y2="%d" style="stroke:rgb(51, 94, 201);stroke-width:1" />
      }}, (iBounds[2]/iNumCols)*kndx, iBounds[3], (iBounds[2]/iNumCols)*kndx, iBounds[3]-(kpeak_detected*0.2)) 
      kndx +=1
    od
    ;puts SPath, times()
    cabbageSet kupdate, SChannel, "svgElement", SPath
  endif
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

  a1 chnget "audioIn"
  ktime times
  kfftsize chnget "fftsize"
  kFftsizes[] fillarray 512, 1024, 2048, 4096, 8192
  kfftsize = kFftsizes[kfftsize-1]
  ;printk2 kfftsize
  
  kamp_on_dB chnget "ampOn"
  kamp_on = ampdbfs(kamp_on_dB)
  kamp_off chnget "ampOff"
  kamp_off = kamp_on*kamp_off
  klow_note chnget "lowNote"
  khigh_note chnget "highNote"
  kmindur chnget "mindur"
  kmindur = kmindur /1000
  krate chnget "rate"
  ktranspose chnget "transpose"
  kcentroid_split chnget "centroid_split"
  kmax_accum chnget "max_amps"
  knumband_rel_amp chnget "numband_rel_amp"

  kspect_display chnget "spect_display"
  kxzoom chnget "xzoom"
  kemphasis chnget "emphasis"
  kemph_amount chnget "emph_amount"
  kunwobble chnget "unwobble"
  kunwobble_thresh chnget "unwobble_thresh"
  kunwobble_lolimit chnget "unwobble_lolimit"
  kpeak_pick chnget "peak_picking"
  knum_peaks chnget "numpeaks"

  iemphasis ftgen 0, 0, 128, -7, 0, 32, 0, 16, 0.1, 16, 0.4, 16, 1, 48, 1; 36, 1, 12, 2, 12, 3, 12, 4, 12, 5, 12, 6, 32, 6 ; like "pre emphasis", per midi note

  if changed(kfftsize, knum_peaks, kxzoom) > 0 then
    reinit set_fftsize
  endif
  set_fftsize:
  ifftsize 	= i(kfftsize)
  ifftsize = ifftsize == 0 ? 2048 : ifftsize
  iAmps0	ftgen	0, 0, ifftsize/2, 2, 0
  iAmps	ftgen	2, 0, ifftsize/2, 2, 0
  iFreqs ftgen	0, 0, ifftsize/2, 2, 0
  kAmps[] init ifftsize/2
  ;isamplerange_gentable = ifftsize/8
  ;kinit init 1
  ;cabbageSet kinit, "ampFFT", "sampleRange", 0, isamplerange_gentable
  ;kinit =0

  ioverlap = ifftsize / 4
  iwinsize = ifftsize
  iwinshape = 1
  f1 pvsanal a1, ifftsize, ioverlap, iwinsize, iwinshape
  ksmooth chnget "smooth"
  f1s pvsmooth f1, ksmooth, ksmooth
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
  kdisplay_updaterate = 15
  kdisplay_update metro kdisplay_updaterate
  kdisplay_update *= kspect_display
  svgGraph "graph1", kdisplay_update, i(kxzoom), 128, kPeakValues, kPeakIndices
  
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
      kvelocity = 10^(dbfsamp(kamp)/40) * 80 + 47
      if kcentroid < kcentroid_split then
        kinstNum = 201 + (knote*0.001)
        event "i", kinstNum, 0, -1, kvelocity, knote, 1		
        tablew ktime, knote, giActiveEvents1			; and add note (onset time) to active events
      else
        if knote > 60 then
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
;  print inum, ivel
  ichn		= p6
  noteondur ichn, inum, ivel, idur
endin
;***************************************************
</CsInstruments>
<CsScore>
i1 0 86400
;i1 1 1

;i2 0 1
i9 0 86400
e
</CsScore>
</CsoundSynthesizer>
