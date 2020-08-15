arch spc700-raw

org $000000
incsrc "asm/main.asm"
base $1C90

org $008000


	mov	a, !SpeedUpBackUp	
	mov	$0387, a		

	mov	a, #$00
	mov	!PauseMusic, a
	ret
