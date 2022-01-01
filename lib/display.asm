    .dseg

textBuffer:
    .byte 8

    .cseg

.macro clearTextBuffer
    ldi XL, low(textBuffer)
    ldi XH, high(textBuffer)
    ldi stringLReg, 8
    ldi quickReg, 0
clearBufLoop:
    st X+, quickReg
    dec stringLReg
    brne clearBufLoop
.endMacro

.macro scrollTextBuffer
    ldi XL, low(textBuffer)         ; shift characters along one from
    ldi XH, high(textBuffer)        ; X
    ldi YL, low(textBuffer)         ; into
    ldi YH, high(textBuffer)        ; Y
    adiw X, 1
    ldi stringLReg, 7               ; 7 to shift (leave last one alone)
shiftLoop:
    ld quickReg, X+
    st Y+, quickReg                 ; Y now points to last char ready to receive next
    dec stringLReg
    brne shiftLoop
.endMacro                           ; leaves Y with value to store new character in

.macro translateCharacter           ; displayReg, ASCII code -> 7 seg code
    cpi displayReg, 0
    breq gotChar
;notNull
    cpi displayReg, ' '
    brne notSpace
    ldi displayReg, 0
    rjmp gotChar
notSpace:
    cpi displayReg, '-'
    brne notMinus
    ldi displayReg, 1
    rjmp gotChar
notMinus:
    cpi displayReg, 'a'             ; currently only works with lower case!!!
    brge isAlpha
;isNum
    ldi ZL, low(charNumeric << 1)   ; BYTE ADDRESS (word address*2) of the table
    ldi ZH, high(charNumeric << 1)
    subi displayReg, '0'            ; reduce character code to table offset
    rjmp getCharFromDefs
isAlpha:
    ldi ZL, low(charAlphabet << 1)  ; BYTE ADDRESS (word address*2) of the table
    ldi ZH, high(charAlphabet << 1)
    subi displayReg, 'a'            ; reduce character code to table offset
getCharFromDefs:
    add ZL, displayReg
    adc ZH, dummyZeroReg
    lpm displayReg, Z
gotChar:
.endMacro

.macro displayTextBuffer
    ldi XL, low(textBuffer)
    ldi XH, high(textBuffer)
    ldi portReg, Max7221RegisterDigit0
displayTextLoop:
    ld displayReg, X+
    translateCharacter
    call max7221SetRegister
    ; The Motram Labs board needs this to be a decrement
    inc portReg
    ; The Motram Labs board needs this to be "- 1" not "+ 1"
    cpi portReg, (Max7221RegisterDigit7 + 1)
    brne displayTextLoop
.endMacro

charNumeric:
    ;    0           1           2           3
    .db 0b01111110, 0b00000110, 0b01101101, 0b01111001
    ;    4           5           6           7
    .db 0b00110011, 0b01011011, 0b01011111, 0b01110000
    ;    8           9
    .db 0b01111111, 0b01111011

charAlphabet:
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
