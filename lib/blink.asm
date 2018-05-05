blink:
    PUSH portReg
    IN portReg, PORTB
    LDI quickReg, 0b00000001
    EOR portReg, quickReg
    OUT PORTB, portReg
    POP portReg
    RET

.MACRO setupBlink
    IN portReg, DDRB
    ORI portReg, 0b00000001
    OUT DDRB, portReg

    IN portReg, PORTB
    ORI portReg, 0b00000001
    OUT PORTB, portReg
.ENDMACRO
