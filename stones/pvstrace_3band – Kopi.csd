<Cabbage>
form size(380, 320), caption("Trace 3 band"), pluginId("tra3"), colour(40,60,60) 
nslider channel("Lo1"), bounds(10, 10, 50, 27), fontSize(12), text("Lo1"), range(0, 20000, 20, 1, 1, 1)
nslider channel("Hi1"), bounds(70, 10, 50, 27), fontSize(12), text("Hi1"), range(0, 20000, 500, 1, 1, 1)
nslider channel("Nbins1"), bounds(130, 10, 50, 27), fontSize(12), text("Nbins1"), range(0, 100, 2, 1, 1, 1)
checkbox channel("On1"), bounds(190, 15, 22, 22), text("")

nslider channel("Lo2"), bounds(10, 50, 50, 27), fontSize(12), text("Lo2"), range(0, 20000, 500, 1, 1, 1)
nslider channel("Hi2"), bounds(70, 50, 50, 27), fontSize(12), text("Hi2"), range(0, 20000, 1000, 1, 1, 1)
nslider channel("Nbins2"), bounds(130, 50, 50, 27), fontSize(12), text("Nbins2"), range(0, 100, 2, 1, 1, 1)
checkbox channel("On2"), bounds(190, 55, 22, 22), text("")

nslider channel("Lo3"), bounds(10, 90, 50, 27), fontSize(12), text("Lo3"), range(0, 20000, 1000, 1, 1, 1)
nslider channel("Hi3"), bounds(70, 90, 50, 27), fontSize(12), text("Hi3"), range(0, 20000, 3000, 1, 1, 1)
nslider channel("Nbins3"), bounds(130, 90, 50, 27), fontSize(12), text("Nbins3"), range(0, 100, 2, 1, 1, 1)
checkbox channel("On3"), bounds(190, 95, 22, 22), text("")

checkbox channel("Ampscale"), bounds(230, 15, 50, 18), text("")
label bounds(230, 35, 50, 12), text("Ampscale"), fontSize(11)
nslider channel("Asc_max"), bounds(230, 50, 50, 27), fontSize(12), text("Asc_max"), range(1, 10, 2, 1, .01)
combobox channel("fft_size"), bounds(230, 90, 50, 14), fontSize(12), text("fftsize"), items("512", "1024", "2048", "4096"), value(1)

checkbox channel("Contrast"), bounds(290, 15, 50, 18), text("")
label bounds(290, 35, 50, 12), text("Contrast"), fontSize(11)
nslider channel("Contrast_filter"), bounds(290, 50, 50, 27), fontSize(12), text("Filter"), range(0, 1, 0.5)
nslider channel("Contrast_amount"), bounds(290, 90, 50, 27), fontSize(12), text("Amount"), range(0, 1, 0.5)
checkbox channel("Contrast_monitor"), bounds(350, 15, 20, 18), text("")
label bounds(350, 35, 50, 12), text("Mon"), fontSize(11), align("left")

csoundoutput bounds(5,130,290,190)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n --displays
</CsOptions>
<CsInstruments>

  ksmps = 32
  nchnls = 2
  0dbfs=1


instr 1
  ; spectral trace
  kfftsize chnget "fft_size"
  if changed(kfftsize) > 0 then
    reinit fftsize
  endif
  fftsize:
  ifftsize chnget "fft_size"
  iSizes[] fillarray 512, 1024, 2048, 4096
  ifftsize = iSizes[ifftsize-1]
  print ifftsize
  inumbins = ifftsize/2

  klofreq1 chnget "Lo1"
  klofreq2 chnget "Lo2"
  klofreq3 chnget "Lo3"
  khifreq1 chnget "Hi1"
  khifreq2 chnget "Hi2"
  khifreq3 chnget "Hi3"
  knbins1 chnget "Nbins1"
  knbins2 chnget "Nbins2"
  knbins3 chnget "Nbins3"
  kband1_on chnget "On1"
  kband2_on chnget "On2"
  kband3_on chnget "On3"
  kamp_scale chnget "Ampscale"
  kscale_max chnget "Asc_max"
  kcontrast_on chnget "Contrast"
  ksmoothfilter chnget "Contrast_filter"
  kcontrast_amount chnget "Contrast_amount"
  kcontrast_monitor chnget "Contrast_monitor"

  a1 inch 1
  f1 pvsanal a1,ifftsize,ifftsize/8,ifftsize,1
  /* amp scaling */
  
  kMags[] init (ifftsize/2)+1 
  kMagSmooth[] init (ifftsize/2)+1 
  kMags1[] init (ifftsize/2)+1 
  kMags2[] init (ifftsize/2)+1 
  kMags3[] init (ifftsize/2)+1 
  kFreqs[] init (ifftsize/2)+1   
  kFreqSmooth[] init (ifftsize/2)+1   
  kAmpscale1[] init (ifftsize/2)+1
  
  kframe pvs2array kMags, kFreqs, f1
  kMags = abs(kMags)
  fsmooth pvsmooth f1, ksmoothfilter, ksmoothfilter
  kframe pvs2array kMagSmooth, kFreqSmooth, fsmooth
  kMagSmooth = abs(kMagSmooth)

  if changed(kscale_max, kamp_scale, klofreq1, klofreq2, klofreq3, khifreq1, khifreq2, khifreq3) > 0 then
    reinit ampscale
  endif 
  ampscale:
  iscale_min chnget "Asc_min"
  iscale_max chnget "Asc_max"
  ilofreq1 chnget "Lo1"
  ilofreq2 chnget "Lo2"
  ilofreq3 chnget "Lo3"
  ihifreq1 chnget "Hi1"
  ihifreq2 chnget "Hi2"
  ihifreq3 chnget "Hi3"
  imin_bin1 = floor(ilofreq1/(sr/ifftsize))
  imin_bin2 = floor(ilofreq2/(sr/ifftsize))
  imin_bin3 = floor(ilofreq3/(sr/ifftsize))
  imax_bin1 = ceil(ihifreq1/(sr/ifftsize))
  imax_bin2 = ceil(ihifreq2/(sr/ifftsize))
  imax_bin3 = ceil(ihifreq3/(sr/ifftsize))
  ;kAmpscale[] genarray_i iscale_min, iscale_max, (iscale_max-iscale_min)/(ifftsize/2)
  print iscale_min, imin_bin1, iscale_min, imax_bin1-imin_bin1, iscale_max, 0, iscale_min, ifftsize/2+1-imax_bin1, iscale_min
  iShape1 ftgen 0, 0, ifftsize/2+1, 7, 1, imin_bin1, 1, imax_bin1-imin_bin1, iscale_max, 0, 1, ifftsize/2+1-imax_bin1, 1
  iShape2 ftgen 0, 0, ifftsize/2+1, 7, 1, imin_bin2, 1, imax_bin2-imin_bin2, iscale_max, 0, 1, ifftsize/2+1-imax_bin2, 1
  iShape3 ftgen 0, 0, ifftsize/2+1, 7, 1, imin_bin3, 1, imax_bin3-imin_bin3, iscale_max, 0, 1, ifftsize/2+1-imax_bin3, 1
  kAmpscale1[] tab2array iShape1, 0,ifftsize/2+1, 1
  kAmpscale2[] tab2array iShape2, 0,ifftsize/2+1, 1
  kAmpscale3[] tab2array iShape3, 0,ifftsize/2+1, 1
  ;rireturn
  ;ktest = kAmpscale1[6]
  ;printk2 ktest
  
  if kframe > 0 then
    if kcontrast_on > 0 then 
      kMags -= kMagSmooth*kcontrast_amount    
    endif
    if kamp_scale > 0 then
      kMags1 = kMags*kAmpscale1*iscale_max
      kMags2 = kMags*kAmpscale2*iscale_max
      kMags3 = kMags*kAmpscale3*iscale_max 
    else
      kMags1 = kMags
      kMags2 = kMags
      kMags3 = kMags
    endif
  endif
  f2_1 pvsfromarray kMags1, kFreqs
  f2_2 pvsfromarray kMags2, kFreqs
  f2_3 pvsfromarray kMags3, kFreqs
  
  fband1 pvsbandp f2_1, klofreq1*0.999, klofreq1, khifreq1, khifreq1*1.01
  fband2 pvsbandp f2_2, klofreq2*0.99, klofreq2, khifreq2, khifreq2*1.01
  fband3 pvsbandp f2_3, klofreq3*0.99, klofreq3, khifreq3, khifreq3*1.01
  ftrace1, kBins1[] pvstrace fband1, knbins1
  ftrace2, kBins2[] pvstrace fband2, knbins2
  ftrace3, kBins3[] pvstrace fband3, knbins3

  ;kminfreq1 = kBins1[0]
  ;kbinfreq1 = (sr/ifftsize)*kminfreq1
  ;kmin_bin1 = ceil(klofreq1/(sr/ifftsize))
  ;kmin_binfreq1 = int(klofreq1/(sr/ifftsize))*((sr/ifftsize)) 
  ;kminfreq1_amp = kMags[kminfreq1]*ifftsize
  ;Sdebug sprintfk "bin %i, freq %.2f, amp %.2f", kminfreq1, kbinfreq1, kminfreq1_amp
  ;kampgate1 = kminfreq1_amp > 0.0001 ? 1 : 0 
  ;puts Sdebug, (changed(Sdebug)+1)* kampgate1

  ;Sdebug sprintfk "lowest in each band: \n bin %i, freq %.2f, minbin %i, minfreq %.2f \n bin %.2f, \n bin %.2f", kminfreq1, kbinfreq1, kmin_bin1, kmin_binfreq1, ktest2, ktest3
  ;puts Sdebug, changed(Sdebug)+1
/*
fsig, kBins[] pvstrace fsigin, kn[,isort, imin, imax] 
kBins[] -- an array of size fftsize/2 + 1 values, whose first N values report the kn bin numbers retained by pvstrace. Other locations are set to 0. It can be sorted or unsorted.

  ; See if pvstrace can output info on bin number or frequency
  ; Make a filter so that if the loudest bin in the band is at the lower frequency bound,
  ; ...then we should mute the whole band, as what we are hedaring is just an upward shadow of a lower peak
  ; We might be able to refine this, assume that we have a lower amp peak somewhere higher in the band, and it is overshadoed by the low freq peak:
  ; Then we could do an amp normalization, either by a linear freq shape scaling, or a common/normal amp rolloff over freq
  ; ??? WHAT is the amp rolloff per octave in "natural" signals ?
  ; .... then the hidden peak might reappear
  ; MAYBE amp normalize the contents of each band anyway, as it could be useful to discover the true peaks
  ; SO: make switch for amp normalization
  ; And make switch to enable a "skip if no peak found" filter
*/

  ftrace1g pvsgain ftrace1, kband1_on*10
  ftrace2g pvsgain ftrace2, kband2_on*10
  ftrace3g pvsgain ftrace3, kband3_on*10
  at1 pvsynth ftrace1g
  at2 pvsynth ftrace2g
  at3 pvsynth ftrace3g
  
  fcontrast_monitor pvsfromarray kMags, kFreqs
  fcontrast_monitor_g pvsgain fcontrast_monitor, kcontrast_monitor 
  acontrast_monitor pvsynth fcontrast_monitor_g
  
  outs (at1+(at2*0.5))+acontrast_monitor, (at3+(at2*0.5))+acontrast_monitor
endin

</CsInstruments>  
<CsScore>
i1 1 86400
</CsScore>
</CsoundSynthesizer>