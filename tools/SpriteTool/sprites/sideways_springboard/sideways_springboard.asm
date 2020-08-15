;============================================================
;
;============================================================

;---

!x_speed_lo     = $C0
!x_speed_hi     = $90

;-

!sfx    = $08
!bank   = $1DFC|!Base2

;-

tilemap:
        db $D2,$D2,$D2,$D2
        db $D3,$D3,$D3,$D3
        db $83,$C2,$83,$C2

;---

print "MAIN ",pc
        PHB
        PHK
        PLB
        JSR Springy
        PLB
print "INIT ",pc
        RTL

Springy:
        LDA !14C8,x
        EOR #$08
        ORA $9D
        BEQ +
        JMP .draw_sprite
+       %SubOffScreen()
        JSL $01802A|!BankB
        LDA !1588,x
        AND #$04
        BEQ +
        JSR bouncy_gravity
+       LDA !1588,x
        AND #$03
        BEQ .no_wall
        LDA !B6,x
        EOR #$FF
        INC
        STA !B6,x
        LDA !B6,x
        ASL
        PHP
        ROR !B6,x
        PLP
        ROR !B6,x
.no_wall
        LDA !1588,x
        AND #$08
        BEQ +
        STZ !AA,x
+       LDA !1540,x
        BEQ .not_in_spring
        DEC
        BNE +
        STZ !1FD6,x
        JMP .draw_sprite
+       LSR
        TAY
        LDA mario_y_offset,y
        STA $00

        STZ $01
        LDA !1FD6,x
        BPL +
        LDA $00
        EOR #$FF
        INC
        STA $00
        DEC $01

+       LDA frame,y
        STA !1602,x
        LDA !E4,x
        SEC
        SBC $00
        STA $94
        LDA !14E0,x
        SBC $01
        STA $95
        STZ $7D
        LDA #$03
        STA $1471|!Base2
        LDA #$CF
        TRB $15
        TRB $16
        LDA #$80
        TRB $17
        TRB $18
        LDA !1540,x
        CMP #$07
        BCS .dont_bounce
        STZ $1471|!Base2
        LDY #!x_speed_lo
        LDA !1FD6,x
        BPL +
        EOR #$FF
        INC
+       AND #$60
        BEQ +
        LDY #!x_speed_hi
+       STY $7B
        LDA !1FD6,x
        BPL +
        LDA $7B
        EOR #$FF
        INC
        STA $7B
+       LDA #!sfx
        STA !bank
.dont_bounce
        BRA .draw_sprite

.not_in_spring
        JSL $01A7DC|!BankB
        BCC .draw_sprite
        STZ $00
        LDA $187A|!Base2
        BEQ +
        LDA #$0A
        STA $00
+       LDA !D8,x
        SEC
        SBC $96
        SEC
        SBC $00
        CLC
        ADC #$04
        CMP #$1C
        BCS .top
        STZ !154C,x
        LDA !E4,x
        SEC
        SBC $94
        CLC
        ADC #$04
        CMP #$18
        BCC .sides
        CMP #$E8
        BCS .sides
.top
        LDA !D8,x
        SEC
        SBC #$20
        STA $96
        LDA $187A|!Base2
        BEQ +
        LDA $96
        SEC
        SBC #$10
        STA $96
+       LDA !14D4,x
        SBC #$00
        STA $97
        LDA #$01
        STA $1471|!Base2
        BRA .draw_sprite
.sides
        LDA #$11
        STA !1540,x
        LDA $7B
        STA !1FD6,x
.draw_sprite
        LDY !1602,x
        LDA !1FD6,x
        BPL +
        INY #3
+       LDA extra_x_disp,y
        ; GETDRAWINFO WILL CRASH IF YOU CHANGE THIS
        JSR draw_sprite
        RTS

frame:
        db $00,$01,$02,$02,$02,$01,$01,$00,$00
mario_y_offset:
        db $0E,$0B,$08,$08,$08,$0A,$0C,$0D,$0E
extra_x_disp:
        db $00,$02,$00
        db $00,$FE,$F8

;---

bouncy_gravity:
        LDA !B6,x
        PHP
        BPL +
        EOR #$FF
        INC
+       LSR
        PLP
        BPL +
        EOR #$FF
        INC
+       STA !B6,x
        LDA !AA,x
        PHA
        LDA !1588,x
        BMI .l2
        LDA #$00
        LDY !15B8,x
        BEQ +
.l2
        LDA #$18
+       STA !AA,x
        PLA
        LSR #2
        TAY
        LDA bounce_y_speed,y
        LDY !1588,x
        BMI +
        STA !AA,x
+       RTS

bounce_y_speed:
        db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
        db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
        db $E8,$E8,$E8,$00,$00,$00,$00,$FE
        db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
        db $DC,$D8,$D4,$D0,$CC,$C8

;---

x_disp:
        db $00,$08,$00,$08
y_disp:
        db $00,$00,$08,$08
flip:
        db $00,$40,$80,$C0

draw_sprite:
        STA $0F
        %GetDrawInfo()
        LDA $00
        CLC
        ADC $0F
        STA $00
        LDA !1602,x
        ASL #2
        STA $02
        LDA !15F6,x
        ORA $64
        STA $03

        LDX #$03
-       LDA $00
        CLC
        ADC x_disp,x
        STA $0300|!Base2,y
        LDA $01
        CLC
        ADC y_disp,x
        STA $0301|!Base2,y

        PHX
        TXA
        CLC
        ADC $02
        TAX
        LDA tilemap,x
        STA $0302|!Base2,y
        PLX
        LDA flip,x
        ORA $03
        STA $0303|!Base2,y

        INY #4
        DEX
        BPL -

        LDX $15E9|!Base2
        LDA #$03
        LDY #$00
        JSL $01B7B3|!BankB
        RTS

