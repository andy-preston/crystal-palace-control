.IF RKAT==1
    .EQU blinkBits=0b00000001
.ELSE
    .EQU blinkBits=0b00010000
.ENDIF

.MACRO  blink
    IN r24, PORTB
    LDI r25, blinkBits
    EOR r24, r25
    OUT PORTB, r24
.ENDMACRO

.MACRO setupBlink
    IN r24, DDRB
    ORI r24, blinkBits
    OUT DDRB, r24

    IN r24, PORTB
    ORI r24, blinkBits
    OUT PORTB, r24
.ENDMACRO
