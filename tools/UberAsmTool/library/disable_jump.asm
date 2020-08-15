main:
	LDA #$C0
	TSB $0DAA ; disable jump

	LDA #$80
	TSB $0DAC ; disable spin jump

	LDA #$80
	TRB $15 ; disable 'b' button
RTL