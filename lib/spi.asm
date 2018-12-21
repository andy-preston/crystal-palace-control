; If we're using SPI there's no need to setup blink
; as it's all on PORTB and we do it all in one place

.EQU pinSCK = 7
.EQU pinMISO = 6
.EQU pinMOSI = 5
.EQU pinSS = 4
.EQU pinCS3 = 3
.EQU pinCS2 = 2
.EQU pinCS1 = 1
.EQU pinBlink = 0 ; miswired as pinCS0

.MACRO spiDeselect
    SBI PORTB, pinCS3
    SBI PORTB, pinCS2
    SBI PORTB, pinCS1
.ENDMACRO

.EQU selectMax7221 = pinCS1

.MACRO spiSelect1
    SBI PORTB, pinCS3
    SBI PORTB, pinCS2
    CBI PORTB, pinCS1
.ENDMACRO

.MACRO spiSelect2
    SBI PORTB, pinCS3
    SBI PORTB, pinCS1
    CBI PORTB, pinCS2
.ENDMACRO

.MACRO spiSelect3
    SBI PORTB, pinCS2
    SBI PORTB, pinCS1
    CBI PORTB, pinCS3
.ENDMACRO

.EQU  spiDivide16 = 0b00000001 ; default spiDivide4
.EQU  spiDivide64 = 0b00000010
.EQU spiDivide128 = 0b00000011

.MACRO setupSpi
    ; Prevent SlaveSelect acting as an input or it'll force SPI into slave mode
    LDI portReg, (1 << pinSS) | (1 << pinCS1) | (1 << pinCS2) | (1 << pinCS3) | (1 << pinBlink)
    OUT DDRB, portReg

    SBI PORTB, pinSS
    SBI PORTB, pinBlink

    LDI portReg, 0 ; disable SPI2X
    OUT SPSR0, portReg

    ; Either the MAX7221 or my shoddy board layout requires that the clock be
    ; divided by at least 16
    LDI portReg, (1 << SPE0) | ( 1 << MSTR0 ) | spiDivide16
    OUT SPCR0, portReg

    ; Setup SCK and MOSI pins AFTER enabling SPI, to avoid
    ; accidentally clocking in a single bit
    SBI DDRB, pinMOSI
    SBI DDRB, pinSCK

    spiDeselect
.ENDMACRO

.MACRO spiOut ; value in portReg
    OUT SPDR0, portReg
spiOutWait:
    IN portReg, SPSR0 ; Can't use SBIS for port > 31
    ANDI portReg, (1 << SPIF0)
    BREQ spiOutWait
.ENDMACRO

.MACRO spiOutIn
    spiOut
    IN inputReg, SPDR0
.ENDMACRO
