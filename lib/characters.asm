    .CSEG

charnum:
    ;    0           1           2           3
    .DB 0b01111110, 0b00000110, 0b01101101, 0b01111001
    ;    4           5           6           7
    .DB 0b00110011, 0b01011011, 0b01011111, 0b01110000
    ;    8           9
    .DB 0b01111111, 0b01111011

charalpha:
    ;    a           b           c           d
    .DB 0b01110111, 0b00011111, 0b01001110, 0b00111101
    ;    e           f           g           h
    .DB 0b01001111, 0b01000111, 0b01011110, 0b00110111
    ;    i           j           k           l
    .DB 0b00010000, 0b00111000, 0b00000111, 0b00001110
    ;    m           n           o           p
    .DB 0b01010101, 0b00010101, 0b00011101, 0b01100111
    ;    q           r           s           t
    .DB 0b01110011, 0b00000101, 0b01011011, 0b00001111
    ;    u           v           w           x
    .DB 0b00011100, 0b00111110, 0b01011100, 0b01001001
    ;    y           z
    .DB 0b00111011, 0b01101101

.MACRO getCharI
    LDI addrLReg, @0
    CALL getChar
.ENDMACRO

; expects ASCII code in addrLReg - Returns 7 segment binary in valReg
getChar:
    CPI addrLReg, ' '
    BRNE notSpace
    LDI valReg, 0
    RET
notSpace:
    CPI addrLReg, 'a'            ; currently only works with lower case!!!
    BRGE isAlpha
;isNum
    LDI ZL, low(charNum << 1)    ; BYTE ADDRESS (word address*2) of the table
    LDI ZH, high(charNum << 1)
    SUBI addrLReg, '0'           ; reduce character code to table offset
    JMP returnChar
isAlpha:
    LDI ZL, low(charAlpha << 1)  ; BYTE ADDRESS (word address*2) of the table
    LDI ZH, high(charAlpha << 1)
    SUBI addrLReg, 'a'           ; reduce character code to table offset
returnChar:
    ADD ZL, addrLReg
    ADC ZH, dummyZeroReg
    LPM valReg, Z
    RET
