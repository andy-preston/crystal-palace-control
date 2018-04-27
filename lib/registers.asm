.DEF addrLReg = r16
.DEF addrHReg = r17

.DEF valReg = r21 ; value to write to an IO chip register
.DEF regReg = r22 ; register in a IO chip
.DEF spiReg = r23
.DEF portReg = r24
.DEF quickReg = r25
.DEF selectReg = r26

; ZL and ZH don't seem to get defined in my version of GAVRASM
.DEF ZL = r30
.DEF ZH = r31