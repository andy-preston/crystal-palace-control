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
resetOutput:
    LDI r22, 0b000001
loop:
    blink
    chipSelectR r22

    LSL r22 ; shift to next output pin
    BREQ resetOutput ; if it's all zeros, restart at 1
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

    RJMP loop ; otherwise skip on to the next blip