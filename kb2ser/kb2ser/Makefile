MCU      = atmega168p
TARGET   = kb2ser
SRC      = SBCInterface.c
OBJDIR   = build
PREBUILT = ../Prebuilt

CC       = avr-gcc
OBJCOPY  = avr-objcopy
OBJDUMP  = avr-objdump
SIZE     = avr-size

CFLAGS  = -mmcu=$(MCU)
CFLAGS += -funsigned-char -funsigned-bitfields
CFLAGS += -Wall
CFLAGS += -I.

LDFLAGS = -mmcu=$(MCU) -lm

AVRDUDE    = avrdude
AVRDUDE_PROGRAMMER = avrispmkII
AVRDUDE_PART = m168

.PHONY: all release debug hex eep lss clean program

all: release

release: CFLAGS += -Os -DNDEBUG
release: hex eep lss

debug: CFLAGS += -O1 -g2 -DDEBUG
debug: hex eep lss

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/$(SRC:.c=.o): $(SRC) | $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR)/$(TARGET).elf: $(OBJDIR)/$(SRC:.c=.o)
	$(CC) $(LDFLAGS) -o $@ $^
	$(SIZE) $@

hex: $(OBJDIR)/$(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $(OBJDIR)/$(TARGET).hex
	cp $(OBJDIR)/$(TARGET).hex $(PREBUILT)/$(TARGET).hex

eep: $(OBJDIR)/$(TARGET).elf
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom="alloc,load" \
		--change-section-lma .eeprom=0 $< $(OBJDIR)/$(TARGET).eep 2>/dev/null; \
	cp $(OBJDIR)/$(TARGET).eep $(PREBUILT)/$(TARGET).eep 2>/dev/null; true

lss: $(OBJDIR)/$(TARGET).elf
	$(OBJDUMP) -h -S $< > $(OBJDIR)/$(TARGET).lss

program:
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMER) -p $(AVRDUDE_PART) -U flash:w:$(PREBUILT)/$(TARGET).hex
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMER) -p $(AVRDUDE_PART) -U eeprom:w:$(PREBUILT)/$(TARGET).eep

program-fuses:
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMER) -p $(AVRDUDE_PART) -U lfuse:w:$(PREBUILT)/$(TARGET).lfuse
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMER) -p $(AVRDUDE_PART) -U hfuse:w:$(PREBUILT)/$(TARGET).hfuse

clean:
	rm -rf $(OBJDIR)
