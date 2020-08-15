@asar

header
lorom

!UnusedRAMonOW = $1686 ; 1 byte, $1FFF or lower, untouched on overworld. This one is some random sprite table, it shouldn't need to be changed.

org $049A5A
SEP #$20
autoclean JML GrabVariables

org $049A83
RTL

org $04DB57
autoclean JML UseVariables

org $04DB18
JSR $945D
autoclean JSL DoWalk
NOP



freecode
DiffY12:
dw -12, 12, 0, 0
DiffX12:
dw 0, 0, -12, 12

DiffY16:
dw -16, 16, 0, 0
DiffX16:
dw 0, 0, -16, 16


GrabVariables:
LDA $02
LSR A
STA !UnusedRAMonOW

JML $049A90
pushpc
org $049A90

;we can fit a two byte instruction we want here
pullpc


UseVariables_WrongFadeDir:
JML $04DB5F

UseVariables:
STX $1B8C
BEQ .WrongFadeDir
SEP #$20
LDA !UnusedRAMonOW
AND #$3F
ASL A
STA $02
ASL A
ADC !UnusedRAMonOW ; C is known clear since we ASLed something with high bits ANDed off
TAY 
LDX $0DD6
REP #$20
LDA $99AA,y
STA $1F19,x
JSL $049A60

TXY
LDX $0DD3
LDA $1F17,y
CLC
ADC.l DiffX16,x
STA $0DC7,y
LDA $1F19,y
CLC
ADC.l DiffY16,x
STA $0DC9,y

PHY
PHX

PHK
PEA.w .jslrtsreturn-1
PEA.w $048575-1
JML $049A93
.jslrtsreturn
REP #$20

LDA $123456

PLX
PLY

LDA $1F11,y
AND #$00FF
BNE .NoCamMove
LDA $1A
CLC
ADC.l DiffX12,x
STA $1A
STA $1E
LDA $1C
CLC
ADC.l DiffY12,x
STA $1C
STA $20
.NoCamMove


JML $04DB5F



DoWalk:
REP #$20
LDX $1B8C
LDA $1B8D
RTL