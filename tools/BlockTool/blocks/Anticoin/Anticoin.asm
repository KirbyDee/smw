; Anticoin with sound by SL converted by DiscoMan improved by Erik557
; Original description: "The contrary of a coin. Includes an anticoin with sound too."
; Acts like "25"

!Sub1Up       = 1           ; 0: Don't do anything when the coin counter is zero
                            ; 1: Substract a 1-Up if the coin counter is zero. Kill Mario if only 1 life
                            ; 2: Kill Mario if the coin counter is zero

!Rollover     = 0           ; If the above is 1:
                            ; 0: Let the coin counter at zero 
                            ; 1: Rollover to 99
                            ; If the above is 0 or 2, this option does nothing.

if !Sub1Up == 2             ; elseif doesn't work
       print "Decreases the coin counter unless it's already zero, in which case it kills Mario."
endif
if !Sub1Up == 1
       print "Decreases the coin counter unless it's already zero, in which case it substracts an 1-Up."
endif
if !Sub1Up == 0
       print "Decreases the coin counter unless it's already zero."
endif

db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return : JMP Mario : JMP Mario : JMP Mario

Mario:
       LDA $14AD|!addr      ;\ Return if P-Switch isn't set
       BEQ .decrease        ;/
       LDY #$01             ;\
       LDA #$30             ; | Act as brown block if it is
       STA $1693|!addr      ;/
       RTL
.decrease
       LDA $0DBF|!addr      ;\ If there's no coin
       BEQ .doAction        ;/ do an specific action
       DEC $0DBF|!addr      ; decrement
       BRA .end
.doAction
       if !Sub1Up == 2
              JSL $00F606|!bank    ; kill Mario
       endif
       if !Sub1Up == 1
              DEC $0DBE            ;\ kill Mario if only 1 life
              BMI .kill            ;/
              if !Rollover == 1
                     LDA #99       ;\ reset coin counter
                     STA $0DBF     ;/
              endif
              BRA .end
       .kill
              JSL $00F606|!bank    ; game over kid =.=
       endif
.end
       %glitter()
       %erase_block()
       LDA #$2A             ;\ Play the Incorrect SFX
       STA $1DFC|!addr      ;/
Return:
       RTL

