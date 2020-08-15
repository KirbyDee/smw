;~@sa1
;This is the top cap of a vertical two-way pipe that is only
;enterable as small mario (note that yoshi isn't allowed).
;behaves $130

MarioAboveTop:			;>mario above only so he cannot enter edge and warp all the way to middle.
	LDA !Freeram_SSP_PipeDir	;\if not in pipe
	AND.b #%00001111		;|then enter
	BEQ enterTop			;/
	CMP #$01		;\exit if going up
	BEQ exitTop		;|
	CMP #$05		;|
	BEQ exitTop		;/
	BRA within_pipe_top	;>other directions = pass
enterTop:
	LDA $187A|!addr		;>no yoshi.
	ORA $19			;>no powerup
	BNE returnTop		;>otherwise return
	if !Setting_SSP_CarryAllowed == 0
		LDA $1470|!addr		;\no carrying item
		ORA $148F|!addr		;|
		BNE returnTop		;/
	endif
	LDA $15			;\must press down
	AND #$04		;|
	BEQ returnTop		;/
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ .NotCarry			;/
		LDA #$01			;\set flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
.NotCarry
	LDA.b #!SSP_PipeTimer_Enter_Downwards_SmallPipe	;\set timer
	STA !Freeram_SSP_PipeTmr			;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 7)
	AND.b #%11110000		;|>Force low nibble clear
	ORA.b #%00000111		;|>Force low nibble set
	STA !Freeram_SSP_PipeDir	;/
	LDA #$01		;\set flag to "entering"
	STA !Freeram_SSP_EntrExtFlg		;/
	JSR center_horiz	;>center the player to pipe
within_pipe_top:
	JSR passable
returnTop:
	RTL
TopCornerTop:
MarioSideTop:
HeadInsideTop:
BodyInsideTop:
MarioBelowTop:
	LDA !Freeram_SSP_PipeDir	;\return for other offsets
	AND.b #%00001111		;|when not in pipe
	BEQ returnTop			;/
	CMP #$01			;\exit if going up
	BEQ exitTop			;|
	CMP #$05			;|
	BEQ exitTop			;/
	BRA within_pipe_top
exitTop:
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02
	BEQ within_pipe_top	;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_horiz	;>center the player horizontally
	JSR passable		;>be passable while exiting
	LDA.b #!SSP_PipeTimer_Exit_Upwards_OffYoshi	;\Set timer.
	STA !Freeram_SSP_PipeTmr			;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	REP #$20		;\center vertically (for small/yoshi)
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	STA $96			;|
	SEP #$20		;/
	RTL
if !Setting_SSP_Description != 0
print "Top cap of 2-way pipe for small mario."
endif