<Cabbage>
form size(700, 640), caption("Trace 3 band"), pluginId("tra3"), colour(40,60,60), guiMode("queue")
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
nslider channel("PkDens_thresh"), bounds(10, 210, 120, 27), fontSize(11), text("PkThr"), range(0.01, 1, 0.2, 1, 0.01)
nslider channel("PkDens_scale"), bounds(140, 210, 120, 27), fontSize(11), text("PkScale"), range(1, 20, 8, 1, 0.1)
nslider channel("PkDens_raw"), bounds(270, 210, 100, 27), fontSize(11), text("PkRaw"), range(0, 2, 0, 1, 0.001), active(0)
nslider channel("FluxGain"), bounds(10, 240, 120, 27), fontSize(11), text("FluxGain"), range(1, 1000, 200, 1, 1)
nslider channel("MidiAnalysisMs"), bounds(140, 240, 120, 27), fontSize(11), text("MidiWinMs"), range(10, 400, 120, 1, 1, 1)
nslider channel("CrestMapMax"), bounds(270, 240, 100, 27), fontSize(11), text("CrMapMax"), range(20, 300, 140, 1, 1, 1)
label bounds(10, 275, 150, 12), text("Feature MIDI (gate on)"), fontSize(10), align("left")
checkbox channel("MidiCentroidOn"), bounds(10, 292, 20, 18), text("")
label bounds(30, 294, 60, 12), text("Cent"), fontSize(10), align("left")
nslider channel("MidiCentroidLo"), bounds(75, 290, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiCentroidHi"), bounds(120, 290, 40, 20), text("Hi"), range(0,127,84,1,1,1), fontSize(10)
nslider channel("MidiCentroidChan"), bounds(165, 290, 40, 20), text("Ch"), range(1,16,1,1,1,1), fontSize(10)

checkbox channel("MidiFlatnessOn"), bounds(10, 317, 20, 18), text("")
label bounds(30, 319, 60, 12), text("Flat"), fontSize(10), align("left")
nslider channel("MidiFlatnessLo"), bounds(75, 315, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiFlatnessHi"), bounds(120, 315, 40, 20), text("Hi"), range(0,127,84,1,1,1), fontSize(10)
nslider channel("MidiFlatnessChan"), bounds(165, 315, 40, 20), text("Ch"), range(1,16,2,1,1,1), fontSize(10)

checkbox channel("MidiTiltOn"), bounds(10, 342, 20, 18), text("")
label bounds(30, 344, 60, 12), text("Tilt"), fontSize(10), align("left")
nslider channel("MidiTiltLo"), bounds(75, 340, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiTiltHi"), bounds(120, 340, 40, 20), text("Hi"), range(0,127,84,1,1,1), fontSize(10)
nslider channel("MidiTiltChan"), bounds(165, 340, 40, 20), text("Ch"), range(1,16,3,1,1,1), fontSize(10)

checkbox channel("MidiCrestOn"), bounds(10, 367, 20, 18), text("")
label bounds(30, 369, 60, 12), text("Crest"), fontSize(10), align("left")
nslider channel("MidiCrestLo"), bounds(75, 365, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiCrestHi"), bounds(120, 365, 40, 20), text("Hi"), range(0,127,84,1,1,1), fontSize(10)
nslider channel("MidiCrestChan"), bounds(165, 365, 40, 20), text("Ch"), range(1,16,4,1,1,1), fontSize(10)

label bounds(210, 275, 180, 12), text("Trace MIDI (bands 1-3, gate on)"), fontSize(10), align("left")
checkbox channel("MidiTrace1On"), bounds(210, 292, 20, 18), text("")
label bounds(230, 294, 40, 12), text("B1"), fontSize(10), align("left")
nslider channel("MidiTrace1Lo"), bounds(275, 290, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiTrace1Hi"), bounds(320, 290, 40, 20), text("Hi"), range(0,127,84,1,1,1), fontSize(10)
nslider channel("MidiTrace1Trsp"), bounds(365, 290, 40, 20), text("Tr"), range(-36,36,0,1,1,1), fontSize(10)
nslider channel("MidiTrace1Chan"), bounds(410, 290, 40, 20), text("Ch"), range(1,16,5,1,1,1), fontSize(10)

checkbox channel("MidiTrace2On"), bounds(210, 317, 20, 18), text("")
label bounds(230, 319, 40, 12), text("B2"), fontSize(10), align("left")
nslider channel("MidiTrace2Lo"), bounds(275, 315, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiTrace2Hi"), bounds(320, 315, 40, 20), text("Hi"), range(0,127,100,1,1,1), fontSize(10)
nslider channel("MidiTrace2Trsp"), bounds(365, 315, 40, 20), text("Tr"), range(-36,36,0,1,1,1), fontSize(10)
nslider channel("MidiTrace2Chan"), bounds(410, 315, 40, 20), text("Ch"), range(1,16,6,1,1,1), fontSize(10)

checkbox channel("MidiTrace3On"), bounds(210, 342, 20, 18), text("")
label bounds(230, 344, 40, 12), text("B3"), fontSize(10), align("left")
nslider channel("MidiTrace3Lo"), bounds(275, 340, 40, 20), text("Lo"), range(0,127,36,1,1,1), fontSize(10)
nslider channel("MidiTrace3Hi"), bounds(320, 340, 40, 20), text("Hi"), range(0,127,108,1,1,1), fontSize(10)
nslider channel("MidiTrace3Trsp"), bounds(365, 340, 40, 20), text("Tr"), range(-36,36,-12,1,1,1), fontSize(10)
nslider channel("MidiTrace3Chan"), bounds(410, 340, 40, 20), text("Ch"), range(1,16,7,1,1,1), fontSize(10)

csoundoutput bounds(5,395,690,240)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d
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
  kpkdens_thresh chnget "PkDens_thresh"
  kpkdens_scale chnget "PkDens_scale"
  kflux_gain chnget "FluxGain"
  kmidi_analysis_ms chnget "MidiAnalysisMs"
  kcrest_map_max chnget "CrestMapMax"
  kmidi_centroid_on chnget "MidiCentroidOn"
  kmidi_flatness_on chnget "MidiFlatnessOn"
  kmidi_tilt_on chnget "MidiTiltOn"
  kmidi_crest_on chnget "MidiCrestOn"
  kmidi_centroid_lo chnget "MidiCentroidLo"
  kmidi_centroid_hi chnget "MidiCentroidHi"
  kmidi_flatness_lo chnget "MidiFlatnessLo"
  kmidi_flatness_hi chnget "MidiFlatnessHi"
  kmidi_tilt_lo chnget "MidiTiltLo"
  kmidi_tilt_hi chnget "MidiTiltHi"
  kmidi_crest_lo chnget "MidiCrestLo"
  kmidi_crest_hi chnget "MidiCrestHi"
  kmidi_centroid_chan chnget "MidiCentroidChan"
  kmidi_flatness_chan chnget "MidiFlatnessChan"
  kmidi_tilt_chan chnget "MidiTiltChan"
  kmidi_crest_chan chnget "MidiCrestChan"
  kmidi_trace1_on chnget "MidiTrace1On"
  kmidi_trace2_on chnget "MidiTrace2On"
  kmidi_trace3_on chnget "MidiTrace3On"
  kmidi_trace1_lo chnget "MidiTrace1Lo"
  kmidi_trace2_lo chnget "MidiTrace2Lo"
  kmidi_trace3_lo chnget "MidiTrace3Lo"
  kmidi_trace1_hi chnget "MidiTrace1Hi"
  kmidi_trace2_hi chnget "MidiTrace2Hi"
  kmidi_trace3_hi chnget "MidiTrace3Hi"
  kmidi_trace1_chan chnget "MidiTrace1Chan"
  kmidi_trace2_chan chnget "MidiTrace2Chan"
  kmidi_trace3_chan chnget "MidiTrace3Chan"
  kmidi_trace1_trsp chnget "MidiTrace1Trsp"
  kmidi_trace2_trsp chnget "MidiTrace2Trsp"
  kmidi_trace3_trsp chnget "MidiTrace3Trsp"

  a1 inch 1
  krms rms a1
  kinput_db = dbfsamp(krms + 1e-12)
  kinput_db_disp limit kinput_db, -120, 0
  kgui_update_trig metro 20
  cabbageSetValue "InputDb", kinput_db_disp, kgui_update_trig
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
  kanalysis_pending init 0
  kanalysis_start init 0
  ksum_centroid init 0
  ksum_flatness init 0
  ksum_tilt init 0
  ksum_crest init 0
  ksum_trace1 init 0
  ksum_trace2 init 0
  ksum_trace3 init 0
  ksum_count init 0
  ksum_trace1_count init 0
  ksum_trace2_count init 0
  ksum_trace3_count init 0

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
    kprev_energy = 0
    kfreq_weighted = 0
    klog_sum = 0
    kflux_change_sum = 0
    kband_lo = 0
    kband_mid = 0
    kband_hi = 0
    kmax_mag = 0
    kndx = 0
    while kndx <= inumbins do
      kmag = kMags[kndx]
      kprev_mag = kPrevMags[kndx]
      kdelta_mag = kmag - kprev_mag
      kfreq = kndx * kbin_hz
      kenergy += kmag
      kprev_energy += kprev_mag
      kfreq_weighted += kmag * kfreq
      klog_sum += log(kmag + 1e-12)
      kflux_change_sum += abs(kdelta_mag)
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
      kndx += 1
    od

    kndx = 0
    while kndx <= inumbins do
      kPrevMags[kndx] = kMags[kndx]
      kndx += 1
    od

    karith = kenergy/(inumbins+1)
    kfeat_centroid_new = kfreq_weighted/(kenergy + 1e-12)
    kfeat_flatness_new = exp(klog_sum/(inumbins+1))/(karith + 1e-12)
    kenergy_mean = (kenergy + kprev_energy)*0.5
    kfeat_flux_raw = kflux_change_sum/(kenergy_mean + 1e-12)
    kfeat_flux_new = log(1 + (kfeat_flux_raw * kflux_gain))/log(1 + kflux_gain)
    kfeat_flux_new limit kfeat_flux_new, 0, 1
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
  kband_bins_total = (kmax_bin1-kmin_bin1+1) + (kmax_bin2-kmin_bin2+1) + (kmax_bin3-kmin_bin3+1)
  kband_bins_total = kband_bins_total < 1 ? 1 : kband_bins_total
  kpeak_mag_threshold = kmax_mag * kpkdens_thresh
  kpeak_count_sig = 0
  kidx = 0
  while kidx < kn1 do
    kpeak_bin = int(kBins1[kidx])
    if (kpeak_bin >= kmin_bin1 && kpeak_bin <= kmax_bin1 && kMags[kpeak_bin] >= kpeak_mag_threshold) then
      kpeak_count_sig += 1
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn2 do
    kpeak_bin = int(kBins2[kidx])
    if (kpeak_bin >= kmin_bin2 && kpeak_bin <= kmax_bin2 && kMags[kpeak_bin] >= kpeak_mag_threshold) then
      kpeak_count_sig += 1
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn3 do
    kpeak_bin = int(kBins3[kidx])
    if (kpeak_bin >= kmin_bin3 && kpeak_bin <= kmax_bin3 && kMags[kpeak_bin] >= kpeak_mag_threshold) then
      kpeak_count_sig += 1
    endif
    kidx += 1
  od
  kfeat_peak_density_raw = kpeak_count_sig/kband_bins_total
  kfeat_peak_density_new = kfeat_peak_density_raw*kpkdens_scale
  kfeat_peak_density_new limit kfeat_peak_density_new, 0, 1

  ktrace_bin1 = -1
  ktrace_bin2 = -1
  ktrace_bin3 = -1
  kidx = 0
  while kidx < kn1 do
    if (ktrace_bin1 < 0 && kBins1[kidx] > 0) then
      ktrace_bin1 = int(kBins1[kidx])
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn2 do
    if (ktrace_bin2 < 0 && kBins2[kidx] > 0) then
      ktrace_bin2 = int(kBins2[kidx])
    endif
    kidx += 1
  od
  kidx = 0
  while kidx < kn3 do
    if (ktrace_bin3 < 0 && kBins3[kidx] > 0) then
      ktrace_bin3 = int(kBins3[kidx])
    endif
    kidx += 1
  od
  ktrace_freq1 = (ktrace_bin1 > 0 ? ktrace_bin1*kbin_hz : 0)
  ktrace_freq2 = (ktrace_bin2 > 0 ? ktrace_bin2*kbin_hz : 0)
  ktrace_freq3 = (ktrace_bin3 > 0 ? ktrace_bin3*kbin_hz : 0)

  if kabove_noise_floor > 0 then
    kfeat_peak_density = kfeat_peak_density_new
    cabbageSetValue "FeatCentroid", kfeat_centroid, changed(kfeat_centroid)
    cabbageSetValue "FeatFlatness", kfeat_flatness, changed(kfeat_flatness)
    cabbageSetValue "FeatFlux", kfeat_flux, changed(kfeat_flux)
    cabbageSetValue "FeatTilt", kfeat_tilt, changed(kfeat_tilt)
    cabbageSetValue "FeatCrest", kfeat_crest, changed(kfeat_crest)
    cabbageSetValue "PkDens_raw", kfeat_peak_density_raw, changed(kfeat_peak_density_raw)
    cabbageSetValue "FeatPeakDensity", kfeat_peak_density, changed(kfeat_peak_density)
  endif

  kgate_rise trigger kabove_noise_floor, 0.5, 0
  ktime timeinsts
  if kgate_rise > 0 then
    kanalysis_pending = 1
    kanalysis_start = ktime
    ksum_centroid = 0
    ksum_flatness = 0
    ksum_tilt = 0
    ksum_crest = 0
    ksum_trace1 = 0
    ksum_trace2 = 0
    ksum_trace3 = 0
    ksum_count = 0
    ksum_trace1_count = 0
    ksum_trace2_count = 0
    ksum_trace3_count = 0
  endif

  if kanalysis_pending > 0 && kabove_noise_floor > 0 && kframe > 0 then
    ksum_centroid += kfeat_centroid
    ksum_flatness += kfeat_flatness
    ksum_tilt += kfeat_tilt
    ksum_crest += kfeat_crest
    if ktrace_freq1 > 0 then
      ksum_trace1 += ktrace_freq1
      ksum_trace1_count += 1
    endif
    if ktrace_freq2 > 0 then
      ksum_trace2 += ktrace_freq2
      ksum_trace2_count += 1
    endif
    if ktrace_freq3 > 0 then
      ksum_trace3 += ktrace_freq3
      ksum_trace3_count += 1
    endif
    ksum_count += 1
  endif

  kelapsed = ktime - kanalysis_start
  if kanalysis_pending > 0 && (kelapsed >= (kmidi_analysis_ms*0.001) || kabove_noise_floor <= 0) then
    if ksum_count > 0 then
      kavg_centroid = ksum_centroid/ksum_count
      kavg_flatness = ksum_flatness/ksum_count
      kavg_tilt = ksum_tilt/ksum_count
      kavg_crest = ksum_crest/ksum_count
      kavg_trace1 = (ksum_trace1_count > 0 ? ksum_trace1/ksum_trace1_count : 0)
      kavg_trace2 = (ksum_trace2_count > 0 ? ksum_trace2/ksum_trace2_count : 0)
      kavg_trace3 = (ksum_trace3_count > 0 ? ksum_trace3/ksum_trace3_count : 0)

      if kmidi_centroid_on > 0 then
        event "i", 201, 0, 0.2, kavg_centroid, kmidi_centroid_lo, kmidi_centroid_hi, int(limit(kmidi_centroid_chan,1,16)), 0, 12000
      endif
      if kmidi_flatness_on > 0 then
        event "i", 201, 0, 0.2, kavg_flatness, kmidi_flatness_lo, kmidi_flatness_hi, int(limit(kmidi_flatness_chan,1,16)), 0, 1
      endif
      if kmidi_tilt_on > 0 then
        event "i", 201, 0, 0.2, kavg_tilt, kmidi_tilt_lo, kmidi_tilt_hi, int(limit(kmidi_tilt_chan,1,16)), -8, 8
      endif
      if kmidi_crest_on > 0 then
        event "i", 201, 0, 0.2, kavg_crest, kmidi_crest_lo, kmidi_crest_hi, int(limit(kmidi_crest_chan,1,16)), 0, limit(kcrest_map_max, 1, 1000)
      endif
      if kmidi_trace1_on > 0 && kavg_trace1 > 0 then
        event "i", 202, 0, 0.2, kavg_trace1, kmidi_trace1_lo, kmidi_trace1_hi, int(limit(kmidi_trace1_chan,1,16)), kmidi_trace1_trsp
      endif
      if kmidi_trace2_on > 0 && kavg_trace2 > 0 then
        event "i", 202, 0, 0.2, kavg_trace2, kmidi_trace2_lo, kmidi_trace2_hi, int(limit(kmidi_trace2_chan,1,16)), kmidi_trace2_trsp
      endif
      if kmidi_trace3_on > 0 && kavg_trace3 > 0 then
        event "i", 202, 0, 0.2, kavg_trace3, kmidi_trace3_lo, kmidi_trace3_hi, int(limit(kmidi_trace3_chan,1,16)), kmidi_trace3_trsp
      endif
    endif
    kanalysis_pending = 0
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

instr 201
  ifeat = p4
  inote_lo = p5
  inote_hi = p6
  ichan = p7
  ifeat_min = p8
  ifeat_max = p9
  ivel = 100
  idur = (p3 < 0 ? 999 : p3)

  inote_min = (inote_lo < inote_hi ? inote_lo : inote_hi)
  inote_max = (inote_lo > inote_hi ? inote_lo : inote_hi)
  inorm = (ifeat-ifeat_min)/((ifeat_max-ifeat_min) + 1e-12)
  inorm limit inorm, 0, 1
  inote = int(round(inote_min + (inorm*(inote_max-inote_min))))

  noteondur ichan, inote, ivel, idur
endin

instr 202
  ifreq = p4
  inote_lo = p5
  inote_hi = p6
  ichan = p7
  itranspose = p8
  ivel = 100
  idur = (p3 < 0 ? 999 : p3)

  if ifreq <= 0 then
    turnoff
  endif

  inote_min = (inote_lo < inote_hi ? inote_lo : inote_hi)
  inote_max = (inote_lo > inote_hi ? inote_lo : inote_hi)
  imidi = 69 + (12 * (log(ifreq/440)/log(2))) + itranspose
  inote = int(round(limit(imidi, inote_min, inote_max)))

  noteondur ichan, inote, ivel, idur
endin

</CsInstruments>  
<CsScore>
i1 1 86400
</CsScore>
</CsoundSynthesizer>