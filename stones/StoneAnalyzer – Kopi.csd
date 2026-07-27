<Cabbage>
form size(700, 640), caption("Stone Analyzer"), pluginId("stan"), colour(40,60,60), latency(128), guiMode("queue")

; ML3 controls (left half, unchanged bounds)
nslider channel("noisefloor"), bounds(5, 10, 50, 25), text("Noise floor"), range(-90, 0, -40, 1, 1)
nslider channel("predelay"), bounds(5, 45, 50, 25), text("Predelay"), range(0.0, 20, 12, 0.5)
nslider channel("trans_thresh"), bounds(5, 80, 50, 25), text("T.thresh"), range(0, 30, 2.5)
nslider channel("retrig_thresh"), bounds(5, 115, 50, 25), text("T.retrig"), range(0, 30, 2)
nslider channel("low_trans"), bounds(5, 150, 50, 25), text("T.lowlimit"), range(-50, -5, -30, 1, 1)
nslider channel("double_limit"), bounds(5, 185, 50, 25), text("T.dbl.lim"), range(0.01, 0.5, 0.05, 0.35)
nslider channel("shape"), bounds(5, 220, 50, 25), text("Shape"), range(0.3, 3, 1, 0.35)
nslider channel("amp_trans"), bounds(5, 255, 50, 25), text("Amp_amt"), range(0.0, 1, 1, 0.35)

rslider channel("attack"), bounds(70, 10, 60, 60), text("Climb"), range(0.01, 1, 0.01, 0.5)
rslider channel("decay"), bounds(140, 10, 60, 60), text("Fall"), range(0.01, 2, 0.5, 0.5)
rslider channel("compress_trans"), bounds(70, 85, 60, 60), text("Levelpeaks"), range(0.0, 12, 0, 0.3)
rslider channel("compress_sustain"), bounds(140, 85, 60, 60), text("Flatwater"), range(0.0, 12, 0, 0.3)
hslider channel("compress_makeup"), bounds(70, 145, 120, 20), range(0.0, 1, 0.5)
label bounds(70, 160, 120, 10), text("Makeup")

rslider channel("transientlevel"), bounds(70, 185, 60, 60), text("Mountains"), range(-96, 6, 1, 5)
rslider channel("sustainlevel"), bounds(140, 185, 60, 60), text("Lakes"), range(-96, 6, -96, 5)

rslider channel("ice_decay"), bounds(210, 10, 60, 60), text("Ice_dec"), range(0.01, 2, 0.5, 0.5)
rslider channel("noise_decay"), bounds(210, 85, 60, 60), text("Noise_dec"), range(0.01, 2, 0.5, 0.5)
rslider channel("spectranslevel"), bounds(210, 185, 60, 60), text("Ice"), range(-96, 6, -96, 5)
rslider channel("noiselevel"), bounds(210, 250, 60, 60), text("Noise"), range(-96, 6, -96, 5)

rslider channel("panwidth"), bounds(70, 250, 60, 60), text("Panwidth"), range(0, 1, 0.5)

; ML3 audio output — moved 40px down and extended to fill width
csoundoutput bounds(5,370,690,100)

; SBA groupbox and controls — moved 70px left
groupbox bounds(298, 5, 402, 340), text("Spectral Band Analyzer"), colour(25, 45, 55), fontColour(200, 220, 220)

; Row 1: baseline/gate setup
nslider channel("RecWeight"),   bounds(304, 26, 60, 20), text("RecWt"),   range(0, 1, 1, 1, 0.01), fontSize(9)
nslider channel("WinDelayMs"), bounds(366, 26, 55, 20), text("WinDly"), range(0, 100, 0, 1, 1, 1), fontSize(9)
nslider channel("FollAtt"), bounds(423, 26, 50, 20), text("Att"), range(0.001, 0.5, 0.005, 1, 0.001), fontSize(9)
nslider channel("FollRel"),    bounds(475, 26, 52, 20), text("Rel"),    range(0.001, 2, 0.08, 1, 0.001), fontSize(9)

; Row 2: note and sustain behavior
nslider channel("MidiVel"), bounds(304, 49, 45, 20), text("Vel"), range(1, 127, 100, 1, 1, 1), fontSize(9)
nslider channel("MidiDur"), bounds(351, 49, 55, 20), text("DurMs"), range(1, 1000, 200, 1, 1, 1), fontSize(9)
label bounds(408, 49, 56, 9), text("Sustain"), fontSize(9), align("centre")
button channel("Sustain"), bounds(408, 59, 56, 10), text("", ""), value(0), colour:0(60,80,80), colour:1(30,140,170), fontColour:0(180,200,200), fontColour:1(255,255,255)
label bounds(408, 71, 56, 9), text("CentSus"), fontSize(8), align("centre")
button channel("SustainCent"), bounds(408, 71, 56, 10), text("", ""), value(0), colour:0(60,80,80), colour:1(170,120,30), fontColour:0(180,200,200), fontColour:1(255,255,255)
nslider channel("HystDb"),     bounds(466, 49, 52, 20), text("Hyst dB"),  range(0, 30, 6, 1, 0.1), fontSize(9)
nslider channel("MaxDurMs"), bounds(520, 49, 55, 20), text("MaxDur"), range(50, 10000, 3000, 1, 1, 1), fontSize(9)
combobox channel("HoldMode"), bounds(577, 49, 69, 20), items("lock", "switch", "add"), value(1), fontSize(8)

; Row 3: baseline buttons
button channel("RecordBaseline"), bounds(304, 96, 108, 14), text("Record Baseline"), value(0), colour:0(60,80,80), colour:1(20,160,60), fontColour:0(180,200,200), fontColour:1(255,255,255)
button channel("SaveBaseline"), bounds(414, 96, 90, 14), text("Save Baseline"), value(0), colour:0(50,70,80), colour:1(60,120,200), fontColour:0(180,200,200), fontColour:1(255,255,255)
button channel("LoadBaseline"), bounds(506, 96, 90, 14), text("Load Baseline"), value(0), colour:0(50,70,80), colour:1(200,130,50), fontColour:0(180,200,200), fontColour:1(255,255,255)

; Band amplitude horizontal bars — dB re baseline (0 dB = at baseline level)
label bounds(304, 120, 56, 10), text("100-200"), fontSize(8), align("left")
hslider channel("BandAmp1"), bounds(362, 118, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 135, 56, 10), text("200-300"), fontSize(8), align("left")
hslider channel("BandAmp2"), bounds(362, 133, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 150, 56, 10), text("300-400"), fontSize(8), align("left")
hslider channel("BandAmp3"), bounds(362, 148, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 165, 56, 10), text("400-500"), fontSize(8), align("left")
hslider channel("BandAmp4"), bounds(362, 163, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 180, 56, 10), text("500-700"), fontSize(8), align("left")
hslider channel("BandAmp5"), bounds(362, 178, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 195, 56, 10), text("700-900"), fontSize(8), align("left")
hslider channel("BandAmp6"), bounds(362, 193, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 210, 56, 10), text("900-1700"), fontSize(8), align("left")
hslider channel("BandAmp7"), bounds(362, 208, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(304, 225, 56, 10), text("1700-2600"), fontSize(8), align("left")
hslider channel("BandAmp8"), bounds(362, 223, 256, 13), range(0, 80, 0), active(0), colour:0(30,50,50), trackerColour(80,200,120), text("")
label bounds(622, 98, 44, 10), text("Cent"), fontSize(8), align("left")
vslider channel("CentroidBand"), bounds(624, 110, 20, 134), range(1, 8, 1, 1, 0.01), active(0), colour:0(30,50,50), trackerColour(200,180,80), text("")
label bounds(650, 106, 44, 10), text("Stats"), fontSize(8), align("left")
nslider channel("StatsPeriodSec"), bounds(650, 130, 44, 20), text("Win"), range(0.2, 10, 2, 1, 0.1), fontSize(8)
nslider channel("StatsRate"), bounds(650, 154, 44, 20), text("Hits"), range(0, 50, 0, 1, 0.01), active(0), fontSize(8)
nslider channel("StatsTempSpread"), bounds(650, 178, 44, 20), text("Temp"), range(0, 500, 0, 1, 0.01), active(0), fontSize(8)
nslider channel("StatsSpecSpread"), bounds(650, 202, 44, 20), text("Spec"), range(0, 8, 0, 1, 0.01), active(0), fontSize(8)

; MIDI note per band
nslider channel("BandNote1"), bounds(304, 242, 38, 25), text("B1"), range(0, 127, 48, 1, 1, 1), fontSize(13)
nslider channel("BandNote2"), bounds(343, 242, 38, 25), text("B2"), range(0, 127, 52, 1, 1, 1), fontSize(13)
nslider channel("BandNote3"), bounds(382, 242, 38, 25), text("B3"), range(0, 127, 55, 1, 1, 1), fontSize(13)
nslider channel("BandNote4"), bounds(421, 242, 38, 25), text("B4"), range(0, 127, 57, 1, 1, 1), fontSize(13)
nslider channel("BandNote5"), bounds(460, 242, 38, 25), text("B5"), range(0, 127, 60, 1, 1, 1), fontSize(13)
nslider channel("BandNote6"), bounds(499, 242, 38, 25), text("B6"), range(0, 127, 64, 1, 1, 1), fontSize(13)
nslider channel("BandNote7"), bounds(538, 242, 38, 25), text("B7"), range(0, 127, 67, 1, 1, 1), fontSize(13)
nslider channel("BandNote8"), bounds(577, 242, 38, 25), text("B8"), range(0, 127, 72, 1, 1, 1), fontSize(13)

; Winner display
checkbox channel("On"), bounds(304, 272, 20, 18), text("")
nslider channel("TrigBand"), bounds(328, 268, 75, 27), text("WinBand"), range(0, 8, 0, 1, 1), active(0), fontSize(10)
nslider channel("TrigNote"), bounds(406, 268, 75, 27), text("WinNote"), range(0, 127, 0, 1, 1), active(0), fontSize(10)
nslider channel("MidiChan"), bounds(486, 268, 52, 27), text("WinCh"),  range(1, 16, 10, 1, 1, 1), fontSize(9)
rslider channel("OctavAmt"), bounds(540, 268, 60, 60), text("Octav"), range(0, 2, 0, 1, 0.01)
checkbox channel("OnCent"), bounds(604, 272, 20, 18), text("")
nslider channel("TrigCent"), bounds(628, 268, 66, 27), text("Cent"), range(0, 8, 0, 1, 0.01), active(0), fontSize(10)

; 2nd best display
checkbox channel("On2nd"), bounds(304, 302, 20, 18), text("")
nslider channel("TrigBand2nd"), bounds(328, 298, 75, 27), text("2ndBand"), range(0, 8, 0, 1, 1), active(0), fontSize(10)
nslider channel("TrigNote2nd"), bounds(406, 298, 75, 27), text("2ndNote"), range(0, 127, 0, 1, 1), active(0), fontSize(10)
nslider channel("MidiChan2nd"), bounds(486, 298, 52, 27), text("2ndCh"), range(1, 16, 11, 1, 1, 1), fontSize(9)
label bounds(542, 307, 62, 12), text("2nd on gate"), fontSize(9), align("left")
nslider channel("CentTransp"), bounds(606, 298, 50, 20), text("CtrTr"), range(-24, 24, 0, 1, 1, 1), fontSize(8)
nslider channel("CentChan"), bounds(658, 298, 36, 20), text("CCh"), range(1, 16, 12, 1, 1, 1), fontSize(8)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-d -+rtmidi=NULL -M0 -Q0 -m0d
</CsOptions>
<CsInstruments>

ksmps = 32
nchnls = 2
0dbfs=1

; Global transient gate signal (bridged from instr 1 to instr 2)
gkttrans init 0

; Baseline save/load table (8 slots) and load-completion flag
giBlSaveTable ftgen 2001, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0
gkload_flag init 0

;***************************************************
; Transient detection UDO (from MountainsLakes3)
opcode TransientDetect, kk,kikkkk
  kin, iresponse, ktthresh, klow_thresh, kdec_thresh, kdouble_limit xin
  kin_del	delayk	kin, iresponse/1000
  ktrig = ((kin > kin_del + ktthresh) ? 1 : 0)
  klow_gate	= (kin < klow_thresh? 0 : 1)
  ktrig = ktrig * klow_gate
  ktrans_lev	init 0
  ktrans_lev	samphold kin, 1-ktrig

  kre_gate	init 1
  ktrig = ktrig*kre_gate
  kmax_amp	init -99999
  kmax_amp	max kmax_amp, kin
  kdiff = kmax_amp-kin
  kre_gate	limit kre_gate-ktrig, 0, 1
  kre_gate	= (kdiff > kdec_thresh ? 1 : kre_gate)
  kmax_amp	= (kre_gate == 1 ? -99999 : kmax_amp)

  kdouble	init 1
  ktrig = ktrig*kdouble
  if ktrig > 0 then
    reinit double
  endif
  double:
  idouble_limit = i(kdouble_limit)
  idouble_limit limit idouble_limit, 1/kr, 5
  kdouble	linseg	0, idouble_limit, 0, 0, 1, 1, 1
  rireturn

  xout ktrig, kdiff
endop

instr 1
  ; ==========================================
  ; MountainsLakes3 transient detector / separator
  ; ==========================================
  a1 inch 1

  knoise_floor_db chnget "noisefloor"
  katck chnget "attack"
  kdec chnget "decay"
  kdec_ice chnget "ice_decay"
  kdec_noise chnget "noise_decay"

  kpre chnget "predelay"

  iresponse = 10
  ktthresh chnget "trans_thresh"
  klow_thresh chnget "low_trans"
  kdouble_limit chnget "double_limit"
  kdec_thresh chnget "retrig_thresh"
  kshape chnget "shape"
  kcompress_transients chnget "compress_trans"
  kcompress_sustain chnget "compress_sustain"
  kcompress_makeup chnget "compress_makeup"

  ktrans_makeup = (kcompress_makeup*(kcompress_transients+2)*0.5)+(1-kcompress_makeup)
  ksustain_makeup = (kcompress_makeup*(kcompress_sustain+2)*0.5)+(1-kcompress_makeup)

  krms rms a1
  krms_db = dbfsamp(krms)
  kgate = (krms_db < knoise_floor_db ? 0 : 1)
  aenv follow2 a1, 0.01, 0.3


  ifftsize = 512
  ioverlap = 16
  iwtype = 1
  iwin ftgen 0, 0, ifftsize, 20, 7, 1, 1.5
  fsin pvsanal a1, ifftsize, ifftsize/ioverlap, ifftsize, -iwin
  ismoothing = 0.002
  fsmooth pvsmooth fsin, ismoothing, ismoothing

  iarrsize = ifftsize/2 + 1
  kttrans init 0
  kTransAmps[] init iarrsize
  kTransFreqs[] init iarrsize
  kTransPrevAmps[] init iarrsize
  kTransAmpsDiff[] init iarrsize

  kAmps[] init iarrsize
  kFreqs[] init iarrsize
  kAmpsmooth[] init iarrsize
  kFreqsmooth[] init iarrsize
  kflag pvs2array kAmps, kFreqs, fsin
  kflag pvs2array kAmpsmooth, kFreqsmooth, fsmooth
  if changed(kflag) > 0 then
    kmax_amp maxarray kAmps
    kFluxL2[] = limit(kAmps^2-kAmpsmooth^2, 0, 9999)
    kflux_l2 = sumarray(kFluxL2)
    if kttrans > 0 then
      kTransAmps = kAmps
      kTransFreqs = kFreqs
      kTransAmpsDiff = limit(kTransAmps-kTransPrevAmps, 0, 9999)
      kTransPrevAmps = kTransAmps
    endif
  endif
  kflux_l2_norm divz kflux_l2, kmax_amp^2, 0
  kflux_l2_norm *= 0.15
  aflux_env follow2 a(kflux_l2_norm), 0.01, 0.3
  aflux_env2 follow2 butterlp(limit(butterhp(a(kflux_l2_norm),2),0,1),25), 0.01, 0.3

  ktransspec_max = maxarray(kTransAmpsDiff)
  ktransspec_norm divz 1, ktransspec_max, 1
  fspec_trans pvsfromarray kTransAmpsDiff*limit(ktransspec_norm,0,1), kTransFreqs, ifftsize/ioverlap, ifftsize, -iwin
  aspectrans pvsynth fspec_trans


  ktrans_in = (k(aflux_env2)^kshape)
  kamp_trans chnget "amp_trans"
  ktrans_in = ktrans_in*kamp_trans*k(aenv) + ktrans_in*(1-kamp_trans)
  kttrans,ktdiff TransientDetect dbfsamp(ktrans_in), iresponse, ktthresh, klow_thresh, kdec_thresh, kdouble_limit
  kttrans *= kgate
  attrans_env follow2 a(kttrans), katck, kdec
  attrans_env *= 1.83
  attrans_env_ice follow2 a(kttrans), katck, kdec_ice
  attrans_env_ice *= 10
  attrans_env_noise follow2 a(kttrans), katck, kdec_noise
  attrans_env_noise *= 1.83

  ; delay audio in to sync with the analysis envelopes
  adly vdelay a1, kpre, 50

  ; apply amp envelopes
  atransients = adly*attrans_env*(1-tanh(aenv*kcompress_transients))*ktrans_makeup
  atransients_ice = aspectrans*attrans_env_ice*(1-tanh(aenv*kcompress_transients))*ktrans_makeup
  anoise rnd31 1, 1
  atransients_noise = anoise*attrans_env_noise*(1-tanh(aenv*kcompress_transients))*ktrans_makeup
  asustain = adly*((1-attrans_env)^2)*(1-tanh(aenv*kcompress_sustain))*ksustain_makeup

  ktransientlevel = ampdbfs(chnget:k("transientlevel"))
  ksustainlevel = ampdbfs(chnget:k("sustainlevel"))
  kspectranslevel = ampdbfs(chnget:k("spectranslevel"))
  knoiselevel = ampdbfs(chnget:k("noiselevel"))

  atrans = atransients*ktransientlevel+atransients_ice*kspectranslevel+atransients_noise*knoiselevel
  asus = asustain*ksustainlevel
  kwidth chnget "panwidth"
  aleft = atrans*(0.5+(kwidth*0.5))+asus*(0.5-(kwidth*0.5))
  aright = asus*(0.5+(kwidth*0.5))+atrans*(0.5-(kwidth*0.5))

  ; Bridge transient pulse to instr 2 (SBA gate)
  gkttrans = kttrans

  outs aleft, aright

endin

instr 2
  ; ==========================================
  ; Spectral Band Analyzer — 8 bands (edges: 100,200,300,400,500,700,900,1700,2600 Hz)
  ; Normalized against a stored baseline; winning band triggers MIDI on gate rise.
  ; Gate triggered by transient detector from instr 1.
  ; ==========================================
  kon chnget "On"
  kchan chnget "MidiChan"
  kvel chnget "MidiVel"
  kdur_ms chnget "MidiDur"
  ksustain chnget "Sustain"
  ksustain_cent chnget "SustainCent"
  kmax_dur_ms chnget "MaxDurMs"
  khold_mode chnget "HoldMode"
  kwin_delay_ms chnget "WinDelayMs"
  knote1 chnget "BandNote1"
  knote2 chnget "BandNote2"
  knote3 chnget "BandNote3"
  knote4 chnget "BandNote4"
  knote5 chnget "BandNote5"
  knote6 chnget "BandNote6"
  knote7 chnget "BandNote7"
  knote8 chnget "BandNote8"
  krec_weight chnget "RecWeight"
  kon_2nd chnget "On2nd"
  kchan_2nd chnget "MidiChan2nd"
  kon_cent chnget "OnCent"
  kchan_cent chnget "CentChan"
  kcent_transpose chnget "CentTransp"
  koctav_amt chnget "OctavAmt"
  khyst_db chnget "HystDb"
  kattack_db chnget "noisefloor"
  kstats_period_sec chnget "StatsPeriodSec"
  kstats_period_sec = max(kstats_period_sec, 0.2)
  i_stats_max = 256
  kstats_time[] init i_stats_max
  kstats_band[] init i_stats_max
  kstats_head init -1
  kstats_len init 0
  kstats_rate_sm init 0
  kstats_temp_spread_sm init 0
  kstats_spec_spread_sm init 0

  a1 inch 1

  kfoll_att chnget "FollAtt"
  kfoll_rel chnget "FollRel"

  abp1 butterbp a1,  150,  100
  abp1 butterbp abp1, 150, 100
  abp2 butterbp a1,  250,  100
  abp2 butterbp abp2, 250, 100
  abp3 butterbp a1,  350,  100
  abp3 butterbp abp3, 350, 100
  abp4 butterbp a1,  450,  100
  abp4 butterbp abp4, 450, 100
  abp5 butterbp a1,  600,  200
  abp5 butterbp abp5, 600, 200
  abp6 butterbp a1,  800,  200
  abp6 butterbp abp6, 800, 200
  abp7 butterbp a1, 1300,  800
  abp7 butterbp abp7, 1300, 800
  abp8 butterbp a1, 2150,  900
  abp8 butterbp abp8, 2150, 900

  amp1 follow2 abp1, kfoll_att, kfoll_rel
  amp2 follow2 abp2, kfoll_att, kfoll_rel
  amp3 follow2 abp3, kfoll_att, kfoll_rel
  amp4 follow2 abp4, kfoll_att, kfoll_rel
  amp5 follow2 abp5, kfoll_att, kfoll_rel
  amp6 follow2 abp6, kfoll_att, kfoll_rel
  amp7 follow2 abp7, kfoll_att, kfoll_rel
  amp8 follow2 abp8, kfoll_att, kfoll_rel
  kamp1 = downsamp(amp1)
  kamp2 = downsamp(amp2)
  kamp3 = downsamp(amp3)
  kamp4 = downsamp(amp4)
  kamp5 = downsamp(amp5)
  kamp6 = downsamp(amp6)
  kamp7 = downsamp(amp7)
  kamp8 = downsamp(amp8)

  kbl_rec1 init 1e-7
  kbl_rec2 init 1e-7
  kbl_rec3 init 1e-7
  kbl_rec4 init 1e-7
  kbl_rec5 init 1e-7
  kbl_rec6 init 1e-7
  kbl_rec7 init 1e-7
  kbl_rec8 init 1e-7
  krecorded init 0
  kbl_live1 init 1e-7
  kbl_live2 init 1e-7
  kbl_live3 init 1e-7
  kbl_live4 init 1e-7
  kbl_live5 init 1e-7
  kbl_live6 init 1e-7
  kbl_live7 init 1e-7
  kbl_live8 init 1e-7

  krec_btn chnget "RecordBaseline"
  krec_btn_rise trigger krec_btn, 0.5, 0
  krec_btn_fall trigger krec_btn, 0.5, 1
  krec_sum1 init 0
  krec_sum2 init 0
  krec_sum3 init 0
  krec_sum4 init 0
  krec_sum5 init 0
  krec_sum6 init 0
  krec_sum7 init 0
  krec_sum8 init 0
  krec_cnt init 0

  if krec_btn_rise > 0 then
    krec_sum1 = 0
    krec_sum2 = 0
    krec_sum3 = 0
    krec_sum4 = 0
    krec_sum5 = 0
    krec_sum6 = 0
    krec_sum7 = 0
    krec_sum8 = 0
    krec_cnt = 0
    printf "SBA: Recording baseline - active\n", 1
  endif

  if krec_btn > 0.5 then
    krec_sum1 += kamp1
    krec_sum2 += kamp2
    krec_sum3 += kamp3
    krec_sum4 += kamp4
    krec_sum5 += kamp5
    krec_sum6 += kamp6
    krec_sum7 += kamp7
    krec_sum8 += kamp8
    krec_cnt += 1
  endif

  if krec_btn_fall > 0 && krec_cnt > 0 then
    krecorded = 1
    kbl_rec1 = krec_sum1 / krec_cnt
    kbl_rec2 = krec_sum2 / krec_cnt
    kbl_rec3 = krec_sum3 / krec_cnt
    kbl_rec4 = krec_sum4 / krec_cnt
    kbl_rec5 = krec_sum5 / krec_cnt
    kbl_rec6 = krec_sum6 / krec_cnt
    kbl_rec7 = krec_sum7 / krec_cnt
    kbl_rec8 = krec_sum8 / krec_cnt
    printf "SBA: Recording baseline - stopped\n", 1
  endif

  ; Internal live baseline (no GUI control): keeps meters responsive before/without manual record.
  kbl_alpha = 1 - exp(-ksmps / (sr * 5))
  kbl_live1 = kbl_live1 + (kamp1 - kbl_live1) * kbl_alpha
  kbl_live2 = kbl_live2 + (kamp2 - kbl_live2) * kbl_alpha
  kbl_live3 = kbl_live3 + (kamp3 - kbl_live3) * kbl_alpha
  kbl_live4 = kbl_live4 + (kamp4 - kbl_live4) * kbl_alpha
  kbl_live5 = kbl_live5 + (kamp5 - kbl_live5) * kbl_alpha
  kbl_live6 = kbl_live6 + (kamp6 - kbl_live6) * kbl_alpha
  kbl_live7 = kbl_live7 + (kamp7 - kbl_live7) * kbl_alpha
  kbl_live8 = kbl_live8 + (kamp8 - kbl_live8) * kbl_alpha

  if krecorded == 0 then
    kbl_rec1 = kbl_live1
    kbl_rec2 = kbl_live2
    kbl_rec3 = kbl_live3
    kbl_rec4 = kbl_live4
    kbl_rec5 = kbl_live5
    kbl_rec6 = kbl_live6
    kbl_rec7 = kbl_live7
    kbl_rec8 = kbl_live8
  endif

  if gkload_flag > 0 then
    krecorded = 1
    kbl_rec1 = tab:k(0, giBlSaveTable)
    kbl_rec2 = tab:k(1, giBlSaveTable)
    kbl_rec3 = tab:k(2, giBlSaveTable)
    kbl_rec4 = tab:k(3, giBlSaveTable)
    kbl_rec5 = tab:k(4, giBlSaveTable)
    kbl_rec6 = tab:k(5, giBlSaveTable)
    kbl_rec7 = tab:k(6, giBlSaveTable)
    kbl_rec8 = tab:k(7, giBlSaveTable)
    gkload_flag = 0
  endif

  krec_weight limit krec_weight, 0, 1
  keff_bl1 = (kbl_rec1 * krec_weight) + (kbl_live1 * (1 - krec_weight))
  keff_bl2 = (kbl_rec2 * krec_weight) + (kbl_live2 * (1 - krec_weight))
  keff_bl3 = (kbl_rec3 * krec_weight) + (kbl_live3 * (1 - krec_weight))
  keff_bl4 = (kbl_rec4 * krec_weight) + (kbl_live4 * (1 - krec_weight))
  keff_bl5 = (kbl_rec5 * krec_weight) + (kbl_live5 * (1 - krec_weight))
  keff_bl6 = (kbl_rec6 * krec_weight) + (kbl_live6 * (1 - krec_weight))
  keff_bl7 = (kbl_rec7 * krec_weight) + (kbl_live7 * (1 - krec_weight))
  keff_bl8 = (kbl_rec8 * krec_weight) + (kbl_live8 * (1 - krec_weight))

  kn1 = kamp1 / (keff_bl1 + 1e-12)
  kn2 = kamp2 / (keff_bl2 + 1e-12)
  kn3 = kamp3 / (keff_bl3 + 1e-12)
  kn4 = kamp4 / (keff_bl4 + 1e-12)
  kn5 = kamp5 / (keff_bl5 + 1e-12)
  kn6 = kamp6 / (keff_bl6 + 1e-12)
  kn7 = kamp7 / (keff_bl7 + 1e-12)
  kn8 = kamp8 / (keff_bl8 + 1e-12)
  kcent_sum = kn1 + kn2 + kn3 + kn4 + kn5 + kn6 + kn7 + kn8
  if kcent_sum > 0 then
    kcentroid_band = (kn1 + (2 * kn2) + (3 * kn3) + (4 * kn4) + (5 * kn5) + (6 * kn6) + (7 * kn7) + (8 * kn8)) / kcent_sum
  else
    kcentroid_band = 1
  endif
  kcentroid_band limit kcentroid_band, 1, 8
  kcent_idx = int(limit(round(kcentroid_band), 1, 8))
  kcent_note = knote1
  if kcent_idx == 2 then
    kcent_note = knote2
  elseif kcent_idx == 3 then
    kcent_note = knote3
  elseif kcent_idx == 4 then
    kcent_note = knote4
  elseif kcent_idx == 5 then
    kcent_note = knote5
  elseif kcent_idx == 6 then
    kcent_note = knote6
  elseif kcent_idx == 7 then
    kcent_note = knote7
  elseif kcent_idx == 8 then
    kcent_note = knote8
  endif

  ; Gate triggered by transient detector; closed by band-follower average falling below threshold.
  ; Using the follower average means kfoll_rel directly controls note release length.
  kamp_avg = (kamp1 + kamp2 + kamp3 + kamp4 + kamp5 + kamp6 + kamp7 + kamp8) / 8
  kdb_avg = dbfsamp(kamp_avg + 1e-12)
  kgate init 0
  kpeak_db init -120
  if gkttrans > 0 then
    kgate = 1
    kpeak_db = kdb_avg
  elseif kgate == 1 then
    kpeak_db = (kdb_avg > kpeak_db ? kdb_avg : kpeak_db)
    kclose_thr = max(kpeak_db - khyst_db, kattack_db)
    if kdb_avg < kclose_thr then
      kgate = 0
    endif
  endif

  kstats_now times
  kstats_window_start = kstats_now - kstats_period_sec
  kstats_hits = 0
  kstats_sum_band_delta = 0
  kstats_min_dt = 1e9
  kstats_prev_time = -1
  kstats_prev_band = -1
  kstats_i = 0
  kstats_idx = kstats_head
stats_loop:
  if kstats_i >= kstats_len then
    kgoto stats_loop_done
  endif
  if kstats_idx < 0 then
    kstats_idx += i_stats_max
  endif
  kstats_evt_time = kstats_time[kstats_idx]
  if kstats_evt_time < kstats_window_start then
    kgoto stats_loop_done
  endif
  kstats_hits += 1
  if kstats_prev_time >= 0 then
    kstats_dt = kstats_prev_time - kstats_evt_time
    if kstats_dt < kstats_min_dt then
      kstats_min_dt = kstats_dt
    endif
    kstats_sum_band_delta += abs(kstats_prev_band - kstats_band[kstats_idx])
  endif
  kstats_prev_time = kstats_evt_time
  kstats_prev_band = kstats_band[kstats_idx]
  kstats_idx -= 1
  kstats_i += 1
  kgoto stats_loop
stats_loop_done:
  kstats_rate = kstats_hits / kstats_period_sec
  if kstats_hits > 0 then
    kstats_spec_spread = kstats_sum_band_delta / kstats_hits
  else
    kstats_spec_spread = 0
  endif
  if kstats_hits > 1 && kstats_min_dt > 0 then
    kstats_temp_spread = 1 - (kstats_rate * kstats_min_dt)
  else
    kstats_temp_spread = 0
  endif
  kstats_lp_alpha = 1 - exp(-6.28318 / (kstats_period_sec * kr))
  kstats_rate_sm += (kstats_rate - kstats_rate_sm) * kstats_lp_alpha
  kstats_temp_spread_sm += (kstats_temp_spread - kstats_temp_spread_sm) * kstats_lp_alpha
  kstats_spec_spread_sm += (kstats_spec_spread - kstats_spec_spread_sm) * kstats_lp_alpha

  kgui_trig metro 20
  kndb1 = limit(20 * log10(kn1 + 1e-12), -20, 60)
  kndb2 = limit(20 * log10(kn2 + 1e-12), -20, 60)
  kndb3 = limit(20 * log10(kn3 + 1e-12), -20, 60)
  kndb4 = limit(20 * log10(kn4 + 1e-12), -20, 60)
  kndb5 = limit(20 * log10(kn5 + 1e-12), -20, 60)
  kndb6 = limit(20 * log10(kn6 + 1e-12), -20, 60)
  kndb7 = limit(20 * log10(kn7 + 1e-12), -20, 60)
  kndb8 = limit(20 * log10(kn8 + 1e-12), -20, 60)
  cabbageSetValue "BandAmp1", kndb1 + 20, kgui_trig
  cabbageSetValue "BandAmp2", kndb2 + 20, kgui_trig
  cabbageSetValue "BandAmp3", kndb3 + 20, kgui_trig
  cabbageSetValue "BandAmp4", kndb4 + 20, kgui_trig
  cabbageSetValue "BandAmp5", kndb5 + 20, kgui_trig
  cabbageSetValue "BandAmp6", kndb6 + 20, kgui_trig
  cabbageSetValue "BandAmp7", kndb7 + 20, kgui_trig
  cabbageSetValue "BandAmp8", kndb8 + 20, kgui_trig
  kcentroid_disp = 9 - kcentroid_band
  cabbageSetValue "CentroidBand", kcentroid_disp, kgui_trig
  cabbageSetValue "StatsRate", kstats_rate_sm, kgui_trig
  cabbageSetValue "StatsTempSpread", kstats_temp_spread_sm, kgui_trig
  cabbageSetValue "StatsSpecSpread", kstats_spec_spread_sm, kgui_trig

  ksave_btn chnget "SaveBaseline"
  if changed(ksave_btn) == 1 && ksave_btn > 0.5 then
    tabw kbl_rec1, 0, giBlSaveTable
    tabw kbl_rec2, 1, giBlSaveTable
    tabw kbl_rec3, 2, giBlSaveTable
    tabw kbl_rec4, 3, giBlSaveTable
    tabw kbl_rec5, 4, giBlSaveTable
    tabw kbl_rec6, 5, giBlSaveTable
    tabw kbl_rec7, 6, giBlSaveTable
    tabw kbl_rec8, 7, giBlSaveTable
    event "i", 204, 0, 0.01
    cabbageSetValue "SaveBaseline", 0, 1
  endif

  kload_btn chnget "LoadBaseline"
  if changed(kload_btn) == 1 && kload_btn > 0.5 then
    event "i", 205, 0, 0.01
    cabbageSetValue "LoadBaseline", 0, 1
  endif

  kpk_active init 0
  kpk_count init 0
  kpk1 init 0
  kpk2 init 0
  kpk3 init 0
  kpk4 init 0
  kpk5 init 0
  kpk6 init 0
  kpk7 init 0
  kpk8 init 0
  kpk_from_hit init 0
  kheld init 0
  kheld_note init 0
  kheld_chan init 0
  kheld_2nd init 0
  kheld_note_2nd init 0
  kheld_chan_2nd init 0
  kheld_cent init 0
  kheld_note_cent init 0
  kheld_chan_cent init 0
  kCentAddHeld[] init 8
  kCentAddNote[] init 8
  kCentAddChan[] init 8
  kAddHeld[] init 8
  kAddNote[] init 8
  kAddChan[] init 8
  kAdd2Held[] init 8
  kAdd2Note[] init 8
  kAdd2Chan[] init 8

  if kon > 0 || kon_2nd > 0 || kon_cent > 0 then
    kgate_rise trigger kgate, 0.5, 0
    kgate_fall trigger kgate, 0.5, 1

    if kgate_fall > 0 then
      if ksustain > 0.5 && khold_mode == 3 then
        ; add mode: kill all accumulated band notes
        ki = 0
        while ki < 8 do
          if kAddHeld[ki] > 0 then
            event "i", 207, 0, 0.01, kAddNote[ki], kAddChan[ki]
            kAddHeld[ki] = 0
          endif
          ki += 1
        od
        ki = 0
        while ki < 8 do
          if kAdd2Held[ki] > 0 then
            event "i", 207, 0, 0.01, kAdd2Note[ki], kAdd2Chan[ki]
            kAdd2Held[ki] = 0
          endif
          ki += 1
        od
      else
        if kheld > 0 then
          event "i", 207, 0, 0.01, kheld_note, kheld_chan
          kheld = 0
        endif
        if kheld_2nd > 0 then
          event "i", 207, 0, 0.01, kheld_note_2nd, kheld_chan_2nd
          kheld_2nd = 0
        endif
      endif
      if ksustain_cent > 0.5 && khold_mode == 3 then
        ki = 0
        while ki < 8 do
          if kCentAddHeld[ki] > 0 then
            event "i", 207, 0, 0.01, kCentAddNote[ki], kCentAddChan[ki]
            kCentAddHeld[ki] = 0
          endif
          ki += 1
        od
      else
        if kheld_cent > 0 then
          event "i", 207, 0, 0.01, kheld_note_cent, kheld_chan_cent
          kheld_cent = 0
        endif
      endif
      kpk_active = 0
    endif

    if kgate_rise > 0 then
      if ksustain > 0.5 && khold_mode == 3 then
        ; add mode: clear band-held flags (don't kill notes — they'll decay or be killed on fall)
        ki = 0
        while ki < 8 do
          kAddHeld[ki] = 0
          kAdd2Held[ki] = 0
          ki += 1
        od
      else
        if kheld > 0 then
          event "i", 207, 0, 0, kheld_note, kheld_chan
          kheld = 0
        endif
        if kheld_2nd > 0 then
          event "i", 207, 0, 0, kheld_note_2nd, kheld_chan_2nd
          kheld_2nd = 0
        endif
      endif
      if ksustain_cent > 0.5 && khold_mode == 3 then
        ki = 0
        while ki < 8 do
          kCentAddHeld[ki] = 0
          ki += 1
        od
      else
        if kheld_cent > 0 then
          event "i", 207, 0, 0, kheld_note_cent, kheld_chan_cent
          kheld_cent = 0
        endif
      endif
      kpk_active = 1
      kpk_count = 0
      kpk1 = 0
      kpk2 = 0
      kpk3 = 0
      kpk4 = 0
      kpk5 = 0
      kpk6 = 0
      kpk7 = 0
      kpk8 = 0
      kpk_from_hit = (gkttrans > 0 ? 1 : 0)
    endif
    ; Non-sustain: every transient restarts the analysis window so each hit fires its own note
    if ksustain < 0.5 && gkttrans > 0 then
      kpk_active = 1
      kpk_count = 0
      kpk1 = 0
      kpk2 = 0
      kpk3 = 0
      kpk4 = 0
      kpk5 = 0
      kpk6 = 0
      kpk7 = 0
      kpk8 = 0
      kpk_from_hit = 1
    endif
    if kpk_active > 0 then
      kpk1 = (kn1 > kpk1 ? kn1 : kpk1)
      kpk2 = (kn2 > kpk2 ? kn2 : kpk2)
      kpk3 = (kn3 > kpk3 ? kn3 : kpk3)
      kpk4 = (kn4 > kpk4 ? kn4 : kpk4)
      kpk5 = (kn5 > kpk5 ? kn5 : kpk5)
      kpk6 = (kn6 > kpk6 ? kn6 : kpk6)
      kpk7 = (kn7 > kpk7 ? kn7 : kpk7)
      kpk8 = (kn8 > kpk8 ? kn8 : kpk8)
      kpk_count += ksmps / sr
      if kpk_count * 1000 >= kwin_delay_ms then
        kpk_active = 0
        kwin_band = 1
        kwin_max = kpk1
        kwin_note = knote1
        if kpk2 > kwin_max then
          kwin_max = kpk2
          kwin_band = 2
          kwin_note = knote2
        endif
        if kpk3 > kwin_max then
          kwin_max = kpk3
          kwin_band = 3
          kwin_note = knote3
        endif
        if kpk4 > kwin_max then
          kwin_max = kpk4
          kwin_band = 4
          kwin_note = knote4
        endif
        if kpk5 > kwin_max then
          kwin_max = kpk5
          kwin_band = 5
          kwin_note = knote5
        endif
        if kpk6 > kwin_max then
          kwin_max = kpk6
          kwin_band = 6
          kwin_note = knote6
        endif
        if kpk7 > kwin_max then
          kwin_max = kpk7
          kwin_band = 7
          kwin_note = knote7
        endif
        if kpk8 > kwin_max then
          kwin_max = kpk8
          kwin_band = 8
          kwin_note = knote8
        endif
        ksec_band = 0
        ksec_max = -1
        ksec_note = knote1
        if kwin_band != 1 && kpk1 > ksec_max then
          ksec_max = kpk1
          ksec_band = 1
          ksec_note = knote1
        endif
        if kwin_band != 2 && kpk2 > ksec_max then
          ksec_max = kpk2
          ksec_band = 2
          ksec_note = knote2
        endif
        if kwin_band != 3 && kpk3 > ksec_max then
          ksec_max = kpk3
          ksec_band = 3
          ksec_note = knote3
        endif
        if kwin_band != 4 && kpk4 > ksec_max then
          ksec_max = kpk4
          ksec_band = 4
          ksec_note = knote4
        endif
        if kwin_band != 5 && kpk5 > ksec_max then
          ksec_max = kpk5
          ksec_band = 5
          ksec_note = knote5
        endif
        if kwin_band != 6 && kpk6 > ksec_max then
          ksec_max = kpk6
          ksec_band = 6
          ksec_note = knote6
        endif
        if kwin_band != 7 && kpk7 > ksec_max then
          ksec_max = kpk7
          ksec_band = 7
          ksec_note = knote7
        endif
        if kwin_band != 8 && kpk8 > ksec_max then
          ksec_max = kpk8
          ksec_band = 8
          ksec_note = knote8
        endif
        if kpk_from_hit > 0 then
          kstats_head = (kstats_head + 1) % i_stats_max
          kstats_time[kstats_head] = kstats_now
          kstats_band[kstats_head] = kwin_band
          if kstats_len < i_stats_max then
            kstats_len += 1
          endif
        endif
        koct_steps = int(round(kstats_rate_sm * koctav_amt))
        koct_offset = 12 * koct_steps
        kwin_note_out = int(limit(kwin_note + koct_offset, 0, 127))
        ksec_note_out = int(limit(ksec_note + koct_offset, 0, 127))
        kcent_note_out = int(limit(kcent_note + int(round(kcent_transpose)), 0, 127))
        if kon > 0 then
          kdur_evt_ms = max(kdur_ms, 1)
          kmax_dur_evt_ms = max(kmax_dur_ms, 1)
          if ksustain > 0.5 then
            if khold_mode == 1 then          ; lock: fire once, hold until gate falls
              event "i", 208, 0, 0.01, kwin_note_out, int(limit(kchan, 1, 16)), int(kvel)
              kheld = 1
              kheld_note = kwin_note_out
              kheld_chan = int(limit(kchan, 1, 16))
            elseif khold_mode == 2 then      ; switch: kill current, fire new if winner changed
              if kheld == 0 then
                event "i", 208, 0, 0.01, kwin_note_out, int(limit(kchan, 1, 16)), int(kvel)
                kheld = 1
                kheld_note = kwin_note_out
                kheld_chan = int(limit(kchan, 1, 16))
              elseif kwin_note_out != kheld_note then
                event "i", 207, 0, 0, kheld_note, kheld_chan
                event "i", 208, 0, 0.01, kwin_note_out, int(limit(kchan, 1, 16)), int(kvel)
                kheld_note = kwin_note_out
                kheld_chan = int(limit(kchan, 1, 16))
              endif
            elseif khold_mode == 3 then      ; add: accumulate one note per band, no kill until gate falls
              kslot = int(kwin_band) - 1
              if kAddHeld[kslot] == 0 then
                event "i", 208, 0, 0.01, kwin_note_out, int(limit(kchan, 1, 16)), int(kvel)
                kAddHeld[kslot] = 1
                kAddNote[kslot] = kwin_note_out
                kAddChan[kslot] = int(limit(kchan, 1, 16))
              endif
            endif
          else
            event "i", 203, 0, kdur_evt_ms*0.001, kwin_note_out, int(limit(kchan, 1, 16)), int(kvel)
          endif
          cabbageSetValue "TrigBand", kwin_band, 1
          cabbageSetValue "TrigNote", kwin_note_out, 1
        endif
        if kon_2nd > 0 && ksec_band > 0 then
          kdur_evt_2_ms = max(kdur_ms, 1)
          kmax_dur_evt_2_ms = max(kmax_dur_ms, 1)
          if ksustain > 0.5 then
            if khold_mode == 1 then
              event "i", 208, 0, 0.01, ksec_note_out, int(limit(kchan_2nd, 1, 16)), int(kvel)
              kheld_2nd = 1
              kheld_note_2nd = ksec_note_out
              kheld_chan_2nd = int(limit(kchan_2nd, 1, 16))
            elseif khold_mode == 2 then
              if kheld_2nd == 0 then
                event "i", 208, 0, 0.01, ksec_note_out, int(limit(kchan_2nd, 1, 16)), int(kvel)
                kheld_2nd = 1
                kheld_note_2nd = ksec_note_out
                kheld_chan_2nd = int(limit(kchan_2nd, 1, 16))
              elseif ksec_note_out != kheld_note_2nd then
                event "i", 207, 0, 0, kheld_note_2nd, kheld_chan_2nd
                event "i", 208, 0, 0.01, ksec_note_out, int(limit(kchan_2nd, 1, 16)), int(kvel)
                kheld_note_2nd = ksec_note_out
                kheld_chan_2nd = int(limit(kchan_2nd, 1, 16))
              endif
            elseif khold_mode == 3 then
              kslot_2 = int(ksec_band) - 1
              if kAdd2Held[kslot_2] == 0 then
                event "i", 208, 0, 0.01, ksec_note_out, int(limit(kchan_2nd, 1, 16)), int(kvel)
                kAdd2Held[kslot_2] = 1
                kAdd2Note[kslot_2] = ksec_note_out
                kAdd2Chan[kslot_2] = int(limit(kchan_2nd, 1, 16))
              endif
            endif
          else
            event "i", 206, 0, kdur_evt_2_ms*0.001, ksec_note_out, int(limit(kchan_2nd, 1, 16)), int(kvel)
          endif
          cabbageSetValue "TrigBand2nd", ksec_band, 1
          cabbageSetValue "TrigNote2nd", ksec_note_out, 1
        endif
        if kon_cent > 0 then
          kdur_evt_cent_ms = max(kdur_ms, 1)
          kcent_chan_i = int(limit(kchan_cent, 1, 16))
          if ksustain_cent > 0.5 then
            if khold_mode == 1 then
              if kheld_cent == 0 then
                event "i", 208, 0, 0.01, kcent_note_out, kcent_chan_i, int(kvel)
                kheld_cent = 1
                kheld_note_cent = kcent_note_out
                kheld_chan_cent = kcent_chan_i
              endif
            elseif khold_mode == 2 then
              if kheld_cent == 0 then
                event "i", 208, 0, 0.01, kcent_note_out, kcent_chan_i, int(kvel)
                kheld_cent = 1
                kheld_note_cent = kcent_note_out
                kheld_chan_cent = kcent_chan_i
              elseif kcent_note_out != kheld_note_cent then
                event "i", 207, 0, 0, kheld_note_cent, kheld_chan_cent
                event "i", 208, 0, 0.01, kcent_note_out, kcent_chan_i, int(kvel)
                kheld_note_cent = kcent_note_out
                kheld_chan_cent = kcent_chan_i
              endif
            elseif khold_mode == 3 then
              kcent_slot = int(limit(round(kcentroid_band), 1, 8)) - 1
              if kCentAddHeld[kcent_slot] == 0 then
                event "i", 208, 0, 0.01, kcent_note_out, kcent_chan_i, int(kvel)
                kCentAddHeld[kcent_slot] = 1
                kCentAddNote[kcent_slot] = kcent_note_out
                kCentAddChan[kcent_slot] = kcent_chan_i
              endif
            endif
          else
            if kpk_from_hit > 0 then
              event "i", 206, 0, kdur_evt_cent_ms*0.001, kcent_note_out, kcent_chan_i, int(kvel)
            endif
          endif
          cabbageSetValue "TrigCent", kcentroid_band, 1
        endif
        ; For switch/add modes, restart peak-accumulation window while gate stays open
        if ((ksustain > 0.5 && (kon > 0 || kon_2nd > 0)) || (ksustain_cent > 0.5 && kon_cent > 0)) && khold_mode > 1 && kgate > 0 then
          kpk_active = 1
          kpk_count = 0
          kpk1 = 0
          kpk2 = 0
          kpk3 = 0
          kpk4 = 0
          kpk5 = 0
          kpk6 = 0
          kpk7 = 0
          kpk8 = 0
          kpk_from_hit = 0
        endif
      endif
    endif
  endif

endin

instr 203
  inote = p4
  ichan = p5
  ivel = p6
  noteondur ichan, inote, ivel, p3
endin

instr 206
  inote = p4
  ichan = p5
  ivel = p6
  noteondur ichan, inote, ivel, p3
endin

instr 207
  inote = p4
  ichan = p5
  noteondur ichan, inote, 0, 0.01
endin

instr 208
  inote = p4
  ichan = p5
  ivel = p6
  noteon ichan, inote, ivel
endin

instr 204
  ftsave "sba_baseline.dat", 0, giBlSaveTable
  prints "SBA: Baseline saved to sba_baseline.dat\n"
endin

instr 205
  ftload "sba_baseline.dat", 0, giBlSaveTable
  gkload_flag = 1
  prints "SBA: Baseline loaded from sba_baseline.dat\n"
endin

</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400
</CsScore>
</CsoundSynthesizer>
