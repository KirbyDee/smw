;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DKC2 Navigation arrows
;; Shows a sprite with the direction where Mario can walk.
;;
;; It came bundled with the old overworld sprite tool.
;; Converted to patch and optimized a bit by LX5.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!arrow_anim	= 4	; How fast the arrows will blink.

!arrow_size	= $00	; Arrow's size. $00 8x8, $02 16x16.
			; Tilemap and that stuff is found below
			; Search ".tilemap" without quotes.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lorom
!dp		= $0000
!addr		= $0000
!bank		= $800000

!7ED000		= $7ED000
!7EC800		= $7EC800

if read1($00FFD5) == $23
	sa1rom
	!dp	= $3000
	!addr	= $6000
	!bank	= $000000
	!7ED000	= $40D000
	!7EC800	= $40C800
endif

!arrow_frame	= $0F5E|!addr

org $048410
	jmp $FFB7
org $04FFB7
	jsr $862E
	autoclean jsl main
	jmp $8413

freecode

main:
	phb
	phk
	plb
	phx
	phy
	lda $9D
	ora $13D4|!addr
	bne .end
	inc !arrow_frame
	lda $13D9|!addr
	cmp #$03
	bne .end
	lda !arrow_frame
	lsr #!arrow_anim
	and #$01
	bne .end
	jsr .check_movement

.draw_gfx
	ldy $0DD6|!addr
	lda $1F17|!addr,y
	sec
	sbc $1A
	sta $00
	lda $1F19|!addr,y
	sec 
	sbc $1C
	sta $02

	lda #$08
	sta $07
	ldx #$03
-	
	lda $06
	and $07
	beq .no_draw
	
	jsr .get_oam
	lda $00
	clc
	adc.w .x_disp,x
	sta $0300|!addr,y
	lda $02
	clc
	adc.w .y_disp,x
	sta $0301|!addr,y
	lda.w .tilemap,x
	sta $0302|!addr,y
	lda.w .props,x
	sta $0303|!addr,y
	tya
	lsr #2
	phy
	tay
	lda #!arrow_size
	sta $0460|!addr,y
	ply
	iny #4
.no_draw
	lsr $07
	dex
	bpl -
.end	
	ply
	plx
	plb
	rtl

.x_disp
	db $0A,$EE,$FC,$FC
.y_disp
	db $F6,$F6,$04,$E8
.tilemap
	db $92,$92,$82,$82
.props
	db $34,$74,$34,$B4

.get_oam
	ldy #$DC
-	
	lda $02FD|!addr,y
	cmp #$F0
	bne +
	cpy #$40
	beq +
	dey #4
	bra -
+	
	rts


.check_movement
	jsr ..get_level_settings
	lda $0DD6|!addr
	lsr #2
	tax
	stz $07
	rep #$20
	lda $04
	sta $08
	sep #$20

	lda $06
	and #$01
	beq ..nope_right
	rep #$20
	inc $00
	jsr ..ow_tilepos_calc
	dec $00
	jsr ..tile_check
	bcs ..nope_right
	lda $07
	ora #$01
	sta $07
..nope_right
	lda $06
	and #$02
	beq ..nope_left
	rep #$20
	dec $00
	jsr ..ow_tilepos_calc
	inc $00
	jsr ..tile_check
	bcs ..nope_left
	lda $07
	ora #$02
	sta $07
..nope_left
	lda $06
	and #$04
	beq ..nope_down
	rep #$20
	inc $02
	jsr ..ow_tilepos_calc
	dec $02
	jsr ..tile_check
	bcs ..nope_down
	lda $07
	ora #$04
	sta $07
..nope_down
	lda $06
	and #$08
	beq ..nope_up
	rep #$20
	dec $02
	jsr ..ow_tilepos_calc
	inc $02
	jsr ..tile_check
	bcs ..nope_up
	lda $07
	ora #$08
	sta $07
..nope_up

	rep #$30
	ldx $08
	lda !7ED000,x
	and #$00FF
	sep #$30
	sta $08
	ldx #$09
..loop		
	lda $049078,x
	cmp #$FF
	beq ..special
	cmp $08
	beq ..written
	phx
..not_special
	plx
	sep #$20
	dex
	bpl ..loop
	bra ..end

..special
	rep #$20
	phx
	lda $0DB3|!addr
	and #$00FF
	tax
	lda $1F11|!addr,x
	and #$00FF
	bne ..not_special
	ldx $0DD6|!addr
	lda $1F19|!addr,x
	cmp $049082
	bne ..not_special
	lda $1F17|!addr,x
	cmp $049084
	bne ..not_special
	plx
	sep #$20
..written
	lda.w ..dir_setting,x
	ora $07
	sta $07
..end	
	lda $06
	and $07
	sta $06
	rts

..dir_setting
	db $04,$02,$02,$01,$01,$02,$04,$01,$01,$02

..tile_check
	lda $04
	cmp #$0800
	bcs ..return
	rep #$30
	phx
	ldx $04
	lda !7EC800,x
	plx
	and #$00FF
	beq ..return
	cmp #$0087
	bcs ..return
	sep #$30
	clc
	rts
..return
	sep #$30
	sec
	rts

..ow_tilepos_calc
	lda $00
	and #$000F
	sta $04
	lda $00
	and #$0010
	asl #4
	adc $04
	sta $04
	lda $02
	asl #4
	and #$00FF
	adc $04
	sta $04
	lda $02
	and #$0010
	beq ...nope
	lda $04
	clc
	adc #$0200
	sta $04
...nope	
	lda $1F11|!addr,x
	and #$00FF
	beq ...return
	lda $04
	clc
	adc #$0400
	sta $04
...return
	rts

..get_level_settings
	rep #$20
	ldx $0DD6|!addr
	lda $1F1F|!addr,x
	sta $00
	lda $1F21|!addr,x
	sta $02
	txa
	lsr #2
	tax
	jsr ..ow_tilepos_calc
	rep #$30
	ldx $04
	lda !7ED000,x
	and #$00FF
	sep #$30
	tax
	lda $1EA2|!addr,x
	sta $06
	rts