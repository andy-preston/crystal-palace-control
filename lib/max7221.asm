    ; The digit registers are reversed on the Motram Labs board (7-0)
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
    spiOut displayReg   ; value to set
    spiDeselect
    ret

.macro setupMax7221
    ldi portReg, Max7221RegisterDecodeMode
    ldi displayReg, 0
    call max7221SetRegister

    ldi portReg, Max7221RegisterIntensity
    ldi displayReg, 0x2
    call max7221SetRegister

    ldi portReg, Max7221RegisterScanLimit
    ldi displayReg, 7 ; display 8 digits
    call max7221SetRegister

    ldi portReg, Max7221RegisterShutdown
    ldi displayReg, 1 ; shutdown mode = 0
    call max7221SetRegister
.endMacro
