.MACRO numDisplayLeft
    LDI XL, low(displayBuffer + 4)
    LDI XH, high(displayBuffer + 4)
.ENDMACRO

.MACRO numDisplayRight
    LDI XL, low(displayBuffer + 8)
    LDI XH, high(displayBuffer + 8)
.ENDMACRO

; TODO: use a better register for this countReg is only really suitable for testing
numDisplay:
    CLR calcReg

numDisplayLoop:
    MOV quickReg, countReg   ; countReg contains number to display
    SUBI countReg, 10
    BRCS numDisplayFoundDigit
    INC calcReg
    RJMP numDisplayLoop

numDisplayFoundDigit:
    LDI countReg, '0'       ; use countReg as a "double quick quickReg" to conv BCD to ASCII ;)
    ADD quickReg, countReg  ; quickReg is the old value of countReg before 10 was subtracted
    ST -X, quickReg

    MOV countReg, calcReg
    CPI countReg, 0
    BRNE numDisplay
    RET

numDisplayUnsigned:
    PUSH countReg
    CALL numDisplay
    POP countReg
    RET

; Not true two-compliment negative - maps 0 -> 255 to -127 -> 128
numDisplaySigned:
    PUSH countReg
    CPI countReg, 128
    BRLO numDisplayNegative
; numDisplayPositive
    SUBI countReg, 127
    CALL numDisplay
    RJMP numDisplaySignedDone
numDisplayNegative:
    LDI quickReg, 127
    SUB quickReg, countReg
    MOV countReg, quickReg
    CALL numDisplay

    LDI quickReg, '-'
    ST -X, quickReg
numDisplaySignedDone:
    POP countReg
    RET