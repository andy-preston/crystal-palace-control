    .nolist
    .include "/usr/local/share/avra/m1284Pdef.inc"
    .list

    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"

    .org 0x0000   ; reset vector
    RJMP progStart

    .org 0x0046
progStart:
    setupBlink
    setupChipSelect
    LDI r22, 0
loop:
    blink
    chipSelectR r22
    INC r22

    ; simple delay loop
    ; I've only just started with AVR Assembler
    ; I'm not ready for timers just yet
    LDI r23, 0x20
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