The prototype for this project is currently at
https://gitlab.com/edgeeffect/avr-control-panel

# Issue Tracking / Project Management

https://trello.com/b/04iQRZz7/cyrstal-palace

# Hardware

* ATmega324P
* 74138 (SN74HCT138N) digital decoder
* 74148 X 2 digital multiplexers
* 4067 X 2 analogue multiplexers
* 10K Linear Potentiometers X 32
* MAX7221 SPI 7 segment controller
* 2 4-digit common cathode 7 segment displays

# Toolchain

## avrdude

I've just got the avrdude that comes with my Linux distribution

## assembler

I couldn't get avra to work with the m1284P
and the GNU avr-as had complicated syntax
then I found gavrasm which seems to do the trick more than adequately
http://www.avr-asm-tutorial.net/gavrasm/index_en.html

# Assemble

    ~/bin/gavrasm -M test.asm

# Program

    avrdude -B10 -c usbasp-clone -p m324p -U flash:w:test.hex
