;~@sa1
;This block will be solid if mario isn't in a pipe, if he is, will let him go
;through this block (mainly use as parts of a pipe that never changes his
;direction).
;behaves $130

incsrc "SSPDef/Defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

	
!flip_gravity		= $91DBEE
!GTAddr 		= $18C7		; Timer for switch gravity

TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\be a solid block if mario isn't pipe status.
	AND.b #%00001111		;|
	BEQ return			;/
	LDY #$00	;\become passable
	LDA #$25	;|
	STA $1693|!addr	;/
	
SwitchGravity:
	LDA !GTAddr		;load timer address
	BNE return		;if equal zero, we can switch gravity, start timer.
	JSL !flip_gravity

ChangeDirection:
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 5)
	AND.b #%11110111		;|>Force low nibble clear
	EOR.b #%00000010		;|>Force low nibble set
	STA !Freeram_SSP_PipeDir	;/

return:
	RTL
if !Setting_SSP_Description != 0
print "A part of the pipe that is passable when in pipe mode."
endif