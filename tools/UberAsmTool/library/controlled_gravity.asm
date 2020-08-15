;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Controlled Gravity
;
; Press a button from the controller to modify gravity.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _____________________________  ;
; /								\ ;
;|		CONTROLLED GRAVITY		 |;
;|								 |;
;|    Press a button from the	 |;
;| controller to modify gravity. |;
; \_____________________________/ ;
;								  ;

!flip_gravity		= $90ADCD
!FreeRAM			= $30

;>  RAM containing the set of buttons you want to check. (Should be $16 or $18) 

!ControlRAM	= $18

;>  Replace with a 1 for the button you want to switch gravity.
; ¬ Do note that "y" means Y and X.
;>  For $16: byetUDLR
;>  For $18: axlr----
!Button	 = #%10000000

;>  b = B only; y = X or Y; e = select; t = Start; U = up; D = down; L = left, R = right
;>  a = A; x = X; l = L; r = R, - = unused

main:	LDA !ControlRAM
		AND !Button
		;STA !FreeRAM
		BEQ .return
		
		JSL !flip_gravity
		LDA $7D
		EOR #$FF
		INC
		STA $7D
		
.return	RTL