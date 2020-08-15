db $42

JMP Main : JMP Main : JMP Main : JMP Return : JMP Return : JMP Return : JMP Return : JMP Main : JMP Main : JMP Main

Main:
	LDA #$01
	STA $13F9
	LDY #$00
	LDA #$06
	STA $1693
Return:
        RTL

print "A vine that can be climbed on from behind."