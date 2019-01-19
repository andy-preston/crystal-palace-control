.device ATmega324P

.cseg

.org 0x0000 ; reset vector
    JMP progStart

.org 0x003E

.include "../lib/registers.asm"
.include "../lib/portB.asm"
.include "../lib/max7221.asm"
.include "../lib/display.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupSpi
    setupMax7221

    LDI XL, low(textBuffer)
    LDI XH, high(textBuffer)

    LDI dispReg, 'c'
    ST X+, dispReg

    LDI dispReg, 'r'
    ST X+, dispReg

    LDI dispReg, 'y'
    ST X+, dispReg

    LDI dispReg, 's'
    ST X+, dispReg

    LDI dispReg, 't'
    ST X+, dispReg

    LDI dispReg, 'a'
    ST X+, dispReg

    LDI dispReg, 'l'
    ST X+, dispReg

    LDI dispReg, 'p'
    ST X+, dispReg

    displayTextBuffer

waiting:
    blink
    delayLoopI 16
    JMP waiting
