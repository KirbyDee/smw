;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gravity Down
;
; Forces downward gravity when the player is inside.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db $42

JMP Main : JMP Main : JMP Main : JMP Return : JMP Return : JMP Return : JMP Return : JMP Main : JMP Main : JMP Main

!flip_gravity		= $90ADCD
!reversed		= $30

Main:		LDA !reversed
		BEQ Return
		JSL !flip_gravity
		LDA $7D
		EOR #$FF
		INC
		STA $7D
Return:		RTL