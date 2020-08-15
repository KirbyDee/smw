;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gravity Down
;
; Forces downward gravity when the player is inside.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db $42

JMP Main : JMP Main : JMP Main : JMP Return : JMP Return : JMP Return : JMP Return : JMP Main : JMP Main : JMP Main

!flip_gravity		= $91DBEE

Main:		
		JSL !flip_gravity

Return:		RTL