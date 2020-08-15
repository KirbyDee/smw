;==================================================================================================
; Next Map16 Key Block
;
;  Changes into the next Map16 number when touched from the side while carrying a configurable carriable sprite.
;
;  Author: Ersanio
;  Updated by Maarfy and Major Flare
;
; v1.3
;==================================================================================================

!destroy_sprite		= 1				; 0 = Trigger sprite is not destroyed on block change
									; 1 = Trigger sprite is destroyed on block change

!trigger_sprite		= $80			;   Sprite number that triggers block change ($80 = Key)
!unlock_SFX			= $10			; \ 
!unlock_BNK			= $1DF9|!addr	; / Sound effect that plays on block change

;==================================================================================================

db $42		; or db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
; JMP WallFeet : JMP WallBody ; when using db $37

MarioSide:

if !sa1
	LDX #$15
else
	LDX #$0B
endif

	-
	LDA !9E,x				; \ 
	CMP #!trigger_sprite	; | Skip if incorrect sprite is carried
	BNE +					; /
	LDA !14C8,x				; \
	CMP #$0B				; | Skip if sprite is not in "carried" state
	BNE +					; /
	BRA .Change				; 

	+
	DEX						; \ 
	BPL -					; / Check next sprite if any are unchecked
	RTL						;   End if all sprites have been checked

	.Change

if !destroy_sprite
	LDA #$00				; \ 
	STA !14C8,x				; / Erase carried sprite if set
endif

	REP #$10				;   16-bit XY
	LDX $03					; \ 
	INX						; / Load next Map16 number
	%change_map16()			;   Change the block
	SEP #$10				;   8-bit XY
	%create_smoke()			;   Create smoke puff at block's location

if !unlock_SFX
	LDA #!unlock_SFX		; \ 
	STA !unlock_BNK			; / Play sound if set
endif

MarioBelow:
MarioAbove:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
MarioCorner:
MarioBody:
MarioHead:
;WallFeet:
;WallBody:

	RTL						; Return


print "This block changes into the next Map16 number when touched from the side while carrying a configurable sprite."

