; Chip select for the SPI bus is controlled by a pair
; of 74HCT138 3-Line to 8-Line Decoder/Demultiplexers
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AVR ; 74138(0) ; 74138(1) ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PA0 ; A        ;          ;
; PA1 ; B        ;          ;
; PA2 ; C        ;          ;
; PA3 ;          ; A        ;
; PA4 ;          ; B        ;
; PA5 ;          ; C        ;
; PA6 ;          ; Enable   ;
; PA7 ; Enable   ;          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; device names mapped to chip select pins
.EQU selectMax7221 = 15

.MACRO chipDeselect
    LDI portReg, 0
    OUT PORTA, portReg
.ENDMACRO

.MACRO setupChipSelect
    LDI portReg, 0b11111111 ; All outputs
    OUT DDRA, portReg
    LDI portReg, 0b00000000 ; All off
    OUT PORTB, portReg
.ENDMACRO

chipSelect:
    CPI portReg, 0x08 ; chip select value 0-15 in portReg
    BRLO lowchip

    LSL portReg ; if it's 8 or higher shift the lower 3 bits up into the higher
    LSL portReg ; nybble. Which has the side effect of shifting the 8 bit into
    LSL portReg ; the lower chip enable bit (which enables the HIGH chip)

    RJMP skipLowChip

lowchip:
    ORI portReg, 0b10000000 ; set the higher enable bit (which enables the LOW chip)

skipLowChip:
    OUT PORTA, portReg
    RET