.MACRO doDelay
    ; simple delay loop
    ; I've only just started with AVR Assembler
    ; I'm not ready for timers just yet
delay:
    LDI quickReg, 0xFF
    MOV r2, quickReg
outerDelay:
    MOV r3, quickReg
innerDelay:
    DEC r3
    BRNE innerDelay
    DEC r2
    BRNE outerDelay
    DEC r1
    BRNE delay
.ENDMACRO

.MACRO delayLoopR
    MOV r1, @0
    doDelay
.ENDMACRO

.MACRO delayLoopI
    LDI quickReg, @0
    delayLoopR quickReg
.ENDMACRO
