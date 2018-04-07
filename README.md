The prototype for this project is currently at
https://github.com/edgeeffect/avr-control-panel

# Toolchain

## avrdude

I've just got the avrdude that comes with my Linux distribution

## assembler

I couldn't get avra to work with the m1284P
and the GNU avr-as had complicated syntax
then I found gavrasm which seems to do the trick more than adequately
http://www.avr-asm-tutorial.net/gavrasm/index_en.html

# Assemble

    ~/bin/gavrasm test.asm

# Program

    avrdude -B10 -c usbasp-clone -p m324p -U flash:w:test.hex

# My Fuse Settings

    avrdude -c usbasp-clone -p m1284p -U lfuse:w:0xff:m -U hfuse:w:0xd6:m -U efuse:w:0xff:m