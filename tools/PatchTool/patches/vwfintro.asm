;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; VWF Level Intros, by imamelia
;
; This patch will make VWF text show up instead of "Mario Start!" in your levels,
; similar to how Yoshi's Island does it.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

lorom

!InitXPosition = $40				; starting X position of the text
!InitYPosition = $50				; starting Y position of the text
!FramesToWait1 = $03				; how many frames to wait between characters
!FramesToWait2 = $30				; how many frames to wait after the text finishes appearing until the level loads
!SpaceWidth = $07					; how many pixels wide a space will be
!SpaceWidth2 = $0E				; how many pixels wide a double space will be
!RAM_VWFTextTimer = $7FA00D		; RAM address that indicates the number of frames left
!RAM_VWFCharsToDraw = $7FA00E	; RAM address that indicates how many characters will be drawn
!RAM_VWFStateFlags = $7FA00F		; RAM address that indicates that the message is complete or disabled entirely (bit 0 - complete, bit 1 - disabled, bit 2 - no-Yoshi intro)

org $0082B0				; end of NMI
autoclean JML fblankfix			; modify the brightness restore
NOP #2

org $0096A1
BRA $05 : NOP #5

org $0091B4					; part of game mode 10
autoclean JML IntroTilemapInitRt	; Mario Start!, Luigi Start!

org $0096E0			; part of game mode 11
JML IntroTilemapMainRt	; Mario Start!, Luigi Start!
NOP				;

org $00A7C2			; part of the NMI routine
JML TileUploadRt		; modify the routine that uploads the Mario Start! tiles to VRAM

org $009F42			; part of game modes 0F and 13
JML ResetTextTimer		; clear all relevant RAM addresses except the No-Yoshi intro flag

org $0096B4			; part of game mode 03
JML ResetTextTimer2	; clear all relevant RAM addresses

org $00A08A			; part of the overworld load
JML ResetTextTimer3	; clear all relevant RAM addresses

org $05DA91			; part of the No-Yoshi intro code
JML NoYoshiIntroDisable	;

freecode
prot CharWidth
;$05DA50
;------------------------------------------------
; level mode before the characters show up
;------------------------------------------------

IntroTilemapInitRt:
	LDA !RAM_VWFStateFlags	;
	AND #$FD				;
	STA $08					;
	JSR GetOWLevelNumber		;
	PHA						;
	LSR #3					;
	TAX						;
	PLA						;
	AND #$07				;
	TAY						;
	LDA.l LevelsDisabled,x		;
	TYX						;
	AND $018000,x			;
	BEQ $04					;
	LDA #$02				;
	TSB $08					;
	LDA $08					;
	STA !RAM_VWFStateFlags	;

	LDA $1425				;
	BEQ .NotBonus				;
	LDX #$00					;
	LDA #$B0					;
	JML $0091B8				;
.NotBonus					;
	JML $008494				;

;------------------------------------------------
; main level mode where the characters show up
;------------------------------------------------

IntroTilemapMainRt:
	LDA $0100				;
	CMP #$11				;
	BNE .SkipIntro				;
	LDA !RAM_VWFStateFlags	;
	AND #$06				;
	ORA $0109				;
	BNE .SkipIntro				;
	JSR TilemapCheckRt			;
	BCS .SkipIntro				;
	JSR DisplayCharacters		;
	- BIT $4212 : BVC -
	LDA #$80				;
	STA $2100				;
	PHK						;
	PEA.w .ReturnSub-1		;
	PEA $84CE				;
	JML $008449				;
.ReturnSub					;
	- BIT $4212 : BVC -
	- BIT $4212 : BVS -
	- BIT $4212 : BVC -
	LDA #$0F					;
	STA $2100				;
	JML $0093F7				;
.SkipIntro						;
	LDA $141D				;
	BEQ .Return2				;
	JSL $84DC09				;
.Return2						;
	JML $0096E9				;     

;------------------------------------------------
; align the NMI brightness restore along H-blank
;------------------------------------------------

fblankfix:
	- BIT $4212 : BVC -
	LDA $0DAE : STA $2100
	JML $0082B6

;------------------------------------------------
; various checks
;------------------------------------------------

TilemapCheckRt:
	LDA !RAM_VWFStateFlags	;
	LSR						;
	BCC .StillDrawing			;
	LDA !RAM_VWFTextTimer	;
	BEQ .ToNextMode			;
	DEC						;
	STA !RAM_VWFTextTimer	;
	BRA .End					;
.StillDrawing					;
	LDA $13					;
	AND #!FramesToWait1		;
	BNE .End					;
	LDA !RAM_VWFCharsToDraw	;
	INC						;
	STA !RAM_VWFCharsToDraw	;
.End							;
	CLC						;
	RTS						;
.ToNextMode					;
	SEC						;
	RTS						;

;------------------------------------------------
; check if the tiles should be uploaded to VRAM or not
;------------------------------------------------

TileUploadRt:
	LDA $1425				;
	BNE .NormUpload			;
	LDA $0100				;
	CMP #$11				;
	BEQ .CustUpload			;
.NormUpload					;
	REP #$20					;
	LDX #$80					;
	JML $00A7C6				;
.CustUpload					;
	JSR UploadTileData			;
;	STZ $143A				; typo :)
	JML $00A82C				;

;------------------------------------------------
; show the characters on the screen
;------------------------------------------------

DisplayCharacters:

	PHB						;
	PHK						;
	PLB						;

	JSR GetOWLevelNumber		;
	REP #$30					;
	AND #$00FF				;
	ASL						;
	TAX						;
	LDA.l CharPtrs,x			;
	STA $08					;
	SEP #$30					;
	LDA.b #CharPtrs>>16		;
	STA $0A					;
	LDA #!InitXPosition			;
	STA $0B					;
	LDA #!InitYPosition			;
	STA $0C					;
	LDY #$00					;
	LDX #$00					;
.Loop						;
	LDA [$08],y				;
	CMP #$FC				;
	BCS .CommandChar			;
	JMP .NormalChars			;
.CommandChar				;
	SEC						;
	SBC #$FC					;
	JSL $8086DF				;

	dw .Space				; FC - space
	dw .DblSpace				; FD - double space
	dw .NewLine				; FE - new line
	dw .EndMessage			; FF - end the message

.EndMessage					;
	LDA !RAM_VWFStateFlags	;
	LSR						;
	BCS .End					;
	ORA #$01				;
	STA !RAM_VWFStateFlags	;
	LDA #!FramesToWait2		;
	STA !RAM_VWFTextTimer	;
.End							;
	PLB						;
	RTS						;

.NewLine						;
	LDA #!InitXPosition			;
	STA $0B					;
	LDA $0C					;
	CLC						;
	ADC #$14				;
	STA $0C					;
	BRA .NextChar				;

.Space						;
	LDA $0B					;
	CLC						;
	ADC #!SpaceWidth			;
	STA $0B					;
	BRA .NextChar				;

.DblSpace					;
	LDA $0B					;
	CLC						;
	ADC #!SpaceWidth2		;
	STA $0B					;
	BRA .NextChar				;

.NormalChars					;
	LDA $0B					;
	STA $0340,x				;
	LDA $0C					;
	STA $0341,x				;
	LDA [$08],y				;
	REP #$30					;
	PHX						;
	AND #$00FF				;
	ASL						;
	TAX						;
	LDA.l CharacterTilemap,x	;
	PLX						;
	STA $0342,x				;
	SEP #$30					;
	INX #4					;
.AddWidth					;
	PHX						;
	LDA [$08],y				;
	TAX						;
	LDA $0B					;
	SEC						;
	ADC.l CharWidth,x			;
	STA $0B					;
	PLX						;
.NextChar					;
	INY						;
	TYA						;
	CMP !RAM_VWFCharsToDraw	;
	BCS .Break				;
	JMP .Loop				;
.Break						;
	LDA #$AA				;
	STA $0414				;
	STA $0415				;
	STA $0416				;
	STA $0417				;
	STA $0418				;
	STA $0419				;
	STA $041A				;
	STA $041B				;
	STA $041C				;
	STA $041D				;
	STA $041E				;
	STA $041F				;
	PLB						;
	RTS						;

;------------------------------------------------
; upload the VWF sprite text to VRAM
;------------------------------------------------

UploadTileData:
	REP #$10					; 16-bit XY
	LDA #$80				;
	STA $2115				; increment after reading the high byte of the VRAM data write ($2119)
	LDY #$6800				;
	STY $2116				; VRAM address $6800 - start of SP2
	LDY #$1801				;
	STY $4320				; 2 regs write once, $2118
	LDY #VWFIntroTiles			;
	STY $4322				; set the lower two bytes of the address of the tilemap
	LDA.b #VWFIntroTiles>>16	;
	STA $4324				;
	LDY #$3000				; 0x3000 bytes to transfer
	STY $4325				;
	LDA #$04				; DMA channel 2
	STA $420B				;
	SEP #$10					; 8-bit XY
	RTS						;

;------------------------------------------------
; reset all necessary RAM addresses before using them
;------------------------------------------------

ResetTextTimer:
	LDA #$00				;
	STA !RAM_VWFTextTimer	;
	STA !RAM_VWFCharsToDraw	;
	LDA !RAM_VWFStateFlags	;
	AND #$FB				;
	STA !RAM_VWFStateFlags	;
	LDA $0DB0				;
	CLC						;
	JML $009F46				;

;------------------------------------------------
; reset all necessary RAM addresses before using them (title screen)
;------------------------------------------------

ResetTextTimer2:
	LDA #$00				;
	STA !RAM_VWFTextTimer	;
	STA !RAM_VWFCharsToDraw	;
	STA !RAM_VWFStateFlags	;
	LDX #$07					;
	LDA #$FF					;
	JML $0096B8				;

;------------------------------------------------
; reset all necessary RAM addresses before using them (overworld)
;------------------------------------------------

ResetTextTimer3:
	LDA #$00				;
	STA !RAM_VWFTextTimer	;
	STA !RAM_VWFCharsToDraw	;
	STA !RAM_VWFStateFlags	;
	LDA $1B9C				;
	BEQ $04					;
	JML $00A08F				;
	JML $00A093				;

;------------------------------------------------
; figure out which overworld level the player is in (since it doesn't get set until the level actually loads)
;------------------------------------------------

GetOWLevelNumberEntry2:
	JSR GetOWLevelNumber
	RTL

; taken from $05D847
GetOWLevelNumber:
	REP #$30
	LDX $0DD6
	LDA $1F1F,x
	AND #$000F
	STA $00
	LDA $1F21,x
	AND #$000F
	ASL #4
	STA $02
	LDA $1F1F,x
	AND #$0010
	ASL #4
	ORA $00
	STA $00
	LDA $1F21,x
	AND #$0010
	ASL #5
	ORA $02
	ORA $00
	TAX
	LDA $0DD6
	AND #$00FF
	LSR #2
	TAY
	LDA $1F11,y
	AND #$000F
	BEQ .NoSubmap
	TXA
	CLC
	ADC #$0400
	TAX
.NoSubmap
	SEP #$20
	LDA $7ED000,x
	SEP #$10
	RTS

;------------------------------------------------
; prevent the message from reappearing after a No-Yoshi intro
;------------------------------------------------

NoYoshiIntroDisable:
	LDA !RAM_VWFStateFlags
	ORA #$04
	STA !RAM_VWFStateFlags
	LDA [$CE]
	AND #$C0
	JML $05DA95

;------------------------------------------------
; various data
;------------------------------------------------

table vwfintrotable.txt

freedata

; how many pixels wide each character is
CharWidth:
	db $08,$06,$08,$08,$08,$08,$08,$08
	db $08,$08,$08,$08,$07,$07,$08,$08
	db $08,$08,$05,$08,$08,$07,$08,$08
	db $08,$08,$08,$08,$08,$07,$08,$08
	db $08,$08,$08,$08,$08,$08,$08,$08
	db $07,$07,$08,$08,$03,$07,$08,$03
	db $08,$08,$08,$08,$08,$07,$07,$08
	db $08,$08,$08,$08,$08,$08,$04,$07
	db $04,$05,$05,$08,$04,$04,$07,$08
	db $06,$06,$05,$05,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00

; tile number and properties of each character
CharacterTilemap:
	dw $3280,$3282,$3284,$3286,$3288,$328A,$328C,$328E
	dw $32A0,$32A2,$32A4,$32A6,$32A8,$32AA,$32AC,$32AE
	dw $32C0,$32C2,$32C4,$32C6,$32C8,$32CA,$32CC,$32CE
	dw $32E0,$32E2,$32E4,$32E6,$32E8,$32EA,$32EC,$32EE
	dw $3300,$3302,$3304,$3306,$3308,$330A,$330C,$330E
	dw $3320,$3322,$3324,$3326,$3328,$332A,$332C,$332E
	dw $3340,$3342,$3344,$3346,$3348,$334A,$334C,$334E
	dw $3360,$3362,$3364,$3366,$3368,$336A,$336C,$336E
	dw $3380,$3382,$3384,$3386,$3388,$338A,$338C,$338E
	dw $33A0,$33A2,$33A4,$33A6,$33A8,$33AA,$33AC,$33AE
	dw $33C0,$33C2,$33C4,$33C6,$33C8,$33CA,$33CC,$33CE
	dw $33E0,$33E2,$33E4,$33E6,$33E8,$33EA,$33EC,$33EE

; which levels will not show the VWF intro at all (bitwise, high bit to low)
LevelsDisabled:
db %00000000,%00000000,%00000000,%00000000	; levels 0-1F
db %00000000,%10000000,%00000000,%00000000	; levels 20-3F (20-24, 101-11B)
db %00000000,%00000000,%00000000,%00000000	; levels 40-5F (11C-13B)

CharPtrs:
incsrc vwfintroptrs.asm

CharacterData:
incsrc vwfintrochars.asm

VWFIntroTiles:
incbin yifont.bin

print freespaceuse

