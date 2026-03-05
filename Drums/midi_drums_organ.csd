<Cabbage>
form caption("Midi drums organ") size(300, 450), colour(30, 35, 40), guiMode("queue"), pluginId("mdr1")

groupbox bounds(5, 5, 300, 45), colour(75,85,90), lineThickness("0"){ 
nslider bounds(5,5,50,20), channel("width"), range(0,50,5, 1, 1), fontSize(14)
label bounds(5, 25, 50, 10), text("width"), align("left")
nslider bounds(65,5,35,20), channel("disperse"), range(-3,3,0.5), fontSize(14)
label bounds(65, 25, 35, 10), text("disperse"), align("left")
combobox bounds(110, 5, 130, 20) fontSize(16), channel("scale"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(110, 25, 35, 10), text("scale"), align("left")
}



csoundoutput bounds(0, 150, 300, 250)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d 
</CsOptions>
<CsInstruments>

ksmps = 8
massign -1, 2
pgmassign -1, -1

instr 1
  ; GUI control
endin

instr 2
  ; midi notes input, trigger midi cluster events
  inote notnum
  ivel veloc
  ichan midichn
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
  printarray iScale

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
    event_i "i", (i_nstrnum+indx*0.001), idelay, -1, ivel, iclusternote, ichan
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
      event "i", -(i_nstrnum+kndx*0.001), kdelay, .01, ivel, kndx, ichan
      kndx += 1
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
