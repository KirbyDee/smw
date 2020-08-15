!FrameCounter 		= $490
!FrameCount 		= $3
!TimeTravelFrameCounter = $491
!TimeTravelCount 	= $40

!TimeTravelSound	= $10 
!SoundBank		= $1DF9|!addr

!position_x_current_1	= $7E0094
!position_x_current_2	= $7E0095
!position_y_current_1	= $7E0096
!position_y_current_2	= $7E0097
!speed_x_current	= $7E007B
!speed_y_current	= $7E007D
!spinjump_flag_current  = $7E140D

; 16 frames of x position (32 bytes)
!position_x_0_1 	= $4A0
!position_x_0_2 	= $4A1
!position_x_1_1 	= $4A2
!position_x_1_2 	= $4A3
!position_x_2_1 	= $4A4
!position_x_2_2 	= $4A5
!position_x_3_1 	= $4A6
!position_x_3_2 	= $4A7
!position_x_4_1 	= $4A8
!position_x_4_2 	= $4A9
!position_x_5_1 	= $4AA
!position_x_5_2 	= $4AB
!position_x_6_1 	= $4AC
!position_x_6_2 	= $4AD
!position_x_7_1 	= $4AE
!position_x_7_2 	= $4AF
!position_x_8_1 	= $4B0
!position_x_8_2 	= $4B1
!position_x_9_1 	= $4B2
!position_x_9_2 	= $4B3
!position_x_A_1 	= $4B4
!position_x_A_2 	= $4B5
!position_x_B_1 	= $4B6
!position_x_B_2 	= $4B7
!position_x_C_1 	= $4B8
!position_x_C_2 	= $4B9
!position_x_D_1 	= $4BA
!position_x_D_2 	= $4BB
!position_x_E_1 	= $4BC
!position_x_E_2 	= $4BD
!position_x_F_1 	= $4BE
!position_x_F_2 	= $4BF

; 16 frames of y position (32 bytes)
!position_y_0_1 	= $4C0
!position_y_0_2 	= $4C1
!position_y_1_1 	= $4C2
!position_y_1_2 	= $4C3
!position_y_2_1 	= $4C4
!position_y_2_2 	= $4C5
!position_y_3_1 	= $4C6
!position_y_3_2 	= $4C7
!position_y_4_1 	= $4C8
!position_y_4_2 	= $4C9
!position_y_5_1 	= $4CA
!position_y_5_2 	= $4CB
!position_y_6_1 	= $4CC
!position_y_6_2 	= $4CD
!position_y_7_1 	= $4CE
!position_y_7_2 	= $4CF
!position_y_8_1 	= $4D0
!position_y_8_2 	= $4D1
!position_y_9_1 	= $4D2
!position_y_9_2 	= $4D3
!position_y_A_1 	= $4D4
!position_y_A_2 	= $4D5
!position_y_B_1 	= $4D6
!position_y_B_2 	= $4D7
!position_y_C_1 	= $4D8
!position_y_C_2 	= $4D9
!position_y_D_1 	= $4DA
!position_y_D_2 	= $4DB
!position_y_E_1 	= $4DC
!position_y_E_2 	= $4DD
!position_y_F_1 	= $4DE
!position_y_F_2 	= $4DF

; 16 frames of x speed (16 bytes)
!speed_x_0 		= $4E0
!speed_x_1 		= $4E1
!speed_x_2 		= $4E2
!speed_x_3 		= $4E3
!speed_x_4 		= $4E4
!speed_x_5 		= $4E5
!speed_x_6 		= $4E6
!speed_x_7		= $4E7
!speed_x_8 		= $4E8
!speed_x_9 		= $4E9
!speed_x_A 		= $4EA
!speed_x_B 		= $4EB
!speed_x_C 		= $4EC
!speed_x_D 		= $4ED
!speed_x_E 		= $4EE
!speed_x_F 		= $4EF

; 16 frames of y speed (16 bytes)
!speed_y_0 		= $4F0
!speed_y_1 		= $4F1
!speed_y_2 		= $4F2
!speed_y_3 		= $4F3
!speed_y_4 		= $4F4
!speed_y_5 		= $4F5
!speed_y_6 		= $4F6
!speed_y_7		= $4F7
!speed_y_8 		= $4F8
!speed_y_9 		= $4F9
!speed_y_A 		= $4FA
!speed_y_B 		= $4FB
!speed_y_C 		= $4FC
!speed_y_D 		= $4FD
!speed_y_E 		= $4FE
!speed_y_F 		= $4FF

; 16 frames of spinjump flag (16 bytes)
!spinjump_flag_0 	= $500
!spinjump_flag_1 	= $501
!spinjump_flag_2 	= $502
!spinjump_flag_3 	= $503
!spinjump_flag_4	= $504
!spinjump_flag_5 	= $505
!spinjump_flag_6 	= $506
!spinjump_flag_7 	= $507
!spinjump_flag_8 	= $508
!spinjump_flag_9 	= $509
!spinjump_flag_A 	= $50A
!spinjump_flag_B 	= $50B
!spinjump_flag_C 	= $50C
!spinjump_flag_D 	= $50D
!spinjump_flag_E 	= $50E
!spinjump_flag_F 	= $50F

; Tile and YXPPCCCT for the marker when Mario is above the screen.
!tileAbove  =   $1D     ; Tile number
!propsAbove =   $28     ; YXPPCCCT properties

; Tile and YXPPCCCT for the marker when Mario is below the screen.
!tileBelow  =   $1D     ; Tile number
!propsBelow =   $28     ; YXPPCCCT properties

; How many pixels the tile should be offset from the very top/bottom of the screen.
;  Use this if you want a small gap between the very edge and the actual tile.
!yOffAbove  =   $02     ; From the top of the screen
!yOffBelow  =   $02     ; From the bottom of the screen

;;;;;;;;;;;;;;;;;;;;;;;;;

!oamIndex   =   $0000   ; OAM index (from $0200) to use.
    ; ^ don't touch this one unless you know how it works.
    ;   this default value isn't really used by much so it should be fine.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;==================================================================================================


init:	
	LDA #!FrameCount		; \ store frame counter
	STA !FrameCounter		; /
	STZ !TimeTravelFrameCounter	; init counter
	
	; init x position frames
	LDA !position_x_current_1
	STA !position_x_0_1
	LDA !position_x_current_2
	STA !position_x_0_2
	LDA !position_x_current_1
	STA !position_x_1_1
	LDA !position_x_current_2
	STA !position_x_1_2
	LDA !position_x_current_1
	STA !position_x_2_1
	LDA !position_x_current_2
	STA !position_x_2_2
	LDA !position_x_current_1
	STA !position_x_3_1
	LDA !position_x_current_2
	STA !position_x_3_2
	LDA !position_x_current_1
	STA !position_x_4_1
	LDA !position_x_current_2
	STA !position_x_4_2
	LDA !position_x_current_1
	STA !position_x_5_1
	LDA !position_x_current_2
	STA !position_x_5_2
	LDA !position_x_current_1
	STA !position_x_6_1
	LDA !position_x_current_2
	STA !position_x_6_2
	LDA !position_x_current_1
	STA !position_x_7_1
	LDA !position_x_current_2
	STA !position_x_7_2
	LDA !position_x_current_1
	STA !position_x_8_1
	LDA !position_x_current_2
	STA !position_x_8_2
	LDA !position_x_current_1
	STA !position_x_9_1
	LDA !position_x_current_2
	STA !position_x_9_2
	LDA !position_x_current_1
	STA !position_x_A_1
	LDA !position_x_current_2
	STA !position_x_A_2
	LDA !position_x_current_1
	STA !position_x_B_1
	LDA !position_x_current_2
	STA !position_x_B_2
	LDA !position_x_current_1
	STA !position_x_C_1
	LDA !position_x_current_2
	STA !position_x_C_2
	LDA !position_x_current_1
	STA !position_x_D_1
	LDA !position_x_current_2
	STA !position_x_D_2
	LDA !position_x_current_1
	STA !position_x_E_1
	LDA !position_x_current_2
	STA !position_x_E_2
	LDA !position_x_current_1
	STA !position_x_F_1
	LDA !position_x_current_2
	STA !position_x_F_2

	; init y position frames
	LDA !position_y_current_1
	STA !position_y_0_1
	LDA !position_y_current_2
	STA !position_y_0_2
	LDA !position_y_current_1
	STA !position_y_1_1
	LDA !position_y_current_2
	STA !position_y_1_2
	LDA !position_y_current_1
	STA !position_y_2_1
	LDA !position_y_current_2
	STA !position_y_2_2
	LDA !position_y_current_1
	STA !position_y_3_1
	LDA !position_y_current_2
	STA !position_y_3_2
	LDA !position_y_current_1
	STA !position_y_4_1
	LDA !position_y_current_2
	STA !position_y_4_2
	LDA !position_y_current_1
	STA !position_y_5_1
	LDA !position_y_current_2
	STA !position_y_5_2
	LDA !position_y_current_1
	STA !position_y_6_1
	LDA !position_y_current_2
	STA !position_y_6_2
	LDA !position_y_current_1
	STA !position_y_7_1
	LDA !position_y_current_2
	STA !position_y_7_2
	LDA !position_y_current_1
	STA !position_y_8_1
	LDA !position_y_current_2
	STA !position_y_8_2
	LDA !position_y_current_1
	STA !position_y_9_1
	LDA !position_y_current_2
	STA !position_y_9_2
	LDA !position_y_current_1
	STA !position_y_A_1
	LDA !position_y_current_2
	STA !position_y_A_2
	LDA !position_y_current_1
	STA !position_y_B_1
	LDA !position_y_current_2
	STA !position_y_B_2
	LDA !position_y_current_1
	STA !position_y_C_1
	LDA !position_y_current_2
	STA !position_y_C_2
	LDA !position_y_current_1
	STA !position_y_D_1
	LDA !position_y_current_2
	STA !position_y_D_2
	LDA !position_y_current_1
	STA !position_y_E_1
	LDA !position_y_current_2
	STA !position_y_E_2
	LDA !position_y_current_1
	STA !position_y_F_1
	LDA !position_y_current_2
	STA !position_y_F_2

	; init x speed frames
	LDA !speed_x_current
	STA !speed_x_0
	LDA !speed_x_current
	STA !speed_x_1
	LDA !speed_x_current
	STA !speed_x_2
	LDA !speed_x_current
	STA !speed_x_3
	LDA !speed_x_current
	STA !speed_x_4
	LDA !speed_x_current
	STA !speed_x_5
	LDA !speed_x_current
	STA !speed_x_6
	LDA !speed_x_current
	STA !speed_x_7
	LDA !speed_x_current
	STA !speed_x_8
	LDA !speed_x_current
	STA !speed_x_9
	LDA !speed_x_current
	STA !speed_x_A
	LDA !speed_x_current
	STA !speed_x_B
	LDA !speed_x_current
	STA !speed_x_C
	LDA !speed_x_current
	STA !speed_x_D
	LDA !speed_x_current
	STA !speed_x_E
	LDA !speed_x_current
	STA !speed_x_F

	; init y speed frames
	LDA !speed_y_current
	STA !speed_y_0
	LDA !speed_y_current
	STA !speed_y_1
	LDA !speed_y_current
	STA !speed_y_2
	LDA !speed_y_current
	STA !speed_y_3
	LDA !speed_y_current
	STA !speed_y_4
	LDA !speed_y_current
	STA !speed_y_5
	LDA !speed_y_current
	STA !speed_y_6
	LDA !speed_y_current
	STA !speed_y_7
	LDA !speed_y_current
	STA !speed_y_8
	LDA !speed_y_current
	STA !speed_y_9
	LDA !speed_y_current
	STA !speed_y_A
	LDA !speed_y_current
	STA !speed_y_B
	LDA !speed_y_current
	STA !speed_y_C
	LDA !speed_y_current
	STA !speed_y_D
	LDA !speed_y_current
	STA !speed_y_E
	LDA !speed_y_current
	STA !speed_y_F

	; init spinjump flag
	STZ !spinjump_flag_0
	STZ !spinjump_flag_1
	STZ !spinjump_flag_2
	STZ !spinjump_flag_3
	STZ !spinjump_flag_4
	STZ !spinjump_flag_5
	STZ !spinjump_flag_6
	STZ !spinjump_flag_7
	STZ !spinjump_flag_8
	STZ !spinjump_flag_9
	STZ !spinjump_flag_A
	STZ !spinjump_flag_B
	STZ !spinjump_flag_C
	STZ !spinjump_flag_D
	STZ !spinjump_flag_E
	STZ !spinjump_flag_F

	RTL


main:
	LDA $7E0017			; \ check if R and/or L is pressed
	AND #%00110000			; |
	BEQ .decreaseTimeTravelCounter	; /
	LDA !TimeTravelFrameCounter	; \ check if we can can travel
	BNE .decreaseTimeTravelCounter	; /

.startTimeTravelCounter:
	LDA #!TimeTravelCount		; \ start time travel counter
	STA !TimeTravelFrameCounter	; /

.createSmoke:
	SEP #$10			;   8-bit XY
	PHP
	SEP #$30
	PHX
	LDX #$03
.loop	LDA $17C0|!addr,x
	BNE .next
	
	INC $17C0|!addr,x
	LDA #$1B
	STA $17CC|!addr,x

	LDA !position_y_current_1
	CLC
	ADC #$10
	STA $17C4|!addr,x
	LDA !position_y_current_2
	STA $17C6|!addr,x
	LDA !position_x_current_1
	STA $17C8|!addr,x
	LDA !position_x_current_2
	STA $17CA|!addr,x
	BRA +

.next	DEX
	BPL .loop

+	PLX
	PLP

.playSound:
	LDA #!TimeTravelSound
	STA !SoundBank	

.timeTravelPositionX:
	LDA !position_x_F_1		; \ set current x-position to the past
	STA !position_x_current_1	; |
	LDA !position_x_F_2		; |
	STA !position_x_current_2	; /
.timeTravelPositionY:
	LDA !position_y_F_1		; \ set current y-position to the past
	STA !position_y_current_1	; |
	LDA !position_y_F_2		; |
	STA !position_y_current_2	; /
.timeTravelSpeedX:
	LDA !speed_x_F			; \ set current x-speed to the past
	STA !speed_x_current		; /
.timeTravelSpeedY:
	LDA !speed_y_F			; \ set current y-speed to the past
	STA !speed_y_current		; /
.timeTravelSpinJump:
	LDA !spinjump_flag_F		; \ set current spinjump flag
	STA !spinjump_flag_current	; /

.skipDecreaseTimeTravelCounter:
	BRA .checkFrameCounter

.decreaseTimeTravelCounter:
	LDA !TimeTravelFrameCounter	;load travel address
	BEQ .checkFrameCounter		;skip if already 0
	LDA !TimeTravelFrameCounter	;load travel address
	SEC				;set carry
	SBC #$01			;subtract value
	STA !TimeTravelFrameCounter	;store result back.
	
.checkFrameCounter:
	LDA !FrameCounter
	BEQ .initFrameCounter

.decreaseCounter:
	LDA !FrameCounter		;load timer address
	SEC				;set carry
	SBC #$01			;subtract value
	STA !FrameCounter		;store result back.
	RTL

.initFrameCounter:
	LDA #!FrameCount		; \ store frame counter
	STA !FrameCounter		; /

.cascadePositionX:
	LDA !position_x_E_1			
	STA !position_x_F_1			
	LDA !position_x_E_2		
	STA !position_x_F_2		
	LDA !position_x_D_1			
	STA !position_x_E_1			
	LDA !position_x_D_2			
	STA !position_x_E_2			
	LDA !position_x_C_1			
	STA !position_x_D_1			
	LDA !position_x_C_2			
	STA !position_x_D_2			
	LDA !position_x_B_1			
	STA !position_x_C_1			
	LDA !position_x_B_2			
	STA !position_x_C_2			
	LDA !position_x_A_1			
	STA !position_x_B_1			
	LDA !position_x_A_2			
	STA !position_x_B_2			
	LDA !position_x_9_1		
	STA !position_x_A_1			
	LDA !position_x_9_2
	STA !position_x_A_2			
	LDA !position_x_8_1			
	STA !position_x_9_1			
	LDA !position_x_8_2			
	STA !position_x_9_2		
	LDA !position_x_7_1			
	STA !position_x_8_1			
	LDA !position_x_7_2			
	STA !position_x_8_2			
	LDA !position_x_6_1			
	STA !position_x_7_1			
	LDA !position_x_6_2			
	STA !position_x_7_2			
	LDA !position_x_5_1			
	STA !position_x_6_1			
	LDA !position_x_5_2			
	STA !position_x_6_2			
	LDA !position_x_4_1			
	STA !position_x_5_1			
	LDA !position_x_4_2			
	STA !position_x_5_2			
	LDA !position_x_3_1			
	STA !position_x_4_1			
	LDA !position_x_3_2			
	STA !position_x_4_2			
	LDA !position_x_2_1			
	STA !position_x_3_1			
	LDA !position_x_2_2			
	STA !position_x_3_2			
	LDA !position_x_1_1			
	STA !position_x_2_1			
	LDA !position_x_1_2			
	STA !position_x_2_2			
	LDA !position_x_0_1			
	STA !position_x_1_1			
	LDA !position_x_0_2			
	STA !position_x_1_2			
	LDA !position_x_current_1	
	STA !position_x_0_1			
	LDA !position_x_current_2	
	STA !position_x_0_2
		
.cascadePositionY:
	LDA !position_y_E_1			
	STA !position_y_F_1			
	LDA !position_y_E_2		
	STA !position_y_F_2		
	LDA !position_y_D_1			
	STA !position_y_E_1			
	LDA !position_y_D_2			
	STA !position_y_E_2			
	LDA !position_y_C_1			
	STA !position_y_D_1			
	LDA !position_y_C_2			
	STA !position_y_D_2			
	LDA !position_y_B_1			
	STA !position_y_C_1			
	LDA !position_y_B_2			
	STA !position_y_C_2			
	LDA !position_y_A_1			
	STA !position_y_B_1			
	LDA !position_y_A_2			
	STA !position_y_B_2			
	LDA !position_y_9_1		
	STA !position_y_A_1			
	LDA !position_y_9_2
	STA !position_y_A_2			
	LDA !position_y_8_1			
	STA !position_y_9_1			
	LDA !position_y_8_2			
	STA !position_y_9_2		
	LDA !position_y_7_1			
	STA !position_y_8_1			
	LDA !position_y_7_2			
	STA !position_y_8_2			
	LDA !position_y_6_1			
	STA !position_y_7_1			
	LDA !position_y_6_2			
	STA !position_y_7_2			
	LDA !position_y_5_1			
	STA !position_y_6_1			
	LDA !position_y_5_2			
	STA !position_y_6_2			
	LDA !position_y_4_1			
	STA !position_y_5_1			
	LDA !position_y_4_2			
	STA !position_y_5_2			
	LDA !position_y_3_1			
	STA !position_y_4_1			
	LDA !position_y_3_2			
	STA !position_y_4_2			
	LDA !position_y_2_1			
	STA !position_y_3_1			
	LDA !position_y_2_2			
	STA !position_y_3_2			
	LDA !position_y_1_1			
	STA !position_y_2_1			
	LDA !position_y_1_2			
	STA !position_y_2_2			
	LDA !position_y_0_1			
	STA !position_y_1_1			
	LDA !position_y_0_2			
	STA !position_y_1_2			
	LDA !position_y_current_1	
	STA !position_y_0_1			
	LDA !position_y_current_2	
	STA !position_y_0_2

.cascadeSpeedX:
	LDA !speed_x_E
	STA !speed_x_F
	LDA !speed_x_D
	STA !speed_x_E
	LDA !speed_x_C
	STA !speed_x_D
	LDA !speed_x_B
	STA !speed_x_C
	LDA !speed_x_A
	STA !speed_x_B
	LDA !speed_x_9
	STA !speed_x_A
	LDA !speed_x_8
	STA !speed_x_9
	LDA !speed_x_7
	STA !speed_x_8
	LDA !speed_x_6
	STA !speed_x_7
	LDA !speed_x_5
	STA !speed_x_6
	LDA !speed_x_4
	STA !speed_x_5
	LDA !speed_x_3
	STA !speed_x_4
	LDA !speed_x_2
	STA !speed_x_3
	LDA !speed_x_1
	STA !speed_x_2
	LDA !speed_x_0
	STA !speed_x_1
	LDA !speed_x_current	
	STA !speed_x_0

.cascadeSpeedY:
	LDA !speed_y_E
	STA !speed_y_F
	LDA !speed_y_D
	STA !speed_y_E
	LDA !speed_y_C
	STA !speed_y_D
	LDA !speed_y_B
	STA !speed_y_C
	LDA !speed_y_A
	STA !speed_y_B
	LDA !speed_y_9
	STA !speed_y_A
	LDA !speed_y_8
	STA !speed_y_9
	LDA !speed_y_7
	STA !speed_y_8
	LDA !speed_y_6
	STA !speed_y_7
	LDA !speed_y_5
	STA !speed_y_6
	LDA !speed_y_4
	STA !speed_y_5
	LDA !speed_y_3
	STA !speed_y_4
	LDA !speed_y_2
	STA !speed_y_3
	LDA !speed_y_1
	STA !speed_y_2
	LDA !speed_y_0
	STA !speed_y_1
	LDA !speed_y_current	
	STA !speed_y_0

.cascadeSpinJumpFlag:
	LDA !spinjump_flag_E	
	STA !spinjump_flag_F
	LDA !spinjump_flag_D	
	STA !spinjump_flag_E
	LDA !spinjump_flag_C	
	STA !spinjump_flag_D
	LDA !spinjump_flag_B	
	STA !spinjump_flag_C
	LDA !spinjump_flag_A	
	STA !spinjump_flag_B
	LDA !spinjump_flag_9	
	STA !spinjump_flag_A
	LDA !spinjump_flag_8	
	STA !spinjump_flag_9
	LDA !spinjump_flag_7	
	STA !spinjump_flag_8
	LDA !spinjump_flag_6	
	STA !spinjump_flag_7
	LDA !spinjump_flag_5	
	STA !spinjump_flag_6
	LDA !spinjump_flag_4	
	STA !spinjump_flag_5
	LDA !spinjump_flag_3	
	STA !spinjump_flag_4
	LDA !spinjump_flag_2	
	STA !spinjump_flag_3
	LDA !spinjump_flag_1	
	STA !spinjump_flag_2
	LDA !spinjump_flag_0	
	STA !spinjump_flag_1
	LDA !spinjump_flag_current	
	STA !spinjump_flag_0

	INY
      .offscreen
    	SEP #$20
    	LDA $7E
    	CLC : ADC #$04
   	STA $0200|!addr+!oamIndex
    	LDA yOffs,y
    	STA $0201|!addr+!oamIndex
    	LDA Tiles,y
    	STA $0202|!addr+!oamIndex
    	LDA Props,y
    	STA $0203|!addr+!oamIndex
    	STZ $0420|!addr+(!oamIndex/4)

      .ret
    	SEP #$20
    	RTL

Tiles:
    db !tileAbove,!tileBelow
Props:
    db !propsAbove,!propsBelow
yOffs:
    db !yOffAbove,$D7-!yOffBelow