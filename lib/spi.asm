.MACRO setupSpi
    ; Prevent SlaveSelect acting as an input or it'll force SPI into slave mode
    IN portReg, DDRB
    ORI portReg, 0b00010000 ; PB4 = output
    OUT DDRB, portReg

    IN portReg, PORTB
    ANDI portReg, 0b00010000 ; PB4 = high
    OUT PORTB, portReg

    ; Enable SPI
    IN portReg, SPCR0
    ; enable, set master, divide clock by 16
    ;ORI portReg, ((1 << SPE0) | (1 << MSTR0) | (1 << SPR00))
    ; enable, set master, divide clock by 128
    ORI portReg, ((1 << SPE0) | (1 << MSTR0) | (1 << SPR00) | (1 << SPR10))

    ; send data MSB
    ;CBR portReg, DORD0 ; WARNING (7221 likes MSB... what about the other chips)
    OUT SPCR0, portReg

    ; Setup SCK and MOSI pins AFTER enabling SPI, to avoid
    ; accidentally clocking in a single bit
    IN portReg, DDRB
    ORI portReg, 0b10100000 ; PB7(SCK) PB5(MOSI) = output
    OUT DDRB, portReg
.ENDMACRO

.MACRO spiOut
    OUT SPDR0, portReg
spiOutWait:
    IN portReg, SPSR0
    ANDI portReg, (1 << SPIF0)
    BREQ spiOutWait
.ENDMACRO

.MACRO spiOutIn
    spiOut
    IN SPDR0, inputReg
.ENDMACRO
