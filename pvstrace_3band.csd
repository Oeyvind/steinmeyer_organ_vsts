<Cabbage>
form size(380, 430), caption("Trace 3 band"), pluginId("tra3"), colour(40,60,60), guiMode("queue")
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

nslider channel("FeatCentroid"), bounds(10, 130, 80, 27), fontSize(11), text("Centroid"), range(0, 12000, 0, 1, 1), active(0)
nslider channel("FeatFlatness"), bounds(100, 130, 80, 27), fontSize(11), text("Flatness"), range(0, 1, 0, 1, 0.001), active(0)
nslider channel("FeatFlux"), bounds(190, 130, 80, 27), fontSize(11), text("Flux"), range(0, 1, 0, 1, 0.001), active(0)
nslider channel("FeatTilt"), bounds(280, 130, 80, 27), fontSize(11), text("Tilt"), range(-8, 8, 0, 1, 0.001), active(0)
nslider channel("FeatCrest"), bounds(10, 170, 80, 27), fontSize(11), text("Crest"), range(0, 80, 0, 1, 0.01), active(0)
nslider channel("FeatPeakDensity"), bounds(100, 170, 80, 27), fontSize(11), text("PkDens"), range(0, 1, 0, 1, 0.001), active(0)
nslider channel("InputDb"), bounds(190, 170, 80, 27), fontSize(11), text("In dB"), range(-120, 0, -120, 1, 0.1), active(0)
nslider channel("NoiseFloorDb"), bounds(280, 170, 80, 27), fontSize(11), text("Noise dB"), range(-90, 0, -55, 1, 0.1)
checkbox channel("AboveNoise"), bounds(350, 170, 20, 20), text(""), active(0)
label bounds(330, 190, 45, 12), text("Gate"), fontSize(10), align("right")
csoundoutput bounds(5,210,370,210)
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
  ksmooth_filter chnget "Contrast_filter"
  kcontrast_amount chnget "Contrast_amount"
  kcontrast_monitor chnget "Contrast_monitor"
  knoise_floor_db chnget "NoiseFloorDb"

  a1 inch 1
  krms rms a1
  kinput_db = ampdbfs(krms + 1e-12)
  cabbageSetValue "InputDb", kinput_db, changed(kinput_db)
  kabove_noise_floor = (kinput_db > knoise_floor_db ? 1 : 0)
  cabbageSetValue "AboveNoise", kabove_noise_floor, changed(kabove_noise_floor)
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
  kPrevMags[] init (ifftsize/2)+1
  
  kframe pvs2array kMags, kFreqs, f1
  kMags = abs(kMags)
  fsmooth pvsmooth f1, ksmooth_filter, ksmooth_filter
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
  
  kfeat_centroid init 0
  kfeat_flatness init 0
  kfeat_flux init 0
  kfeat_tilt init 0
  kfeat_crest init 0
  kfeat_peak_density init 0

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

    kbin_hz = sr/ifftsize
    kmin_bin1 = int(klofreq1/kbin_hz)
    kmax_bin1 = int(khifreq1/kbin_hz)
    kmin_bin2 = int(klofreq2/kbin_hz)
    kmax_bin2 = int(khifreq2/kbin_hz)
    kmin_bin3 = int(klofreq3/kbin_hz)
    kmax_bin3 = int(khifreq3/kbin_hz)
    kmin_bin1 = kmin_bin1 < 0 ? 0 : kmin_bin1
    kmin_bin2 = kmin_bin2 < 0 ? 0 : kmin_bin2
    kmin_bin3 = kmin_bin3 < 0 ? 0 : kmin_bin3
    kmax_bin1 = kmax_bin1 > inumbins ? inumbins : kmax_bin1
    kmax_bin2 = kmax_bin2 > inumbins ? inumbins : kmax_bin2
    kmax_bin3 = kmax_bin3 > inumbins ? inumbins : kmax_bin3

    kenergy = 0
    kfreq_weighted = 0
    klog_sum = 0
    kflux_sum = 0
    kband_lo = 0
    kband_mid = 0
    kband_hi = 0
    kmax_mag = 0
    kndx = 0
    while kndx <= inumbins do
      kmag = kMags[kndx]
      kfreq = kndx * kbin_hz
      kenergy += kmag
      kfreq_weighted += kmag * kfreq
      klog_sum += log(kmag + 1e-12)
      kflux_sum += abs(kmag - kPrevMags[kndx])
      if kmag > kmax_mag then
        kmax_mag = kmag
      endif
      if (kndx >= kmin_bin1 && kndx <= kmax_bin1) then
        kband_lo += kmag
      endif
      if (kndx >= kmin_bin2 && kndx <= kmax_bin2) then
        kband_mid += kmag
      endif
      if (kndx >= kmin_bin3 && kndx <= kmax_bin3) then
        kband_hi += kmag
      endif
      kPrevMags[kndx] = kmag 
      kndx += 1
    od

    karith = kenergy/(inumbins+1)
    kfeat_centroid_new = kfreq_weighted/(kenergy + 1e-12)
    kfeat_flatness_new = exp(klog_sum/(inumbins+1))/(karith + 1e-12)
    kfeat_flux_new = kflux_sum/(kenergy + 1e-12)
    kfeat_tilt_new = log((kband_hi + 1e-9)/(kband_lo + 1e-9))
    kfeat_crest_new = kmax_mag/(karith + 1e-12)

    if kabove_noise_floor > 0 then
      kfeat_centroid = kfeat_centroid_new
      kfeat_flatness = kfeat_flatness_new
      kfeat_flux = kfeat_flux_new
      kfeat_tilt = kfeat_tilt_new
      kfeat_crest = kfeat_crest_new
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

  kn1 = int(knbins1)
  kn2 = int(knbins2)
  kn3 = int(knbins3)
  kpeak_count = 0
  kidx = 0
  while kidx < kn1 do
    if kBins1[kidx] > 0 then
      kpeak_count += 1
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn2 do
    if kBins2[kidx] > 0 then
      kpeak_count += 1
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn3 do
    if kBins3[kidx] > 0 then
      kpeak_count += 1
    endif
    kidx += 1
  od
  kpeak_denom = kn1 + kn2 + kn3
  kpeak_denom = kpeak_denom < 1 ? 1 : kpeak_denom
  if kabove_noise_floor > 0 then
    kfeat_peak_density = kpeak_count/kpeak_denom
    cabbageSetValue "FeatCentroid", kfeat_centroid, changed(kfeat_centroid)
    cabbageSetValue "FeatFlatness", kfeat_flatness, changed(kfeat_flatness)
    cabbageSetValue "FeatFlux", kfeat_flux, changed(kfeat_flux)
    cabbageSetValue "FeatTilt", kfeat_tilt, changed(kfeat_tilt)
    cabbageSetValue "FeatCrest", kfeat_crest, changed(kfeat_crest)
    cabbageSetValue "FeatPeakDensity", kfeat_peak_density, changed(kfeat_peak_density)
  endif

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