    .device ATmega164P

    .cseg

    .org 0x0000 ; reset vector
    jmp progStart

    .org 0x003E

    .include "../lib/registers.asm"
    .include "../lib/portb-spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/display.asm"
    .include "./util/delay.asm"

progStart:
    cli
    setupStackAndReg
    setupSpi
    setupMax7221

    ldi XL, low(textBuffer)
    ldi XH, high(textBuffer)

    ldi displayReg, 'c'
    st X+, displayReg

    ldi displayReg, 'r'
    st X+, displayReg

    ldi displayReg, 'y'
    st X+, displayReg

    ldi displayReg, 's'
    st X+, displayReg

    ldi displayReg, 't'
    st X+, displayReg

    ldi displayReg, 'a'
    st X+, displayReg

    ldi displayReg, 'l'
    st X+, displayReg

    ldi displayReg, 'p'
    st X+, displayReg

    displayTextBuffer

waiting:
    blink
    delayLoopI 16
    jmp waiting
