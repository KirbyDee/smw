db $42

JMP Return : JMP Return : JMP Return
JMP Return : JMP Return
JMP Return : JMP Return
JMP Return : JMP MarioInside : JMP Return

; Teleport settings
!FixTeleport = !True		; Set to !False so the door uses Mario's position
!FixedDestination = !False	; Set to !True so the destination is set by the door, not the current screen
!TeleDest = $0105			; What level to teleport to
!TeleSecond = !False		; Activates secondary exits
!TeleMidwayWater = !False	; Teleports to the midway point (non-secondary) / transforms the level into a water level (secondary)

; Switch settings
!Switch = $14AD|!addr		; Values include but are not limited to:
							; $14AD (blue P-switch), $14AE (silver P-switch), $14AF (on/off switch)
!Inverted = !False			; Set to true to make doors only enterable if the switch is off

; Door settings
!TopPart = !True			; Only let Mario pass if he's small
!BossDoor = !False			; Doesn't check if Mario is really inside similar to boss doors.

; Don't change these!
!True = 1
!False = 0

!Reversed #= xor(equal(!Switch, $14AF|!addr), !Inverted)

MarioInside:
	LDA !Switch		;   If the corresponding switch (of whatever is checked)...
	if !Reversed
		BNE Return	;   ...is active, return
	else
		BEQ Return	;   ...is not active, return
	endif
	LDA $16			;\  Only enter the door if you press up.
	AND #$08		; |
	BEQ Return		;/ 
	LDA $8F			;\  Surprise: It's a backup of $72
	BNE Return		;/
if !TopPart
	LDA $19			;   If it's the top door part
	BNE Return		;   don't enter if big.
endif
if not(!BossDoor)
	%door_approximity()
	BCS Return		;   Check if Mario is centered enough
endif

	LDA #$0F		;\  Enter door SFX
	STA $1DFC|!addr	;/

if !FixedDestination
	LDX $95			;   The teleport destination and settings are fixed.
	REP #$20
	LDA.w #(((!TeleDest&$1E00)<<3)|(!TeleSecond<<9)|(!TeleMidwayWater<<11)|(!TeleDest&$1FF)|$400)
	LDX #$FF
else
	if !FixTeleport
		LDX #$01
	else
		LDX #$00
	endif
endif
	%teleport_direct()
Return:
RTL

if !Reversed
	print "The top part of door which you can only enter if a specific switch isn't active."
else
	print "The top part of door which you can only enter if a specific switch isn't active."
endif
