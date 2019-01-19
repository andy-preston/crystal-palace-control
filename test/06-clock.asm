.device ATmega324P

.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E

.include "../lib/registers.asm"
.include "../lib/portB.asm"
.include "../lib/portC.asm"
.include "../lib/max7221.asm"
.include "../lib/display.asm"
.include "../lib/numDisp.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupSpi
    setupMax7221
    setupPortC
    CLR highReg
loop:
    delayLoopI 64
    blink
    clearTextBuffer

    clockTick
    numDisplayLeft
    MOV lowReg, portReg
    CALL numDisplayUnsigned

    readC
    numDisplayRight
    MOV lowReg, inputReg
    CALL numDisplayUnsigned

    displayTextBuffer

    RJMP loop
