; portB pins
.EQU pinSCK = 7
.EQU pinMISO = 6
.EQU pinMOSI = 5
.EQU pinSS = 4
.EQU pinSelectMax7221 = 3
; 2 & 1 - unused
.EQU pinBlink = 0

.macro blink
    IN ioReg, PORTB
    LDI quickReg, 0b00000001
    EOR ioReg, quickReg
    OUT PORTB, ioReg
.endm

.macro spiDeselect
    SBI PORTB, pinSelectMax7221
.endm

.macro spiSelectMax7221
    CBI PORTB, pinSelectMax7221
.endm

.equ  spiDivide16 = 0b00000001 ; default spiDivide4
.equ  spiDivide64 = 0b00000010
.equ spiDivide128 = 0b00000011

.macro setupBlink ; not needed if we use SPI
    SBI DDRB, pinBlink
    SBI PORTB, pinBlink
.endm

.macro setupSpi
    ; Prevent SlaveSelect acting as an input or it'll force SPI into slave mode
    LDI portReg, (1 << pinSS) | (1 << pinSelectMax7221) | (1 << pinBlink)
    OUT DDRB, portReg
    OUT PORTB, portReg

    ;LDI portReg, 0 ; disable SPI2X
    ;OUT SPSR0, portReg

    ; Either the MAX7221 or my shoddy board layout requires that the clock be
    ; divided by at least 16
    LDI portReg, (1 << SPE0) | ( 1 << MSTR0 ) | spiDivide128
    OUT SPCR0, portReg

    ; Setup SCK and MOSI pins AFTER enabling SPI, to avoid
    ; accidentally clocking in a single bit
    SBI DDRB, pinMOSI
    SBI PORTB, pinMISO ; pullup on MISO
    SBI DDRB, pinSCK
.endm

.macro spiOut
    OUT SPDR0, @0
spiOutWait:
    IN quickReg, SPSR0 ; Can't use SBIS for port > 31
    SBRS quickReg, SPIF0
    RJMP spiOutWait
.endm
