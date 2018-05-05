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
    .include "../lib/characters.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStack
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    getCharI 'c'
    ; LDI valReg, 0b01001110
    LDI regReg, Max7221RegisterDigit0
    max7221SetRegister

    getCharI 'r'
    ; LDI valReg, 0b00000101
    LDI regReg, Max7221RegisterDigit1
    max7221SetRegister

    getCharI 'y'
    ; LDI valReg, 0b00111011
    LDI regReg, Max7221RegisterDigit2
    max7221SetRegister

    getCharI 's'
    ; LDI valReg, 0b01011011
    LDI regReg, Max7221RegisterDigit3
    max7221SetRegister

    getCharI 't'
    ; LDI valReg, 0b00001111
    LDI regReg, Max7221RegisterDigit4
    max7221SetRegister

    getCharI 'a'
    ; LDI valReg, 0b01110111
    LDI regReg, Max7221RegisterDigit5
    max7221SetRegister

    getCharI 'l'
    ORI valReg, 0b10000000 ; turn decimal point on
    ; LDI valReg, 0b10001110
    LDI regReg, Max7221RegisterDigit6
    max7221SetRegister

    getCharI 'p'
    ; LDI valReg, 0b01100111
    LDI regReg, Max7221RegisterDigit7
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
