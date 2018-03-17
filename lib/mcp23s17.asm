    .include "../lib/mcp23s17.inc"

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
