    .DSEG
displayBuffer:
    .BYTE 8

    .CSEG

clearDisplayBuffer:
    LDI quickReg, ' '
    LDI countReg, 8
    LDI XL, low(displayBuffer)
    LDI XH, high(displayBuffer)
clearDBLoop:
    ST X+, quickReg
    DEC countReg
    BRNE clearDBLoop
    RET

scrollDisplayBuffer:
    ; leaves Y with value to store new character in
    LDI XL, low(displayBuffer)  ; shift characters along one from
    LDI XH, high(displayBuffer) ; X
    LDI YL, low(displayBuffer)  ; into
    LDI YH, high(displayBuffer) ; Y
    LD dummyJunkReg, X+         ; dummy operation to INC X
    LDI countReg, 7             ; 7 to shift (leave last one alone)
shiftLoop:
    LD quickReg, X+
    ST Y+, quickReg ; Y now points to last char ready to recieve another one
    DEC countReg
    BRNE shiftLoop
    RET
