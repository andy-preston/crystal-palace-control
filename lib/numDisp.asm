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
    PUSH countReg            ; countReg contains number to display
    CLR calcReg

numDisplayLoop:
    MOV quickReg, countReg
    SUBI countReg, 10
    BRCS numDisplayNextDigit
    INC calcReg
    RJMP numDisplayLoop

numDisplayNextDigit:
    LDI countReg, '0'       ; use countReg as a "double quick quickReg" to conv BCD to ASCII ;)
    ADD quickReg, countReg  ; quickReg is the old value of countReg before 10 was subtracted
    ST -X, quickReg

    MOV countReg, calcReg
    CPI countReg, 0
    BRNE numDisplay
    POP countReg
    RET
