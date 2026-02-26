<CsoundSynthesizer>
<CsOptions>
-d -m0 -odac
</CsOptions>
<CsInstruments>
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
  Sfile = "c:/Cabbage_VST/CabbageEfx/midiplugs/domen_ai/stones_rec_example.wav"
  ifilelen filelen Sfile
  prints "TEST_FILE=%s\n", Sfile
  print ifilelen

  ; analysis/mapping defaults (matching current patch defaults)
  ifftsize = 2048
  inumbins = ifftsize/2
  ihop = ifftsize/8
  kbin_hz = sr/ifftsize

  klofreq1 init 20
  khifreq1 init 500
  knbins1 init 2
  klofreq2 init 500
  khifreq2 init 1000
  knbins2 init 2
  klofreq3 init 1000
  khifreq3 init 3000
  knbins3 init 2

  knoise_floor_db init -55
  kmidi_analysis_ms init 110
  kretrigger_sec init 0.25
  konset_thresh_db init -85
  konset_attack_db init 0.15
  kdetect_rate init 200
  kmin_frames init 4

  kcent_lo init 36
  kcent_hi init 84
  kflat_lo init 36
  kflat_hi init 84
  ktilt_lo init 36
  ktilt_hi init 84
  kcrest_lo init 36
  kcrest_hi init 84

  ktr1_lo init 36
  ktr1_hi init 84
  ktr2_lo init 36
  ktr2_hi init 84
  ktr3_lo init 36
  ktr3_hi init 84
  ktr1_trsp init 0
  ktr2_trsp init 0
  ktr3_trsp init 0

  aL, aR diskin2 Sfile, 1, 0, 0
  a1 = (aL + aR) * 0.5

  krms rms a1
  kenv = krms
  kinput_db = dbfsamp(kenv + 1e-12)
  kabove_noise_floor = (kinput_db > knoise_floor_db ? 1 : 0)

  f1 pvsanal a1, ifftsize, ihop, ifftsize, 1
  kMags[] init inumbins+1
  kFreqs[] init inumbins+1
  kPrevMags[] init inumbins+1
  kframe pvs2array kMags, kFreqs, f1
  kMags = abs(kMags)

  ; state
  khit_count init 0
  kanalysis_pending init 0
  kanalysis_start init 0
  klast_gate_time init -10
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
  kenv_db_prev init -120
  kenv_db_min init 0
  kenv_db_max init -120
  kabove_count init 0
  konset_candidate_count init 0
  kprinted_summary init 0

  if kframe > 0 then
    kmin_bin1 = int(klofreq1/kbin_hz)
    kmax_bin1 = int(khifreq1/kbin_hz)
    kmin_bin2 = int(klofreq2/kbin_hz)
    kmax_bin2 = int(khifreq2/kbin_hz)
    kmin_bin3 = int(klofreq3/kbin_hz)
    kmax_bin3 = int(khifreq3/kbin_hz)

    kenergy = 0
    kfreq_weighted = 0
    klog_sum = 0
    kband_lo = 0
    kband_hi = 0
    kmax_mag = 0
    kndx = 0
    while kndx <= inumbins do
      kmag = kMags[kndx]
      kfreq = kndx * kbin_hz
      kenergy += kmag
      kfreq_weighted += kmag * kfreq
      klog_sum += log(kmag + 1e-12)
      if kmag > kmax_mag then
        kmax_mag = kmag
      endif
      if (kndx >= kmin_bin1 && kndx <= kmax_bin1) then
        kband_lo += kmag
      endif
      if (kndx >= kmin_bin3 && kndx <= kmax_bin3) then
        kband_hi += kmag
      endif
      kPrevMags[kndx] = kmag
      kndx += 1
    od

    karith = kenergy/(inumbins+1)
    kfeat_centroid = kfreq_weighted/(kenergy + 1e-12)
    kfeat_flatness = exp(klog_sum/(inumbins+1))/(karith + 1e-12)
    kfeat_tilt = log((kband_hi + 1e-9)/(kband_lo + 1e-9))
    kfeat_crest = kmax_mag/(karith + 1e-12)

    fband1 pvsbandp f1, klofreq1*0.999, klofreq1, khifreq1, khifreq1*1.01
    fband2 pvsbandp f1, klofreq2*0.99, klofreq2, khifreq2, khifreq2*1.01
    fband3 pvsbandp f1, klofreq3*0.99, klofreq3, khifreq3, khifreq3*1.01
    fs1, kBins1[] pvstrace fband1, knbins1
    fs2, kBins2[] pvstrace fband2, knbins2
    fs3, kBins3[] pvstrace fband3, knbins3

    ktrace_bin1 = (kBins1[0] > 0 ? int(kBins1[0]) : -1)
    ktrace_bin2 = (kBins2[0] > 0 ? int(kBins2[0]) : -1)
    ktrace_bin3 = (kBins3[0] > 0 ? int(kBins3[0]) : -1)
    ktrace_freq1 = (ktrace_bin1 > 0 ? ktrace_bin1*kbin_hz : 0)
    ktrace_freq2 = (ktrace_bin2 > 0 ? ktrace_bin2*kbin_hz : 0)
    ktrace_freq3 = (ktrace_bin3 > 0 ? ktrace_bin3*kbin_hz : 0)

    ktime timeinsts
    kdetect metro kdetect_rate
    konset = 0
    if kdetect > 0 then
      kdelta_db = kinput_db - kenv_db_prev
      if kinput_db > konset_thresh_db then
        kabove_count += 1
      endif
      kenv_db_min = (kinput_db < kenv_db_min ? kinput_db : kenv_db_min)
      kenv_db_max = (kinput_db > kenv_db_max ? kinput_db : kenv_db_max)
      if kinput_db > konset_thresh_db && kdelta_db > konset_attack_db then
        konset_candidate_count += 1
      endif
      if kinput_db > konset_thresh_db && kdelta_db > konset_attack_db && (ktime-klast_gate_time) > kretrigger_sec then
        konset = 1
      endif
      kenv_db_prev = kinput_db
    endif

    if konset > 0 then
      kanalysis_pending = 1
      kanalysis_start = ktime
      klast_gate_time = ktime
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

    if kanalysis_pending > 0 then
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
    if kanalysis_pending > 0 && kelapsed >= (kmidi_analysis_ms*0.001) then
      if ksum_count >= kmin_frames then
        kavg_centroid = ksum_centroid/ksum_count
        kavg_flatness = ksum_flatness/ksum_count
        kavg_tilt = ksum_tilt/ksum_count
        kavg_crest = ksum_crest/ksum_count
        kavg_trace1 = (ksum_trace1_count > 0 ? ksum_trace1/ksum_trace1_count : 0)
        kavg_trace2 = (ksum_trace2_count > 0 ? ksum_trace2/ksum_trace2_count : 0)
        kavg_trace3 = (ksum_trace3_count > 0 ? ksum_trace3/ksum_trace3_count : 0)

        kn_cent = int(round(limit(kcent_lo + ((kavg_centroid/12000)*(kcent_hi-kcent_lo)), 0, 127)))
        kn_flat = int(round(limit(kflat_lo + (kavg_flatness*(kflat_hi-kflat_lo)), 0, 127)))
        kn_tilt = int(round(limit(ktilt_lo + (((kavg_tilt+8)/16)*(ktilt_hi-ktilt_lo)), 0, 127)))
        kn_crest = int(round(limit(kcrest_lo + ((kavg_crest/80)*(kcrest_hi-kcrest_lo)), 0, 127)))

        kn_tr1 = (kavg_trace1 > 0 ? int(round(limit(69 + (12*(log(kavg_trace1/440)/log(2))) + ktr1_trsp, ktr1_lo, ktr1_hi))) : -1)
        kn_tr2 = (kavg_trace2 > 0 ? int(round(limit(69 + (12*(log(kavg_trace2/440)/log(2))) + ktr2_trsp, ktr2_lo, ktr2_hi))) : -1)
        kn_tr3 = (kavg_trace3 > 0 ? int(round(limit(69 + (12*(log(kavg_trace3/440)/log(2))) + ktr3_trsp, ktr3_lo, ktr3_hi))) : -1)

        khit_count += 1
        printf "hit=%d t=%.3f env=%.1f C=%d F=%d T=%d Cr=%d B1=%d B2=%d B3=%d\n", 1, khit_count, ktime, kinput_db, kn_cent, kn_flat, kn_tilt, kn_crest, kn_tr1, kn_tr2, kn_tr3
      endif
      kanalysis_pending = 0
    endif
  endif

  ktime_end timeinsts
  outs a1*0, a1*0
  if ktime_end > ifilelen && kprinted_summary == 0 then
    prints "DEBUG env_min=%f env_max=%f above_count=%f onset_candidates=%f hits=%f\n", kenv_db_min, kenv_db_max, kabove_count, konset_candidate_count, khit_count
    kprinted_summary = 1
  endif
  if ktime_end > ifilelen + 0.25 then
    turnoff
  endif
endin
</CsInstruments>
<CsScore>
i1 0 3600
</CsScore>
</CsoundSynthesizer>
