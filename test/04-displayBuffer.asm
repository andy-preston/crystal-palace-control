    .device ATmega324P

    .DSEG
    .org 0x0100
displayBuffer:
    .BYTE 8

    .CSEG
    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "../lib/spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/characters.asm"
    .include "./util/delay.asm"

testString:
    .DB "0123456789abcdefghijklmnopqrstuvwxyz  "

progStart:
    CLI
    setupStackAndReg
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    LDI quickReg, ' ' ; One off - clear the display buffer
    LDI countReg, 8
    LDI XL, low(displayBuffer)
    LDI XH, high(displayBuffer)
clearLoop:
    ST X+, quickReg
    DEC countReg
    BRNE clearLoop

stringStart:
    LDI stringLReg, 0 ; stringReg points to character in testString

displayStart:
    delayLoopI 0x20
    call blink

    LDI XL, low(displayBuffer)
    LDI XH, high(displayBuffer)  ; move display buffer
    LDI regReg, Max7221RegisterDigit0 ; into Max7221 registers
displayLoop:
    LD addrLReg, X+    ; addrLReg for getChar
    CALL getChar       ; ASCII code in addrLReg -> 7 seg code in valReg
    max7221SetRegister ; register number in regReg, 7 seg code in valReg
    INC regReg
    CPI regReg, (Max7221RegisterDigit7 + 1)
    BRNE displayLoop

    LDI XL, low(displayBuffer)  ; shift characters along one from
    LDI XH, high(displayBuffer) ; X
    LDI YL, low(displayBuffer)  ; into
    LDI YH, high(displayBuffer) ; Y
    LD quickReg, X+             ; dummy operation to INC X
    LDI countReg, 7             ; 7 to shift (leave last one alone)
shiftLoop:
    LD quickReg, X+
    ST Y+, quickReg ; Y now points to last char ready to recieve another one
    DEC countReg
    BRNE shiftLoop

    LDI ZL, low(testString << 1)   ; get from testString in progam memory
    LDI ZH, high(testString << 1)
    ADD ZL, stringLReg             ; stringReg holds the current offset
    ADC ZH, dummyZeroReg
    LPM quickReg, Z
    ST Y, quickReg                 ; Y is last char - after shift operation
    CPI quickReg, ' '              ; space is the last char
    BREQ stringStart               ; back to start of string

    INC stringLReg
    JMP displayStart               ; or display next char
