.DEF calcReg = r10
.DEF clockReg = r11
.DEF inputReg = r12
.DEF inputLReg = r12 ; inputReg is sometimes 16 bit
.DEF inputHReg = r13
.DEF dummyJunkReg = r14
.DEF dummyZeroReg = r15

; only registers r16-r31 can LDI

.DEF addrLReg = r16
;.DEF addrHReg = r17
.DEF stringLReg = r18
;.DEF stringHReg = r19
.DEF valReg = r20       ; value to write to an IO chip register
.DEF regReg = r21       ; register in a IO chip
.DEF numReg = r22       ; A number value from a control on the panel
.DEF portReg = r23      ; value to write to AVR port
.DEF quickReg = r24     ; very short intermediate values
.DEF countReg = r25

; XL, XH, YL, YH, ZL, ZH don't seem to get defined in my version of GAVRASM
.DEF XL = r26
.DEF XH = r27
.DEF YL = r28
.DEF YH = r29
.DEF ZL = r30
.DEF ZH = r31

.MACRO setupStackAndReg
    CLR dummyZeroReg

    LDI quickReg, high(RAMEND)
    OUT SPH, quickReg
    LDI quickReg, low(RAMEND)
    OUT SPL, quickReg
.ENDMACRO
