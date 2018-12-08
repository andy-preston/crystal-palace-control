    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/blink.asm"
    .include "../lib/portC.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupBlink
    setupPortC
loop:
    clockTick
    CALL blink
    delayLoopI 0x20
    RJMP loop
