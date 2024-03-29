;Act as $130
;This itself does not changes the player direction, but merely changes
;the planned direction when Mario hits a turn special.

incsrc "SSPDef/Defines.asm"

db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; when using db $37

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:

	LDA !Freeram_SSP_PipeDir		;\If outside a pipe, return.
	AND.b #%00001111			;|
	BEQ Return				;/
	
	LDY #$00				;\Render pipe passable
	LDA #$25				;|
	STA $1693|!addr				;/
	
	JSR DistanceFromTurnCornerCheck
	BCC Return
	
	LDA !Freeram_SSP_PipeDir		;\Set planned direction to down.
	AND.b #%00001111			;|
	ORA.b #%00110000			;|
	STA !Freeram_SSP_PipeDir		;/

WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
Return:
	RTL
	DistanceFromTurnCornerCheck:
	;Prevents such glitches where as the player leaves a special turn corner
	;and activates a special direction block while touching the previous corner
	;would cause the player to travel in the wrong direction.
	;
	;$00-$03 holds the position "point" on Mario/yoshi's feet:
	;$00-$01 is the X position in units of block
	;$02-$03 is Y position in units of block
	;
	;AND #$FFF0 rounds DOWN to the nearest #$0010 value
	;Carry is set if the player's position point is inside the block and clear if outside.
	
	LDA $187A|!addr		;\Yoshi Y positioning
	ASL			;|
	TAX			;/
	
	REP #$20
	LDA $94				;\Get X position
	CLC				;|
	ADC #$0008			;|
	AND #$FFF0			;|
	STA $00				;/
	LDA $96				;\Get Y position
	CLC				;|
	ADC FootDistanceYpos,x		;|
	AND #$FFF0			;|
	STA $02				;/
	
	LDA $9A				;\if X position point is within this block
	AND #$FFF0			;|
	CMP $00				;|
	BNE +				;/
	LDA $98				;\if Y position point is within this block
	AND #$FFF0			;|
	CMP $02				;|
	BNE +				;/
	SEC
	SEP #$20
	RTS
	+
	CLC
	SEP #$20
	RTS
	FootDistanceYpos:
	dw $0018, $0028, $0028
if !Setting_SSP_Description != 0
print "Directs the next upcoming special turn downwards."
endif