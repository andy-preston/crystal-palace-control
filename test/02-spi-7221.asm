    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/portB.asm"
    .include "../lib/max7221.asm"
    .include "../lib/display.asm"
    .include "./util/delay.asm"

getChar:
    translateCharacter
    RET

progStart:
    setupStackAndReg
    setupSpi
    setupMax7221

    LDI portReg, Max7221RegisterDigit0
    LDI dispReg, 'c' ; LDI dispReg, 0b01001110
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit1
    LDI dispReg, 'r' ; LDI dispReg, 0b00000101
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit2
    LDI dispReg, 'y' ; LDI dispReg, 0b00111011
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit3
    LDI dispReg, 's' ; LDI dispReg, 0b01011011
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit4
    LDI dispReg, 't' ; LDI dispReg, 0b00001111
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit5
    LDI dispReg, 'a' ; LDI dispReg, 0b01110111
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit6
    LDI dispReg, 'l' ; LDI dispReg, 0b10001110
    CALL getChar
    ORI dispReg, 0b10000000 ; turn decimal point on
    CALL max7221SetRegister
    blink

    LDI portReg, Max7221RegisterDigit7
    LDI dispReg, 'p' ; LDI dispReg, 0b01100111
    CALL getChar
    CALL max7221SetRegister
    blink

    LDI countReg, 0x0F
loop:
    delayLoopI 25
    blink

    LDI portReg, Max7221RegisterIntensity
    MOV dispReg, countReg
    CALL max7221SetRegister

    DEC countReg
    RJMP loop
