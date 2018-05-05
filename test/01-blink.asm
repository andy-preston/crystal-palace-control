    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/stack.asm"
    .include "../lib/blink.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStack
    setupBlink
seqStart:
    LDI countReg, 0x20
loop:
    call blink
    delayLoopR countReg

    DEC countReg
    BRNE loop
    RJMP seqStart
