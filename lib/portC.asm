.MACRO setupPortC
    LDI portReg, 0b00001111
    OUT DDRC, portReg
.ENDMACRO

.MACRO clockTick
    ; The increment must be done prior to writing to the muxs
    ; because other code may want to know what clockReg is holding
    INC clockReg ; clock is on lower nybble of portC

    MOV portReg, clockReg
    ANDI portReg, 0b00001111
    OUT PORTC, portReg
.ENDMACRO

.MACRO readC
    IN inputReg, PINC ; inputs are on high nybble
    LSR inputReg
    LSR inputReg
    LSR inputReg
    LSR inputReg
.ENDMACRO
