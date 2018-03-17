.MACRO setupSpi
    ; Prevent SlaveSelect acting as an input or it'll force SPI into slave mode
    IN r24, DDRB
    ORI r24, 0b00010000 ; PB4 = output
    OUT DDRB, r24

    IN r24, PORTB
    ANDI r24, 0b00010000 ; PB4 = high
    OUT PORTB, r24

    ; Enable SPI
    IN r24, SPCR
    ORI r24, ((1 << SPE) | (1 << MSTR) | (1 << SPR0))
    OUT SPCR, r24

    ; Setup SCK and MOSI pins AFTER enabling SPI, to avoid
    ; accidentally clocking in a single bit
    IN r24, DDRB
    ORI r24, 0b10100000 ; PB7(SCK) PB5(MOSI) = output
    OUT DDRB, r24
.ENDMACRO

; parameter @0 - register to output
.MACRO spiOutR
    OUT SPDR, @0
spiOutWait:
    ; wait for SPIF bit in SPSR to be set
    IN @0, SPSR
    ANDI @0, 0b10000000 ; SPIF
    BREQ spiOutWait
.ENDMACRO

; parameter @0 - value to output
.MACRO spiOutI
    LDI r24, @0
    spiOutR r24
.ENDMACRO

; parameters @0 - register to output @1 - register to recieve input
.MACRO spiOutInR
    spiOutR @0
    IN SPDR, @1
.ENDMACRO

; parameters @0 - value to output @1 - register to recieve input
.MACRO spiOutInI
    LDI r24, @0
    spiInR r24 @1
.ENDMACRO

