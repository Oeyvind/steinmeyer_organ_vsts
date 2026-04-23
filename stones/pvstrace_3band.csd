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

csoundoutput bounds(5,395,360,240)

groupbox bounds(368, 5, 327, 340), text("Spectral Band Analyzer"), colour(25, 45, 55), fontColour(200, 220, 220)

; Row 1: On, Record Baseline (latched, green=active)
checkbox channel("SbaOn"), bounds(374, 28, 20, 18), text("")
label bounds(396, 30, 20, 12), text("Win"), fontSize(10), align("left")
button channel("SbaRecordBaseline"), bounds(418, 26, 108, 20), text("Record Baseline"), value(0), colour:0(60,80,80), colour:1(20,160,60), fontColour:0(180,200,200), fontColour:1(255,255,255)
checkbox channel("SbaOn2nd"), bounds(534, 28, 20, 18), text("")
label bounds(556, 30, 20, 12), text("2nd"), fontSize(10), align("left")

; Row 2: baseline weights, AdaptTC, GateDb, MidiChan
nslider channel("SbaRecWeight"),   bounds(374, 51, 60, 20), text("RecWt"),   range(0, 1, 1, 1, 0.01), fontSize(9)
nslider channel("SbaAdaptWeight"), bounds(436, 51, 63, 20), text("AdaptWt"), range(0, 1, 0, 1, 0.01), fontSize(9)
nslider channel("SbaAdaptTC"),     bounds(501, 51, 55, 20), text("AdaptTC"), range(0.5, 30, 5, 1, 0.1), fontSize(9)
nslider channel("SbaGateDb"),      bounds(558, 51, 58, 20), text("GateDb"),  range(-90, 0, -55, 1, 0.1), fontSize(9)
nslider channel("SbaHystDb"),     bounds(618, 51, 52, 20), text("HystDb"),  range(0, 30, 6, 1, 0.1), fontSize(9)

; Row 3: Vel, DurMs, envelope follower Att/Rel
nslider channel("SbaMidiVel"), bounds(374, 74, 48, 20), text("Vel"), range(1, 127, 100, 1, 1, 1), fontSize(9)
nslider channel("SbaMidiDur"), bounds(424, 74, 55, 20), text("DurMs"), range(-1, 1000, 200, 1, 1, 1), fontSize(9)
nslider channel("SbaFollAtt"), bounds(481, 74, 50, 20), text("Att"), range(0.001, 0.5, 0.005, 1, 0.001), fontSize(9)
nslider channel("SbaFollRel"),    bounds(533, 74, 52, 20), text("Rel"),    range(0.001, 2, 0.08, 1, 0.001), fontSize(9)
nslider channel("SbaWinDelayMs"), bounds(587, 74, 52, 20), text("WinDly"), range(0, 100, 0, 1, 1, 1), fontSize(9)

; Row 4: Save/Load baseline (AmpScale removed — dB display handles range)
button channel("SbaSaveBaseline"), bounds(374, 96, 90, 20), text("Save Baseline"), value(0), colour:0(50,70,80), colour:1(60,120,200), fontColour:0(180,200,200), fontColour:1(255,255,255)
button channel("SbaLoadBaseline"), bounds(466, 96, 90, 20), text("Load Baseline"), value(0), colour:0(50,70,80), colour:1(200,130,50), fontColour:0(180,200,200), fontColour:1(255,255,255)

; Band amplitude horizontal bars — dB re baseline (0 dB = at baseline level)
label bounds(374, 120, 56, 10), text("100-200"), fontSize(8), align("left")
hslider channel("SbaBandAmp1"), bounds(432, 118, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 135, 56, 10), text("200-300"), fontSize(8), align("left")
hslider channel("SbaBandAmp2"), bounds(432, 133, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 150, 56, 10), text("300-400"), fontSize(8), align("left")
hslider channel("SbaBandAmp3"), bounds(432, 148, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 165, 56, 10), text("400-500"), fontSize(8), align("left")
hslider channel("SbaBandAmp4"), bounds(432, 163, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 180, 56, 10), text("500-700"), fontSize(8), align("left")
hslider channel("SbaBandAmp5"), bounds(432, 178, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 195, 56, 10), text("700-900"), fontSize(8), align("left")
hslider channel("SbaBandAmp6"), bounds(432, 193, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 210, 56, 10), text("900-1700"), fontSize(8), align("left")
hslider channel("SbaBandAmp7"), bounds(432, 208, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(374, 225, 56, 10), text("1700-2600"), fontSize(8), align("left")
hslider channel("SbaBandAmp8"), bounds(432, 223, 256, 13), range(-40, 20, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")

; MIDI note per band
nslider channel("SbaBandNote1"), bounds(374, 242, 38, 20), text("B1"), range(0, 127, 48, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote2"), bounds(413, 242, 38, 20), text("B2"), range(0, 127, 52, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote3"), bounds(452, 242, 38, 20), text("B3"), range(0, 127, 55, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote4"), bounds(491, 242, 38, 20), text("B4"), range(0, 127, 57, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote5"), bounds(530, 242, 38, 20), text("B5"), range(0, 127, 60, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote6"), bounds(569, 242, 38, 20), text("B6"), range(0, 127, 64, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote7"), bounds(608, 242, 38, 20), text("B7"), range(0, 127, 67, 1, 1, 1), fontSize(8)
nslider channel("SbaBandNote8"), bounds(647, 242, 38, 20), text("B8"), range(0, 127, 72, 1, 1, 1), fontSize(8)

; Winner display
nslider channel("SbaTrigBand"), bounds(374, 268, 75, 27), text("WinBand"), range(0, 8, 0, 1, 1), active(0), fontSize(10)
nslider channel("SbaTrigNote"), bounds(452, 268, 75, 27), text("WinNote"), range(0, 127, 0, 1, 1), active(0), fontSize(10)
nslider channel("SbaMidiChan"), bounds(532, 268, 52, 27), text("WinCh"),  range(1, 16, 10, 1, 1, 1), fontSize(9)

; 2nd best display
nslider channel("SbaTrigBand2nd"), bounds(374, 298, 75, 27), text("2ndBand"), range(0, 8, 0, 1, 1), active(0), fontSize(10)
nslider channel("SbaTrigNote2nd"), bounds(452, 298, 75, 27), text("2ndNote"), range(0, 127, 0, 1, 1), active(0), fontSize(10)
nslider channel("SbaMidiChan2nd"), bounds(532, 298, 52, 27), text("2ndCh"), range(1, 16, 11, 1, 1, 1), fontSize(9)
label bounds(588, 307, 107, 12), text("2nd -> MIDI on gate"), fontSize(9), align("left")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d
</CsOptions>
<CsInstruments>

  ksmps = 32
  nchnls = 2
  0dbfs=1

  ; Baseline save/load table (8 slots) and load-completion flag
  giBlSaveTable ftgen 2001, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0
  gkLoadFlag    init 0


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

instr 2
  ; ==========================================
  ; Spectral Band Analyzer — 8 bands (edges: 100,200,300,400,500,700,900,1700,2600 Hz)
  ; Normalized against a stored baseline; winning band triggers MIDI on gate rise.
  ; Independent from instr 1.
  ; ==========================================
  kSbaOn      chnget "SbaOn"
  kSbaAdaptTC  chnget "SbaAdaptTC"
  kSbaChan    chnget "SbaMidiChan"
  kSbaGateDb  chnget "SbaGateDb"
  kSbaVel     chnget "SbaMidiVel"
  kSbaDurMs   chnget "SbaMidiDur"
  kSbaWinDelayMs chnget "SbaWinDelayMs"
  kSbaNote1   chnget "SbaBandNote1"
  kSbaNote2   chnget "SbaBandNote2"
  kSbaNote3   chnget "SbaBandNote3"
  kSbaNote4   chnget "SbaBandNote4"
  kSbaNote5   chnget "SbaBandNote5"
  kSbaNote6   chnget "SbaBandNote6"
  kSbaNote7   chnget "SbaBandNote7"
  kSbaNote8   chnget "SbaBandNote8"
  kRecWeight   chnget "SbaRecWeight"
  kAdaptWeight chnget "SbaAdaptWeight"
  kSbaOn2nd    chnget "SbaOn2nd"
  kSbaChan2nd  chnget "SbaMidiChan2nd"
  kSbaHystDb   chnget "SbaHystDb"

  a1 inch 1

  ; Time-domain bandpass filtering — butterbp(centre, bandwidth) cascaded x2 for steeper rolloff
  ; Band edges: 100-200, 200-300, 300-400, 400-500, 500-700, 700-900, 900-1700, 1700-2600 Hz
  kFollAtt chnget "SbaFollAtt"
  kFollRel chnget "SbaFollRel"

  aBp1 butterbp a1,  150,  100   ; 100-200 Hz,   centre=150,  bw=100
  aBp1 butterbp aBp1, 150, 100
  aBp2 butterbp a1,  250,  100   ; 200-300 Hz,   centre=250,  bw=100
  aBp2 butterbp aBp2, 250, 100
  aBp3 butterbp a1,  350,  100   ; 300-400 Hz,   centre=350,  bw=100
  aBp3 butterbp aBp3, 350, 100
  aBp4 butterbp a1,  450,  100   ; 400-500 Hz,   centre=450,  bw=100
  aBp4 butterbp aBp4, 450, 100
  aBp5 butterbp a1,  600,  200   ; 500-700 Hz,   centre=600,  bw=200
  aBp5 butterbp aBp5, 600, 200
  aBp6 butterbp a1,  800,  200   ; 700-900 Hz,   centre=800,  bw=200
  aBp6 butterbp aBp6, 800, 200
  aBp7 butterbp a1, 1300,  800   ; 900-1700 Hz,  centre=1300, bw=800
  aBp7 butterbp aBp7, 1300, 800
  aBp8 butterbp a1, 2150,  900   ; 1700-2600 Hz, centre=2150, bw=900
  aBp8 butterbp aBp8, 2150, 900

  ; Envelope follower per band
  aAmp1 follow2 aBp1, kFollAtt, kFollRel
  aAmp2 follow2 aBp2, kFollAtt, kFollRel
  aAmp3 follow2 aBp3, kFollAtt, kFollRel
  aAmp4 follow2 aBp4, kFollAtt, kFollRel
  aAmp5 follow2 aBp5, kFollAtt, kFollRel
  aAmp6 follow2 aBp6, kFollAtt, kFollRel
  aAmp7 follow2 aBp7, kFollAtt, kFollRel
  aAmp8 follow2 aBp8, kFollAtt, kFollRel
  kAmp1 = downsamp(aAmp1)
  kAmp2 = downsamp(aAmp2)
  kAmp3 = downsamp(aAmp3)
  kAmp4 = downsamp(aAmp4)
  kAmp5 = downsamp(aAmp5)
  kAmp6 = downsamp(aAmp6)
  kAmp7 = downsamp(aAmp7)
  kAmp8 = downsamp(aAmp8)

  ; Recorded baseline (snapshot while button is latched ON)
  kBlRec1 init 1e-7
  kBlRec2 init 1e-7
  kBlRec3 init 1e-7
  kBlRec4 init 1e-7
  kBlRec5 init 1e-7
  kBlRec6 init 1e-7
  kBlRec7 init 1e-7
  kBlRec8 init 1e-7
  ; Flag: 0 = no explicit baseline ever recorded/loaded, kBlRec mirrors kBlAdapt
  kHasRecorded init 0

  ; Adaptive baseline (EMA, always runs)
  kBlAdapt1 init 1e-7
  kBlAdapt2 init 1e-7
  kBlAdapt3 init 1e-7
  kBlAdapt4 init 1e-7
  kBlAdapt5 init 1e-7
  kBlAdapt6 init 1e-7
  kBlAdapt7 init 1e-7
  kBlAdapt8 init 1e-7

  ; Record Baseline button (latched): integrate amplitudes over duration, store average on release
  kRecBtn chnget "SbaRecordBaseline"
  kRecBtnRise trigger kRecBtn, 0.5, 0
  kRecBtnFall trigger kRecBtn, 0.5, 1
  kRecSum1 init 0
  kRecSum2 init 0
  kRecSum3 init 0
  kRecSum4 init 0
  kRecSum5 init 0
  kRecSum6 init 0
  kRecSum7 init 0
  kRecSum8 init 0
  kRecCnt  init 0

  if kRecBtnRise > 0 then
    kRecSum1 = 0
    kRecSum2 = 0
    kRecSum3 = 0
    kRecSum4 = 0
    kRecSum5 = 0
    kRecSum6 = 0
    kRecSum7 = 0
    kRecSum8 = 0
    kRecCnt  = 0
    printf "SBA: Recording baseline - active\n", 1
  endif

  if kRecBtn > 0.5 then
    kRecSum1 += (kAmp1 > 1e-9 ? kAmp1 : kBlAdapt1)
    kRecSum2 += (kAmp2 > 1e-9 ? kAmp2 : kBlAdapt2)
    kRecSum3 += (kAmp3 > 1e-9 ? kAmp3 : kBlAdapt3)
    kRecSum4 += (kAmp4 > 1e-9 ? kAmp4 : kBlAdapt4)
    kRecSum5 += (kAmp5 > 1e-9 ? kAmp5 : kBlAdapt5)
    kRecSum6 += (kAmp6 > 1e-9 ? kAmp6 : kBlAdapt6)
    kRecSum7 += (kAmp7 > 1e-9 ? kAmp7 : kBlAdapt7)
    kRecSum8 += (kAmp8 > 1e-9 ? kAmp8 : kBlAdapt8)
    kRecCnt  += 1
  endif

  if kRecBtnFall > 0 && kRecCnt > 0 then
    kHasRecorded = 1
    kBlRec1 = kRecSum1 / kRecCnt
    kBlRec2 = kRecSum2 / kRecCnt
    kBlRec3 = kRecSum3 / kRecCnt
    kBlRec4 = kRecSum4 / kRecCnt
    kBlRec5 = kRecSum5 / kRecCnt
    kBlRec6 = kRecSum6 / kRecCnt
    kBlRec7 = kRecSum7 / kRecCnt
    kBlRec8 = kRecSum8 / kRecCnt
    printf "SBA: Recording baseline - stopped\n", 1
  endif

  if kHasRecorded == 0 then
    ; No baseline yet: mirror adaptive baseline so bars are always active before first record
    kBlRec1 = kBlAdapt1
    kBlRec2 = kBlAdapt2
    kBlRec3 = kBlAdapt3
    kBlRec4 = kBlAdapt4
    kBlRec5 = kBlAdapt5
    kBlRec6 = kBlAdapt6
    kBlRec7 = kBlAdapt7
    kBlRec8 = kBlAdapt8
  endif

  ; Adaptive baseline: EMA always tracks (cheap; used as live reference even when AdaptWeight=0)
  kAlpha = 1 - exp(-ksmps / (sr * kSbaAdaptTC))
  kBlAdapt1 = kBlAdapt1 + (kAmp1 - kBlAdapt1) * kAlpha
  kBlAdapt2 = kBlAdapt2 + (kAmp2 - kBlAdapt2) * kAlpha
  kBlAdapt3 = kBlAdapt3 + (kAmp3 - kBlAdapt3) * kAlpha
  kBlAdapt4 = kBlAdapt4 + (kAmp4 - kBlAdapt4) * kAlpha
  kBlAdapt5 = kBlAdapt5 + (kAmp5 - kBlAdapt5) * kAlpha
  kBlAdapt6 = kBlAdapt6 + (kAmp6 - kBlAdapt6) * kAlpha
  kBlAdapt7 = kBlAdapt7 + (kAmp7 - kBlAdapt7) * kAlpha
  kBlAdapt8 = kBlAdapt8 + (kAmp8 - kBlAdapt8) * kAlpha

  ; Apply loaded baselines from table into recorded baseline
  if gkLoadFlag > 0 then
    kHasRecorded = 1
    kBlRec1 = tab:k(0, giBlSaveTable)
    kBlRec2 = tab:k(1, giBlSaveTable)
    kBlRec3 = tab:k(2, giBlSaveTable)
    kBlRec4 = tab:k(3, giBlSaveTable)
    kBlRec5 = tab:k(4, giBlSaveTable)
    kBlRec6 = tab:k(5, giBlSaveTable)
    kBlRec7 = tab:k(6, giBlSaveTable)
    kBlRec8 = tab:k(7, giBlSaveTable)
    gkLoadFlag = 0
  endif

  ; Blend effective baseline. kBlAdapt is always live-tracking, so it serves as the
  ; fallback reference when both weights are 0 — bars always show meaningful movement.
  kWtRemainder = limit(1 - kRecWeight - kAdaptWeight, 0, 1)
  kEffBl1 = kBlRec1 * kRecWeight + kBlAdapt1 * kAdaptWeight + kBlAdapt1 * kWtRemainder
  kEffBl2 = kBlRec2 * kRecWeight + kBlAdapt2 * kAdaptWeight + kBlAdapt2 * kWtRemainder
  kEffBl3 = kBlRec3 * kRecWeight + kBlAdapt3 * kAdaptWeight + kBlAdapt3 * kWtRemainder
  kEffBl4 = kBlRec4 * kRecWeight + kBlAdapt4 * kAdaptWeight + kBlAdapt4 * kWtRemainder
  kEffBl5 = kBlRec5 * kRecWeight + kBlAdapt5 * kAdaptWeight + kBlAdapt5 * kWtRemainder
  kEffBl6 = kBlRec6 * kRecWeight + kBlAdapt6 * kAdaptWeight + kBlAdapt6 * kWtRemainder
  kEffBl7 = kBlRec7 * kRecWeight + kBlAdapt7 * kAdaptWeight + kBlAdapt7 * kWtRemainder
  kEffBl8 = kBlRec8 * kRecWeight + kBlAdapt8 * kAdaptWeight + kBlAdapt8 * kWtRemainder

  ; Normalized amplitudes
  kN1 = kAmp1 / (kEffBl1 + 1e-12)
  kN2 = kAmp2 / (kEffBl2 + 1e-12)
  kN3 = kAmp3 / (kEffBl3 + 1e-12)
  kN4 = kAmp4 / (kEffBl4 + 1e-12)
  kN5 = kAmp5 / (kEffBl5 + 1e-12)
  kN6 = kAmp6 / (kEffBl6 + 1e-12)
  kN7 = kAmp7 / (kEffBl7 + 1e-12)
  kN8 = kAmp8 / (kEffBl8 + 1e-12)

  ; Noise gate on overall RMS
  kSbaRms  rms a1
  kSbaDb   = dbfsamp(kSbaRms + 1e-12)
  ; Schmitt trigger: opens at GateDb, closes at (GateDb - HystDb)
  kSbaGate init 0
  if kSbaGate == 0 && kSbaDb > kSbaGateDb then
    kSbaGate = 1
  elseif kSbaGate == 1 && kSbaDb < (kSbaGateDb - kSbaHystDb) then
    kSbaGate = 0
  endif

  ; Update GUI horizontal bar meters at ~20 Hz — dB re baseline (0 dB = at baseline)
  kGuiTrig metro 20
  kNdB1 = limit(20 * log10(kN1 + 1e-12), -40, 20)
  kNdB2 = limit(20 * log10(kN2 + 1e-12), -40, 20)
  kNdB3 = limit(20 * log10(kN3 + 1e-12), -40, 20)
  kNdB4 = limit(20 * log10(kN4 + 1e-12), -40, 20)
  kNdB5 = limit(20 * log10(kN5 + 1e-12), -40, 20)
  kNdB6 = limit(20 * log10(kN6 + 1e-12), -40, 20)
  kNdB7 = limit(20 * log10(kN7 + 1e-12), -40, 20)
  kNdB8 = limit(20 * log10(kN8 + 1e-12), -40, 20)
  cabbageSetValue "SbaBandAmp1", kNdB1, kGuiTrig
  cabbageSetValue "SbaBandAmp2", kNdB2, kGuiTrig
  cabbageSetValue "SbaBandAmp3", kNdB3, kGuiTrig
  cabbageSetValue "SbaBandAmp4", kNdB4, kGuiTrig
  cabbageSetValue "SbaBandAmp5", kNdB5, kGuiTrig
  cabbageSetValue "SbaBandAmp6", kNdB6, kGuiTrig
  cabbageSetValue "SbaBandAmp7", kNdB7, kGuiTrig
  cabbageSetValue "SbaBandAmp8", kNdB8, kGuiTrig

  ; Save Baseline: write kBl values to table then trigger file save
  kSaveBtn chnget "SbaSaveBaseline"
  if changed(kSaveBtn) == 1 && kSaveBtn > 0.5 then
    tabw kBlRec1, 0, giBlSaveTable
    tabw kBlRec2, 1, giBlSaveTable
    tabw kBlRec3, 2, giBlSaveTable
    tabw kBlRec4, 3, giBlSaveTable
    tabw kBlRec5, 4, giBlSaveTable
    tabw kBlRec6, 5, giBlSaveTable
    tabw kBlRec7, 6, giBlSaveTable
    tabw kBlRec8, 7, giBlSaveTable
    event "i", 204, 0, 0.01
    cabbageSetValue "SbaSaveBaseline", 0, 1
  endif

  kLoadBtn chnget "SbaLoadBaseline"
  if changed(kLoadBtn) == 1 && kLoadBtn > 0.5 then
    event "i", 205, 0, 0.01
    cabbageSetValue "SbaLoadBaseline", 0, 1
  endif

  ; Peak-tracking state: accumulate max per band from gate rise until WinDelay expires
  kPkActive init 0
  kPkCount  init 0
  kPk1 init 0
  kPk2 init 0
  kPk3 init 0
  kPk4 init 0
  kPk5 init 0
  kPk6 init 0
  kPk7 init 0
  kPk8 init 0
  ; Hold-mode state: tracks which notes are currently held
  kHeld    init 0  ; 1 = winner note is held
  kHeldNote init 0
  kHeldChan init 0
  kHeld2nd    init 0  ; 1 = 2nd note is held
  kHeldNote2nd init 0
  kHeldChan2nd init 0

  ; Trigger MIDI note for winner and/or 2nd best on gate rising edge (with configurable delay)
  if kSbaOn > 0 || kSbaOn2nd > 0 then
    kGateRise trigger kSbaGate, 0.5, 0
    kGateFall trigger kSbaGate, 0.5, 1

    ; Gate fall: send noteoff for any held notes
    if kGateFall > 0 then
      if kHeld > 0 then
        event "i", 207, 0, 0.01, kHeldNote, kHeldChan
        kHeld = 0
      endif
      if kHeld2nd > 0 then
        event "i", 207, 0, 0.01, kHeldNote2nd, kHeldChan2nd
        kHeld2nd = 0
      endif
      kPkActive = 0
    endif

    if kGateRise > 0 then
      ; If a note is still held from previous event, release it first
      if kHeld > 0 then
        event "i", 207, 0, 0, kHeldNote, kHeldChan
        kHeld = 0
      endif
      if kHeld2nd > 0 then
        event "i", 207, 0, 0, kHeldNote2nd, kHeldChan2nd
        kHeld2nd = 0
      endif
      ; arm peak-tracking window
      kPkActive = 1
      kPkCount  = 0
      kPk1 = 0
      kPk2 = 0
      kPk3 = 0
      kPk4 = 0
      kPk5 = 0
      kPk6 = 0
      kPk7 = 0
      kPk8 = 0
    endif
    if kPkActive > 0 then
      ; accumulate per-band peaks
      kPk1 = (kN1 > kPk1 ? kN1 : kPk1)
      kPk2 = (kN2 > kPk2 ? kN2 : kPk2)
      kPk3 = (kN3 > kPk3 ? kN3 : kPk3)
      kPk4 = (kN4 > kPk4 ? kN4 : kPk4)
      kPk5 = (kN5 > kPk5 ? kN5 : kPk5)
      kPk6 = (kN6 > kPk6 ? kN6 : kPk6)
      kPk7 = (kN7 > kPk7 ? kN7 : kPk7)
      kPk8 = (kN8 > kPk8 ? kN8 : kPk8)
      kPkCount += ksmps / sr
      if kPkCount * 1000 >= kSbaWinDelayMs then
        kPkActive = 0
        ; find winner from accumulated peaks
        kWinBand = 1
        kWinMax  = kPk1
        kWinNote = kSbaNote1
        if kPk2 > kWinMax then
          kWinMax  = kPk2
          kWinBand = 2
          kWinNote = kSbaNote2
        endif
        if kPk3 > kWinMax then
          kWinMax  = kPk3
          kWinBand = 3
          kWinNote = kSbaNote3
        endif
        if kPk4 > kWinMax then
          kWinMax  = kPk4
          kWinBand = 4
          kWinNote = kSbaNote4
        endif
        if kPk5 > kWinMax then
          kWinMax  = kPk5
          kWinBand = 5
          kWinNote = kSbaNote5
        endif
        if kPk6 > kWinMax then
          kWinMax  = kPk6
          kWinBand = 6
          kWinNote = kSbaNote6
        endif
        if kPk7 > kWinMax then
          kWinMax  = kPk7
          kWinBand = 7
          kWinNote = kSbaNote7
        endif
        if kPk8 > kWinMax then
          kWinMax  = kPk8
          kWinBand = 8
          kWinNote = kSbaNote8
        endif
        ; find second-best from accumulated peaks
        kSecBand = 0
        kSecMax  = -1
        kSecNote = kSbaNote1
        if kWinBand != 1 && kPk1 > kSecMax then
          kSecMax  = kPk1
          kSecBand = 1
          kSecNote = kSbaNote1
        endif
        if kWinBand != 2 && kPk2 > kSecMax then
          kSecMax  = kPk2
          kSecBand = 2
          kSecNote = kSbaNote2
        endif
        if kWinBand != 3 && kPk3 > kSecMax then
          kSecMax  = kPk3
          kSecBand = 3
          kSecNote = kSbaNote3
        endif
        if kWinBand != 4 && kPk4 > kSecMax then
          kSecMax  = kPk4
          kSecBand = 4
          kSecNote = kSbaNote4
        endif
        if kWinBand != 5 && kPk5 > kSecMax then
          kSecMax  = kPk5
          kSecBand = 5
          kSecNote = kSbaNote5
        endif
        if kWinBand != 6 && kPk6 > kSecMax then
          kSecMax  = kPk6
          kSecBand = 6
          kSecNote = kSbaNote6
        endif
        if kWinBand != 7 && kPk7 > kSecMax then
          kSecMax  = kPk7
          kSecBand = 7
          kSecNote = kSbaNote7
        endif
        if kWinBand != 8 && kPk8 > kSecMax then
          kSecMax  = kPk8
          kSecBand = 8
          kSecNote = kSbaNote8
        endif
        if kSbaOn > 0 then
          ; hold mode: dur < 0 → fire long note, release on gate fall
          if kSbaDurMs < 0 then
            event "i", 203, 0, 9999, int(kWinNote), int(limit(kSbaChan, 1, 16)), int(kSbaVel)
            kHeld     = 1
            kHeldNote = int(kWinNote)
            kHeldChan = int(limit(kSbaChan, 1, 16))
          else
            event "i", 203, 0, kSbaDurMs*0.001, int(kWinNote), int(limit(kSbaChan, 1, 16)), int(kSbaVel)
          endif
          cabbageSetValue "SbaTrigBand", kWinBand, 1
          cabbageSetValue "SbaTrigNote", kWinNote, 1
        endif
        if kSbaOn2nd > 0 && kSecBand > 0 then
          if kSbaDurMs < 0 then
            event "i", 203, 0, 9999, int(kSecNote), int(limit(kSbaChan2nd, 1, 16)), int(kSbaVel)
            kHeld2nd     = 1
            kHeldNote2nd = int(kSecNote)
            kHeldChan2nd = int(limit(kSbaChan2nd, 1, 16))
          else
            event "i", 206, 0, kSbaDurMs*0.001, int(kSecNote), int(limit(kSbaChan2nd, 1, 16)), int(kSbaVel)
          endif
          cabbageSetValue "SbaTrigBand2nd", kSecBand, 1
          cabbageSetValue "SbaTrigNote2nd", kSecNote, 1
        endif
      endif
    endif
  endif

endin

instr 203
  ; MIDI note output for the winning spectral band
  inote = p4
  ichan = p5
  ivel  = p6
  noteondur ichan, inote, ivel, p3
endin

instr 206
  ; MIDI note output for the 2nd best spectral band
  inote = p4
  ichan = p5
  ivel  = p6
  noteondur ichan, inote, ivel, p3
endin

instr 207
  ; MIDI noteoff for hold mode (vel=0 noteoff)
  inote = p4
  ichan = p5
  noteondur ichan, inote, 0, 0.01
endin

instr 204
  ; Save baselines: write giBlSaveTable to disk
  ftsave "sba_baseline.dat", 0, giBlSaveTable
  prints "SBA: Baseline saved to sba_baseline.dat\n"
endin

instr 205
  ; Load baselines: read giBlSaveTable from disk, then signal instr 2 to apply
  ftload "sba_baseline.dat", 0, giBlSaveTable
  gkLoadFlag = 1
  prints "SBA: Baseline loaded from sba_baseline.dat\n"
endin

</CsInstruments>  
<CsScore>
i1 1 86400
i2 1 86400
</CsScore>
</CsoundSynthesizer>