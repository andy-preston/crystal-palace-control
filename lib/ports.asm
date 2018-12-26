.macro blink
    IN ioReg, PORTB
    LDI quickReg, 0b00000001
    EOR ioReg, quickReg
    OUT PORTB, ioReg
.endm

.macro setupPorts
    ; B has blinkenlicht on PB0
    LDI quickReg, 0b00000001
    OUT DDRB, quickReg
.endm
