<Cabbage>
form caption("Sine midi test") size(600, 500), colour(30, 35, 40), guiMode("queue"), pluginId("sim1")
csoundoutput bounds(0, 0, 600, 500)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -Q0 -m0d -+raw_controller_mode=1

</CsOptions>
<CsInstruments>

  sr = 48000
  ksmps = 64
  nchnls = 2
  0dbfs = 1


instr 1
  inum notnum
  icps = cpsmidinn(inum)
  iamp = ampdbfs(-6)
  a1 oscili iamp, icps
  outs a1, a1
endin

instr 2
  kstatus, kchan, kdata1, kdata2 midiin
  printk2 kstatus,10
  printk2 kchan, 15
  printk2, kdata1, 20
endin
;***************************************************

</CsInstruments>
<CsScore>
i2 0 84600
</CsScore>
</CsoundSynthesizer>
