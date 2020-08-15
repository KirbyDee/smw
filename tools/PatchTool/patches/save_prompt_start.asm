;===========================================
; Bring up Save Prompt By pressing Start
; By Erik
;
; Brings up the save prompt by pressing
; start in the overworld, as long as Mario
; is not moving anywhere.
;===========================================

if read1($00FFD5) = $23
        sa1rom
        !addr   = $6000
else
        lorom
        !addr   = $0000
endif

padbyte $EA             ;   replace unused code with NOPs

org $048375             ;   remove submap checks
        BRA +           ;\  skip submap check       
        pad $04837D     ;/  placeholder NOPs
org $04837D
+

org $048383                     ;   swap action that happens when start was pressed
        LDA $13D9|!addr         ;\
        CMP #$03                ; | don't do anything if not in a level tile
        BNE +                   ;/
        autoclean JSL save      ;   save some other ow stuff
        INC $13CA|!addr         ;   save prompt is being brought up
        JSR $9037               ;   make save prompt appear
        BRA +                   ;   skip
        pad $04839A
org $0483C3
+

freedata
save:                           ;   based around $048F94
        LDX #$2C                ;\
-       LDA $1F02|!addr,x       ; |
        STA $1FA9|!addr,x       ; | update some misc stuff in the save buffer not updated in $049037
        DEX                     ; |
        BPL -                   ;/
        REP #$30                ;   16-bit axy
        LDX $0DD6|!addr         ;\
        TXA                     ; | load mario/luigi data on x and luigi/mario data on y
        EOR #$0004              ; |
        TAY                     ;/
        LDA $1FBE|!addr,x       ;\
        STA $1FBE|!addr,y       ; |
        LDA $1FC0|!addr,x       ; |
        STA $1FC0|!addr,y       ; | sync x/y positions and its pointers between players
        LDA $1FC6|!addr,x       ; |
        STA $1FC6|!addr,y       ; |
        LDA $1FC8|!addr,x       ; |
        STA $1FC8|!addr,y       ;/
        TXA                     ;\
        LSR                     ; |
        TAX                     ; | more of the same
        EOR #$0002              ; |
        TAY                     ;/
        LDA $1FBA|!addr,x       ;\  sync player animations
        STA $1FBA|!addr,y       ;/
        TXA                     ;\
        SEP #$30                ; | 8-bit axy
        LSR                     ; |
        TAX                     ; | more of the same
        EOR #$01                ; |
        TAY                     ;/
        LDA $1FB8|!addr,x       ;\  sync submap between players
        STA $1FB8|!addr,y       ;/
        RTL

