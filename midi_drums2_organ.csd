<Cabbage>
form caption("Midi drums 2 organ") size(310, 260), colour(30, 35, 40), guiMode("queue"), pluginId("mdr2")

groupbox bounds(5, 5, 300, 45), colour(75,85,90), lineThickness("0"){ 
nslider bounds(5,5,50,20), channel("width"), range(0,50,5, 1, 1), fontSize(14)
label bounds(5, 25, 50, 10), text("width"), align("left")
nslider bounds(65,5,35,20), channel("disperse"), range(-3,3,0.5), fontSize(14)
label bounds(65, 25, 35, 10), text("disperse"), align("left")
combobox bounds(110, 5, 120, 20) fontSize(16), channel("scale"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(110, 25, 35, 10), text("scale"), align("left")
nslider bounds(240,5,35,20), channel("gliss_dur"), range(0,1,0.1), fontSize(14)
label bounds(240, 25, 50, 10), text("glisdur"), align("left")
}
label bounds(5, 55, 300, 10), text("Cluster for small intervals - gliss for large intervals"), align("left")
label bounds(5, 70, 300, 10), text("Semitone or wholetone cluster set by intervl size"), align("left")
label bounds(5, 85, 300, 10), text("Cluster width set by intervl size"), align("left")

csoundoutput bounds(0, 110, 300, 150)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 8
massign -1, 2
pgmassign -1, -1

giNotesActive[] init 5 ; really only need 2

instr 1
  ; GUI control
endin

instr 2
  ; midi notes input, trigger midi cluster and midi glissandi events
  ivel veloc
  inote notnum
  ichan midichn
  idry_nstrnum = 201+(inote*0.001)+0.0001
  icluster_nstrnum = 3
  iactive active 2
  i_nstrnum = iactive == 1 ? idry_nstrnum : icluster_nstrnum
  event_i "i", i_nstrnum, 0, -1, ivel, inote, ichan
  koff lastcycle
  if koff > 0 then
    event "i", -i_nstrnum, 0, .1
    reinit clear_note
    clear_note:
    giNotesActive[iactive-1] = 0
    ;printarray giNotesActive
    rireturn
  endif
  giNotesActive[iactive-1] = inote
  ;printarray giNotesActive
  if iactive > 1 then
    interval = giNotesActive[iactive-1]-giNotesActive[iactive-2]
  else
    interval = 1
  endif
  chnset interval, "interval" ; used in gliss mode
  imode_selector = abs(interval) > 6 ? 2 : 1 ; gliss mode for large intervals, cluster for small
  chnset imode_selector, "mode" 
  if imode_selector == 1 then
    iwidth = interval > 0 ? (((interval-1)%3)+1)*6 : (((abs(interval)-1)%3)+1)*12
    cabbageSetValue "width", iwidth
    iscale = abs(interval) > 3 ? 2 : 1 ; semitone for small intervals, wholetone for large
    cabbageSetValue "scale", iscale
  endif
endin

instr 3
  ; cluster
  ivel = p4
  inote = p5
  ichan = p6
  imode chnget "mode"
  if imode == 1 then
    iwidth chnget "width"
    idisperse chnget "disperse"
    idisperse *= 0.1
    ilow = inote-ceil(iwidth/2)
    ihigh = inote+floor(iwidth/2)

    ; find length of scale
    indx = 0
    iSemitone ftgen 0, 0, 13, -2, 0,1,2,3,4,5,6,7,8,9,10,11,12
    iWholetone ftgen 0, 0, 7, -2, 0,2,4,6,8,10,12
    iMajor ftgen 0, 0, 8, -2, 0,2,4,5,7,9,11,12
    iMinor ftgen 0, 0, 8, -2, 0,2,3,5,7,9,10,12
    iPenta1 ftgen 0, 0, 6, -2, 0,3,5,7,10,12
    iPenta2 ftgen 0, 0, 6, -2, 0,2,5,7,9,12
    iScales ftgen 0, 0, 6, -2, iSemitone, iWholetone, iMajor, iMinor, iPenta1, iPenta2
    iscale chnget "scale"
    iscaletab = table(iscale-1,iScales)
    iscalelen = ftlen(iscaletab)
    iScale[] init iscalelen
    indx = 0
    while indx < iscalelen do
      iScale[indx] = table(indx,iscaletab)
      indx += 1
    od
    ;iScale fillarray 0,3,5,7,10
    ;printarray iScale

    ; make cluster
    indx = ilow
    i_nstrnum = 201
    while indx <= ihigh do
      if idisperse > 0 then
        idelay = divz(indx-ilow,ihigh-ilow,0)*idisperse
      else
        idelay = divz(ihigh-indx,ihigh-ilow,0)*abs(idisperse)
      endif
      if int(indx-inote) > 0 then
        iclusternote = int((indx-inote-1)%(lenarray(iScale)-1))+1
        ioffset = ((ceil((indx-inote)/(lenarray(iScale)-1))-1)*iScale[lenarray(iScale)-1])

      elseif int(indx-inote) < 0 then
        iclusternote = ((lenarray(iScale)*2)+indx-inote)%(lenarray(iScale)-1)
        ioffset = ((floor((indx-inote)/(lenarray(iScale)-1)))*iScale[lenarray(iScale)-1])
        ;print iclusternote, ioffset
      else
        iclusternote = 0
        ioffset = 0
      endif
      iclusternote = inote+iScale[iclusternote]+ioffset
      ;iclusternote = indx ; cop out on scale
      ;print iclusternote
      event_i "i", i_nstrnum+(indx*0.001), idelay, -1, ivel, iclusternote, ichan
      indx += 1
    od
    koff lastcycle
    if koff > 0 then
      kndx = ilow
      while kndx <= ihigh do
        if idisperse > 0 then
          kdelay = divz(kndx-ilow,ihigh-ilow,0)*idisperse
        else
          kdelay = divz(ihigh-kndx,ihigh-ilow,0)*abs(idisperse)
        endif
        event "i", -(i_nstrnum+(kndx*0.001)), kdelay, .01, ivel, kndx, ichan
        kndx += 1
      od
    endif
  else
    interval chnget "interval"
    igliss_dur chnget "gliss_dur"
    igliss_dur = (igliss_dur/7)*abs(interval); longer glisses for longer pitch spans
    igliss_instr = 201
    indx = 0
    while indx < abs(interval) do
      igliss_note = inote - (indx*signum(interval))
      igliss_delay = indx*(igliss_dur/abs(interval))
      event_i "i", igliss_instr+(igliss_note*0.001)+0.0002, igliss_delay, .1, ivel, igliss_note, ichan
      indx += 1
    od
  endif
endin

instr 201
  ; midi  output
    ivel = p4
    inote = p5
    ichan = p6
    idur    = (p3 < 0 ? 999 : p3)  ; use very long duration for negative dur, noteondur will create note off when instrument stops
    noteondur ichan, inote, ivel, idur
    
endin

</CsInstruments>
<CsScore>
i1 0 86400

</CsScore>
</CsoundSynthesizer>
