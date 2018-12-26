.macro doDelay
    ; simple delay loop
delay:
    LDI quickReg, 0xFF
    MOV r2, quickReg
outerDelay:
    MOV r3, quickReg
innerDelay:
    delayTick
    DEC r3
    BRNE innerDelay
    DEC r2
    BRNE outerDelay
    DEC r1
    BRNE delay
.endm

.macro delayLoopR
    MOV r1, @0
    doDelay
.endm

.macro delayLoopI
    LDI quickReg, @0
    delayLoopR quickReg
.endm
