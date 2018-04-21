    .device ATmega324P

    .org 0x0000   ; reset vector
    JMP progStart

    .org 0x003E
    .include "../lib/registers.asm"
    .include "../lib/stack.asm"
    .include "../lib/blink.asm"
    .include "../lib/chipselect.asm"
    .include "../lib/spi.asm"
    .include "../lib/max7221.asm"
    .include "./util/delay.asm"

progStart:
    CLI
    setupStack
    setupBlink
    setupChipSelect
    setupSpi
    setupMax7221

    max7221Test

loop:
    delayLoopI 0x10
    blink
    RJMP loop ; otherwise skip on to the next blip