;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Decrement Gravity timer (to no switch gravity every frame)
; 
; use GTAddr to check in reverse_gravity.asm patch if it is 0 to switch gravity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!reversed		= $30

!GTAddr 		= $18C7	; Timer for switch gravity

init:
	LDA #$00		;load zero
	STA !GTAddr		;store zero



main:
	.timer_compare:
		LDA !GTAddr		;load timer address
		BEQ .return		;if equal zero, don't decrement.

	.timer_decrement:
		LDA !GTAddr		;load timer address
		SEC			;set carry
		SBC #$01		;subtract value
		STA !GTAddr		;store result back.
		
	.return:
		RTL