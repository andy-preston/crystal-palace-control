    .device ATmega164P

    .org 0x0000   ; reset vector
    jmp progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/portb-spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/display.asm"
    .include "./util/delay.asm"

getChar:
    translateCharacter
    ret

progStart:
    setupStackAndReg
    setupSpi
    switchOnMax7221
    setupMax7221

    ldi portReg, Max7221RegisterDigit0
    ldi displayReg, 'c' ; ldi displayReg, 0b01001110
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit1
    ldi displayReg, 'r' ; ldi displayReg, 0b00000101
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit2
    ldi displayReg, 'y' ; ldi displayReg, 0b00111011
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit3
    ldi displayReg, 's' ; ldi displayReg, 0b01011011
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit4
    ldi displayReg, 't' ; ldi displayReg, 0b00001111
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit5
    ldi displayReg, 'a' ; ldi displayReg, 0b01110111
    call getChar
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit6
    ldi displayReg, 'l' ; ldi displayReg, 0b10001110
    call getChar
    ORI displayReg, 0b10000000 ; turn decimal point on
    call max7221SetRegister
    blink

    ldi portReg, Max7221RegisterDigit7
    ldi displayReg, 'p' ; ldi displayReg, 0b01100111
    call getChar
    call max7221SetRegister
    blink

    ldi countReg, 0x0F
loop:
    delayLoopI 25
    blink

    ldi portReg, Max7221RegisterIntensity
    mov displayReg, countReg
    call max7221SetRegister

    dec countReg
    rjmp loop
