.MACRO doDelay
    ; simple delay loop
    ; I've only just started with AVR Assembler
    ; I'm not ready for timers just yet
delay:
    LDI r24, 0xFF
outerDelay:
    LDI r25, 0xFF
innerDelay:
    DEC r25
    BRNE innerDelay
    DEC r24
    BRNE outerDelay
    DEC r23
    BRNE delay
.ENDMACRO

.MACRO delayLoopI
    LDI r23, @0
    doDelay
.ENDMACRO

.MACRO delayLoopR
    MOV r23, @0
    doDelay
.ENDMACRO
