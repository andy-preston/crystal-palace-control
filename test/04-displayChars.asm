.device ATmega324P

.cseg

.org 0x0000 ; reset vector
    JMP progStart

.org 0x003E

.include "../lib/registers.asm"
.include "../lib/ports.asm"
.include "../lib/display.asm"
.include "../lib/clock.asm"
.include "./util/delayTickDisplay.asm"
.include "./util/delay.asm"

testString:
.db "0123456789-abcdefghijklmnopqrstuvwxyz  \@"

progStart:
    CLI
    setupStackAndReg
    setupPorts
    clearBuffer displayBuffer

stringStart:
    LDI stringLReg, 0             ; stringReg points to character in testString

displayStart:
    blink
    delayLoopI 16
    scrollBuffer displayBuffer    ; Y now points to last char ready to recieve another one
    LDI ZL, low(testString << 1)  ; get from testString in progam memory
    LDI ZH, high(testString << 1)
    ADD ZL, stringLReg            ; stringReg holds the current offset
    ADC ZH, dummyZeroReg
    LPM dispReg, Z                ; LPM requires Z register not X or Y
    CPI dispReg, 0                ; NULL Terminator
    BRNE notDisplayEnd
    JMP stringStart
notDisplayEnd:
    translateCharacter
    ST Y, dispReg                 ; Y is last char - after shift operation
    INC stringLReg
    JMP displayStart              ; or display next char
