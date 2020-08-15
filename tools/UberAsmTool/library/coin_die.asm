!FreeRAMTimer = $1F48|!addr	; You may want to change that. But it's unlikely.
!RAMCounter = $0DBF|!addr	; Can be either freeRAM or used RAM like the coin counter (currently, it's the coin counter)
!GetNoOneUp = 1				; Change this to 0 that you will after collecting a coin while already having 99 (due to the coin counter resetting to 0 and getting a one-up)

!DecreaseTimer = 12			; Remember: 60 frames = 1 second; 40 frames = 1 SMW second

!ShowStatusBar = 0			; Change this to 1 to display the RAM on the status bar

!Initialise = 99			; Set this to zero to disable an initialisation
!InitialiseAtLevelStart = 1	; Make the initialisation only start at the start of a level

!StatusPos = $0F0E|!addr	;
!TileSize = 1				; Change this to 2 if you use the advanced Super Status Bar

!WarningSound = $2A
!WarningPort = $1DFC|!addr

!KaizoTrap = 0				; Set his to 1 to make the counter still decrease during the goal march



init:
	if !Initialise
		if !InitialiseAtLevelStart
			LDA $141A|!addr
			BNE .noInit
		endif
		LDA #!Initialise
		STA !RAMCounter
	.noInit
	endif
		LDA #!DecreaseTimer
		STA !FreeRAMTimer
	if !ShowStatusBar
		JSR display
	endif





main:
	.coindDieCodeMain:
		LDA $9D
		ORA $13D4|!addr
	if !KaizoTrap == 0
		ORA $1493|!addr
	endif
		BNE .coindDieReturn
		LDA !RAMCounter
		BEQ .coinDieKill
		BMI .coinDieKill
	if !RAMCounter == $0DBF|!addr && !GetNoOneUp
		CMP #99
		BCC .notFull
		LDA $13CC|!addr
		BEQ .notFull
		STZ $13CC|!addr
		LDA #99
		STA $0DBF|!addr
		LDA #!DecreaseTimer
		STA !FreeRAMTimer
	.notFull
	endif
		DEC !FreeRAMTimer
		LDA !FreeRAMTimer
		BNE .coindDieReturn
		LDA #!DecreaseTimer
		STA !FreeRAMTimer
		DEC !RAMCounter
		LDA !RAMCounter
		CMP #$0A
		BCS .coindDieReturn
		LDA #!WarningSound
		STA !WarningPort
		BRA .coindDieReturn
	
	.coinDieKill
		LDA #$00
		STA !RAMCounter
		JSL $00F606|!bank
	
	.coindDieReturn:
		RTL