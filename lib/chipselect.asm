; Chip select for the SPI bus is controlled by a pair
; of 74HCT138 3-Line to 8-Line Decoder/Demultiplexers
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AVR ; 74138(0) ; 74138(1) ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PA0 ; Enable   ;          ;
; PA1 ; A        ;          ;
; PA2 ; B        ;          ;
; PA3 ; C        ;          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PA4 ;          ; Enable   ;
; PA5 ;          ; A        ;
; PA6 ;          ; B        ;
; PA7 ;          ; C        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.MACRO chipSelect
    LDI r24, @0
    OUT PORTA, r24
.ENDMACRO

.MACRO setupChipSelect
    LDI r24, 0b11111111 ; All outputs
    OUT DDRA, r24

    LDI r24, 0b00000000 ; All off
    OUT PORTB, r24
.ENDMACRO
