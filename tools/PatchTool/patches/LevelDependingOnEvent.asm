;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level Depending On Event v0.8
;made by Deflaktor
;
;bug reports and questions go to deflaktor@oleco.net
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

header
lorom

;--------------------------
;---------defines----------
;--------------------------

!FreeSpace = $10EDD0	;if already used, relocate

; You can change the table at the end of this file

;--------------------------
;---------replaces---------
;--------------------------

org $05DCDD		;hijack level loading routine
JSL Main
NOP
;LDA $13BF		\ replaced opcodes
;CMP #$25		/

;--------------------------
;----overworld routines----
;--------------------------

org !FreeSpace		;the SNES adress the code will be inserted to
!CodeSize = CodeEnd-CodeStart
db "STAR"
dw !CodeSize-$01
dw !CodeSize-$01^$FFFF

CodeStart:
Main:	PHY
	PHX
	PHP
	LDA $13BF	; load the level number
	PHA
	LDA $141D	; load the "Disable Mario Start! Flag"
	BEQ GoOn	; if the flag is 1 (because it is only 0 while loading the overworld level)
	PLA
	BRA Ret2	; return
GoOn:	;LDA #$01
	;STA $141D	; Disable Mario Start and a second execution of this code inside the level
	PLA
	REP #$30	; let A,X and Y go 16 bit, since we deal with large numbers > FF
	JSR LevelToRoom	; convert the level number to a room number
	LDX #$0000	; load zero to X (the index for the table)

Loop:	PHA
	LDA Table,x	
	TAY
	PLA
	CPY #$FFFF	; end of table reached?
	BEQ Return	; return
	CMP Table,x
	BEQ Event	; we found an entry, check event
	INX #5		; increase index by 5
	BRA Loop	; loop

Event:	PHX		; we still need our table index later on
	INX #4		; increase X by 4 to get the event number
	AND #$00FF	; mask high byte of A
	SEP #$20	; let A go back to 8 bit
	LDA Table,x	; load event number
	; calculate the modulo:
	PHA		; \ save A, we need it later
	LSR #3		;  | divide it by 8
	TAY		; store it to Y, we need it later
	ASL #3		;  | multiply it by 8
	STA $04		;  | save it to scratch ram
	PLA		;  | get A back
	SBC $04		;  | subtract A with $04
	INC		; / increase A because SBC subtracts an additional 1 because of carry
	TAX
	LDA EvConv,x	; get the event flag bit
	PLX		; get the old X back (index of our table)
	AND $1F02,y	; and it with the event flag byte
	REP #$20	; let A go 16 bit
	AND #$00FF
	BNE SetLvl	; if the bit is set, set the new level number

	; else load the level number and jump back to the loop
	SEP #$20	; let A go back to 8 bit
	LDA $13BF	; load the level number
	JSR LevelToRoom ; convert the level number to a room number
	INX #5		; increase X by 5 to get the next row of the table
	BRA Loop

	; now that we know the event is set, change the level number

SetLvl: INX #2		; increase index X by 2 to get the new level number
	LDA Table,x
Return:	JSR RoomToLevel	; convert the room number to the level number
	SEP #$20	; let A go back to 8 bit

Ret2:	PLP
	PLX
	PLY
	CMP #$25	; replaced opcode
	RTL

; Subroutine that converts overworld level numbers to room numbers
LevelToRoom: 	REP #$20	; let A go 16 bit, since we deal with large numbers > FF
		AND #$00FF	; mask the high byte
		CMP #$0025
		BCC ReturnLR	; if level number is greater than #$025
		CLC
		ADC #$00DC	; subtract #$0DC from it
ReturnLR:	RTS

; Subroutine that converts room numbers to overworld level numbers
RoomToLevel: 	CMP #$0025
		BCC ReturnRL	; if level number is greater than #$025
		SEC
		SBC #$00DC	; add #$0DC to it
ReturnRL:	RTS

EvConv: db #$80,#$40,#$20,#$10,#$08,#$04,#$02,#$01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	edit this table: use only levels 000-024 and 101-13B
;	DO NOT MIX THE HIGH BIT OF THE LEVELS (0XX and 1XX)
;		e.g.	024 -> 105   WRONG
;			127 -> 005   WRONG
;			020 -> 023   RIGHT
;			107 -> 130   RIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Table:
dw #$024, #$105 : db #$06	;level 024 becomes level 105 after event 6 is passed
dw #$101, #$014 : db #$04	;level 101 becomes level 014 after event 4 is passed
dw #$FFFF			;table end (necessary)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CodeEnd:
