.device ATmega324P

.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E

.macro delayTick
    NOP
.endm

.include "../lib/registers.asm"
.include "../lib/ports.asm"
.include "../lib/clock.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPorts
loop:
    clockTick
    portsOut
    blink
    delayLoopI 0x20
    RJMP loop
