##
# @file   Makefile
# @author cy023 (cyyang023@gmail.com)
# @date   2023.09.13
# @brief  Makefile for RV32-BM project.

################################################################################
# User Settings
################################################################################

## Target
TARGET = main

# Upload Info.
COMPORT    ?=
UPLOAD_HEX ?= main

## Target Info.
BOARD  = gd32vf103c_longan_nano
MCU    = gd32vf103
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

## Libraries Path
LIBS    = 
LIBDIRS = 

## User App Path
C_APPSRCS = $(wildcard core/*.c)

## C Source Path
C_SOURCES += $(wildcard startup/*.c)

## ASM Source Path
ASM_SOURCES =

## Include Path
C_INCLUDES  = -I.
C_INCLUDES += -Icore

################################################################################
# Project Architecture
################################################################################

## Root Path
IPATH = .

## Build Output Path
BUILD_DIR = build

## Build Reference Path
VPATH  = $(sort $(dir $(C_SOURCES)))
VPATH += $(sort $(dir $(C_APPSRCS)))
VPATH += $(sort $(dir $(ASM_SOURCES)))

## Object Files
OBJECTS  = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o))) 
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
APPOBJS  = $(addprefix $(BUILD_DIR)/,$(notdir $(C_APPSRCS:.c=.o)))

## Target HEX Files
TARGET_FILE = $(BUILD_DIR)/$(TARGET).hex

## Linker script
LDSCRIPT = gd32vf103xb.ld

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

## Common Options for assemble, compile and link.
MCUFLAGS = $(ARCH) $(ISA) $(ABI) $(CMODEL)

## Assembler Options
ASMFLAGS  = $(MCUFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,$(DEBUG)
ASMFLAGS += -x assembler-with-cpp
ASMFLAGS += $(C_INCLUDES)

## Compile Options
CFLAGS  = $(MCUFLAGS)
CFLAGS += $(WARNINGS) $(DEBUG) $(OPTIMIZE)
CFLAGS += -fmessage-length=0
CFLAGS += $(C_INCLUDES)

## Link Options
LDFLAGS  = $(MCUFLAGS)
LDFLAGS += -Wl,--no-relax -Wl,--gc-sections
LDFLAGS += -nostdlib -nostartfiles
LDFLAGS += -lc -lgcc
LDFLAGS += -specs=nosys.specs
LDFLAGS += -T$(LDSCRIPT)
LDFLAGS += $(LIBDIRS) $(LIBS)

################################################################################
# User Command
################################################################################

all: $(OBJECTS) $(APPOBJS) $(TARGET_FILE)
	@echo "========== SIZE =========="
	$(SIZE) $^

macro: $(APPOBJS:.o=.i)

dump: $(BUILD_DIR)/$(TARGET).lss $(BUILD_DIR)/$(TARGET).sym

size: $(TARGET_FILE)
	$(SIZE) $(TARGET_FILE)

clean:
	-rm -rf $(BUILD_DIR)

systeminfo:
	@uname -a
	@$(CC) --version

.PHONY: all macro dump size systeminfo clean upload terminal

################################################################################
# Build The Project
################################################################################

## Preprocess
$(BUILD_DIR)/%.i: %.c Makefile | $(BUILD_DIR)
	$(CC) -E $(C_INCLUDES) $< -o $@

## Compile
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(CC) -c $(ASMFLAGS) $< -o $@

## Link
$(TARGET_FILE:.hex=.elf): $(OBJECTS) $(APPOBJS) Makefile
	$(CC) $(LDFLAGS) $(OBJECTS) $(APPOBJS) -o $@

## Intel HEX format
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(OBJCOPY) -O ihex $(HEX_FLASH_FLAGS) $< $@

## Binary format
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(OBJCOPY) -S -O binary $< $@

## Eeprom format
$(BUILD_DIR)/%.eep: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(OBJCOPY) $(HEX_EEPROM_FLAGS) -O binary $< $@ || exit 0

## Disassemble
$(BUILD_DIR)/%.lss: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(OBJDUMP) -h -S $< > $@

## Symbol Table
$(BUILD_DIR)/%.sym: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(NM) -n $< > $@

## Make Directory
$(BUILD_DIR):
	mkdir $@
