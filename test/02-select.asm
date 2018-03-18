    .device ATmega1284P

    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "./util/delay.asm"

    .org 0x0000   ; reset vector
    RJMP progStart

    .org 0x0046
progStart:
    setupBlink
    setupChipSelect
resetOutput:
    LDI r22, 0b000001
loop:
    blink
    chipSelectR r22
    delayLoopI 0x20

    LSL r22 ; shift to next output pin
    BREQ resetOutput ; if it's all zeros, restart at 1

    RJMP loop ; otherwise skip on to the next blip