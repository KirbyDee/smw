print "A horizontal vine tile."

db $42
JMP MarioBelow : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

MarioBelow:	PHP				; Push processor bits to stack
		REP #%00100000			; Set 16-bit accumulator/memory
		PHA				; Push A
		PHX				; Push X
		PHY				; Push Y
		BRA CHECKYOSHI			; Branch over early end statement

EARLYSTOP:	PLY				; Pull Y		\
		PLX				; Pull X		 | early end statement
		PLA				; Pull A		 | for when the end is
		PLP				; Pull Processor bits	 | too far to branch to
Return:		RTL				; Return		/

CHECKYOSHI:	LDX $187A|!addr			; \  don't hold on
		CPX #$00			;  | if on yoshi
		BNE EARLYSTOP			; /

		LDX $1470|!addr			; \  don't hold on
		CPX #$00			;  | if carrying
		BNE EARLYSTOP			; /  item

		LDA $15				; \  drop if
		BIT.w #%0000000000000100	;  | pressing
		BNE EARLYSTOP			; /  down

BITSTRIP:	LDA $98				; \
		SBC.w #$0010			;  | strip the
		BIT.w #%0000000000000001	;  | last 4 bits
		BNE BIT1CHECK			;  | off of $98
		SBC.w #%0000000000000001	;  | (I don't
BIT1CHECK:	BIT.w #%0000000000000010	;  | know if there
		BNE BIT2CHECK			;  | is a simpler
		SBC.w #%0000000000000010	;  | way to do this)
BIT2CHECK:	BIT.w #%0000000000000100	;  | $98 (16 bit) is
		BNE BIT3CHECK			;  | the position of
		SBC.w #%0000000000000100	;  | the current block
BIT3CHECK:	BIT.w #%0000000000001000	;  | (unlike in
		BNE TRYHOLD			;  | SMWCentral's map)
		SBC.w #%0000000000001000	; /

TRYHOLD:	CLC				; \  add 1 to block position because my bitstripper
		ADC.w #$0001			;  | always returns 1 less than desired value. (I don't
		STA $00				; /  know why) Then it stores it into scratch RAM
		LDA $96				; Load mario's Y position
		LDX $19				; \
		CPX #$00			;  | if not small mario, subtract 8 from position.
		BEQ TRYHOLDP2			;  | (so he doesn't have the wrong holding position)
		SBC.w #$0008			; /
TRYHOLDP2:	CMP $00				; \
		BEQ HOLD3			;  | Branch to holding code
		SBC.w #$0001			;  | if mario is in a grip spot.
		CMP $00				;  | then, according to which spot,
		BEQ HOLD2			;  | add 0 to 4 to mario's position
		SBC.w #$0001			;  | so he always holds on in the
		CMP $00				;  | same spot. this part makes the
		BEQ HOLD1			;  | vine glitch with ground, so don't
		SBC.w #$0001			;  | put it directly above ground tiles.
		CMP $00				;  | If none of these grip spots apply,
		BEQ HOLD			;  | then branch to stop. (see next
		SBC.w #$0001			;  | comment)
		CMP $00				;  |
		BEQ HOLD			; /
		BRA STOP			; Branch to stop if not in possible grip spot

HOLD4:		INC $96				; \  depending on the grip
HOLD3:		INC $96				;  | spot, the code is
HOLD2:		INC $96				;  | branched over to execute
HOLD1:		INC $96				; /  a certain number of 1 increments
HOLD:		LDX #$01			; \  set "Mario is
		STX $74				; /  "Climbing" flag

		LDA $94				; \
		BIT.w #%0000000000001000	;  | This handles
		BEQ FLIP1			;  | the flipping effect
		LDX #$01			;  | that occurs
		BRA APPLYFLIP			;  | when mario moves across
FLIP1:		LDX #$00			;  | the vine ($76 = player's direction)
APPLYFLIP:	STX $76				; /

		LDA $0013			; \
		BIT.w #%0000000000000001	;  | This handles
		BNE STOP			;  | movement left
		LDA $15				;  | and right when
		BIT.w #%0000000000000001	;  | the player presses
		BNE TRYRIGHT			;  | the left and right
		DEC $0094|!dp			;  | arrow keys on
TRYRIGHT:	BIT.w #%0000000000000010	;  | the controller's
		BNE STOP			;  | keypad
		INC $0094|!dp			; /

STOP:		PLY				; Pull Y
		PLX				; Pull X
		PLA				; Pull A
		PLP				; Pull Processor bits
		RTL				; Return