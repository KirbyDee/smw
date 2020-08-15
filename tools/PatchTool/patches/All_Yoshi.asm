if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
else
	lorom
	!addr = $0000
	!bank = $800000
endif

ORG $008FD8|!bank		;handles drawing of yoshi-coins in status bar
autoclean JML YoshiCode		;Jump to my code


freecode
YoshiCode:
	LDA $1422|!addr
	CMP #$05
	BCS .write

	LDA $13BF|!addr		;\
	LSR A			; |
	LSR A			; | Get Index
	LSR A			; |
	TAY			;/
	LDA $13BF|!addr		;\
	AND #$07		; |
	TAX			; | Check Bit
	LDA $1F2F|!addr,y	; |
	AND $0DA8A6|!bank,x	;/	
	BEQ .notCollected

.write
	LDA #$0A		;\
	STA $0EFF|!addr		; |
	LDA #$15		; |
	STA $0F00|!addr		; | Write the "ALL0" (0 stands for the coin symbol)
	STA $0F01|!addr		; |
	LDA #$2E		; |
	STA $0F02|!addr		;/
	JML $008FF9|!bank	;   Return to normal routine.

.notCollected
	LDA $1422|!addr		;\
	DEC A			; | Some restore stuff
	STA $00			;/
	JML $008FE4|!bank	;   Return to normal routine.