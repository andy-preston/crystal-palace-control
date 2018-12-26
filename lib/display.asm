.dseg

displayBuffer:
    .byte 8

.cseg

.macro clearDisplayBuffer
    LDI XL, low(displayBuffer)
    LDI XH, high(displayBuffer)
    LDI countReg, 8
    LDI quickReg, ' '
clearDBLoop:
    ST X+, quickReg
    DEC countReg
    BRNE clearDBLoop
.endm

.macro scrollDisplayBuffer
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
.endm

.macro getDisplayCell
    LDI XL, low(displayBuffer)
    LDI XH, high(displayBuffer) ; move display buffer
    MOV quickReg, clockReg      ; get display cell from clockReg
    ANDI quickReg, 0b00000111   ; there's only 8 display cells
    ADD XL, quickReg            ; buffer displacement
    ADC XH, dummyZeroReg
    LD dispReg, X

    ; ASCII code -> 7 seg code
    CPI dispReg, ' '
    BRNE notSpace
    LDI dispReg, 0
    RJMP gotChar
notSpace:
    CPI dispReg, '-'
    BRNE notMinus
    LDI dispReg, 1
    RJMP gotChar
notMinus:
    CPI dispReg, 'a'              ; currently only works with lower case!!!
    BRGE isAlpha
;isNum
    LDI ZL, low(charNum << 1)    ; BYTE ADDRESS (word address*2) of the table
    LDI ZH, high(charNum << 1)
    SUBI dispReg, '0'             ; reduce character code to table offset
    RJMP getCharFromDefs
isAlpha:
    LDI ZL, low(charAlpha << 1)  ; BYTE ADDRESS (word address*2) of the table
    LDI ZH, high(charAlpha << 1)
    SUBI dispReg, 'a'             ; reduce character code to table offset
getCharFromDefs:
    ADD ZL, dispReg
    ADC ZH, dummyZeroReg
    LPM dispReg, Z
gotChar:
.endm

charnum:
;    0           1           2           3
.db 0b01111110, 0b00000110, 0b01101101, 0b01111001
;    4           5           6           7
.db 0b00110011, 0b01011011, 0b01011111, 0b01110000
;    8           9
.db 0b01111111, 0b01111011

charalpha:
;    a           b           c           d           e           f
.db 0b01110111, 0b00011111, 0b01001110, 0b00111101, 0b01001111, 0b01000111
;    g           h           i           j           k           l
.db 0b01011110, 0b00110111, 0b00010000, 0b00111000, 0b00000111, 0b00001110
;    m           n           o           p           q           r
.db 0b01010101, 0b00010101, 0b00011101, 0b01100111, 0b01110011, 0b00000101
;    s           t           u           v           w           x
.db 0b01011011, 0b00001111, 0b00011100, 0b00111110, 0b01011100, 0b01001001
;    y           z
.db 0b00111011, 0b01101101
