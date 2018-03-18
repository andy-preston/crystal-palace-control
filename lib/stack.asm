.MACRO setupStack
    LDI	R24, low(RAMEND)
    OUT	SPL, R24
    LDI	R24, high(RAMEND)
    OUT	SPH, R24
.ENDMACRO