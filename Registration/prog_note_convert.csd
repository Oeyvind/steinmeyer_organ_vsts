<Cabbage>
form caption("Program-Note Converter") size(520, 180), colour(30, 35, 40), guiMode("queue"), pluginId("pnc1")

label bounds(12, 10, 496, 16), text("Steinmeyer mapping: program N(on) <-> note N/2 on, program N(off=odd) <-> note (N-1)/2 off"), fontSize(10), align("left")
checkbox bounds(12, 34, 180, 22), channel("enablePgmToNote"), text("Program -> Note"), value(1)
checkbox bounds(210, 34, 180, 22), channel("enableNoteToPgm"), text("Note -> Program"), value(1)
checkbox bounds(400, 34, 110, 22), channel("enablePrint"), text("Debug Print"), value(1)
label bounds(12, 62, 496, 16), text("Input and output keep the same MIDI channel."), fontSize(10), align("left")
csoundoutput bounds(12, 84, 496, 84)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -+raw_controller_mode=1
</CsOptions>
<CsInstruments>

ksmps = 128
massign -1, 99
pgmassign -1, -1

instr 1
  kpgm_to_note chnget "enablePgmToNote"
  knote_to_pgm chnget "enableNoteToPgm"

  kpgm_to_note_changed changed kpgm_to_note
  if kpgm_to_note_changed > 0 then
    if kpgm_to_note > 0.5 then
      event "i", 10, 0, -1
    else
      event "i", -10, 0, .05
    endif
  endif

  knote_to_pgm_changed changed knote_to_pgm
  if knote_to_pgm_changed > 0 then
    if knote_to_pgm > 0.5 then
      event "i", 11, 0, -1
    else
      event "i", -11, 0, .05
    endif
  endif
endin

instr 10
  ; Program Change -> MIDI Note
  kprintflag init 0
  kstatus, kchan, kdata1, kdata2 midiin
  kchanged changed kstatus, kchan, kdata1, kdata2
  if kchanged < 0.5 then
    kgoto done
  endif
  kprintflag = kprintflag + kchanged
  kprint chnget "enablePrint"
  if kprint > 0.5 then
    printf "P to N in : st=%f ch=%f d1=%f d2=%f\n", kprintflag, kstatus, kchan, kdata1, kdata2
  endif

  ; In this setup, Program Change messages arrive with status 192 and kdata1 as program number.
  if kstatus != 192 then
    goto done
  endif

  kprog = int(kdata1 + 0.5)
  if kprog < 0 || kprog > 127 then
    goto done
  endif

  knote = int(kprog / 2)
  if knote < 0 || knote > 63 then
    goto done
  endif

  if (kprog % 2) == 0 then
    ; Even program number = ON -> Note On
    midiout 144, kchan, knote, 100
    if kprint > 0.5 then
      printf "P to N out: st=144 ch=%f note=%f vel=100\n", kprintflag, kchan, knote
    endif
  else
    ; Odd program number = OFF -> Note Off
    midiout 128, kchan, knote, 0
    if kprint > 0.5 then
      printf "P to N out: st=128 ch=%f note=%f vel=0\n", kprintflag, kchan, knote
    endif
  endif

  done:
endin

instr 11
  ; MIDI Note -> Program Change
  kprintflag init 0
  kstatus, kchan, kdata1, kdata2 midiin
  kchanged changed kstatus, kchan, kdata1, kdata2
  if kchanged < 0.5 then
    kgoto done
  endif
  kprintflag = kprintflag + kchanged
  kprint chnget "enablePrint"
  if kprint > 0.5 then
    printf "N to P in : st=%f ch=%f d1=%f d2=%f\n", kprintflag, kstatus, kchan, kdata1, kdata2
  endif

  knote = int(kdata1 + 0.5)
  if knote < 0 || knote > 127 then
    goto done
  endif

  ; Channel-specific limits from steinmeyer_registers mapping.
  ; Regular ranges:
  ; ch1: notes 0..26, ch2: 0..25, ch3: 0..30, ch4: 0..29, ch8: 0..31
  ; Ruck switch notes (derived from special PC numbers 70..77):
  ; ch1: 36, ch2: 35, ch3: 37, ch8: 38
  kallowed = 0
  if kchan == 1 then
    if knote <= 26 || knote == 36 then
      kallowed = 1
    endif
  elseif kchan == 2 then
    if knote <= 25 || knote == 35 then
      kallowed = 1
    endif
  elseif kchan == 3 then
    if knote <= 30 || knote == 37 then
      kallowed = 1
    endif
  elseif kchan == 4 then
    if knote <= 29 then
      kallowed = 1
    endif
  elseif kchan == 8 then
    if knote <= 31 || knote == 38 then
      kallowed = 1
    endif
  endif

  if kallowed < 0.5 then
    goto done
  endif

  ; Note On (vel>0) -> even program number (ON)
  if kstatus >= 144 && kstatus <= 159 && kdata2 > 0 then
    kprog = knote * 2
    midiout 192, kchan, kprog, 0
    if kprint > 0.5 then
      printf "N to P out: st=192 ch=%f prog=%f d2=0\n", kprintflag, kchan, kprog
    endif
    goto done
  endif

  ; Note Off (status 128..143, or Note On with vel=0) -> odd program number (OFF)
  if (kstatus >= 128 && kstatus <= 143) || ((kstatus >= 144 && kstatus <= 159) && kdata2 == 0) then
    kprog = (knote * 2) + 1
    midiout 192, kchan, kprog, 0
    if kprint > 0.5 then
      printf "N to P out: st=192 ch=%f prog=%f d2=0\n", kprintflag, kchan, kprog
    endif
  endif

  done:
endin

instr 99
; dummy
endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
