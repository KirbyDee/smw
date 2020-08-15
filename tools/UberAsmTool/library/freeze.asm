; from https://www.smwcentral.net/?p=viewthread&t=84416&page=27




main:
LDA $18
AND #$10
BEQ notR
EOR $5C
STA $5C
notR:
LDA $5C
BEQ .skip
LDX #$0C
.loop:
STZ $AA,x
STZ $B6,x
;STZ $1588,x
TXA
BEQ .skip
DEX
BRA .loop
.skip:
RTL