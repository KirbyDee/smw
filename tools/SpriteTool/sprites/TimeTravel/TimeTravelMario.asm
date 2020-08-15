;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A sleepy Goomba that wakes up when Mario gets too close and chases him.
;;  If the extra bit is clear, the Goomba will go back to sleep when it gets too far away.
;;  If the extra bit is set, it'll never back to sleep.
;;
;; Code by Thomas/kaizoman666. No credit necessary.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!horzDistance   =   $30
!vertDistance   =   $40
    ; Distances in pixels that Mario needs to be on either side of the Goomba to wake it up.
    ; Max for either is $7F.

!horzDistance2   =   $30
!vertDistance2   =   $40
    ; Distances in pixels that Mario needs to be on either side of the Goomba for it to fall asleep.
    ; Max for either is $7F.
    
!hopSpeed       =   $C0
    ; Y speed to give the Goomba when it wakes up.

!maxSpeed       =   $28
    ; Max X speed to run at.

!sleepTimer     =   $60
    ; How many frames Mario needs to be far enough away for the Goomba for it to fall asleep again.



Tilemap:
    db $A8,$AA,$00,$02,$04
Properties:
    db $28,$28,$29,$29,$29
    ; Running A/B, sleeping A/B/C.
    ; Second table is YXPPCCCT.

!squishTile     =   $20
!squishProp     =   $09
    ; 8x8 tile to use when squished, because I didn't bother with making this carryable.



!position_x_F_1 	= $4BE
!position_x_F_2 	= $4BF
!position_y_F_1 	= $4DE
!position_y_F_2 	= $4DF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; actual code begins
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "INIT ",pc
    JSR FaceMario
    RTL

print "MAIN ",pc
    PHB
    PHK
    PLB
    JSR Main
    PLB
    RTL



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SleepAni:               ; Animation frames for sleeping.
    db $02,$02,$02,$03,$04,$04,$04,$03
MaxSpeeds:              ; Max X speeds.
    db !maxSpeed,$100-!maxSpeed
AniLength:              ; How fast the running animation changes, depending on the Goomba's X speed.
    db $01,$02,$03,$04,$05,$06,$07,$08

Main:
    LDA $9D                     ;\ Just draw GFX if the game is frozen.
    BNE .drawgfx                ;/
    LDA !14C8,x
    CMP #$08
    BCS NotDead
    STZ !1602,x
  .drawgfx
    JMP Graphics


NotDead:
    JSL $01803A|!BankB          ; Interact with Mario and other sprites.
    LDA #$00 : %SubOffScreen()  ; Offscreen processing.
    JSL $01802A|!BankB          ; Update the sprite's position and apply gravity.


Running:
    LDA !position_x_F_1
    STA $7E00E4
    LDA !position_y_F_2
    STA $7E00D8

;   BRA Graphics	; Unnecesary since branches directly to the next instruction.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; gfx routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Graphics:
    %GetDrawInfo()
    LDA !14C8,x
    BEQ .return
    CMP #$03
    BEQ Squished
    
    LDA $00                     ;\ 
    STA $0300|!Base2,y          ;| Set X/Y position.
    LDA $01                     ;|
    STA $0301|!Base2,y          ;/
    PHX
    LDA !1602,x                 ;\ 
    TAX                         ;| Set tile number.
    LDA Tilemap,x               ;|
    STA $0302|!Base2,y          ;/
    LDA Properties,x
    STA $03
    PLX
    LDA !157C,x                 ;\ 
    LSR                         ;|
    LDA $03                     ;|
    BCS .noXFlip                ;|
    EOR #$40                    ;|
  .noXFlip                      ;| Set YXPPCCCT.
    PHA                         ;|  Flip X if the sprite is facing left.
    LDA !14C8,x                 ;|  Set Y if killed.
    CMP #$03                    ;|
    PLA                         ;|
    BCS .noYFlip                ;|
    ORA #$80                    ;|
  .noYFlip                      ;|
    STA $0303|!Base2,y          ;/
    LDA #$00                    ;\ 
    LDY #$02                    ;| Draw a 16x16.
    JSL $01B7B3|!BankB          ;/
  .return
    RTS

Squished:
    LDA $00                     ;\ 
    STA $0300|!Base2,y          ;|
    CLC                         ;| Set X position.
    ADC #$08                    ;|
    STA $0304|!Base2,y          ;/
    LDA $01                     ;\ 
    CLC                         ;|
    ADC #$08                    ;| Set Y position.
    STA $0301|!Base2,y          ;|
    STA $0305|!Base2,y          ;/
    LDA #!squishTile            ;\ 
    STA $0302|!Base2,y          ;| Set tile number.
    STA $0306|!Base2,y          ;/
    LDA #!squishProp            ;\ 
    ORA $64			;|
    STA $0303|!Base2,y          ;| Set YXPPCCCT.
    ORA #$40                    ;|
    STA $0307|!Base2,y          ;/
    LDA #$01                    ;\ 
    LDY #$00                    ;| Draw two 8x8s.
    JSL $01B7B3|!BankB          ;/
    RTS





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; helper routines
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FaceMario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FaceMario:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IsOnGround
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IsOnGround:
    LDA $1588,X
    AND #$04
    RTS