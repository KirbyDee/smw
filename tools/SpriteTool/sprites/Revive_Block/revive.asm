;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Revival "Block"
;;   by TheBiob
;; Description: If the player is dead and touches this block he will get revived
;;
;; Uses first extra bit: NO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
;   DEFINES   ;
;;;;;;;;;;;;;;;

	!tile	= $2E		; What tile is used to display
	!properties	= $36	; YXPPCCCT properties of that tile (please setting palette from cfg file)
	
	!invul	= $30		; How long the player will be invulnerable for
	
	!reviveSound	= $02	; \ Which sound to play. See http://www.smwcentral.net/?p=viewthread&t=6665 for more information
	!sndAddress		= $1DFC|!Base2	; /
	
	!lives	= $00	; How many lives the player looses when being revived (Set to 0 if you don't want lives removed

;;;;;;;;;;;;;;;
; Sprite INIT ;
;;;;;;;;;;;;;;;

	print "INIT ",pc
		LDA $0DDA|!Base2	; \ Store backup of music register to $1602,x
		CMP #$FF	; |
		BEQ +		; |
		AND #$3F	; |
		STA !1602,x	; /
+	RTL
	
;;;;;;;;;;;;;;;
; Sprite MAIN ;
;;;;;;;;;;;;;;;

	print "MAIN ",pc
		PHB : PHK : PLB
			JSR SpriteMain
		PLB
	RTL

SpriteMain:
	JSR GFX		; > Run graphic routine
	LDY $9D
	BNE +
	JSL $01B44F	; > Invisible solid block routine
+	LDA !157C,x	; \ Check if music should restart
	BEQ +		; |
	LDA !1540,x	; |
	BNE ++		; |
	LDA !1602,x	; |
	STA $1DFB|!Base2	; |
	STZ !157C,x	; /
	BRA ++
+	LDA !167A,x	; \ Process Sprite out of bounds (disable despawning)
	ORA.b #%00000100; |
	STA !167A,x	; /
	LDA #$02	
	%SubOffScreen() ; Handle sprite off screen/but only when music isn't about to restart (To prevent the sprite accidentally despawning before the music can restart)
++	LDA $71		; \ Check if player is dying
	CMP #$09	; |
	BNE .returnXX	; /
	JSL $03B664	; \ Get player clipping
	JSL $03B69F	; | Get sprite clipping
	JSL $03B72B	; / Check for contact
	BCC .returnXX	; > Return if no contact
	LDA #!lives	; \ Remove lives
	BEQ +		; |
	LDA $0DBE|!Base2	; |
	CMP #!lives	; |
	BCC .returnXX	; |
	SBC #!lives	; |
	STA $0DBE|!Base2	; /
+	STZ $71		; > Set mode to "move freely"
	LDA #!invul	; \ Set flashing invulnerability timer
	STA $1497|!Base2	; /
	LDA #$80	; \ Play music fadeout
	STA $1DFB|!Base2	; /
	LDA #$40	; \ Set timer to restart actual game music again
	STA !1540,x	; /
	LDA #$01	; \ Set restart music flag
	STA !157C,x	; /
	LDA #!reviveSound	; \ Play revive sound
	STA !sndAddress		; /
    .returnXX:
    RTS

GFX:
	%GetDrawInfo()
	
	LDA $00			; x position
	STA $0300|!Base2,y
	LDA $01			; y position
	STA $0301|!Base2,y
	LDA #!tile 		; tile
	STA $0302|!Base2,y
	LDA !15F6,x		; palette
	ORA #!properties; properties
	STA $0303|!Base2,y
	
	LDY #$02		; 00 = 8x8, 02 = 16x16, FF = Don't set tile size
	LDA #$00		; How many tile have been drawn - 1
	JSL $01B7B3		; reserve
    RTS
    