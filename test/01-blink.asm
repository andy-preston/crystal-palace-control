    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/blink.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupBlink
seqStart:
    LDI r22, 0x20
loop:
    blink
    delayLoopR r22

    DEC r22
    BRNE loop
    RJMP seqStart
