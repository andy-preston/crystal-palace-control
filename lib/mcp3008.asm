mcp3008Read:
    PUSH portReg

    LDI portReg, selectMCP2008a
    CALL chipSelect

    LDI portReg, 0b00000001 ; I'd rather waste a few bits than have to bit-bang
    spiOut                  ; 7 don't care bits and a start bit

    POP portReg
    PUSH portReg

    LSL portReg             ; The least significant 3 bits (in the lower nybble)
    LSL portReg             ; need to be the least significant 3 bits in the
    LSL portReg             ; upper nybble
    LSL portReg             ; the lower nybble is zeroed (it's "don't care")
    ORI portReg, 0b10000000 ; Indicate single ended conversion
    spiOutIn
    MOV dummyJunkReg, inputReg

    CLR portReg
    spiOutIn                ; 8 least significant bits in inputReg

    chipDeselect

    ; We're trating the 2 least significant bits in inputReg as "don't care"
    ; to cut the 10-bit convereted value down to a "simple" 8 bits
    ; loosing some precision but keeping numbers more manageable.
    ; If that turns out to be a bad idea, we'll have to hold these 10-bit
    ; values as 16-bit pairs
                     ; dummyJunkReg = XXXXXX12       inputReg = 345678XX
    ROR dummyJunkReg ; dummyJunkReg = XXXXXXX1 c = 2
    ROR inputReg     ;                               inputReg = 2345678X
    ROR dummyJunkReg ; dummyJunkReg = XXXXXXXX c = 1
    ROR inputReg     ;                               inputReg = 12345678

    POP portReg
    RET
