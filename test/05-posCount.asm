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
.include "./util/delayTickDisplay.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPorts
    CLR highReg
    CLR lowReg
    clearBuffer displayBuffer

    ;LDI highReg, high(512)
    ;LDI lowReg, low(512)

nextNumber:
    delayLoopI 16
    blink

    clearBuffer textBuffer
    numDisplayLeft
    CALL numDisplaySigned
    numDisplayRight
    CALL numDisplayUnsigned

    translateBuffer
    ADIW lhReg, 1
    ANDI highReg, 0b0000000011 ; only for 10 bit numbers
    RJMP nextNumber
