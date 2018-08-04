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
    MOV quickReg, numReg   ; numReg contains number to display
    SUBI numReg, 10
    BRCS numDisplayFound
    INC calcReg
    RJMP numDisplayLoop

numDisplayFound:
    LDI numReg, '0'        ; use numReg as a "double quick quickReg" to conv BCD to ASCII ;)
    ADD quickReg, numReg   ; quickReg is the old value of numReg before 10 was subtracted
    ST -X, quickReg

    MOV numReg, calcReg
    CPI numReg, 0
    BRNE numDisplay
    RET

numDisplayUnsigned:
    PUSH numReg            ; Oh baby, baby!
    CALL numDisplay
    POP numReg
    RET

; Not true two-compliment negative - maps 0 -> 255 to -127 -> 128
numDisplaySigned:
    PUSH numReg            ; Oh baby, baby!
    CPI numReg, 128
    BRLO numDisplayNegative
; numDisplayPositive
    SUBI numReg, 127
    CALL numDisplay
    RJMP numDisplaySignedDone
numDisplayNegative:
    LDI quickReg, 127
    SUB quickReg, numReg
    MOV numReg, quickReg
    CALL numDisplay

    LDI quickReg, '-'
    ST -X, quickReg
numDisplaySignedDone:
    POP numReg
    RET