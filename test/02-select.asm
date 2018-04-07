    .device ATmega1284P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupBlink
    setupChipSelect
resetOutput:
    LDI r26, 0
loop:
    blink
    CALL chipSelect
    delayLoopI 0x20

    INC r26
    CPI r26, 0b00001000
    BREQ resetOutput

    RJMP loop ; otherwise skip on to the next blip