Crystal Palace Control

The human-interface components of my home made digital (pseudo-analog)
Synthesizer project. https://hackaday.io/project/18950-crystal-palace

# Hardware

* ATmega324P (I'm using it on an RKAT40c board)
* MAX7221 SPI 7 segment controller
* 2 4-digit common cathode 7 segment displays
* 4067 X 2 analogue multiplexers
* 10K Linear Potentiometers X 32

* 74138 (SN74HCT138N) digital decoder
* 74148 X 2 digital multiplexers

RKAT40c here:
https://www.rkeducation.co.uk/rkat40c-mcc-compact-project-pcb-for-40-pin-atmel-and-sanguino---self-build-kit-727-p.asp

# Toolchain

## avrdude

I've just got the avrdude that comes with my Linux distribution

## assembler

I couldn't get avra to work with the m1284P
and the GNU avr-as had complicated syntax
then I found gavrasm which seems to do the trick very nicely
http://www.avr-asm-tutorial.net/gavrasm/index_en.html

# Assemble

    ~/bin/gavrasm -M test.asm

# Program

    avrdude -B10 -c usbasp-clone -p m324p -U flash:w:test.hex
