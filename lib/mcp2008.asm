mcp3008Read:
                         ; returns 8 bit value in r23
    PUSH r24             ; r24 chip select to use
    PUSH r25             ; r25 converter index (3 least significant bits)

    chipSelectR r24      ; SPIout & chipSelect use r24, so it's useless now

                         ; I'd rather waste a few bits than have to bit-bang
    spiOutI 0b00000001   ; 7 don't care bits and a start bit

    LSL r25              ; The least significant 3 bits (in the lower nybble)
    LSL r25              ; need to be the least significant 3 bits in the
    LSL r25              ; upper nybble
    LSL r25              ; the lower nybble is zeroed (it's "don't care")

    ANDI r25, 0b10000000 ; Indicate single ended conversion

    spiOutInR r25 r25    ; start conversion and get the 2 most significant bits

    spiOutInI 0 r23      ; get 8 least significant bits

    chipDeselect

    ; We're trating the 2 least significant bits in r23 as "don't care"
    ; to cut the 10-bit convereted value down to a "simple" 8 bits
    ; loosing some precision but keeping numbers more manageable.
    ; If that turns out to be a bad idea, we'll have to hold these 10-bit
    ; values as 16-bit pairs

                         ; r25 = XXXXXX12       r23 = 345678XX
    ROR r25              ; r25 = XXXXXXX1 c = 2
    ROR r23              ;                      r23 = 2345678X
    ROR r25              ; r25 = XXXXXXXX c = 1
    ROR r23              ;                      r23 = 12345678

    POP r25
    POP r24
    RET
