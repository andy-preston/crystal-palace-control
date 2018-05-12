    .device ATmega324P

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
    .include "../lib/display.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    CLR countReg

nextNumber:
    delayLoopI 10
    CALL blink

    CALL clearDisplayBuffer
    LDI XL, low(displayBuffer + 4)
    LDI XH, high(displayBuffer + 4)
    MOV quickReg, countReg
    INC countReg

numConvStart:
    CLR calcReg
numConvLoop:
    SUBI quickReg, 10
    BRCS numConvNextDigit
    INC calcReg
    RJMP numConvLoop

numConvNextDigit:
    SUBI quickReg, -58    ; add the overflowed back on and
                          ; convert BCD to ASCII by adding ASCII('0'), 48
    ST -X, quickReg
    MOV quickReg, calcReg
    CPI quickReg, 0
    BRNE numConvStart


    CALL showDisplayBuffer
    RJMP nextNumber
