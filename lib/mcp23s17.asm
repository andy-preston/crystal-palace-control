    ; Simplified Opcodes

    .EQU OP_READ = 0x41
    .EQU OP_WRITE = 0x40

    ; Registers

    .EQU IODIRA   = 0x00 ; I/O Direction Register
    .EQU IODIRB   = 0x01 ; 1 = Input (default),
                         ; 0 = Output
    .EQU IPOLA    = 0x02 ; Input Polarity Register
    .EQU IPOLB    = 0x03 ; 0 = Normal (default)(low reads as 0),
                         ; 1 = Inverted (low reads as 1)
    .EQU GPINTENA = 0x04 ; Interrupt on Change Pin Assignements
    .EQU GPINTENB = 0x05 ; 0 = No Interrupt on Change (default),
                         ; 1 = Interrupt on Change
    .EQU DEFVALA  = 0x06 ; Default Compare Register for Interrupt on Change
    .EQU DEFVALB  = 0x07 ; Opposite of what is here will trigger an interrupt
                         ; default = 0
    .EQU INTCONA  = 0x08 ; MCP23x17 Interrupt on Change Control Register
    .EQU INTCONB  = 0x09 ; 1 = pin is compared to DEFVAL,
                         ; 0 = pin is compared to previous state (default)
    .EQU IOCON    = 0x0A ; MCP23x17 Configuration Register
                  ; 0x0B ;      Also Configuration Register
    .EQU GPPUA    = 0x0C ; MCP23x17 Weak Pull-Up Resistor Register
    .EQU GPPUB    = 0x0D ; INPUT ONLY: 0 = No Internal 100k Pull-Up (default)
                         ;             1 = Internal 100k Pull-Up
    .EQU INTFA    = 0x0E ; MCP23x17 Interrupt Flag Register
    .EQU INTFB    = 0x0F ; READ ONLY: 1 = This Pin Triggered the Interrupt
    .EQU INTCAPA  = 0x10 ; MCP23x17 Interrupt Captured Value for Port Register
    .EQU INTCAPB  = 0x11 ; READ ONLY: State of pin when the Interrupt Occurred
    .EQU GPIOA    = 0x12 ; GPIO Port Register
    .EQU GPIOB    = 0x13 ; Value on the Port. Write to Set Bits in output latch
    .EQU OLATA    = 0x14 ; MCP23x17 Output Latch Register
    .EQU OLATB    = 0x15 ; 1 = Latch High, 0 = Latch Low (default)
                         ; Reading Returns Latch State, Not Port Value!

; parameters @0 - chip, @1 - register, @2 - register to recieve value
.MACRO mcp23s17Read
    chipSelectI @0
    spiOutI OP_READ
    spiOutI @1
    spiOutIn 0, @2
    chipDeselect
.ENDMACRO

; parameters @0 - chip, @1 - register, @2 - value
.MACRO mcp23s17Write
    chipSelectI @0
    spiOutI OP_WRITE
    spiOutI @1
    spiOutI @2
    chipDeselect
.ENDMACRO
