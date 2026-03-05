<Cabbage>
form caption("Midi drums organ 3") size(430, 500), colour(30, 35, 40), guiMode("queue"), pluginId("mdr3")

groupbox bounds(5, 5, 420, 68), colour(75,85,90), lineThickness("0"){
groupbox bounds(5,6,165,50), text("Width"), lineThickness("0"){
nslider bounds(5,14,48,20), channel("minw1"), range(0,50,2,1,1), fontSize(11)
label bounds(5,35,48,10), text("min"), align("centre")
nslider bounds(57,14,48,20), channel("maxw1"), range(0,50,8,1,1), fontSize(11)
label bounds(57,35,48,10), text("max"), align("centre")
nslider bounds(109,14,48,20), channel("effw1"), range(0,50,0,1,1), fontSize(11)
label bounds(109,35,48,10), text("eff"), align("centre")
}
nslider bounds(175,18,35,20), channel("disp1"), range(-3,3,0.0), fontSize(12)
label bounds(175,39,35,10), text("disp"), align("left")
nslider bounds(214,18,35,20), channel("inchan1"), range(1,16,1,1,1), fontSize(12)
label bounds(214,39,35,10), text("in"), align("left")
nslider bounds(253,18,35,20), channel("outchan1"), range(1,16,1,1,1), fontSize(12)
label bounds(253,39,35,10), text("out"), align("left")
combobox bounds(292, 18, 120, 20), fontSize(11), channel("scale1"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(292, 39, 120, 10), text("scale"), align("left")
}

groupbox bounds(5, 78, 420, 68), colour(75,85,90), lineThickness("0"){
groupbox bounds(5,6,165,50), text("Width"), lineThickness("0"){
nslider bounds(5,14,48,20), channel("minw2"), range(0,50,2,1,1), fontSize(11)
label bounds(5,35,48,10), text("min"), align("centre")
nslider bounds(57,14,48,20), channel("maxw2"), range(0,50,8,1,1), fontSize(11)
label bounds(57,35,48,10), text("max"), align("centre")
nslider bounds(109,14,48,20), channel("effw2"), range(0,50,0,1,1), fontSize(11)
label bounds(109,35,48,10), text("eff"), align("centre")
}
nslider bounds(175,18,35,20), channel("disp2"), range(-3,3,0.0), fontSize(12)
label bounds(175,39,35,10), text("disp"), align("left")
nslider bounds(214,18,35,20), channel("inchan2"), range(1,16,2,1,1), fontSize(12)
label bounds(214,39,35,10), text("in"), align("left")
nslider bounds(253,18,35,20), channel("outchan2"), range(1,16,2,1,1), fontSize(12)
label bounds(253,39,35,10), text("out"), align("left")
combobox bounds(292, 18, 120, 20), fontSize(11), channel("scale2"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(292, 39, 120, 10), text("scale"), align("left")
}

groupbox bounds(5, 151, 420, 68), colour(75,85,90), lineThickness("0"){
groupbox bounds(5,6,165,50), text("Width"), lineThickness("0"){
nslider bounds(5,14,48,20), channel("minw3"), range(0,50,2,1,1), fontSize(11)
label bounds(5,35,48,10), text("min"), align("centre")
nslider bounds(57,14,48,20), channel("maxw3"), range(0,50,8,1,1), fontSize(11)
label bounds(57,35,48,10), text("max"), align("centre")
nslider bounds(109,14,48,20), channel("effw3"), range(0,50,0,1,1), fontSize(11)
label bounds(109,35,48,10), text("eff"), align("centre")
}
nslider bounds(175,18,35,20), channel("disp3"), range(-3,3,0.0), fontSize(12)
label bounds(175,39,35,10), text("disp"), align("left")
nslider bounds(214,18,35,20), channel("inchan3"), range(1,16,3,1,1), fontSize(12)
label bounds(214,39,35,10), text("in"), align("left")
nslider bounds(253,18,35,20), channel("outchan3"), range(1,16,3,1,1), fontSize(12)
label bounds(253,39,35,10), text("out"), align("left")
combobox bounds(292, 18, 120, 20), fontSize(11), channel("scale3"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(292, 39, 120, 10), text("scale"), align("left")
}

groupbox bounds(5, 224, 420, 68), colour(75,85,90), lineThickness("0"){
groupbox bounds(5,6,165,50), text("Width"), lineThickness("0"){
nslider bounds(5,14,48,20), channel("minw4"), range(0,50,2,1,1), fontSize(11)
label bounds(5,35,48,10), text("min"), align("centre")
nslider bounds(57,14,48,20), channel("maxw4"), range(0,50,8,1,1), fontSize(11)
label bounds(57,35,48,10), text("max"), align("centre")
nslider bounds(109,14,48,20), channel("effw4"), range(0,50,0,1,1), fontSize(11)
label bounds(109,35,48,10), text("eff"), align("centre")
}
nslider bounds(175,18,35,20), channel("disp4"), range(-3,3,0.0), fontSize(12)
label bounds(175,39,35,10), text("disp"), align("left")
nslider bounds(214,18,35,20), channel("inchan4"), range(1,16,4,1,1), fontSize(12)
label bounds(214,39,35,10), text("in"), align("left")
nslider bounds(253,18,35,20), channel("outchan4"), range(1,16,4,1,1), fontSize(12)
label bounds(253,39,35,10), text("out"), align("left")
combobox bounds(292, 18, 120, 20), fontSize(11), channel("scale4"), items("semitone", "wholetone", "major", "minor", "penta1", "penta2"), value(1)
label bounds(292, 39, 120, 10), text("scale"), align("left")
}

csoundoutput bounds(0, 297, 430, 190)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d
</CsOptions>
<CsInstruments>

ksmps = 8
massign -1, 2
pgmassign -1, -1

giSemitone ftgen 0, 0, 13, -2, 0,1,2,3,4,5,6,7,8,9,10,11,12
giWholetone ftgen 0, 0, 7, -2, 0,2,4,6,8,10,12
giMajor ftgen 0, 0, 8, -2, 0,2,4,5,7,9,11,12
giMinor ftgen 0, 0, 8, -2, 0,2,3,5,7,9,10,12
giPenta1 ftgen 0, 0, 6, -2, 0,3,5,7,10,12
giPenta2 ftgen 0, 0, 6, -2, 0,2,5,7,9,12
giScales ftgen 0, 0, 6, -2, giSemitone, giWholetone, giMajor, giMinor, giPenta1, giPenta2

instr 1
endin

opcode ClusterInstance, 0, iiiiiiiiiiS
  inote, ivel, ichan, iinchan, ioutchan, iscale, iminw, imaxw, idisperse, ibase, S_effchan xin

  if ichan != iinchan igoto done

  if imaxw < iminw then
    itemp = imaxw
    imaxw = iminw
    iminw = itemp
  endif

  iwidth = iminw + (ivel/127)*(imaxw-iminw)
  iwidth = round(iwidth)
  iwidth = (iwidth < 1 ? 1 : iwidth)
  k_eff init iwidth
  k_trig init 1
  cabbageSetValue S_effchan, k_eff, k_trig
  idisperse *= 0.1

  iscaletab = table(iscale-1, giScales)
  iscalelen = ftlen(iscaletab)
  ioct = table(iscalelen-1, iscaletab)

  icount = int(iwidth)
  idown = int((icount-1)/2)
  iup = icount-1-idown

  istep_n = -idown
  iord = 0
  while istep_n <= iup do
    if idisperse > 0 then
      idelay = divz(iord,icount-1,0)*idisperse
    else
      idelay = divz((icount-1)-iord,icount-1,0)*abs(idisperse)
    endif

    if istep_n >= 0 then
      iq = int(istep_n/(iscalelen-1))
      ir = istep_n%(iscalelen-1)
      ioffset = iq*ioct + table(ir, iscaletab)
    else
      iabs = -istep_n
      iq = int(iabs/(iscalelen-1))
      ir = iabs%(iscalelen-1)
      if ir == 0 then
        ioffset = -iq*ioct
      else
        ioffset = -(iq+1)*ioct + table((iscalelen-1)-ir, iscaletab)
      endif
    endif

    iclusternote = inote + ioffset
    ievt_id = ibase + (500+istep_n)*0.001
    event_i "i", ievt_id, idelay, -1, ivel, iclusternote, ioutchan
    istep_n += 1
    iord += 1
  od

  koff lastcycle
  if koff > 0 then
    kstep_n = -idown
    kord = 0
    while kstep_n <= iup do
      if idisperse > 0 then
        kdelay = divz(kord,icount-1,0)*idisperse
      else
        kdelay = divz((icount-1)-kord,icount-1,0)*abs(idisperse)
      endif

      if kstep_n >= 0 then
        kq = int(kstep_n/(iscalelen-1))
        k_rem = kstep_n%(iscalelen-1)
        koffset = kq*ioct + table(k_rem, iscaletab)
      else
        kabs = -kstep_n
        kq = int(kabs/(iscalelen-1))
        k_rem = kabs%(iscalelen-1)
        if k_rem == 0 then
          koffset = -kq*ioct
        else
          koffset = -(kq+1)*ioct + table((iscalelen-1)-k_rem, iscaletab)
        endif
      endif

      knote = inote + koffset
      kevt_id = ibase + (500+kstep_n)*0.001
      event "i", -kevt_id, kdelay, .01, ivel, knote, ioutchan
      kstep_n += 1
      kord += 1
    od
  endif

done:
endop

#define PROCESS_INSTANCE(N'BASE) #
  iinchan$N chnget "inchan$N"
  ioutchan$N chnget "outchan$N"
  iscale$N chnget "scale$N"
  iminw$N chnget "minw$N"
  imaxw$N chnget "maxw$N"
  idisp$N chnget "disp$N"
  ClusterInstance inote, ivel, ichan, iinchan$N, ioutchan$N, iscale$N, iminw$N, imaxw$N, idisp$N, $BASE, "effw$N"
#

instr 2
  inote notnum
  ivel veloc
  ichan midichn

  $PROCESS_INSTANCE(1'201)
  $PROCESS_INSTANCE(2'202)
  $PROCESS_INSTANCE(3'203)
  $PROCESS_INSTANCE(4'204)

endin

instr 201,202,203,204
  ivel = p4
  inote = p5
  ichan = p6
  idur = (p3 < 0 ? 999 : p3)
  noteondur ichan, inote, ivel, idur
endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
