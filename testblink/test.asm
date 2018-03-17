    .nolist
    .include "/usr/local/share/avra/m1284Pdef.inc"
    .list

    .include "../lib/blink.asm"

    .org 0x0000   ; reset vector
    RJMP progStart

    .org 0x0046
progStart:
    setupBlink
loop:
    blink
    ; simple delay loop
    ; I've only just started with AVR Assembler
    ; I'm not ready for timers just yet
    LDI r23, 0x10
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

    RJMP loop