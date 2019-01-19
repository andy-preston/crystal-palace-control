.device ATmega324P

.cseg
.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E
.include "../lib/registers.asm"
.include "../lib/portB.asm"
.include "../lib/max7221.asm"
.include "../lib/display.asm"
.include "../lib/numDisp.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupSpi
    setupMax7221
    CLR highReg
    CLR lowReg

nextNumber:
    delayLoopI 16
    blink

    clearTextBuffer
    numDisplayLeft
    CALL numDisplaySigned
    numDisplayRight
    CALL numDisplayUnsigned

    displayTextBuffer
    ADIW lhReg, 1
    ANDI highReg, 0b0000000011 ; only for 10 bit numbers
    RJMP nextNumber
