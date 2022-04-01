    ; portB pins
    .equ pinSCK = 7
    .equ pinMISO = 6
    .equ pinMOSI = 5
    .equ pinSS = 4
    .equ pinBlink = 4
    ; 3 & 2 - unused
    .equ pinSelectMax7221 = 0

.macro blink
    in ioReg, PORTB
    ldi quickReg, 1 << pinBlink
    eor ioReg, quickReg
    out PORTB, ioReg
.endMacro

.macro spiDeselect
    sbi PORTB, pinSelectMax7221
.endMacro

.macro spiSelectMax7221
    cbi PORTB, pinSelectMax7221
.endMacro

    .equ  spiDivide16 = 0b00000001 ; default spiDivide4
    .equ  spiDivide64 = 0b00000010
    .equ spiDivide128 = 0b00000011

.macro setupBlink ; not needed if we use SPI
    sbi DDRB, pinBlink
    sbi PORTB, pinBlink
.endMacro

.macro setupSpi
    ; Prevent SS/Blink acting as an input or it'll force SPI into slave mode
    ldi portReg, (1 << pinSS) | (1 << pinSelectMax7221)
    out DDRB, portReg
    out PORTB, portReg

    ;ldi portReg, 0 ; disable SPI2X
    ;out SPSR0, portReg

    ; Either the MAX7221 or my shoddy board layout requires that the clock be
    ; divided by at least 16
    ldi portReg, (1 << SPE0) | ( 1 << MSTR0 ) | spiDivide128
    out SPCR0, portReg

    ; Setup SCK and MOSI pins AFTER enabling SPI, to avoid
    ; accidentally clocking in a single bit
    sbi DDRB, pinMOSI
    sbi PORTB, pinMISO ; pull up on MISO
    sbi DDRB, pinSCK
.endMacro

.macro spiOut
    out SPDR0, @0
spiOutWait:
    in quickReg, SPSR0 ; Can't use sbis for ports > 31
    sbrs quickReg, SPIF0
    rjmp spiOutWait
.endMacro
