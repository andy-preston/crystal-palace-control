.MACRO setupStack
    LDI	quickReg, high(RAMEND)
    OUT	SPH, quickReg
    LDI	quickReg, low(RAMEND)
    OUT	SPL, quickReg
.ENDMACRO