; How many lives to start with
ORG $009E25
	db $63

; disable lives loss
ORG $00D0D8
	NOP #3

; don't show lives on overworld
ORG $00A15A
	BRA $02
ORG $04A530
	db $FE

; disable gaining live through coins
ORG $008F2F
	NOP #3