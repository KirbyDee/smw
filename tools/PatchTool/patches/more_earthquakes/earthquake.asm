; ========================================
;  Multiple overworld earthquake events
;  Made by Ersanio.
;  Requested by Wizard The Wizzisential
; ========================================
;  Usage: Do not edit the earthquake level
;  trigger in Lunar Magic after applying
;  this patch. Edit it here instead!
;  This patch uses level numbers, not
;  event numbers. Edit table "Levelnums"
; ========================================

HEADER
LOROM

!ADDR = $0000

IF READ1($00FFD5) == $23
	SA1ROM
	!ADDR = $6000
ENDIF

ORG $04E65C
autoclean JML Main

freedata ; this one doesn't change the data bank register, so it uses the RAM mirrors from another bank, so I might as well toss it into banks 40+

;The table holds the OW level numbers where the earthquake will trigger.
;Keep in mind that it is in RAM $13BF format. You can add at most $FF level numbers.
;Use the included .html file to convert OW level numbers to $13BF format.

Levelnums:	db $29,$2A ;levels 105, 106 for multiple levels demonstration
.end

Main:		PHP
		SEP #$10
		LDA $13BF|!ADDR
		LDX.b #Levelnums_end-Levelnums-$01
-		CMP.l Levelnums,x
		BEQ .quake
		DEX
		BPL -
		PLP
		JML $04E668

.quake		LDA #$FF
		STA $1BA0|!ADDR
		PLP
		JML $04E668
