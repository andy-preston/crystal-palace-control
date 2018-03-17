.MACRO  blink
    IN r24, PORTB
    LDI r25, 0b00000001 ; PB0 = LED
    EOR r24, r25
    OUT PORTB, r24
.ENDMACRO

.MACRO setupBlink
    IN r24, DDRB
    ORI r24, 0b00000001 ; PB0 = output
    OUT DDRB, r24

    IN r24, PORTB
    ANDI r24, 0b11111110 ; PB0 = off
    OUT PORTB, r24
.ENDMACRO
