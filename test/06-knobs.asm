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
    .include "../lib/numDisp.asm"
    .include "../lib/portC.asm"
    .include "../lib/analog.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPortC
    setupAnalog
    setupSpi
    setupMax7221
    LDI countReg, 0

nextNumber:
    CPI countReg, 0
    BRNE skipTick
    clockTick

skipTick:

    delayLoopI 2
    INC countReg
    CALL blink

    CALL clearDisplayBuffer

    analogStart ; we'll only read port 1 at this stage
    analogRead

    numDisplayRight
    MOV numReg, inputLReg
    CALL numDisplayUnsigned


    numDisplayLeft
    MOV numReg, clockReg
    ANDI numReg, 0b00011111
    CALL numDisplayUnsigned

    CALL showDisplayBuffer

    RJMP nextNumber
