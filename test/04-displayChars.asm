    .device ATmega324P

    .CSEG
    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/blink.asm"
    .include "../lib/spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/characters.asm"
    .include "../lib/display.asm"
    .include "./util/delay.asm"

testString:
    .DB "0123456789-abcdefghijklmnopqrstuvwxyz  \@"

progStart:
    CLI
    setupStackAndReg
    setupSpi
    setupMax7221
    CALL clearDisplayBuffer

stringStart:
    LDI stringLReg, 0 ; stringReg points to character in testString

displayStart:
    delayLoopI 20
    CALL blink

    CALL showDisplayBuffer;
    CALL scrollDisplayBuffer       ; Y now points to last char ready to recieve another one

    LDI ZL, low(testString << 1)   ; get from testString in progam memory
    LDI ZH, high(testString << 1)
    ADD ZL, stringLReg             ; stringReg holds the current offset
    ADC ZH, dummyZeroReg
    LPM quickReg, Z
    CPI quickReg, 0                ; NULL Terminator
    BREQ stringStart               ; back to start of string
    ST Y, quickReg                 ; Y is last char - after shift operation

    INC stringLReg
    JMP displayStart               ; or display next char
