; TODO: need an "analog debounce"

.device ATmega324P

.cseg
.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E
.include "../lib/registers.asm"
.include "../lib/portA.asm"
.include "../lib/portB.asm"
.include "../lib/portC.asm"
.include "../lib/max7221.asm"
.include "../lib/display.asm"
.include "../lib/numDisp.asm"
.include "./util/delay.asm"

progStart:
    CLI
    setupStackAndReg
    setupPortC
    setupAnalog
    setupSpi
    setupMax7221
    CLR countReg

nextNumber:
    CPI countReg, 0
    BRNE skipTick
    clockTick

skipTick:
    delayLoopI 4
    INC countReg
    blink

    clearTextBuffer

    analogStart
    analogRead

    numDisplayRight ; display analog value
    MOV lowReg, inputLReg
    MOV highReg, inputHReg
    CALL numDisplayUnsigned

    numDisplayLeft ; display clock value
    MOV lowReg, clockReg
    ANDI lowReg, 0b00011111
    CLR highReg
    CALL numDisplayUnsigned

    displayTextBuffer
    RJMP nextNumber
