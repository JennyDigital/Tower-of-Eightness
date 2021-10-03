#!/bin/bash

avrdude -c avrispmkII -p m168 -U flash:w:kb2ser.hex
avrdude -c avrispmkII -p m168 -U eeprom:w:kb2ser.eep
avrdude -c avrispmkII -p m168 -U lfuse:w:kb2ser.lfuse
avrdude -c avrispmkII -p m168 -U hfuse:w:kb2ser.hfuse



