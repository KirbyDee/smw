;~@sa1
;This is the bottom cap of a vertical two-way pipe that is only
;enterable as small mario (note that yoshi always not allowed).
;behaves $130

db $42

incsrc "SSPDef/Defines.asm"

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
	LDA !reversed
	BNE .normal
	JMP MarioBelowTop
.normal
	JMP MarioBelowBottom

MarioAbove:
	LDA !reversed
	BNE .normal
	JMP MarioAboveTop
.normal
	JMP MarioAboveBottom

MarioSide:
	LDA !reversed
	BNE .normal
	JMP MarioSideTop
.normal
	JMP MarioSideBottom

TopCorner:
	LDA !reversed
	BNE .normal
	JMP TopCornerTop
.normal
	JMP TopCornerBottom

BodyInside:
	LDA !reversed
	BNE .normal
	JMP BodyInsideTop
.normal
	JMP BodyInsideBottom

HeadInside:
	LDA !reversed
	BNE .normal
	JMP HeadInsideTop
.normal
	JMP HeadInsideBottom

incsrc "bottom_vertical_pipe_cap_small.asm"
incsrc "top_vertical_pipe_cap_small.asm"

return:
	RTL

center_horiz:
	REP #$20		;\center player to pipe horizontally.
	LDA $9A			;|
	AND #$FFF0		;|
	STA $94			;|
	SEP #$20		;/
	RTS

passable:
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
	RTS