; This isn't good enough for 16 bit values.
; The ADC is 10 bit 0 -> 1023 (signed 3 digits + sign ... -511 -> 512)

.macro numDisplayLeft
    LDI XL, low(textBuffer)
    LDI XH, high(textBuffer)
.endm

.macro numDisplayRight
    LDI XL, low(textBuffer + 4)
    LDI XH, high(textBuffer + 4)
.endm

; ------------------------------------------------------------------------------

numDisplayDigit:
    CPI dispReg, '0'         ; if not 0, just display
    BRNE noLeading0
    BRTC noLeading0          ; if 0 but other digits displayed, show the 0
    LDI dispReg, ' '
    RJMP numDisplayDoDigit
noLeading0:
    CLT
numDisplayDoDigit:
    ST X+, dispReg
    RET

; ------------------------------------------------------------------------------

numDisplayShared:
    SET                      ; leading 0 flag
    LDI dispReg, '0' - 1

numDisplay1000:
    INC dispReg
    MOV saveLReg, lowReg
    MOV saveHReg, highReg
    SUBI lowReg, low(1000)
    SBCI highReg, high(1000)
    BRCC numDisplay1000
    MOV lowReg, saveLReg      ; restore number from before overflow
    MOV highReg, saveHReg
    CALL numDisplayDigit

    LDI dispReg, '0' - 1
numDisplay100:
    INC dispReg
    MOV saveLReg, lowReg
    MOV saveHReg, highReg
    SUBI lowReg, low(100)
    SBCI highReg, high(100)
    BRCC numDisplay100
    MOV lowReg, saveLReg      ; restore number from before overflow
    MOV highReg, saveHReg
    CALL numDisplayDigit

    LDI dispReg, '0' - 1
    CLR saveHReg
numDisplay10:
    INC dispReg
    MOV saveLReg, lowReg
    SUBI lowReg, 10
    BRCC numDisplay10
    MOV lowReg, saveLReg      ; restore number from before overflow
    MOV highReg, saveHReg
    CALL numDisplayDigit

numDisplayUnit:
    CLT ; even if it is all zeros, we want to see the last one
    LDI dispReg, '0'
    ADD dispReg, lowReg
    CALL numDisplayDigit
    RET

; ------------------------------------------------------------------------------

numDisplayUnsigned:
    PUSH highReg
    PUSH lowReg
    CALL numDisplayShared
numDisplayExit:
    POP lowReg
    POP highReg
    RET

; ------------------------------------------------------------------------------

; Not true two-compliment negative - maps 0 -> 1023 to -511 -> 512
numDisplaySigned:
    PUSH highReg
    PUSH lowReg

    CPI highReg, high(512)
    BRLT numDisplayNegative
    SUBI lowReg, low(511)
    SBCI highReg, high(511)
    CALL numDisplayShared
    RJMP numDisplayExit

numDisplayNegative:
    MOVW Z, lhReg
    LDI lowReg, low(511)
    LDI highReg, high(511)
    SUB lowReg, ZL
    SBC highReg, ZH
    CALL numDisplayShared
minusSignLoop:

    ; TODO: Add the negative sign

    ;LD dispReg, -X
    ;CPI dispReg, ' '
    ;BRNE minusSignLoop
    ;LDI dispReg, '-'
    ;ST X, dispReg
    RJMP numDisplayExit
