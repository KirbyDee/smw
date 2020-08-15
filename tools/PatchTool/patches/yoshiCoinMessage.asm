!RAM_Bank = $1DF9|!Base2	;Which bank to use for sound effect?
!Value_Sound = $1C		;Which sound to use for sound effect?
!Value_Message = $03		;Which message to use? $01 -> Level Message 1; $02 -> Level Message 2; $03 - Yoshi Thanks Message

lorom

;Do not edit
if read1($00FFD5) == $23
	!SA1 = 1
	sa1rom
else
	!SA1 = 0
endif

;This either
if !SA1
	; SA-1 base addresses
	!Base1 = $3000
	!Base2 = $6000
	!FastMirror = $000000
else
	; Non SA-1 base addresses
	!Base1 = $0000
	!Base2 = $0000
	!FastMirror = $800000
endif

reset bytes

org $00F358|!FastMirror		;Sound effect part of Yoshi Coin collection subroutine
autoclean	JSL RAMCheck	;Replace with JSL RAMCheck
NOP #1				;Clear out 1 byte to prevent crashing

freedata	;Freespace

RAMCheck:
LDA #!Value_Sound		;Play sound effect
STA !RAM_Bank

LDA $1F2B|!Base2		;Load flag
BEQ Show			;If 00, show message
RTL

Show:
LDA #!Value_Message		;Load message number
STA $1426|!Base2
INC $1F2B|!Base2		;Set the "collected one yoshi coin" flag
RTL

print "Inserted ",bytes," bytes at $",pc