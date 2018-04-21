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
    LDI valReg, 0
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit1
    LDI valReg, 1
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit2
    LDI valReg, 2
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit3
    LDI valReg, 3
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit4
    LDI valReg, 4
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit5
    LDI valReg, 5
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit6
    LDI valReg, 6
    max7221SetRegister
    LDI regReg, Max7221RegisterDigit7
    LDI valReg, 7
    max7221SetRegister

    LDI r20, 0xF
loop:
    delayLoopI 0x10
    blink

    LDI regReg, Max7221RegisterIntensity
    MOV valReg, r20
    max7221SetRegister

    DEC r20
    RJMP loop
