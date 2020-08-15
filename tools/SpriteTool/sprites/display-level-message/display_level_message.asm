;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; Display Level Message Sprite, by imamelia
;
; This sprite is like the Display Level Message sprite in SMW.  It displays a specified
; message after a certain number of frames, either in the original style or a VWF
; message from RPG Hacker's patch.  Setting the level number for the regular message
; to #$60 or higher or the VWF message number to #$2AAA or higher will prevent the
; sprite from displaying a message at all.
;
; Extra bytes: 1 or 2
;
; For the vanilla message version:
;
; Extra byte 1:
;
; Bits 0-6: Level number from which to display a message.  ($13BF format)
; Bit 7: Message number to display (1 or 2).
;
; For the VWF message version:
;
; Bits 0-7: Low byte of message number.
;
; Extra byte 2:
;
; Bits 0-5: High byte of message number.
; Bits 6-7: Unused.
;
; Extra property bytes:
;
; If bit 0 of the extra property byte 1 is clear, the sprite will use the original
; message system and one extra byte.  If bit 0 of the extra property byte 1 is set,
; the sprite wiill use the VWF message system and two extra bytes.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; defines and tables
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!VWFState = $702000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; init routine
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

print "INIT ",pc
	LDA #$28
	STA !1564,x
	RTL

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; main routine
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

print "MAIN ",pc
SpriteMainRt:
	LDA !151C,x
	BEQ .NoCloseMessage
	LDA !1504,x
	STA $13BF|!Base2
	STZ !151C,x
.NoCloseMessage
	LDA !1564,x
	CMP #$01
	BNE .Return
	LDA !7FAB28,x
	AND #$01
	BNE .DisplayVWF
	LDA $13BF|!Base2
	STA !1504,x
	LDA !7FAB40,x
	AND #$7F
	CMP #$60
	BCS .Return
	STA $13BF|!Base2
	LDA !7FAB40,x
	ROL #2
	AND #$01
	INC
	STA $1426|!Base2
	INC !151C,x
.Return
	SEP #$20
	RTL
.DisplayVWF
	LDA !VWFState
	BNE .Return
	LDA #$01
	STA !VWFState
	LDA !7FAB40,x
	XBA
	LDA !7FAB4C,x
	REP #$20
	AND #$3FFF
	CMP #$2AAA
	BCS .Return
	STA !VWFState+1
	SEP #$20
	RTL














