.device ATmega324P

.cseg
.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E
.include "../lib/registers.asm"
.include "../lib/ports.asm"
.include "../lib/display.asm"
.include "../lib/numDisp.asm"
.include "../lib/clock.asm"

.macro delayTick
    clockTick
    getDisplayCell
    portsOut
.endm

.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPorts
    CLR numReg

nextNumber:
    delayLoopI 8
    blink
    clearDisplayBuffer
    numDisplayLeft
    CALL numDisplaySigned
    numDisplayRight
    CALL numDisplayUnsigned
    INC numReg
    RJMP nextNumber
