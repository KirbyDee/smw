;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable Death Scrolling ; by Ruberjig
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This makes it so that when the player dies, the screen doesn't scroll vertically anymore.

main:
	LDA $71		;Player animation trigger...
	CMP #$09	;If the player is dying...
	BNE +
	STZ $1411|!addr
	STZ $1412|!addr
+	RTL