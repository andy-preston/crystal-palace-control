    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupBlink
    setupStackAndReg
    setupChipSelect
resetOutput:
    LDI countReg, 0
loop:
    MOV portReg, countReg
    CALL chipSelect

    delayLoopI 0x10
    CALL blink

    chipDeselect

    delayLoopI 0x10
    CALL blink

    INC countReg
    CPI countReg, 16 ; chip select goes from 0-15
    BREQ resetOutput

    RJMP loop ; otherwise skip on to the next blip