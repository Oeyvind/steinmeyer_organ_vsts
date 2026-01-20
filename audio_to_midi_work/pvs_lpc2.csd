<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>



sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

gifw ftgen 0, 0, 1024, 20, 2, 1             ; Hanning window

; epoch filtering udo
	opcode EpochCps, k,a
	a1              xin 
	                setksmps 8
	a20		butterbp a1, 20, 5
	a20		dcblock2 a20*40
	aepochSig	butlp a20, 200
	kepochSig	downsamp aepochSig
	kepochRms	rms aepochSig

; count epoch zero crossings
	ktime		times	
	kZC		trigger kepochSig, 0, 0		; zero cross
	kprevZCtim	init 0
	kinterval1	init 0
	kinterval2	init 0
	kinterval3	init 0
	kinterval4	init 0
	if kZC > 0 then
	kZCtim	 	= ktime				; get time between zero crossings
	kinterval4	= kinterval3
	kinterval3	= kinterval2
	kinterval2	= kinterval1
	kinterval1	= kZCtim-kprevZCtim
	kprevZCtim	= kZCtim
	endif
	kmax		max kinterval1, kinterval2, kinterval3, kinterval4
	kmin		min kinterval1, kinterval2, kinterval3, kinterval4
	kZCmedi		= (kinterval1+kinterval2+kinterval3+kinterval4-kmax-kmin)/2
	kepochZCcps	divz 1, kZCmedi, 1
	kepochZCcps     mediank kepochZCcps, 40, 40
	                xout kepochZCcps
	endop

instr 1

a1 diskin "fox.wav", 1, 0, 1            ; then the fox
isize = 1024
kcps, k_ ptrack a1, 512

	kcps    	EpochCps a1     ; pitch analysis by epoch filtering and zero cross count
  kcps limit kcps, 10, 2000
  kcps_semi = int(12 * log2(kcps / 440) + 69)
  kcps = cpsmidinn(kcps_semi)

fharm pvsosc 0.8, kcps, 3, isize, isize/8
iorder  =   p4
fenv    pvslpc  a1, isize, isize/8, iorder, gifw
itab ftgen 0, 0, isize, 7, 1, isize, 1
fenv_mask pvstencil fenv, 0, ampdbfs(-12), itab
fsig    pvsfilter fharm, fenv_mask, 1           
a3      pvsynth fsig              
a3      dcblock a3*40
outs    a3*.1, a3*.1
endin

</CsInstruments>
<CsScore>
i1  2  10  30
i1  13 10  150
e
</CsScore>
</CsoundSynthesizer>