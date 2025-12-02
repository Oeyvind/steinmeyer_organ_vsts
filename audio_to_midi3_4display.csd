<Cabbage>
form caption("Audio to midi 3_4 display"), size(600, 610), pluginId("at34"), colour(10,30,35), guiMode("queue")
combobox bounds(15, 5, 50, 16), channel("fftsize"), text(" "), items(512,1024, 2048, 4096, 8192), value(2)
button bounds(70, 5, 90, 16), channel("max_amps"), text("max(/acm)"), colour:0("black"), colour:1("green")
;nslider bounds(170, 5, 30, 16), channel("numband_rel_amp"), range(0,10,1,1,1), fontSize(13)
;label bounds(205, 5, 70, 16), text("n_relamp"), fontSize(11)

gentable outlineThickness(1), bounds( 300,  0, 300,300), tableNumber(1,2,3), tablebackgroundColour("white"), tableGridColour(100,100,100,50), tableColour:1(0,0,200,200),tableColour:2(200,0,0,200),tableColour:3(200,0,0,0), channel("ampFFT"), ampRange(0,0.2,-1), outlineThickness(0), sampleRange(0, 64) 
button bounds(300, 305, 90, 16), channel("spect_display"), text("spect_display"), colour:0("black"), colour:1("green")
button bounds(300, 325, 90, 16), channel("ceps_display"), text("ceps_display"), colour:0("black"), colour:1("green")
button bounds(300, 345, 90, 16), channel("unwobble"), text("unwobble"), colour:0("black"), colour:1("green")

nslider bounds(400, 305, 50, 16), channel("peak_thresh"), range(0,1,0.01,1,0.0001), fontSize(13)
label bounds(455, 305, 70, 16), text("peak_thresh"), fontSize(11), align("left")
nslider bounds(400, 325, 50, 16), channel("ceps_coefs"), range(1,200,10,1,1), fontSize(13)
label bounds(455, 325, 70, 16), text("ceps_coefs"), fontSize(11), align("left")

nslider bounds(400, 345, 50, 16), channel("unwobble_thresh"), range(0,1,0.1), fontSize(13)
label bounds(455, 345, 70, 16), text("unwobble_thresh"), fontSize(11), align("left")
nslider bounds(400, 365, 50, 16), channel("unwobble_lolimit"), range(0,1,0.1, 1, 0.001), fontSize(13)
label bounds(455, 365, 70, 16), text("unwobble_lolimit"), fontSize(11), align("left")

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

giActiveEvents1	ftgen	0, 0, 128, 2, 0
giActiveEvents2	ftgen	0, 0, 128, 2, 0
;giTempEvents	ftgen	0, 0, 128, 2, 0
;giZeroEvents	ftgen	0, 0, 128, 2, 0

giSine	ftgen	0, 0, 65536, 10, 1			; sine wave

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
  kceps_display chnget "ceps_display"
  kpeak_thresh chnget "peak_thresh"
  kceps_coefs chnget "ceps_coefs"

  kunwobble chnget "unwobble"
  kunwobble_thresh chnget "unwobble_thresh"
  kunwobble_lolimit chnget "unwobble_lolimit"

  if changed(kfftsize) > 0 || changed(kceps_coefs) > 0 then
    reinit set_fftsize
  endif
  set_fftsize:
  ifftsize 	= i(kfftsize)
  ifftsize = ifftsize == 0 ? 2048 : ifftsize
  iAmps0	ftgen	0, 0, ifftsize/2, 2, 0
  iAmps	ftgen	3, 0, ifftsize/2, 2, 0
  iFreqs ftgen	0, 0, ifftsize/2, 2, 0
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

  kCepstrum[] pvsceps f1s,i(kceps_coefs)
  kCepsInv[] = cepsinv(kCepstrum)
  kCepsInvPeaks[] init ifftsize/2
  ;fenv tab2pvs r2c(kCepsInv)
  itab_ceps ftgen  1,0,ifftsize/2,2,0
  itab_ceps_peaks ftgen  2,0,ifftsize/2,2,0
  ilen lenarray kCepsInv
  kCepsInvPeaks = kCepsInvPeaks*0
  kndx_peaks = 1
  while kndx_peaks < ilen-2 do
    if kCepsInv[kndx_peaks] > kpeak_thresh && kCepsInv[kndx_peaks] > kCepsInv[kndx_peaks-1] && kCepsInv[kndx_peaks] > kCepsInv[kndx_peaks+1] then
      kCepsInvPeaks[kndx_peaks] = 1
    endif
    kndx_peaks += 1
  od
  if  metro(16)==1 then
    if kceps_display > 0 then
      copya2ftab kCepsInv, itab_ceps
      copya2ftab kCepsInvPeaks, itab_ceps_peaks
      ktrig = 1
      if kspect_display > 0 then
        cabbageSet ktrig, "ampFFT", "tableNumber", 1,2,3
        ;chnset  "tableNumber(1,2,3)", "ampFFT"
      else
        cabbageSet ktrig, "ampFFT", "tableNumber", 1,2
        ;chnset  "tableNumber(1,2)", "ampFFT"
      endif
    elseif kspect_display > 0 then
      cabbageSet ktrig, "ampFFT", "tableNumber", 3
      ;chnset  "tableNumber(3)", "ampFFT"
    endif
  endif

  if kflag > 0 then
  kindx = 0
  readspectral:
  kfreq	table kindx, iFreqs
  knote	= round(12 * (log(kfreq/220)/log(2)) + 57 + ktranspose)
  ;if (knote > klowNote) && (knote < khighNote) then
  kamp table kindx, iAmps
  kamp0 table knote, giNoteAmps
  if kmax_accum == 0 then
    tablew (kamp+kamp0), knote, giNoteAmps			; accumulate amps
  else
    kmax_amp max kamp, kamp0
    tablew kmax_amp, knote, giNoteAmps			; max amps within this semitone
  endif
  ;endif 
  kindx = kindx	+ 1
    if kindx < ifftsize goto readspectral
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
