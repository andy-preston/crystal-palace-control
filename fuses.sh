#!/bin/bash

# http://www.engbedded.com/fusecalc/

# Ext. Crystal Osc.; Frequency 8.0- MHz;
# Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms;  [CKSEL=1111 SUT=00]

# CKOUT = 1
# CKDIV8 = 1
# BOOTRST = 1 # BOOTSZ = 00 (default)

# ESAVE = 0
# WDTON = 1
# SPIEN = 0
# DWEN = 1
# RSTDISBL = 0
# BODLEVEL = 111

avrdude -c usbasp-clone -p m324p \
    -U lfuse:w:0xcf:m -U hfuse:w:0xd1:m -U efuse:w:0xff:m