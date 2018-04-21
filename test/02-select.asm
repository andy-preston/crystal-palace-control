    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/stack.asm"
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStack
    setupBlink
    setupChipSelect
resetOutput:
    LDI r26, 0
loop:
    blink
    CALL chipSelect
    delayLoopI 0x10

    blink
    chipDeselect
    delayLoopI 0x10

    INC r26
    CPI r26, 16 ; chip select goes from 0-15
    BREQ resetOutput

    RJMP loop ; otherwise skip on to the next blip