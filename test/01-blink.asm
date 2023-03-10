    .device ATmega164P

    .org 0x0000   ; reset vector
    jmp progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/portb-spi.asm"
    .include "./util/delay.asm"

progStart:
    cli
    setupStackAndReg
    setupBlink
seqStart:
    ldi countReg, 0x20
loop:
    blink
    delayLoopR countReg

    dec countReg
    brne loop
    rjmp seqStart
