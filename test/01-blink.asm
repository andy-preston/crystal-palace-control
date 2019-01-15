.device ATmega324P

.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E
.include "../lib/registers.asm"
.include "../lib/portB.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupBlink
seqStart:
    LDI countReg, 0x20
loop:
    blink
    delayLoopR countReg

    DEC countReg
    BRNE loop
    RJMP seqStart
