<Cabbage>
form size(520, 440), caption("Mountains and Lakes 3 Midiout Spect"), pluginId("mls3"), colour(25,40,75), latency(128), guiMode("queue")
nslider channel("noisefloor"), bounds(5, 10, 50, 25), text("Noise floor"), range(-90, 0, -40, 1, 1)
nslider channel("predelay"), bounds(5, 45, 50, 25), text("Predelay"), range(0.0, 100, 12, 0.5)
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

groupbox bounds(280, 5, 235, 325), colour(25,35,40), lineThickness("0"){ 
button bounds(5, 5, 90, 16), channel("max_amps"), text("max(/acm)"), colour:0("black"), colour:1("green")
hslider bounds(5, 20, 200, 30), channel("ampOn"), text("ampOn"), range(-96, 0, -12, 2, 0.1)
hslider bounds(5, 50, 200, 30), channel("transpose"), text("transpose"), range(-12, 12, 0, 1, 1)
hslider bounds(5, 80, 200, 30), channel("duration"), text("duration"), range(0, 1, 0.1)
hslider bounds(5, 110, 200, 30), channel("dur_ampscale"), text("dur_ampscale"), range(0, 5, 0.1)
hslider bounds(5, 140, 200, 30), channel("low_note"), text("lowNote"), range(0, 127, 36, 1, 1)
hslider bounds(5, 170, 200, 30), channel("high_note"), text("highNote"), range(0, 127, 112, 1, 1)
rslider bounds(5, 220, 50, 50), channel("midi_spect"), text("Spect-M"), range(0, 1, 1)
rslider bounds(5, 270, 50, 50), channel("midi_ice"), text("Ice-M"), range(0, 1, 1)
rslider bounds(65, 220, 50, 50), channel("midi_centr"), text("Centr-M"), range(0, 1, 1)
rslider bounds(125, 220, 50, 50), channel("midi_mfcc"), text("Mfcc-M"), range(0, 1, 1)
rslider bounds(185, 220, 50, 50), channel("midi_zeroc"), text("Zero-M"), range(0, 1, 1)
hslider bounds(65, 275, 50, 20), channel("cmz_offset"), range(0, 20, 0, 1, 1)
nslider bounds(115, 275, 50, 20), channel("cmz_offset_Hz"), range(0, 20000, 0, 1, 1)
hslider bounds(65, 300, 50, 20), channel("cmz_range"), range(0, 100, 20, 1, 1)
nslider bounds(115, 300, 50, 20), channel("cmz_range_Hz"), range(100, 20000, 1875, 1, 1)

}
csoundoutput bounds(0,335,520,105)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-m0 -d -+rtmidi=null -Q0
</CsOptions>
<CsInstruments>

ksmps = 32
nchnls = 2
0dbfs=1

giNoteAmps	ftgen	0, 0, 128, 2, 0


;***************************************************
; Transient detection udo

opcode TransientDetect, kk,kikkkk
  kin, iresponse, ktthresh, klowThresh, kdecThresh, kdoubleLimit xin 
  /*
  iresponse	= 10 		; response time in milliseconds
  ktthresh	= 6		; transient trig threshold 
  klowThresh	= -60		; lower threshold for transient detection
  kdoubleLimit	= 0.02		; minimum duration between events, (double trig limit)
  kdecThresh	= 6		; retrig threshold, how much must the level decay from its local max before allowing new transient trig
  */	
  kinDel	delayk	kin, iresponse/1000		; delay with response time for comparision of levels
  ktrig		= ((kin > kinDel + ktthresh) ? 1 : 0) 	; if current rms plus threshold is larger than previous rms, set trig signal to current rms
  klowGate	= (kin < klowThresh? 0 : 1)		; gate to remove transient of low level signals
  ktrig		= ktrig * klowGate			; activate gate on trig signal
  ktransLev	init 0
  ktransLev	samphold kin, 1-ktrig			; read amplitude at transient
  
  kreGate	init 1					; retrigger gate, to limit transient double trig before signal has decayed (decThresh) from its local max
  ktrig		= ktrig*kreGate				; activate gate
  kmaxAmp	init -99999
  kmaxAmp	max kmaxAmp, kin			; find local max amp
  kdiff		= kmaxAmp-kin				; how much the signal has decayed since its local max value
  kreGate	limit kreGate-ktrig, 0, 1		; mute when trig detected
  kreGate	= (kdiff > kdecThresh ? 1 : kreGate)	; re-enable gate when signal has decayed sufficiently
  kmaxAmp	= (kreGate == 1 ? -99999 : kmaxAmp)	; reset max amp gauge

  ; avoid closely spaced transient triggers (first trig priority)
  kdouble	init 1
  ktrig		= ktrig*kdouble
  if ktrig > 0 then
    reinit double
  endif
  double:
  idoubleLimit  = i(kdoubleLimit)	
  idoubleLimit  limit idoubleLimit, 1/kr, 5
  kdouble	linseg	0, idoubleLimit, 0, 0, 1, 1, 1
  rireturn

  xout ktrig, kdiff
endop


instr 1
  a1 inch 1

  knoiseFloor_dB chnget "noisefloor" ; (-40) noise floor of input signal, no transients detected below the noisefloor
  katck chnget "attack" ; (0.01) attack time for envelope applied to audio output
  kdec chnget "decay" ; (0.5) decay time for envelope applied to audio output
  kdec_ice chnget "ice_decay" ; (0.5) decay time for envelope applied to audio output
  kdec_noise chnget "noise_decay" ; (0.5) decay time for envelope applied to audio output
  
  kpre chnget "predelay" ; (5 ms) predelay for syncing audio with output trans envelopes
  
  iresponse = 10 ; transient detect response time in milliseconds (set and forget)
  ktthresh chnget "trans_thresh" ; (3) transient trig threshold (log scale but not dB, as it refers to variations in both flux and amplitude) 
  klowThresh chnget "low_trans"	; (-20) lower threshold for transient detection (log scale but not dB, as it refers to variations in both flux and amplitude) 
  kdoubleLimit chnget "double_limit" ; (0.02) minimum duration between events, (double trig limit)
  kdecThresh chnget "retrig_thresh"	; (2) retrig threshold, how much must the level decay from its local max before allowing new transient trig (log scale but not dB)
  kshape chnget "shape" ; > 1 makes it less sensitive to soft transients, < 1 makes it more sensitive to soft transients
  kcompress_transients chnget "compress_trans" ; (2) range 0 to 4
  kcompress_sustain chnget "compress_sustain" ; (2) range 0 to 4
  kcompress_makeup chnget "compress_makeup"; (0.5) range 0 to 1

  ; empirical/adhoc adjustment
  ktrans_makeup = (kcompress_makeup*(kcompress_transients+2)*0.5)+(1-kcompress_makeup)
  ksustain_makeup = (kcompress_makeup*(kcompress_sustain+2)*0.5)+(1-kcompress_makeup)
  
  krms rms a1
  krms_dB = dbfsamp(krms)
  kgate = (krms_dB < knoiseFloor_dB ? 0 : 1)
  aenv follow2 a1, 0.01, 0.3

 
  ; ***************
  ; spectral analysis L2, low fft size, smoothing, custom window
  ifftsize = 512
  ioverlap = 4
  iwtype = 1
  iwin ftgen 0, 0, ifftsize, 20, 7, 1, 1.5 ;  KAISER
  fsin pvsanal a1, ifftsize, ifftsize/ioverlap, ifftsize, -iwin  
  ;kcentroid_spect pvscent fsin
  icentmetro = (sr/ifftsize)
  kcentrig metro icentmetro
  kcentroid centroid a1, kcentrig, ifftsize

  kIn_mfcc[] init ifftsize
  kcnt init 0
  kIn_mfcc shiftin a1
  kcnt += ksmps
  if kcnt == ifftsize then
    kWin[] window kIn_mfcc
    kFFT[] = rfft(kWin)
    kPows[] = pows(kFFT)
    kMFB[] = log(mfb(kPows,300,8000,32))
    kMfcc[] = dct(kMFB)
    kcnt = 0
  endif
  ktest sumarray kMfcc
  
  kmfcc1 = kMfcc[1]
  kmfcc1 = qnan(kmfcc1) > 0 ? 0 : kmfcc1
  ;printk2 kmfcc1
  azerocross zerocrossing a1
  kzerocross downsamp azerocross

  ismoothing = 0.002
  fsmooth pvsmooth fsin, ismoothing, ismoothing
  iarrsize = ifftsize/2 + 1
  ; attempt to differentiate polyphonic overlapping transients
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
    kmaxAmp maxarray kAmps
    kFluxL2[] = limit(kAmps^2-kAmpsmooth^2, 0, 9999) ; L2 distance (limit, includes only positive changes)
    kfluxL2 = sumarray(kFluxL2) ; sum of all distances
    ; transient spectral differentiation
    if kttrans > 0 then
      kTransAmps = kAmps
      kTransFreqs = kFreqs
      kTransAmpsDiff = limit(kTransAmps-kTransPrevAmps, 0, 9999) ; SPECULATIVE, CORNY, ICY
      kTransPrevAmps = kTransAmps 
    endif
  endif
  kfluxL2_norm divz kfluxL2, kmaxAmp^2, 0 ; normalized flux, independent of amplitude
  kfluxL2_norm *= 0.15
  aflux_env follow2 a(kfluxL2_norm), 0.01, 0.3
  aflux_env2 follow2 butterlp(limit(butterhp(a(kfluxL2_norm),2),0,1),25), 0.01, 0.3

  ; attempt to differentiate polyphonic overlapping transients
  ktransspec_max = maxarray(kTransAmpsDiff)
  ktransspec_norm divz 1, ktransspec_max, 1
  fspec_trans pvsfromarray kTransAmpsDiff*limit(ktransspec_norm,0,1), kTransFreqs, ifftsize/ioverlap, ifftsize, -iwin 
  aspectrans pvsynth fspec_trans ; ice
    
  ktrans_in = (k(aflux_env2)^kshape)
  kamp_trans chnget "amp_trans"
  ktrans_in = ktrans_in*kamp_trans*k(aenv) + ktrans_in*(1-kamp_trans) ; mix in amp anvelope
  kttrans,ktdiff TransientDetect dbfsamp(ktrans_in), iresponse, ktthresh, klowThresh, kdecThresh, kdoubleLimit
  kttrans *= kgate
  attrans_env follow2 a(kttrans), katck, kdec ; make amp envelop out of transient trigger clicks
  attrans_env *= 1.83 ; normalize the transient envelope
  attrans_env_ice follow2 a(kttrans), katck, kdec_ice ; make amp envelope out of transient trigger clicks
  attrans_env_ice *= 10 ; normalize the transient envelope
  attrans_env_noise follow2 a(kttrans), katck, kdec_noise ; make amp envelope out of transient trigger clicks
  attrans_env_noise *= 1.83 ; normalize the transient envelope
  
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
  
  ;aout = atransients*ktransientlevel+atransients_ice*kspectranslevel+asustain*ksustainlevel
  atrans = atransients*ktransientlevel+atransients_ice*kspectranslevel+atransients_noise*knoiselevel
  asus = asustain*ksustainlevel
  kwidth chnget "panwidth"
  aleft = atrans*(0.5+(kwidth*0.5))+asus*(0.5-(kwidth*0.5))
  aright = asus*(0.5+(kwidth*0.5))+atrans*(0.5-(kwidth*0.5))

  idel = (1/sr)*ifftsize
  if changed(kpre) > 0 then
    reinit transdelay
    transdelay:
    idel = i(kpre)/1000
    print idel  
  endif
  kdel_trans delayk kttrans, idel
  rireturn

  kMidi_spect_amps[] init iarrsize
  kMidi_spect_freqs[] init iarrsize
  kmidi_spect chnget "midi_spect"
  kmidi_ice chnget "midi_ice"
  kmidi_centr chnget "midi_centr"
  kmidi_mfcc chnget "midi_mfcc"
  kmidi_zerocross chnget "midi_zeroc"
  kcmz_offset chnget "cmz_offset"
  kcmz_offset_Hz = kcmz_offset*(sr/ifftsize)
  cabbageSetValue "cmz_offset_Hz", int(kcmz_offset_Hz), changed(kcmz_offset_Hz)
  kcmz_range chnget "cmz_range"
  kcmz_range_Hz = kcmz_range*(sr/ifftsize)
  cabbageSetValue "cmz_range_Hz", int(kcmz_range_Hz), changed(kcmz_range_Hz)
  

  kMidi_spect_freqs = kFreqs ; perhaps no need to update this(?) it's perc after all
  kMidi_spect_amps = (kAmps*kmidi_spect)+(kTransAmpsDiff*limit(ktransspec_norm,0,1)*kmidi_ice*2)
  ;kcentr_indx = int(kcentroid/(sr/ifftsize))
  ;kMidi_spect_amps[kcentr_indx] = kMidi_spect_amps[kcentr_indx]+kmidi_centr ; add peak at centroid
  ;
  ; calculate our own "centroid" with log weighting of the amps
  ; preliminary: recreate regular centroid by array manipulation
  ;ksum_amp = sumarray(kAmps)
  ;ksum_amp = (ksum_amp == 0 ? 1 : ksum_amp)
  ;kCentr[] = (kAmps/ksum_amp)*kFreqs
  ;kcent_test = sumarray(kCentr)
;
  ;kCentr_pow[] init iarrsize
  ;icent_pow = 3
  ;ksum_amp_pow = sumarray(kAmps^icent_pow)
  ;ksum_amp_pow = (ksum_amp_pow == 0 ? 1 : ksum_amp_pow)
  ;kCentr_pow[] = ((kAmps^icent_pow)/ksum_amp_pow)*kFreqs
  ;kcent_pow_test = sumarray(kCentr_pow)
  ;printk2 kcent_pow_test
  
  ;kcentroidf pvscent fsin
	;kArrAnorm[] = kAmps/ksum_amp      
	;kspread = sumarray(((kFreqs+(kcentroid*-1))^2)*kArrAnorm)^0.5
	;kskewness divz sumarray(((kFreqs+(kcentroid*-1))^3)*kArrAnorm), kspread^3, 1
	;askewness follow2 a(kskewness), 0.01, 0.2
  kcentroid_sh samphold kcentroid, kttrans
  kcentr_indx limit round((kcentroid_sh/(sr/2))*kcmz_range)+kcmz_offset, 0, iarrsize-2
  ;knorm_mfcc sumarray kMfcc
  ;knorm_mfcc = knorm_mfcc == 0 ? 1 : abs(knorm_mfcc)
  kmfcc1_sh samphold (kmfcc1/300)+0.5, kttrans
  ;printk2 kmfcc1_sh
  kmfcc_indx limit int((1-kmfcc1_sh)*kcmz_range*0.5)+kcmz_offset, 0, iarrsize-2
  ;kmfcc_indx limit int((1-kmfcc1_sh)*iarrsize*0.25), 0, iarrsize-1
  ;printk2 (kmfcc1/200)^2
  ;kMidi_spect_amps[kcentr_indx] = kMidi_spect_amps[kcentr_indx]+kmidi_centr ; add peak at centroid
  kzerocross_sh samphold kzerocross, kttrans
  kzeroc_indx limit round((kzerocross_sh/sr)*kcmz_range)+kcmz_offset, 0, iarrsize-2
  ;printk2 kzerocross_sh
  ;printk2 kzeroc_indx, 10
  ;printk2 k(aenv)*kttrans
  kMidi_spect_amps[kcentr_indx] = kMidi_spect_amps[kcentr_indx]+(kmidi_centr*k(aenv)*4) ; add peak at centroid band amp
  kMidi_spect_amps[kmfcc_indx] = kMidi_spect_amps[kmfcc_indx]+(kmidi_mfcc*k(aenv)*4) ; add peak at mfcc1 band amp
  kMidi_spect_amps[kzeroc_indx] = kMidi_spect_amps[kzeroc_indx]+(kmidi_zerocross*k(aenv)*4) ; add peak at zerocross freq
  
  
  ftest pvsfromarray kMidi_spect_amps, kMidi_spect_freqs
  atest pvsynth ftest
  
  if kdel_trans > 0 then
    
    kmax_accum chnget "max_amps"
    kamp_on_dB chnget "ampOn"
    kamp_on = ampdbfs(kamp_on_dB)
    ktranspose chnget "transpose"
    kdur chnget "duration"
    kdur_ampscale chnget "dur_ampscale"
    klow_note chnget "low_note"
    khigh_note chnget "high_note"

    ; read spectrum, produce amps per midinote
    kindx = 0
    readspectral:
    kfreq	= kMidi_spect_freqs[kindx]
    knote	= round(12 * (log(kfreq/220)/log(2)) + 57 + ktranspose)
    ;if (knote > klowNote) && (knote < khighNote) then
    kamp = kMidi_spect_amps[kindx]
    kamp0 table knote, giNoteAmps
    if kmax_accum == 0 then
      tablew (kamp+kamp0), knote, giNoteAmps			; accumulate amps
    else
      kmax_amp max kamp, kamp0
      tablew kmax_amp, knote, giNoteAmps			; max amps within this semitone
    endif
    kindx = kindx	+ 1
    if kindx < ifftsize/2 goto readspectral
    
    ; read amp table, generate midi
    knote = 0
    readnotes:	

    kamp table knote, giNoteAmps
    tablew 0, knote, giNoteAmps                          	; reset amp accumulator
    
    if (kamp > kamp_on) && (knote > klow_note) && (knote < khigh_note) then		; if high enough amp in band, and note not already playing
      kvelocity = dbfsamp(kamp);90;10^(dbfsamp(kamp)/40); * 80 + 47
      kinstNum = 201 + (knote*0.001)
      ;printk2 kamp
      ;printk2 kvelocity, 10
      kdur += (kdur*kdur_ampscale*kamp)
      event "i", kinstNum, 0, kdur, knote, kvelocity, 1		
    endif
    knote = knote + 1
    if knote < 127 goto readnotes

  ;kcent_sh samphold kcent_test, kdel_trans  
  ;kcent_pow_test_sh samphold kcent_pow_test, kdel_trans
  endif
  
  ;outs a(kcentroid/(sr*0.25)), askewness*0.05; a(kdel_trans)+(a(kcent_sh)/20000)
  ;outs a(kcent_sh/(sr*0.25)), a((kmfcc1/500)^2)
  ;outs a(kdel_trans), atest
  outs aleft, aright
endin

;***************************************************
instr	201
  ; midi  output

  inote = p4
  iamp = p5
  idB_range  = 70
  ivel = pow((1+(iamp/idB_range)),2) * 127
  ichan = p6
  ;print inote, ivel, ichan
  ivel limit ivel, 0, 127

  idur = (p3 < 0 ? 999 : p3)	; use very long duration for realtime events, noteondur will create note off when instrument stops
  noteondur ichan, inote, ivel, idur
endin
;***************************************************

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>