; r1, r2 and r3 are used by test/util/delay.asm

.def ioReg = r8
.def calcReg = r9
.def clockReg = r10
.def clockOutReg = r11
.def inputReg = r12
.def inputLReg = r12 ; inputReg is sometimes 16 bit
.def inputHReg = r13
.def dummyJunkReg = r14
.def dummyZeroReg = r15

; only registers r16-r31 can use immediate

.def stringLReg = r18
;.def stringHReg = r19
.def dispReg = r20      ; value to write to an IO chip register
; r21

; numReg is only used by num-disp.asm - that may need rewriting yet
.def numReg = r22       ; A number value from a control on the panel

.def portReg = r23      ; value to write to AVR port
.def quickReg = r24     ; very short intermediate values
.def countReg = r25

; XL, XH, YL, YH, ZL, ZH don't seem to get defined in my version of GAVRASM
.def XL = r26
.def XH = r27
.def YL = r28
.def YH = r29
.def ZL = r30
.def ZH = r31

.macro setupStackAndReg
    LDI quickReg, high(RAMEND)
    OUT SPH, quickReg
    LDI quickReg, low(RAMEND)
    OUT SPL, quickReg

    CLR dummyZeroReg
    CLR clockReg
    DEC clockReg ; so when we INC it, it'll be 0
.endm
