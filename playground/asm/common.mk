##
# @file   Makefile
# @author cy023 (cyyang023@gmail.com)
# @date   2023.09.18
# @brief  Makefile for RISC-V assembly test.

################################################################################
# System Infomation & Configuration
################################################################################

## Target Info.
ARCH   = -march=rv32imac
ISA    = -misa-spec=2.2
ABI    = -mabi=ilp32
CMODEL = -mcmodel=medlow

## Warning Options
WARNINGS = -Wall

## Debugging Options
DEBUG = -g

## Optimize Options
OPTIMIZE = -O0

################################################################################
# Files
################################################################################

## Target HEX Files
TARGET_FILE = $(TARGET).elf $(TARGET).bin

## Object Files
OBJECTS = $(ASM_SOURCES:.s=.o)

################################################################################
# Toolchain
################################################################################
COMPILER_PATH ?= 
CROSS   := $(COMPILER_PATH)riscv64-unknown-elf
CC      := $(CROSS)-gcc
AR      := $(CROSS)-ar
SIZE    := $(CROSS)-size
OBJDUMP := $(CROSS)-objdump
OBJCOPY := $(CROSS)-objcopy
NM      := $(CROSS)-nm
GDB     := gdb-multiarch

## Common Options for assemble, compile and link.
MCUFLAGS = $(ARCH) $(ISA) $(ABI) $(CMODEL)

## Assembler Options
ASMFLAGS  = $(MCUFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,$(DEBUG)

## Compile Options
CFLAGS  = $(MCUFLAGS)
CFLAGS += $(WARNINGS) $(DEBUG) $(OPTIMIZE)

## Link Options
LDFLAGS  = $(MCUFLAGS)
LDFLAGS += -Wl,--no-relax -Wl,--gc-sections
LDFLAGS += -nostdlib -nostartfiles
LDFLAGS += -Ttext=0x80000000

## QEMU Options
QEMU = qemu-system-riscv32
QFLAGS = -nographic -smp 1 -machine virt -bios none

################################################################################
# User Command
################################################################################

all: $(OBJECTS) $(TARGET_FILE)
	@echo "=============== SIZE ==============="
	@echo "------------------------------------"
	$(SIZE) $^

macro: $(OBJECTS:.o=.i)

dump: $(TARGET).lss $(TARGET).sym

size: $(TARGET_FILE)
	$(SIZE) $(TARGET_FILE)

run: all
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@echo "No output, please run 'make debug' to see details"
	@${QEMU} ${QFLAGS} -kernel ./${TARGET}.elf

debug: all
	@echo "Press Ctrl-C and then input 'quit' to exit GDB and QEMU"
	@echo "-------------------------------------------------------"
	@${QEMU} ${QFLAGS} -kernel ${TARGET}.elf -s -S &
	@${GDB} ${TARGET}.elf -q -x ${GDBINIT}

code: all
	@${OBJDUMP} -S ${TARGET}.elf | less

hex: all
	@hexdump -C ${TARGET}.bin

clean:
	-rm -f *.i *.o *.bin *.hex *.elf *.lss *.sym

systeminfo:
	@uname -a
	@$(CC) --version

.PHONY: all macro dump size systeminfo run debug code hex clean systeminfo

################################################################################
# Build The Project
################################################################################

## Preprocess
%.i: %.c Makefile
	$(CC) -E $(C_INCLUDES) $< -o $@

## Compile
%.o: %.c Makefile
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.s Makefile
	$(CC) -c $(ASMFLAGS) $< -o $@

## Link
$(TARGET_FILE:.hex=.elf): $(OBJECTS) Makefile
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

## Intel HEX format
%.hex: %.elf
	$(OBJCOPY) -O ihex $(HEX_FLASH_FLAGS) $< $@

## Binary format
%.bin: %.elf
	$(OBJCOPY) -S -O binary $< $@

## Disassemble
%.lss: %.elf
	$(OBJDUMP) -h -S $< > $@

## Symbol Table
%.sym: %.elf
	$(NM) -n $< > $@
