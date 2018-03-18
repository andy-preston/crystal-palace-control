    .device ATmega1284P

    .include "../lib/blink.asm"

    .org 0x0000   ; reset vector
    RJMP progStart

    .org 0x0046
progStart:
    setupBlink
seqStart:
    LDI r22, 0x20
loop:
    blink
    ; simple delay loop
    ; I've only just started with AVR Assembler
    ; I'm not ready for timers just yet
    MOV r23, r22
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

    DEC r22
    BRNE loop
    RJMP seqStart