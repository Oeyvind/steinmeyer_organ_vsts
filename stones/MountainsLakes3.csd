<Cabbage>
form size(280, 440), caption("Mountains and Lakes 3"), pluginId("mlk3"), colour(25,40,75), latency(128), guiMode("queue")
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

csoundoutput bounds(5,330,260,105)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-m0 -d
</CsOptions>
<CsInstruments>

ksmps = 32
nchnls = 2
0dbfs=1


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
  ioverlap = 16
  iwtype = 1
  iwin ftgen 0, 0, ifftsize, 20, 7, 1, 1.5 ;  KAISER
  fsin pvsanal a1, ifftsize, ifftsize/ioverlap, ifftsize, -iwin  
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
  outs aleft, aright

endin


</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>