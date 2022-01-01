; This isn't good enough for 16 bit values.
; The ADC is 10 bit 0 -> 1023 (signed 3 digits + sign ... -511 -> 512)

.macro numDisplayLeft
    ldi XL, low(textBuffer)
    ldi XH, high(textBuffer)
.endMacro

.macro numDisplayRight
    ldi XL, low(textBuffer + 4)
    ldi XH, high(textBuffer + 4)
.endMacro

; ------------------------------------------------------------------------------

numDisplayDigit:
    cpi displayReg, '0'         ; if not 0, just display
    brne noLeading0
    BRTC noLeading0          ; if 0 but other digits displayed, show the 0
    ldi displayReg, ' '
    rjmp numDisplayDoDigit
noLeading0:
    CLT
numDisplayDoDigit:
    st X+, displayReg
    ret

; ------------------------------------------------------------------------------

numDisplayShared:
    SET                      ; leading 0 flag
    ldi displayReg, '0' - 1

numDisplay1000:
    inc displayReg
    mov saveLReg, lowReg
    mov saveHReg, highReg
    subi lowReg, low(1000)
    SBCI highReg, high(1000)
    BRCC numDisplay1000
    mov lowReg, saveLReg      ; restore number from before overflow
    mov highReg, saveHReg
    call numDisplayDigit

    ldi displayReg, '0' - 1
numDisplay100:
    inc displayReg
    mov saveLReg, lowReg
    mov saveHReg, highReg
    subi lowReg, low(100)
    SBCI highReg, high(100)
    BRCC numDisplay100
    mov lowReg, saveLReg      ; restore number from before overflow
    mov highReg, saveHReg
    call numDisplayDigit

    ldi displayReg, '0' - 1
numDisplay10:
    inc displayReg
    mov saveLReg, lowReg
    subi lowReg, 10
    BRCC numDisplay10
    mov lowReg, saveLReg      ; restore number from before overflow
    call numDisplayDigit

numDisplayUnit:
    ldi displayReg, '0'
    ADD displayReg, lowReg
    rjmp numDisplayDoDigit ; even if it is all zeros, we want to see the last one

; ------------------------------------------------------------------------------

numDisplayUnsigned:
    PUSH highReg
    PUSH lowReg
    call numDisplayShared
numDisplayExit:
    POP lowReg
    POP highReg
    ret

; ------------------------------------------------------------------------------

; Not true two-compliment negative - maps 0 -> 1023 to -511 -> 512
numDisplaySigned:
    PUSH highReg
    PUSH lowReg

    cpi highReg, high(512)
    BRLT numDisplayNegative
    subi lowReg, low(511)
    SBCI highReg, high(511)
    call numDisplayShared
    rjmp numDisplayExit      ; Careful now! Approaching spagetti

numDisplayNegative:
    movW Z, lhReg
    ldi lowReg, low(511)
    ldi highReg, high(511)
    SUB lowReg, ZL
    SBC highReg, ZH
    call numDisplayShared

minusSignLoop:
    LD displayReg, -X
    cpi displayReg, ' '
    brne minusSignLoop
    ldi displayReg, '-'
    st X, displayReg

    rjmp numDisplayExit      ; Careful now! Approaching spagetti
