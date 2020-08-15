;if read1($00FFD5) == $23
;	sa1rom
;	!addr	= $6000
;else
;	lorom
;	!addr	= $0000
;endif




init:			
	RTL


main:
;	LDA $7E0019 ; check powerup state
;	BEQ .return
;	JML $00F606 ; kill mario

.return:
	RTL 




;org $01C554				; Disable "growing big" animation from collecting Mushroom while small
;	db $6D				; Repoints jump table past animation setup

;org $01C56C				; 
;	NOP	