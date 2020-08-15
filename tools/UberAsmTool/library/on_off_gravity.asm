;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; On-Off Gravity
;
; Sets the on-off switch to modify gravity.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!flip_gravity		= $90ADCD
!reversed		= $30

main:	LDA $14AF|!addr
		CMP !reversed
		BEQ .return
		
		JSL !flip_gravity
		LDA $7D
		EOR #$FF
		INC
		STA $7D
		
.return	RTL