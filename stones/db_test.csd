<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
ksmps=32
nchnls=1
0dbfs=1
instr 1
  kamp = 0.1
  k1 = ampdbfs(kamp)
  k2 = dbfsamp(kamp)
  k3 = dbamp(kamp)
  k4 = ampdb(kamp)
  printk2 k1
  printk2 k2
  printk2 k3
  printk2 k4
  turnoff
endin
</CsInstruments>
<CsScore>
i1 0 0.1
</CsScore>
</CsoundSynthesizer>
