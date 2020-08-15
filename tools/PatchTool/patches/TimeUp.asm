;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Seperate Death And Time Up Deaths ;;
;;	     	   by		     ;;
;;	      wiiqwertyuiop          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;

!Pose = $3C		; mario's pose when time up
!Sound = $2A		;\ sound effect to play
!Bank = $1DFC		;/
!Music = $09		; Music to play when death
!Time = $34		; Time before warping to the OW

;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


header
lorom

!addr = $0000

if read1($00ffd5) == $23
	!addr = $6000
	sa1rom
endif

org $00F606
autoclean JML TimeStart

org $00D108
autoclean JML Test

freedata ; this one doesn't change the data bank register, so it uses the RAM mirrors from another bank, so I might as well toss it into banks 40+

TimeStart:
LDA $0F31|!addr ;\  
ORA $0F32|!addr ; | If time is zero branch
ORA $0F33|!addr ; |
BEQ DeathTime	;/
LDA #$90	;\ Restore old code
STA $7D		;/
JML $00F60A

DeathTime:
LDA #!Sound	;\ Play sound
STA !Bank|!addr	;/
LDA #!Music	;\ Change music
STA $1DFB|!addr	;/ 
LDA #$FF	;\ change music some more
STA $0DDA|!addr	;/
STZ $140D|!addr	; No spinjumping
STZ $1407|!addr	; Cape status = 0
LDA #$FF	;\ Set lock sprites timer
STA $9D		;/
LDA #$09	;\ Mario death sequence
STA $71		;/
LDA #!Time	;\ Set timer
STA $1496|!addr	;/
RTL

Test:
LDA $1496|!addr	;\
CMP #$26	; | Old code
BCS Done	; |
STZ $7B		;/
LDA $0F31|!addr	;\
ORA $0F32|!addr	; | If time up death
ORA $0F33|!addr	; | branch
BEQ Done	;/
JML $00D10E

Done:
LDA $0F31|!addr	;\
ORA $0F32|!addr	; | If not time up death
ORA $0F33|!addr	; | branch
BNE NotTimed	;/
LDA #!Pose	;\ Set pose
STA $13E0|!addr	;/
NotTimed:
JML $00D11C
