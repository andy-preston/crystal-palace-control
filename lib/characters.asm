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

; expects ASCII code in quickReg - returns 7 segment binary in quickReg
getChar:
    mov addrLReg, quickReg
    cpi addrLReg, 'a'           ; currently only works with lower case!!!
    brge isAlpha
;isNum
    ldi ZL, low(charNum << 1)   ; BYTE ADDRESS (word address*2) of the table
    ldi ZH, high(charNum << 1)
    subi addrLReg, '0'           ; reduce character code to table offset
    JMP returnChar
isAlpha:
    ldi ZL, low(charAlpha << 1) ; BYTE ADDRESS (word address*2) of the table
    ldi ZH, high(charAlpha << 1)
    subi addrLReg, 'a'           ; reduce character code to table offset
returnChar:
    ldi addrHReg, 0             ; load a dummy 0 for 16-bit addition
    add ZL, addrLReg
    adc ZH, addrHReg
    lpm quickReg, Z
    ret
