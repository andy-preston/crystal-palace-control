    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/stack.asm"
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "../lib/spi.asm"
    .include "../lib/max7221.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStack
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    LDI regReg, Max7221RegisterDigit0
    LDI valReg, 0b01001110 ; c
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit1
    LDI valReg, 0b00000101 ; r
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit2
    LDI valReg, 0b00111011 ; y
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit3
    LDI valReg, 0b01011011 ; s
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit4
    LDI valReg, 0b00001111 ; t
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit5
    LDI valReg, 0b01110111 ; a
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit6
    LDI valReg, 0b10001110 ; l.
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit7
    LDI valReg, 0b01100111 ; p
    max7221SetRegister

    LDI countReg, 0x0F
loop:
    delayLoopI 3
    CALL blink

    LDI regReg, Max7221RegisterIntensity
    MOV valReg, countReg
    max7221SetRegister

    DEC countReg
    RJMP loop
