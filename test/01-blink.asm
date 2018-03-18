    .device ATmega1284P

    .org 0x0000   ; reset vector
    RJMP progStart

    .org 0x0046
    .include "../lib/blink.asm"
    .include "./util/delay.asm"

progStart:
    setupBlink
seqStart:
    LDI r22, 0x20
loop:
    blink
    delayLoopR r22

    DEC r22
    BRNE loop
    RJMP seqStart