.MACRO numDisplayLeft
    LDI XL, low(displayBuffer + 4)
    LDI XH, high(displayBuffer + 4)
.ENDMACRO

.MACRO numDisplayRight
    LDI XL, low(displayBuffer + 8)
    LDI XH, high(displayBuffer + 8)
.ENDMACRO

numDisplay:
    CLR calcReg
numDisplayLoop:
    SUBI quickReg, 10
    BRCS numDisplayNextDigit
    INC calcReg
    RJMP numDisplayLoop

numDisplayNextDigit:
    SUBI quickReg, -58    ; add the overflowed back on and
                          ; convert BCD to ASCII by adding ASCII('0'), 48
    ST -X, quickReg
    MOV quickReg, calcReg
    CPI quickReg, 0
    BRNE numDisplay
    RET
