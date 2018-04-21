.EQU Max7221CharBlank=0x00

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

.EQU Max7221BcdMinus=0x0A
.EQU Max7221BcdE=0x0B
.EQU Max7221BcdH=0x0C
.EQU Max7221BcdL=0x0D
.EQU Max7221BcdP=0x0E
.EQU Max7221BcdBlank=0x0F

.MACRO max7221SetRegister
    LDI selectReg, selectMax7221
    CALL chipSelect
    MOV spiReg, regReg ; MAX7221 register to set
    spiOut
    MOV spiReg, valReg ; value to set
    spiOut
    chipDeselect
.ENDMACRO

.MACRO max7221Clear
    LDI valReg, Max7221CharBlank
    LDI regReg, 1;
max7221ClearLoop:
    max7221SetRegister
    INC regReg
    CPI regReg, 8
    BRNE max7221ClearLoop
.ENDMACRO

.MACRO max7221Test
    LDI regReg, Max7221RegisterDisplayTest
    LDI valReg, 0xF
    max7221SetRegister
.ENDMACRO

.MACRO max7221BcdMode
    LDI regReg, Max7221RegisterDecodeMode
    LDI valReg, 0xF
    max7221SetRegister
.ENDMACRO

.MACRO setupMax7221
    LDI regReg, Max7221RegisterScanLimit
    LDI valReg, 8 ; number of digits on display
    max7221SetRegister
    LDI regReg, Max7221RegisterIntensity
    LDI valReg, 0xF
    max7221SetRegister
    LDI regReg, Max7221RegisterShutdown
    LDI valReg, 1 ; shutdown mode = 0
    max7221SetRegister
    max7221Clear
.ENDMACRO
