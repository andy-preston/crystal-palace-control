; Chip select for the SPI bus is controlled by a pair
; of 74HCT138 3-Line to 8-Line Decoder/Demultiplexers
;
; In the initial PORTA test,
; we've just been bunging numbers at the chip select
; but it only works with 0001 - 1111 for each nybble
; because the enable pin has to be on for any change
;
; This is how the current chip select is set up:
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

; It needs to be remoddled to this:
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

.MACRO csPortR
    OUT PORTA, @0
.ENDMACRO

.MACRO chipDeselect
    LDI r24, 0
    csPortR r24
.ENDMACRO

.MACRO setupChipSelect
    LDI r24, 0b11111111 ; All outputs
    OUT DDRA, r24
    LDI r24, 0b00000000 ; All off
    OUT PORTB, r24
.ENDMACRO

chipSelect:
    PUSH r26 ; chip select value 0-15
    CPI r26, 0x08
    BRLO lowchip

    LSL r26 ; if it's 8 or higher shift the lower 3 bits up into the higher
    LSL r26 ; nybble. Which has the side effect of shifting the 8 bit into
    LSL r26 ; the lower chip enable bit (which enables the HIGH chip)
    RJMP skipLowChip

lowchip:
    ORI r26, 0b10000000 ; set the higher enable bit (which enables the LOW chip)

skipLowChip:
    csPortR r26

    POP r26
    RET