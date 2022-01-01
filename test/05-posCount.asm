    .device ATmega164P

    .cseg
    .org 0x0000   ; reset vector
    jmp progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/portb-spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/display.asm"
    .include "../lib/numDisplay.asm"
    .include "./util/delay.asm"

progStart:
    cli
    setupStackAndReg
    setupSpi
    setupMax7221
    clr highReg
    clr lowReg

nextNumber:
    delayLoopI 16
    blink

    clearTextBuffer
    numDisplayLeft
    call numDisplaySigned
    numDisplayRight
    call numDisplayUnsigned

    displayTextBuffer
    adiw lhReg, 1
    andi highReg, 0b0000000011 ; only for 10 bit numbers
    rjmp nextNumber
