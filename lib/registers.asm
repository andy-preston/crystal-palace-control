    ; r1, r2 and r3 are used by test/util/delay.asm
    .def ioReg = r7
    .def calcReg = r8
    .def clockReg = r9
    .def saveReg = r10
    .def saveLReg = r10
    .def saveHReg = r11
    .def inputReg = r12
    .def inputLReg = r12 ; inputReg is sometimes 16 bit
    .def inputHReg = r13
    .def dummyJunkReg = r14
    .def dummyZeroReg = r15

    ; only registers r16-r31 can use immediate
    .def quickReg = r16     ; very short intermediate values
    .def countReg = r17
    .def stringLReg = r18
    ;.def stringHReg = r19
    .def displayReg = r20      ; value to write to PORTC for display
    ; r21
    ; numReg is only used by numDisplay.asm - that may need rewriting yet
    .def numReg = r22       ; A number value from a control on the panel

    .def portReg = r23      ; value to write to AVR port - SPI chip register ID
    .def lhReg = r24
    .def lowReg = r24
    .def highReg = r25
    .def X = r26 ; r27
    .def Y = r28 ; r28
    .def Z = r30 ; r31

.macro setupStackAndReg
    cli

    ldi quickReg, high(RAMEND)
    out SPH, quickReg
    ldi quickReg, low(RAMEND)
    out SPL, quickReg

    clr dummyZeroReg
    clr clockReg
    dec clockReg ; so when we inc it, it'll be 0
.endMacro
