; Patch by JackTheSpades.
; made to work reasonably with AddMusicK and other bugs fixed by Katrina
; Edit values below if you want to.

; Track that plays when the level-end circle shrinks around Mario.
; For AddMusicK, use $08
!IrisOut = $11

!TimeLeft = $10 ; amount of frames to walk to the left
!TimeJump = $10 ; amount of frames to hold the spinjump button

;----------------------------------------


!TimeInit #= !TimeLeft+!TimeJump+$01

if read1($00FFD5) == $23
	sa1rom
	!Base2 = $6000
else
	lorom
	!Base2 = $0000
endif

!Timer = $1436+!Base2

org $00C9C2
	autoclean JML DitchYoshi
ReturnCircle:
	JSR.w $00CA44       ; do the circle stuff
Return:
	JSR.w $00CD24       ; update Mario's Image

;handles the zoom in music not starting too early
org $00C9B7
	autoclean JSL Music
	RTS

org $00A0D8
	NOP #2              ; \
	STZ $13C7+!Base2    ; | remove yoshi when going to OW
	STZ $0DBA+!Base2,x  ; /

org $0491C9
	STZ $0DC1+!Base2    ; \
	STZ $0DBA+!Base2,x  ; | moving on OW or something...
	STZ $13C7+!Base2    ; |
	STZ $187A+!Base2    ; /

freedata
Music:
	DEC $1492+!Base2 ; decrement timer
	BNE +            ; only change the song if it's zero now

	; if the player isn't on Yoshi...
	LDA $187A+!Base2 : BNE +
	; reset the timer (which might be set from an earlier level or something),
	; and change the music
	LDA #$00 : STA !Timer ; using lda/sta so that free ram can be long
	LDA.b #!IrisOut
	STA $1DFB+!Base2
+	RTL

DitchYoshi:
	LDA !Timer              ; \ if timer is set already
	BNE .doTimer            ; / go do timer stuff
	LDA $187A+!Base2        ; \ if not on yoshi
	BEQ .justwalk           ; / just walk
	LDA #!TimeInit          ; \ set timer
	STA !Timer              ; /
	JML Return

.doTimer
	DEC                     ; \ Decrement Timer
	STA !Timer              ; / as long as the timer is more than
	CMP #!TimeJump          ; \ TimeJump, walk to the left
	BCS .walkleft           ; /
	CMP #$00                ; \ for the remaining timer,
	BNE .jumpoff            ; / hold jump and right
	LDA.b #!IrisOut         ; \ change music.
	STA $1DFB+!Base2        ; / Code only runs once, when timer goes from 01->00
.justwalk                   ; timer has run out
	LDA #$01                ; \ walk right
	STA $15                 ; /
	JML ReturnCircle        ; run circle code

.walkleft
	LDA #$02
	STA $15
	JML Return
.jumpoff
	LDA #$89
	STA $15
	STA $18
	JML Return


