;Reprogrammed Vertical Scrolling by Blind Devil (revision 2019-04-15)
;This patch rewrites SMW's vertical scrolling code to make it move smoother, also allowing
;the player to move the camera up or down when looking up or ducking if this behavior is set.

;Configurable defines:

;FREE VERTICAL SCROLL
;This determines if the player should land on something in order for the camera to move.
;If you enable !LookUpDown, you can set this on for best results.
;Possible values: 0 = disabled, 1 = enabled.
	!FreeVerticalScroll = 0

;LOOK UP/DOWN
;This determines if the screen should scroll when the player looks up or ducks while
;standing still.
;Possible values: 0 = disabled, 1 = enabled.
	!LookUpDown = 0

;LOOK UP/DOWN CAMERA MAX SPEEDS
;Max speeds the camera can have when looking up/down.
;Values that are higher than the camera max speed itself are ignored, and these are
;used instead.
;Default max speeds are $0005 and $FFF6, respectively.
	!MaxMoveDn = $0002
	!MaxMoveUp = $FFFE

;SCREEN SPLITTING AREA
;At which height relative to the screen should the player be to make the screen scroll
;up (if player's Y-pos is lower than it) or down (if player's Y-pos is higher than it).
;If !LookUpDown is zero, you should only worry about the second define.
;First define is for when looking up.
;Second one is normal.
;Third one is looking down.
;Recommended values range from $0000-$00E0.
	!YScrnSplitU = $00AC
	!YScrnSplitN = $006C
	!YScrnSplitD = $000C

;Below are default defines. Don't modify.

!addr	= $0000			; $0000 if LoROM, $6000 if SA-1 ROM.
!bank	= $800000		; $80:0000 if LoROM, $00:0000 if SA-1 ROM.

if read1($00FFD5) == $23
	!addr	= $6000
	!bank	= $000000
	sa1rom
endif

;Code starts below.

org $00F7FC				;hijack location
autoclean JML VertScrollReprogramming	;jump to custom code
padbyte $EA : pad $00F8AA+1		;fill original code area with NOPs (171 bytes cleared total)
warnpc $00F8AB				;warn if this byte is overwritten

freecode

VertScrollReprogramming:
PHB			;preserve data bank
PHK			;push program bank into stack
PLB			;pull program bank as new data bank because we need to read tables from the same bank as the code.

LDA #!YScrnSplitN	;load default value for screen splitting area

if !LookUpDown
LDX #$00		;load value into X
STX $0C			;store to scratch RAM.

LDX $71			;load player animation pointer into X
BNE +			;if not equal zero, skip ahead.
LDX $72			;load player is in the air flag into X
BNE +			;if flag is set, skip ahead.
LDX $7B			;load player's X speed into X
BNE +			;if not equal zero, skip ahead.
PHA			;preserve A
LDA $15			;load controller flags 1 (and first frame only as high byte which is irrelevant but I feel like commenting that)
AND #$0008		;preserve up button bit
TAX			;transfer to X
PLA			;restore A
CPX #$00		;compare X to value
BEQ +			;if up button was not pressed, skip ahead.

LDX #$01		;load value into X
STX $0C			;store to scratch RAM.

LDA #!YScrnSplitU	;load new value for screen splitting area
BRA ++			;branch to store it

+
LDX $1471|!addr		;load player is standing on a platform flag into X
BNE +			;if flag is set, branch.
LDX $72			;load player is in the air flag into X
BNE ++			;if flag is set, skip ahead.
LDX $75			;load player is in water flag into X
BNE +			;if yes, branch.
LDX $7D			;load player's Y speed into X
CPX #$06		;compare X to value
BMI ++			;if negative relative to it, skip ahead.
+
LDX $7B			;load player's X speed into X
BNE ++			;if not equal zero, skip ahead.
LDX $73			;finally load player is ducking flag
BEQ ++			;if not set, skip ahead.

LDX #$01		;load value into X
STX $0C			;store to scratch RAM.

LDA #!YScrnSplitD	;load new value for screen splitting area
++
endif

STA $0A			;store screen splitting area value to scratch RAM.

LDY #$00		;set scroll direction to default (#$00 would mean scroll upwards, so #$02 means the opposite)

LDA $96			;load player's Y-pos within the level, next frame
SEC			;set carry
SBC $1C			;subtract layer 1 Y-pos, current frame, from it
STA $00			;store to scratch RAM. (now this is some kind of player's Y-pos within the screen, next frame)

CMP $0A			;compare recently calculated result to value
BMI +			;if value is negative relative to it (in case, lower), skip ahead and keep Y intact.

LDY #$02		;load new value for scroll direction
+
STY $55			;store Y to direction of scrolling for Layer 1.
STY $56			;store Y to direction of scrolling for Layer 2.

SEC			;set carry
SBC $0A			;subtract screen splitting area value
CLC			;clear carry
ADC NullDispRelTbl,y	;add value from table (contains relative distance values for camera moving/stopping) according to index
STA $02			;store to scratch RAM. (now this contains some kind of player's Y-pos + camera moving zone index?, next frame)

EOR EorTbl,y		;invert the recently calculated result if Y = #$02, so the camera doesn't move down if player is too high above the screen
BMI +			;branch if value is negative.

LDY #$02		;load new value for max scroll speed table index into Y
STZ $02			;reset scratch RAM. the previous calculation was a lie, I guess (in truth, it means that the screen shouldn't scroll down)

+
LDA $02			;load the calculated weird value from scratch RAM
BMI +			;branch if value is negative.

LDX #$00		;load value into X
STX $1404|!addr		;store it to free vertical scroll flag.
BRA .movescreen		;branch straight to screen moving code.

+
SEP #$20		;8-bit A

LDA $13E3|!addr		;load wallrunning flag
CMP #$06		;compare to value
BCS +			;if player is wallrunning, skip ahead.

LDA $1410|!addr		;load Yoshi has wings flag
LSR			;divide by 2 (gets rid of bit 0, which's not related to Yoshi wings - AND #$02 to preserve only bit 1 would work, but takes one byte more)
ORA $149F|!addr		;OR with player gliding timer
ORA $74			;OR with player is climbing flag
ORA $13F3|!addr		;OR with P-balloon timer
ORA $18C2|!addr		;OR with player is riding Lakitu cloud flag
ORA $1406|!addr		;OR with bouncing from springboard/triangle flag

+
TAX			;transfer A to X
REP #$20		;16-bit A
BNE +++			;if X is non-zero, skip other checks.

LDX $187A|!addr		;load player is on Yoshi flag
BEQ +			;if not riding, skip ahead
LDX $141E|!addr		;load Yoshi has wings flag #2
CPX #$02		;compare X to value
BEQ +++			;if equal, allow screen to move up.

+
LDX $75			;load player is in water flag
BEQ ++			;if not in water, skip ahead.
LDX $72			;load player is in the air flag
BNE +++			;if in the air (as in water, so swimming and not touching the ground), branch.

++
LDX $1412|!addr		;load vertical scroll type flag
DEX			;subtract it by one
BEQ ++++		;if vertical scroll at will, branch.
LDX $13F1|!addr		;load vertical scroll enabled flag
BNE ++++		;if flag is active, branch.

+++
STX $13F1|!addr		;store whatever is in X to vertical scroll enabled flag.

LDX $13F1|!addr		;load vertical scroll enabled flag again
BNE +++++		;if not equal zero, branch.

.Return
PLB			;restore previous data bank
JML $00F8DE|!bank	;jump back to a return in bank 0.

++++
if !FreeVerticalScroll == 0
LDX $1404|!addr		;load vertical scroll condition flag into X
BNE +++++		;if set, allow moving the screen.
LDX $72			;load player is in the air flag into X
BNE .Return		;if in the air, don't allow moving screen.
endif
+++++

.movescreen
LDA $04			;load limit for screen Y-pos (this gets set by SMW)
SEC			;set carry
SBC $1C			;subtract layer 1 Y-pos, current frame, from it
STA $06			;store to scratch RAM. this now holds the distance between the screen and the limit value.

LDA $02			;load weird camera thingy from scratch RAM
BEQ .zeroaccel		;if zero, clear acceleration.
BMI .negativeaccel	;if negative, branch to make negative compares.

LDA $06			;load distance from bottom of last vertical screen
BEQ .zeroaccel		;if zero, clear acceleration.
BMI .zeroaccel		;same if negative.

CMP #$0006		;compare to value
BCC .plushalf		;if equal or lower, branch
CMP #$0008		;compare to value
BCC .plus1		;if equal or lower, branch
CMP #$000A		;compare to value
BCC .plus2		;if equal or lower, branch

LDA $02			;else, load weird camera thingy from scratch RAM
CMP #$0004		;compare to value
BCC .plushalf		;branch if equal or lower
CMP #$0008		;compare to value
BCC .plus1		;branch if equal or lower
CMP #$000A		;compare to value
BCC .plus2		;branch if equal or lower
CMP #$000C		;compare to value
BCC .plus3		;branch if equal or lower
BRA .plus4		;branch always if higher

.negativeaccel
LDA $1C			;load layer 1 Y-pos
BMI .zeroaccel		;if negative, don't accelerate.
BEQ .zeroaccel		;same if equal zero.

CMP #$0004		;compare to value
BCC .minushalf		;if equal or lower, branch
CMP #$0008		;compare to value
BCC .minus1		;if equal or lower, branch
CMP #$000C		;compare to value
BCC .minus2		;if equal or lower, branch

LDA $02			;else, load weird camera thingy from scratch RAM
CMP #$FFFD		;compare to value
BCS .minushalf		;branch if equal or higher
CMP #$FFFA		;compare to value
BCS .minus1		;branch if equal or higher
CMP #$FFF6		;compare to value
BCS .minus2		;branch if equal or higher
BRA .minus3		;branch always if lower

.plushalf
SEP #$20		;8-bit A
LDA $14			;load effective frame counter
AND #$01		;preserve bit 0
TAX			;transfer value to X
REP #$20		;16-bit A
BNE .plus1		;if X is not zero, branch.
.zeroaccel
LDA #$0000		;load value
BRA .storespd		;branch to store speed
.plus1
LDA #$0001		;load value
BRA .storespd		;branch to store speed
.plus2
LDA #$0002		;load value
BRA .storespd		;branch to store speed
.plus3
LDA #$0004		;load value
BRA .storespd		;branch to store speed
.plus4
LDA #$0005		;load value
BRA .storespd		;branch to store speed

.minushalf
SEP #$20		;8-bit A
LDA $14			;load effective frame counter
AND #$01		;preserve bit 0
TAX			;transfer value to X
REP #$20		;16-bit A
BNE .minus1		;if X is not zero, branch.
BRA .zeroaccel		;else, set zero to speed.
.minus1
LDA #$FFFF		;load value
BRA .storespd		;branch to store speed
.minus2
LDA #$FFFE		;load value
BRA .storespd		;branch to store speed
.minus3
LDA #$FFFD		;load value

.storespd
if !LookUpDown
if !MaxMoveUp > $FFFD || !MaxMoveDn < $0005
LDX $0C			;load player is moving camera up/down flag
BEQ +			;if not set, skip ahead.

CPY #$00		;compare Y to value
BEQ .up			;if equal, set low speed for camera going up.

if !MaxMoveDn < $0005
CMP #!MaxMoveDn		;compare speed to value
BCC +			;if equal or lower, simply store it.

LDA #!MaxMoveDn		;else load this value
endif

BRA +			;branch to store it

.up
if !MaxMoveUp > $FFFD
CMP #!MaxMoveUp		;compare speed to value
BCS +			;if equal or higher, simply store it.

LDA #!MaxMoveUp		;else load this value
endif

+
endif
endif

STA $08			;store speed.
TAX			;transfer A to X
STX $1404|!addr		;store to vertical scroll condition flag.

LDA $1C			;load layer 1 Y-pos
CMP $04			;compare with limit value
BCC +			;if lower or equal, skip

LDA $04			;load limit value
STA $1C			;store to layer 1 Y-pos.

+
CLC			;clear carry
ADC $08			;add speed value
BPL +			;only store if value is positive

LDA #$0000		;load value
+
STA $1C			;store result back.

LDX #$00		;load value into X
STX $13F1|!addr		;store to vertical scroll enabled flag.

JMP .Return		;jump to return.

;Some tables below.

NullDispRelTbl:
dw $0004,$FFF4		;controls the camera's "dead zone" - can be modified but it's not really recommended

EorTbl:
dw $0000,$FFFF		;used to invert certain values. don't modify.