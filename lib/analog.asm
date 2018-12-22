.EQU useARef = 0
.EQU useAVcc = (1<<REFS0) ; Capacitor on AREF
.EQU useIRef = (1<<REFS0) | (1<<REFS1) ; Internal 2.56V reference

.EQU prescale2   =                           (1<<ADPS0)
.EQU prescale4   =              (1<<ADPS1)
.EQU prescale8   =              (1<<ADPS1) | (1<<ADPS0)
.EQU prescale16  = (1<<ADPS2)
.EQU prescale32  = (1<<ADPS2)              | (1<<ADPS0)
.EQU prescale64  = (1<<ADPS2) | (1<<ADPS1)
.EQU prescale128 = (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)

.EQU muxFlags = useAVcc
.EQU controlFlags = (1<<ADEN) | prescale128
.EQU startConv = (1<<ADSC) | controlFlags

.MACRO setupAnalog
    LDI portReg, muxFlags    ; Set individual MUX bits later
    STS ADMUX, portReg       ; Can't use OUT for ports > 63
    LDI portReg, controlFlags
    STS ADCSRA, portReg
.ENDMACRO

.MACRO analogStart
    MOV portReg, clockReg    ; count in clockReg
    LSR portReg
    LSR portReg
    LSR portReg
    LSR portReg              ; low bit of portReg is ADC chan
    ANDI portReg, 0b00000001 ; upper nybble of portReg is ADC chan
    ORI portReg, muxFlags    ; portReg has full ADMUX value

    STS ADMUX, portReg       ; can't use OUT for ports > 63

    LDI portReg, startConv
    STS ADCSRA, portReg
.ENDMACRO

.MACRO analogRead
    ; see TODO on MACRO spiOut
analogReadWait:
    LDS portReg, ADCSRA      ; Can't use SBIS for port > 31
    ANDI portReg, (1 << ADSC)
    BREQ analogReadWait

    LDS inputLreg, ADCL      ; Someone on Stack Overflow said
    LDS inputHreg, ADCH      ; you must read ADCL first then ADCH

    ; We're trating the 2 least significant bits in inputReg as "don't care"
    ; to cut the 10-bit convereted value down to a "simple" 8 bits
    ; loosing some precision but keeping numbers more manageable.
    ; If that turns out to be a bad idea, we'll have to hold these 10-bit
    ; values as 16-bit pairs ; inputHReg = XXXXXX12       inputLReg = 345678XX
    ROR inputHReg            ; inputHReg = XXXXXXX1 c = 2
    ROR inputLReg            ;                            inputLReg = 2345678X
    ROR inputHReg            ; inputHReg = XXXXXXXX c = 1
    ROR inputLReg            ;                            inputLReg = 12345678
.ENDMACRO
