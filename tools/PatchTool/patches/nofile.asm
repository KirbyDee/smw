;One file, One player
;By Noobish Noobsicle

;This patch removes the options of having multiple save files or multiple players. Instead, if the game has never been saved after
;the installation of this patch, you will be taken to the intro screen upon pressing a button on the title screen. If the game has
;been saved, you will see two options: Continue game (followed by the number of exits gotten) or New game. New game will take you
;to the intro screen, while Continue game will resume the game where you last saved.

;For the love of god, please give credit if you use this patch. I spent almost 23 hours of continuous work on this patch, sometimes
;vibrating so hard from frustration my headphones fell off. (I exceeded my two 'freespaces' by THREE BYTES EACH!!!)

;Oh, and this patch requires no freespace. It uses the unused area that the file select screen used.

;==============================
;=========-DEFINES-============
;==============================
if read1($00FFD5) == $23
	sa1rom
	!Base2 = $6000
	!sram = $000000
else
	lorom
	!Base2 = $0000
	!sram = $2E4000
endif
!FreeSRAM = $41C7FF+!sram
!NumOfExitsComplete = $60
!NumOfExitsProperties = $38
!CompleteExitsTileOne = $88
!CompleteExitsTileTwo = $87
;==============================

header

org $009BC9		;hijack save game routine
PHP
REP #$10
SEP #$20
LDX #$008C
loopstart:
LDA $1F49|!Base2,x
STA $41C000+!sram,x
DEX
BPL loopstart
LDA #$27
STA !FreeSRAM
PLP
RTL

org $009CB8		;we incriment our own game modes, thank you very much
JSR $9D38		;
RTS

org $009CEF		;hijack stuff that runs when file is selected
STZ $0DB2|!Base2
TXA
BNE imlaxy
STZ $0109|!Base2	;don't show intro level
REP #$10
;BRA $1E		;load data
LDX #$008C
.loopstart
LDA $41C000+!sram,x
STA $1F49|!Base2,x
DEX
BPL .loopstart
imlaxy:
SEP #$30
RTS

org $009D38		;used as freespace
LDA !FreeSRAM
CMP #$27
BEQ Path		;branch if file has progress
LDX #$00
STX $0DB2|!Base2
JMP $9E10
BRA Cliff
Path:
LDA #$12
STA $12
Cliff:
LDA $0100|!Base2
CLC
ADC #$03
STA $0100|!Base2
LDA $7F837B
TAX
REP #$20
LDA #$1852
STA $7F837D,x
INX
INX
LDA #$0300
STA $7F837D,x
INX
INX
STX $00
SEP #$20
LDA $41C08C+!sram
SEP #$10
CMP #!NumOfExitsComplete
BCC .notfull
LDA #!CompleteExitsTileOne
LDY #!CompleteExitsTileTwo
BRA .doitright
.notfull
JSR $9045
TXY
LDX $00
CPY #$00
BNE .doitright
LDY #$FC
.doitright
PHY
TAY
PLA
STA $7F837D,x
INX
LDA #!NumOfExitsProperties
STA $7F837D,x
STA $7F837F,x
INX
TYA
STA $7F837D,x
INX
INX
LDA #$FF
STA $7F837D,x
TXA
STA $7F837B
RTS

org $009DFA		;you can't press X/Y to go back to the file select
BRA $0C

org $009E0D		;hijack stuff that runs when player (continuity) is selected
JSR $9CEF

org $05B872
db $52,$4A,$00,$0F,$79,$30,$73,$31,$81,$30,$FC,$00,$75		;stripe image data to replace 1 player game\n2 player game
db $31,$71,$31,$76,$31,$73,$31,$52,$0A,$00,$19,$2D,$11
db $83,$10,$79,$10,$2F,$11,$82,$10,$79,$10,$7B,$10,$73
db $31,$FC,$00,$75,$31,$71,$31,$76,$31,$73,$31,$FF