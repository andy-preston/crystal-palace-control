.device ATmega324P

.cseg

.org 0x0000   ; reset vector
    JMP progStart

.org 0x003E

.include "../lib/registers.asm"
.include "../lib/ports.asm"
.include "../lib/display.asm"
.include "../lib/clock.asm"

.macro delayTick
    clockTick
    getDisplayCell
    portsOut
.endm

.include "./util/delay.asm"

testString:
    .db "0123456789-abcdefghijklmnopqrstuvwxyz  \@"

progStart:
    CLI
    setupStackAndReg
    setupPorts
    clearDisplayBuffer

stringStart:
    LDI stringLReg, 0 ; stringReg points to character in testString

displayStart:
    blink
    delayLoopI 32

    scrollDisplayBuffer           ; Y now points to last char ready to recieve another one
    LDI ZL, low(testString << 1)  ; get from testString in progam memory
    LDI ZH, high(testString << 1)
    ADD ZL, stringLReg            ; stringReg holds the current offset
    ADC ZH, dummyZeroReg
    LPM quickReg, Z
    CPI quickReg, 0               ; NULL Terminator
    BRNE notDisplayEnd
    JMP stringStart
notDisplayEnd:
    ST Y, quickReg                ; Y is last char - after shift operation
    INC stringLReg
    JMP displayStart              ; or display next char
