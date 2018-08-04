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
    .include "../lib/numDisp.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    CLR numReg

nextNumber:
    delayLoopI 20
    CALL blink

    CALL clearDisplayBuffer

    numDisplayLeft
    CALL numDisplaySigned

    numDisplayRight
    CALL numDisplayUnsigned

    CALL showDisplayBuffer

    INC numReg
    RJMP nextNumber
