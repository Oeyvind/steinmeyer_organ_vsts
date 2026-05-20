<Cabbage>
form caption("Midi delay") size(420, 520), colour(30, 35, 40), guiMode("queue"), pluginId("mdl2")

nslider bounds(5, 15, 30, 25), channel("inchan"), range(1,16,1, 1, 1)
label bounds(5, 40, 40, 15), text("inchan"), fontSize(11)
nslider bounds(55, 15, 60, 25), channel("bpm"), range(10,999,120,1,1)
label bounds(55, 40, 40, 15), text("bpm"), fontSize(11)

nslider bounds(5, 65, 40, 25), channel("outchan"), range(1,16,2, 1, 1)
label bounds(5, 90, 40, 15), text("chan_1"), fontSize(11)
nslider bounds(55, 65, 40, 25), channel("dly_min"), range(1,32,1,1,1)
label bounds(55, 90, 40, 15), text("dly_min"), fontSize(11)
nslider bounds(105, 65, 40, 25), channel("dly_max"), range(1,32,4,1,1)
label bounds(105, 90, 40, 15), text("dly_max"), fontSize(11)
nslider bounds(155, 65, 40, 25), channel("duration"), range(0,1,1)
label bounds(155, 90, 40, 15), text("duration"), fontSize(11)
nslider bounds(205, 65, 40, 25), channel("transpose"), range(-12,12,0,1,1)
label bounds(205, 90, 40, 15), text("transp"), fontSize(11)
checkbox bounds(255, 65, 120, 25), channel("tap1_enable"), value(1), text("tap1 enable")

nslider bounds(5, 115, 40, 25), channel("outchan2"), range(1,16,3, 1, 1)
label bounds(5, 140, 40, 15), text("chan_2"), fontSize(11)
nslider bounds(55, 115, 40, 25), channel("dly2_min"), range(1,32,1,1,1)
label bounds(55, 140, 40, 15), text("dly2_mn"), fontSize(11)
nslider bounds(105, 115, 40, 25), channel("dly2_max"), range(1,32,4,1,1)
label bounds(105, 140, 40, 15), text("dly2_mx"), fontSize(11)
nslider bounds(155, 115, 40, 25), channel("duration2"), range(0,1,1)
label bounds(155, 140, 40, 15), text("dur2"), fontSize(11)
nslider bounds(205, 115, 40, 25), channel("transpose2"), range(-12,24,0,1,1)
label bounds(205, 140, 40, 15), text("trsp2"), fontSize(11)
checkbox bounds(255, 115, 120, 25), channel("tap2_enable"), value(1), text("tap2 enable")

checkbox bounds(5, 215, 70, 25), channel("gen_enable"), value(0), text("gen on")
nslider bounds(80, 215, 65, 25), channel("note_density_meter"), range(0,20,0,1,0.01)
label bounds(80, 240, 65, 15), text("ev/s"), fontSize(11)
label bounds(155, 200, 110, 15), text("r-events  trig"), fontSize(11)
nslider bounds(150, 215, 55, 25), channel("gen_eps_min"), range(0.1,20,2,1,0.1)
label bounds(150, 240, 55, 15), text("eps_min"), fontSize(11)
nslider bounds(210, 215, 55, 25), channel("gen_eps_max"), range(0.1,20,8,1,0.1)
label bounds(210, 240, 55, 15), text("eps_max"), fontSize(11)
label bounds(270, 200, 130, 15), text("-nevents scaling-"), fontSize(11)
checkbox bounds(270, 215, 55, 25), channel("gen_scale_tempo"), value(1), text("tvar")
nslider bounds(330, 215, 55, 25), channel("gen_scale_density"), range(0,3,1,1,0.01)
label bounds(330, 240, 55, 15), text("density"), fontSize(11)

nslider bounds(5, 275, 35, 25), channel("gen_outchan"), range(1,16,2,1,1)
label bounds(5, 300, 40, 15), text("chan_g"), fontSize(11)
nslider bounds(45, 275, 35, 25), channel("gen_dly_min"), range(1,32,1,1,1)
label bounds(45, 300, 35, 15), text("min"), fontSize(11)
nslider bounds(85, 275, 35, 25), channel("gen_dly_max"), range(1,32,4,1,1)
label bounds(85, 300, 35, 15), text("max"), fontSize(11)
label bounds(52, 315, 60, 15), text("-delay-"), fontSize(11)
nslider bounds(125, 275, 35, 25), channel("gen_min"), range(1,10,1,1,1)
label bounds(125, 300, 35, 15), text("min"), fontSize(11)
nslider bounds(165, 275, 35, 25), channel("gen_max"), range(1,10,4,1,1)
label bounds(165, 300, 35, 15), text("max"), fontSize(11)
nslider bounds(205, 275, 35, 25), channel("gen_max_eff"), range(1,120,4,1,1)
label bounds(205, 300, 35, 15), text("eff"), fontSize(11)
label bounds(130, 315, 70, 15), text("-nevents-"), fontSize(11)
combobox bounds(245, 275, 60, 25), channel("gen_mult"), value(2), items("slow", "medium", "fast")
label bounds(245, 300, 60, 15), text("g_mult"), fontSize(11)
combobox bounds(310, 275, 70, 25), channel("tempo_var"), value(1), items("unit", "1 and 2", "1 and 3", "1_2_3")
label bounds(310, 300, 70, 15), text("tempo_var"), fontSize(11)


csoundoutput bounds(0, 370, 420, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -b-1 -B-1
</CsOptions>
<CsInstruments>

; Quick Start (midi_delay2)
; 1) Set inchan to your played MIDI channel.
; 2) Set bpm for all beat-based delays and generator timing.
; 3) Enable tap1/tap2 and set chan_1/chan_2, dly min/max, transp.
; 4) Turn on gen on to allow phrase generation.
; 5) Set eps_min / eps_max to map note density to trigger probability.
;    - near eps_min: ~25% trigger chance
;    - at/above eps_max: 100% trigger chance
; 6) In row 5 set chan_g, delay min/max, nevents min/max.
; 7) Choose g_mult and tempo_var for phrase speed/variation.
; 8) Use tvar + density scaling to expand max nevents dynamically.
; 9) Generated notes are clamped to MIDI 36..96.
; 10) Keep csoundoutput open to monitor density/count debug prints.

ksmps = 64
massign -1, 2
pgmassign -1, -1


instr 1
  ; GUI control
  chnset 0, "note_density"
  cabbageSetValue "note_density_meter", 0
  cabbageSetValue "gen_max_eff", 0
  chnset -1, "last_count"
  iidx = 0
  while iidx < 20 do
    Sslot sprintf "evt_%d", iidx
    chnset -1000, Sslot
    iidx += 1
  od

endin

instr 2
  ; midi notes input, 
  ; same note with short duration in another channel
  
  inote notnum
  ivel veloc 0, 1
  ichn midichn
  inchan chnget "inchan"
  ibpm chnget "bpm"
  ioutchan chnget "outchan"
  idly_min chnget "dly_min"
  idly_max chnget "dly_max"
  idly_secs = (60.0/ibpm) * int(random(idly_min, idly_max+0.999))
  ;print inote, ichn, inchan
  idur chnget "duration"
  itranspose chnget "transpose"
  itap1_enable chnget "tap1_enable"
  itap2_enable chnget "tap2_enable"
  ioutchan2 chnget "outchan2"
  idly2_min chnget "dly2_min"
  idly2_max chnget "dly2_max"
  idly2_delta_secs = (60.0/ibpm) * int(random(idly2_min, idly2_max+0.999))
  idly2_secs = idly_secs + idly2_delta_secs
  idur2 chnget "duration2"
  itranspose2 chnget "transpose2"
  if ichn == inchan && ivel > 0 then
    igen_enable chnget "gen_enable"
    igen_outchan chnget "gen_outchan"
    ieps_min chnget "gen_eps_min"
    ieps_max chnget "gen_eps_max"
    if ieps_min < 0.001 then
      ieps_min = 0.001
    endif
    if ieps_max < ieps_min then
      itemp_eps = ieps_min
      ieps_min = ieps_max
      ieps_max = itemp_eps
      if ieps_min < 0.001 then
        ieps_min = 0.001
      endif
    endif
    inow times
    ivalid_times[] init 20
    ivalid_count = 0
    iidx = 0
    while iidx < 20 do
      Sslot sprintf "evt_%d", iidx
      itime chnget Sslot
      if itime > -999 then
        if (inow - itime) <= 2.0 then
          ivalid_times[ivalid_count] = itime
          ivalid_count += 1
        endif
      endif
      iidx += 1
    od
    if ivalid_count >= 20 then
      ikeep_count = 19
      ikeep_start = ivalid_count - 19
    else
      ikeep_count = ivalid_count
      ikeep_start = 0
    endif
    iidx = 0
    while iidx < 20 do
      Sslot sprintf "evt_%d", iidx
      chnset -1000, Sslot
      iidx += 1
    od
    iwrite = 0
    while iwrite < ikeep_count do
      Sslot sprintf "evt_%d", iwrite
      chnset ivalid_times[ikeep_start+iwrite], Sslot
      iwrite += 1
    od
    Sslot sprintf "evt_%d", ikeep_count
    chnset inow, Sslot
    iwindow_count = ikeep_count + 1
    idensity = iwindow_count/2.0
    chnset idensity, "note_density"
    cabbageSetValue "note_density_meter", idensity
    if idensity >= ieps_max then
      iprob = 1
    elseif idensity >= ieps_min then
      idenom = ieps_max - ieps_min
      if idenom < 0.0001 then
        idenom = 0.0001
      endif
      iprob = 0.25 + (0.75*((idensity-ieps_min)/idenom))
    else
      iprob = 0
    endif
    if iprob < 0 then
      iprob = 0
    elseif iprob > 1 then
      iprob = 1
    endif
    if igen_enable > 0.5 then
      if random(0, 1) < iprob then
        event_i "i", 401, 0, 0.01, inote, ivel, igen_outchan, ibpm
      endif
    endif
    kdur timeinsts
    klast lastcycle
    if itap1_enable > 0.5 then
      instnum = 201+((inote+itranspose)*0.001)
      event_i "i", instnum, idly_secs, -1, inote+itranspose, ivel, ioutchan
      if klast > 0.0 then
        event "i", -instnum, idly_secs-(kdur*(1-idur)), .1
      endif
      if itap2_enable > 0.5 then
        instnum2 = 201.5+((inote+itranspose2)*0.001)
        event_i "i", instnum2, idly2_secs, -1, inote+itranspose2, ivel, ioutchan2
        if klast > 0.0 then
          event "i", -instnum2, idly2_secs-(kdur*(1-idur2)), .1
        endif
      endif
    endif
  endif
endin


instr 201
  ; midi  output
  inote = p4
  ivel = p5*127
  ichan = p6
  ;print inote, ivel, ichan
  idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
  ;idur    = (p3 < 0.0105 ? 0 : p3)  ; avoid extremely short notes as they won't play
  noteondur ichan, inote, ivel, idur
    
endin

instr 401
  ; trajectory-based event generator
  inote = p4
  ivel = p5
  ioutchan = p6
  ibpm = p7
  igen_min chnget "gen_min"
  igen_max chnget "gen_max"
  if igen_min > igen_max then
    itemp = igen_min
    igen_min = igen_max
    igen_max = itemp
  endif
  igen_mult_mode chnget "gen_mult"
  if igen_mult_mode == 1 then
    ibase_mult = 2
  elseif igen_mult_mode == 2 then
    ibase_mult = 4
  else
    ibase_mult = 8
  endif
  itempo_var_mode chnget "tempo_var"
  if itempo_var_mode == 1 then
    itempo_var = 1
  elseif itempo_var_mode == 2 then
    itempo_var = (int(random(0, 1.999)) == 0 ? 1 : 2)
  elseif itempo_var_mode == 3 then
    itempo_pick = int(random(0, 2.999))
    if itempo_pick == 0 then
      itempo_var = 1
    elseif itempo_pick == 1 then
      itempo_var = 1.5
    else
      itempo_var = 2
    endif
  else
    itempo_pick = int(random(0, 3.999))
    if itempo_pick == 0 then
      itempo_var = 1
    elseif itempo_pick == 1 then
      itempo_var = 1.5
    elseif itempo_pick == 2 then
      itempo_var = 2
    else
      itempo_var = 3
    endif
  endif
  igen_dly_min chnget "gen_dly_min"
  igen_dly_max chnget "gen_dly_max"
  if igen_dly_min > igen_dly_max then
    itemp2 = igen_dly_min
    igen_dly_min = igen_dly_max
    igen_dly_max = itemp2
  endif
  igen_dly_secs = (60.0/ibpm) * int(random(igen_dly_min, igen_dly_max+0.999))
  iscale_tempo chnget "gen_scale_tempo"
  if iscale_tempo > 0.5 then
    itempo_scale = itempo_var
  else
    itempo_scale = 1
  endif
  ieps_min chnget "gen_eps_min"
  ieps_max chnget "gen_eps_max"
  if ieps_min < 0.001 then
    ieps_min = 0.001
  endif
  if ieps_max < ieps_min then
    itemp_eps = ieps_min
    ieps_min = ieps_max
    ieps_max = itemp_eps
    if ieps_min < 0.001 then
      ieps_min = 0.001
    endif
  endif
  idensity chnget "note_density"
  idens_norm = (idensity - ieps_min)/(ieps_max - ieps_min + 0.0001)
  if idens_norm < 0 then
    idens_norm = 0
  elseif idens_norm > 1 then
    idens_norm = 1
  endif
  iscale_density chnget "gen_scale_density"
  idensity_scale = 1 + (iscale_density * idens_norm)
  igen_max_scaled = int((igen_max * itempo_scale * idensity_scale) + 0.999)
  if igen_max_scaled < igen_min then
    igen_max_scaled = igen_min
  endif
  cabbageSetValue "gen_max_eff", igen_max_scaled
  igen_count = int(random(igen_min, igen_max_scaled+0.999))
  istep_secs = (60.0/ibpm)/(ibase_mult*itempo_var)
  itraj_mode = int(random(0, 3.999))
  iexpand_dir = (int(random(0, 1.999)) == 0 ? -1 : 1)
  iexpand_base = int(random(2, 4.999))
  ialt_dir = (int(random(0, 1.999)) == 0 ? -1 : 1)
  iprev_note = inote
  iidx = 0
  while iidx < igen_count do
    if iidx < 3 then
      irand_step = int(random(-1, 1.999))
      igen_note = iprev_note + irand_step
    else
      if itraj_mode == 0 then
        igen_note = iprev_note - 1
        if random(0, 1) > 0.8 then
          igen_note = igen_note - 1
        endif
      elseif itraj_mode == 1 then
        igen_note = iprev_note + 1
        if random(0, 1) > 0.8 then
          igen_note = igen_note + 1
        endif
      elseif itraj_mode == 2 then
        iint = iexpand_base + (iidx-3)
        if random(0, 1) > 0.7 then
          iint = iint + int(random(1, 3.999))
        endif
        igen_note = iprev_note + (iint * iexpand_dir)
      else
        ialt_step = int(random(1, 3.999))
        igen_note = iprev_note + (ialt_step * ialt_dir)
        ialt_dir = -ialt_dir
      endif
    endif
    if igen_note < 36 then
      igen_note = 36
    elseif igen_note > 96 then
      igen_note = 96
    endif
    iprev_note = igen_note
    istart = igen_dly_secs + (iidx * istep_secs)
    idur = istep_secs * 0.9
    instnumg = 201.7 + (igen_note*0.001) + (iidx*0.00001)
    event_i "i", instnumg, istart, idur, igen_note, ivel, ioutchan
    iidx += 1
  od
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
