;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gravity Switch
;
; Switches gravity when the player hits the block.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV
JMP SpriteH : JMP MarioCape : JMP MarioFireball : JMP TopCorner
JMP BodyInside : JMP HeadInside : JMP WallFeet : JMP WallBody

!flip_gravity		= $90ADCD
!reversed		= $30
!gravity_block_flag	= $20

!GravitySound 		= $25
!APUPort 		= $1DF9|!addr


MarioBelow:
	LDA !reversed
	BNE .normal
	JMP MarioBelowReversed
.normal
	JMP MarioBelowNormal

MarioAbove:
	LDA !reversed
	BNE .normal
	JMP MarioAboveReversed
.normal
	JMP MarioAboveNormal


MarioBelowNormal:
MarioAboveReversed:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
	LDA !gravity_block_flag
	BNE .off
	LDA #$01
	STA !gravity_block_flag
	BRA .check_for_gravity

.off	
	STZ !gravity_block_flag

.check_for_gravity
	LDA !gravity_block_flag
	CMP !reversed
	BNE Return

	LDA #!GravitySound
	STA !APUPort
	JSL !flip_gravity
	LDA $7D
	EOR #$FF
	INC
	STA $7D
	BRA Return

MarioBelowReversed:
MarioAboveNormal:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
Return:
	RTL