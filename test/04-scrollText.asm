    .device ATmega164P

    .cseg

    .org 0x0000 ; reset vector
    jmp progStart

    .org 0x003E

    .include "../lib/registers.asm"
    .include "../lib/portb-spi.asm"
    .include "../lib/max7221.asm"
    .include "../lib/display.asm"
    .include "./util/delay.asm"

testString:
    .db "0123456789-abcdefghijklmnopqrstuvwxyz  \@"

progStart:
    cli
    setupStackAndReg
    setupSpi
    setupMax7221
    clearTextBuffer

stringStart:
    ldi countReg, 0               ; countReg points to character in testString

displayStart:
    blink
    delayLoopI 16
    ldi ZL, low(testString << 1)  ; get from testString in program memory
    ldi ZH, high(testString << 1)
    add ZL, countReg              ; countReg holds the current offset
    adc ZH, dummyZeroReg
    lpm displayReg, Z             ; LPM requires Z register not X or Y
    cpi displayReg, 0             ; NULL Terminator
    brne notDisplayEnd
    jmp stringStart
notDisplayEnd:
    scrollTextBuffer              ; Y now points to last char ready to receive another one
    st Y, displayReg              ; Y is last char - after shift operation
    displayTextBuffer
    inc countReg
    jmp displayStart              ; or display next char
