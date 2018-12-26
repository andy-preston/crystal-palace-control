.macro portsOut
    OUT PORTC, dispReg
    OUT PORTA, clockOutReg
.endm

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
    OUT PORTB, dummyZeroReg

    ; Lower nybble of A - address output to the 4067s & the 74138s
    ; (upper two bits are "eaten" by ADC mux)
    LDI quickReg, 0b11110000
    OUT DDRA, quickReg
    OUT PORTA, dummyZeroReg

    ; port C outputs to the segments of the current display cell
    LDI quickReg, 0b11111111
    OUT DDRC, quickReg
    OUT PORTC, dummyZeroReg
.endm
