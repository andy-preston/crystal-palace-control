.MACRO clockOut
    MOV portReg, clockReg
    ANDI portReg, 0b00001111
    OUT PORTC, portReg
.ENDMACRO

.MACRO setupPortC
    ; Lower nybble of C - address output to the 4067s & the 74138s
    ; Lower 3 bits of the upper nybble - input from the 74148
    LDI portReg, 0b00001111
    OUT DDRC, portReg

    ; Lower nybble of clock reg - address output to the 4067s & the 74138s
    CLR clockReg
    clockOut
.ENDMACRO

.MACRO clockTick
    INC clockReg
    clockOut
.ENDMACRO
