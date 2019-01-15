.equ        Max7221RegisterNoop=0x00
.equ      Max7221RegisterDigit0=0x01
.equ      Max7221RegisterDigit1=0x02
.equ      Max7221RegisterDigit2=0x03
.equ      Max7221RegisterDigit3=0x04
.equ      Max7221RegisterDigit4=0x05
.equ      Max7221RegisterDigit5=0x06
.equ      Max7221RegisterDigit6=0x07
.equ      Max7221RegisterDigit7=0x08
.equ  Max7221RegisterDecodeMode=0x09
.equ   Max7221RegisterIntensity=0x0A
.equ   Max7221RegisterScanLimit=0x0B
.equ    Max7221RegisterShutdown=0x0C
.equ Max7221RegisterDisplayTest=0x0F

max7221SetRegister:
    spiSelectMax7221
    spiOut portReg    ; MAX7221 register to set
    spiOut dispReg   ; value to set
    spiDeselect
    RET

.macro setupMax7221
    LDI portReg, Max7221RegisterDecodeMode
    LDI dispReg, 0
    CALL max7221SetRegister

    LDI portReg, Max7221RegisterIntensity
    LDI dispReg, 0x2
    CALL max7221SetRegister

    LDI portReg, Max7221RegisterScanLimit
    LDI dispReg, 7 ; display 8 digits
    CALL max7221SetRegister

    LDI portReg, Max7221RegisterShutdown
    LDI dispReg, 1 ; shutdown mode = 0
    CALL max7221SetRegister
.endm
