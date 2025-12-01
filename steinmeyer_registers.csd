<Cabbage>
form caption("Steinmeyer registers") size(600, 500), colour(30, 35, 40), guiMode("queue"), pluginId("stn1")
image bounds(0, 0, 600, 400), channel("console"), file("steinmeyer_console_combo.png")
csoundoutput bounds(0, 400, 600, 100)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -+raw_controller_mode=1

</CsOptions>
<CsInstruments>

ksmps = 128
;massign -1, 2
pgmassign 0, 0

instr 1
  ; GUI assembly
  irowx_left = 5
  irowx1_left = 218
  
  irowx_right = 308
  irowx1_right = 382
  irowx2_right = 522
  irowx3_right = 558

  irow1y = 336
  irow2y = 256
  irow3y = 176
  irow4y = 96
  irow5y = 16
  ixspace = 17.7
  iheight = 30

  ix_ruckbutn = 162
  iy_ruckbutn1 = 80
  iyspace_ruckbutn = 79

  ; Pedal, left panel
  ibutn = 0
  ix = irowx_left
  iy = irow1y
  while ibutn < 16 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; pedal right panel 
  ix = irowx_right
  while ibutn < 32 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; Manual 1, left panel
  ix = irowx_left
  iy = irow2y
  while ibutn < 48 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; Manual 1 right panel
  ix = irowx_right
  while ibutn < 59 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Manual 2, left panel
  ix = irowx_left
  iy = irow3y
  while ibutn < 75 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; Manual 2 right panel
  ix = irowx_right
  while ibutn < 84 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Master swell
  ix = irowx2_right 
  SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
  cabbageCreate "checkbox", SWidget
  ibutn += 1

  ; Manual 3, left panel
  ix = irowx_left
  iy = irow4y
  while ibutn < 101 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; Manual 3 right panel
  ix = irowx_right
  while ibutn < 114 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Switches: Fjernverk, Kororgel
  ix = irowx3_right
  while ibutn < 116 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Fjernverk
  ix = irowx_left
  iy = irow5y
  while ibutn < 127 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Solo, left panel
  ix = irowx1_left
  iy = irow5y
  while ibutn < 131 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od
  ; Solo, right panel
  ix = irowx_right
  while ibutn < 134 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Ruckpositiv, right panel
  ix = irowx1_right
  while ibutn < 146 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, ixspace, iheight, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    ix += ixspace
  od

  ; Ruckpositiv, enable switches
  ix = ix_ruckbutn
  iy = iy_ruckbutn1
  iruckbutn_height = 15
  iruckbutn_width = 30
  while ibutn < 150 do
    SWidget sprintf "bounds(%d, %d, %d, %d), channel(\"check%d\"), colour:1(%d, %d, %d)", ix, iy, iruckbutn_width, iruckbutn_height, ibutn, 200,200,0
    cabbageCreate "checkbox", SWidget
    ibutn += 1
    iy += iyspace_ruckbutn
  od

  chnset ibutn, "numbuttons"  
    
endin


instr 2
  ; program change
  ; NEED TO CHECK PROG NUM og CHN FOR
  ; - fjernverk 
  ; - ruckpositiv
  ; - manual koble til ruckpositiv
  ; - fjernverk inn
  ; - kororgel inn


  kRegOffset[] fillarray 32,59,85,116,0,0,0,0 ; register number offset per midi channel
  kRuckSwitchOffset[] fillarray 74,70,72,76 ; special treatment of ruckpositiv enable switches
  iButnChan ftgen 0, 0, 256, -17, 0,8,  32,1,  59,2,  85,3,  116,4,  145, 1

  kbutn = 0
  inumbuttons chnget "numbuttons"
  kButtons[] init inumbuttons
  while kbutn < inumbuttons do
    kval chnget sprintfk("check%i", kbutn)
    if kButtons[kbutn] != kval then
      kstatus = 192
      kchan table kbutn, iButnChan
      if kbutn > 145 then ; ruckpositiv enable switches
        kprognum = kRuckSwitchOffset[kbutn-145-1]+1-kval
      else
        kprognum = ((kbutn-kRegOffset[kchan-1])*2)+1-kval
      endif
      Sdebug sprintfk "butn %i, chan %i, prognum %i", kbutn, kchan, kprognum
      puts Sdebug, kprognum+1
      kdata2 = 0
      midiout kstatus, kchan, kprognum, kdata2
    endif
    kButtons[kbutn] = kval
    kbutn += 1
  od
;kstatus = 192 (program change)
  kstatus, kchan, kdata1, kdata2 midiin
  if kstatus == 192 then
    kregister = int(kdata1/2)
    if kdata1%2 == 0 then
      kreg_onoff = 1
    else
      kreg_onoff = 0
    endif
    if kregister >= 70 && kchan == 1 then ; ruckpos switches
      kregister = 146 ; test
    else
      kregister += kRegOffset[kchan-1]
    endif
    Sreg sprintfk "reg %i ch %i onoff %i", kregister, kchan, kreg_onoff
    puts Sreg, changed(kdata1)+1
    cabbageSet 1, sprintfk("check%i", kregister), "value", kreg_onoff
  endif

endin


</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400

</CsScore>
</CsoundSynthesizer>
