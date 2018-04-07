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
    LDI r22, 0b000001
loop:
    blink
    csPortR r22
    delayLoopI 0x20

    LSL r22 ; shift to next output pin
    BREQ resetOutput ; if it's all zeros, restart at 1

    RJMP loop ; otherwise skip on to the next blip