.MACRO clockTick
    ; The increment must be done prior to writing to the muxs
    ; because other code may want to know what clockReg is holding
    INC clockReg

    MOV clockOutReg, clockReg
    LSL clockOutReg ; clock is on lower nybble of A
    LSL clockOutReg
    LSL clockOutReg
    LSL clockOutReg
.ENDMACRO
