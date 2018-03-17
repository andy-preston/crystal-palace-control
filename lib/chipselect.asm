; Chip select for the SPI bus is controlled by a pair
; of 74HCT138 3-Line to 8-Line Decoder/Demultiplexers
;
; TODO: here's the bug!
; ;;;;;;;;;;;;;;;;;;;;;
;
; We've just been bunging numbers at the chip select
; but it only works with 0001 - 1111 for each nybble
; because the enable pin has to be on for any change
; infact - you might even have to do some kind of
; enable pin twiddling to get the 74138s to work.
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

.MACRO chipSelectR
    OUT PORTA, @0
.ENDMACRO

.MACRO chipSelectI
    LDI r24, @0
    chipSelectR r24
.ENDMACRO

.MACRO chipDeselect
    LDI r24, 0
    chipSelectR r24
.ENDMACRO

.MACRO setupChipSelect
    LDI r24, 0b11111111 ; All outputs
    OUT DDRA, r24

    LDI r24, 0b00000000 ; All off
    OUT PORTB, r24
.ENDMACRO
