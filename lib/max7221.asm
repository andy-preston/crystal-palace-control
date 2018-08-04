.EQU Max7221RegisterNoop=0x00
.EQU Max7221RegisterDigit0=0x01
.EQU Max7221RegisterDigit1=0x02
.EQU Max7221RegisterDigit2=0x03
.EQU Max7221RegisterDigit3=0x04
.EQU Max7221RegisterDigit4=0x05
.EQU Max7221RegisterDigit5=0x06
.EQU Max7221RegisterDigit6=0x07
.EQU Max7221RegisterDigit7=0x08
.EQU Max7221RegisterDecodeMode=0x09
.EQU Max7221RegisterIntensity=0x0A
.EQU Max7221RegisterScanLimit=0x0B
.EQU Max7221RegisterShutdown=0x0C
.EQU Max7221RegisterDisplayTest=0x0F

.MACRO max7221SetRegister
    LDI portReg, selectMax7221
    CALL chipSelect
    MOV spiReg, regReg ; MAX7221 register to set
    spiOut
    MOV spiReg, valReg ; value to set
    spiOut
    chipDeselect
.ENDMACRO

.MACRO setupMax7221
    LDI valReg, 0
    LDI regReg, Max7221RegisterDecodeMode
    max7221SetRegister

    LDI valReg, 0xF
    LDI regReg, Max7221RegisterIntensity
    max7221SetRegister

    LDI regReg, Max7221RegisterScanLimit
    LDI valReg, 7 ; display 8 digits
    max7221SetRegister

    LDI regReg, Max7221RegisterShutdown
    LDI valReg, 1 ; shutdown mode = 0
    max7221SetRegister
.ENDMACRO
