;========================
; DEFINES
;========================

!FreeRAM = $0F50         ; You may want to change this.
!levelnum = $010B        ; must be the same as level.asm

!DefaultMarSm = $00B2C8   ; \ You may not want to change these.
!DefaultLuiSm = $00B2DC   ;  |
!DefaultMarBg = $00B2C8   ;  |
!DefaultLuiBg = $00B2DC   ;  |
!DefaultMarCp = $00B2C8   ;  |
!DefaultLuiCp = $00B2DC   ;  |
!DefaultMarFr = $00B2F0   ;  |
!DefaultLuiFr = $00B304   ; /

!addr = $0000

if read1($00ffd5) == $23
       sa1rom
       !addr = $6000
       !levelnum #= !levelnum|!addr
       !FreeRAM #= !FreeRAM|!addr
endif

;----------------
; Hijacks.
;----------------

org $00A31A
autoclean JML NotQuiteMain

org $00B048
autoclean JSL LessMainThanThat

org $00E31B
autoclean JML Main

;==========================
; FROM UBERASM, NOT BY ME
;==========================

ORG $05D8B7
       BRA +
       NOP #3        ;the levelnum patch goes here in many ROMs, just skip over it
+      REP #$30
       LDA $0E
       STA !levelnum
       ASL
       CLC
       ADC $0E
       TAY
       LDA.w $E000,y
       STA $65
       LDA.w $E001,y
       STA $66
       LDA.w $E600,y
       STA $68
       LDA.w $E601,y
       STA $69
       BRA +
ORG $05D8E0
       +


;-----------------------
; Custom Routine
;-----------------------

freedata ; this one doesn't change the data bank register, so it uses the RAM mirrors from another bank, so I might as well toss it into banks 40+

Main:
       LDY $0D9B|!addr
       CPY #$02
       BEQ LoadOW
       REP #$30
       AND #$00FF                              ;\ A * 256.
       XBA                                     ; |
       CLC                                     ; | + current level num.
       ADC !levelnum                           ; |
       STA $00                                 ;/ Into $00 (scratch)
       ASL                                     ;\ Result *3
       CLC                                     ; |
       ADC $00                                 ; |
       TAX                                     ;/ Result of that into X.
       LDA.l PalPtr,x                          ;\ Get low and middle byte into $0D82.
       STA $0D82|!addr                         ;/
       SEP #$20
       LDA.l PalPtr+2,x                        ; Get bank byte into !ThirdRam.
Common:
       STA !FreeRAM
       SEP #$10
JumpBack:
       JML $00E326

LoadOW:
       LSR                  ;\ Divide powerup index and into X.
       TAX                  ;/
       LDA.l Offsets,x      ; Get offsets to index the pointers.
       STA $01              ; Store temporarily.
       LDX $0DB3|!addr      ;\ Get Mario/Luigi's submap.
       LDA $1F11|!addr,x    ;/
       ASL                  ;\
       CLC                  ; | Multiply by 3.
       ADC $1F11|!addr,x    ;/
       CLC                  ;\ Sum the offsets.
       ADC $01              ;/
       TAX
       REP #$20
       LDA.l OwPalPtr,x
       STA $0D82|!addr
       SEP #$20
       LDA.l OwPalPtr+2,x
       BRA Common

Offsets:
       db 00,21,42,63,84,105,126,147

NotQuiteMain:
       LDY !FreeRAM
       STY $4324
       JML $00A31F

LessMainThanThat:
       LDA !FreeRAM
       STA $02
       RTL

incsrc cusmarpal_tables.asm