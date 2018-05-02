# The ARM toolchain prefix (32 bit = arm-...-eabi, 64 bit = aarch64-...-gnueabi)
TOOLCHAIN = /root/x-tools/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-elf/bin/aarch64-elf

SRC_DIR = src
BLD_DIR = build
CPY_DIR = /Volumes/boot

LINK = linker.ld
ROBJ = target/aarch64-none-elf/debug/libkernel.a
SOBJ = bootcode.o vectors.o

BINARY = kernel8

all: $(BLD_DIR)/$(BINARY).img $(BLD_DIR)/$(BINARY).list

# ELF
$(BLD_DIR)/$(BINARY).elf: $(addprefix $(BLD_DIR)/, $(SOBJ)) $(ROBJ)
	$(TOOLCHAIN)-ld -T $(SRC_DIR)/$(LINK) $^ -o $(BLD_DIR)/$(BINARY).elf

# ELF to LIST
$(BLD_DIR)/$(BINARY).list: $(BLD_DIR)/$(BINARY).elf
	$(TOOLCHAIN)-objdump -D $(BLD_DIR)/$(BINARY).elf > $(BLD_DIR)/$(BINARY).list

# ELF to IMG
$(BLD_DIR)/$(BINARY).img: $(BLD_DIR)/$(BINARY).elf
	$(TOOLCHAIN)-objcopy -O binary $(BLD_DIR)/$(BINARY).elf $(BLD_DIR)/$(BINARY).img

# ASM
$(addprefix $(BLD_DIR)/, $(SOBJ)): $(BLD_DIR)/%.o: $(SRC_DIR)/asm/%.s
	$(TOOLCHAIN)-as $(SRC_DIR)/asm/$(basename $(@F)).s -o $@

# RUST
$(ROBJ): $(SRC_DIR)
	RUST_TARGET_PATH=$(shell pwd) xargo build --target aarch64-none-elf

copy: all
	cp $(BLD_DIR)/$(BINARY).img $(CPY_DIR)/$(BINARY).img

clean:
	rm -f $(BLD_DIR)/*
	xargo clean

DOCKER_IMAGE = aarch64-rust
DOCKER_BUILD = /root/build
docker:
	docker run --rm -it -v $(CURDIR):$(DOCKER_BUILD) -w $(DOCKER_BUILD) $(DOCKER_IMAGE)

SERIAL_DEVICE = /dev/tty.usbserial-AH069DMB
SERIAL_BAUD_RATE = 115200
screen:
	screen $(SERIAL_DEVICE) $(SERIAL_BAUD_RATE)

# GDB_HOST = localhost
GDB_HOST = docker.for.mac.host.internal
GDB_ARGS = -ex "tui enable" -ex "layout split" -ex "set confirm off" 

gdb-0:
	$(TOOLCHAIN)-gdb $(BLD_DIR)/$(BINARY).elf -tui -ex "target remote $(GDB_HOST):3333" $(GDB_ARGS) -ex "load $(BLD_DIR)/$(BINARY).elf"

gdb-1:
	$(TOOLCHAIN)-gdb $(BLD_DIR)/$(BINARY).elf -ex="target remote $(GDB_HOST):3334" $(GDB_ARGS) -ex "file $(BLD_DIR)/$(BINARY).elf"
	
gdb-2:
	$(TOOLCHAIN)-gdb $(BLD_DIR)/$(BINARY).elf -ex="target remote $(GDB_HOST):3335" $(GDB_ARGS) -ex "file $(BLD_DIR)/$(BINARY).elf"
	
gdb-3:
	$(TOOLCHAIN)-gdb $(BLD_DIR)/$(BINARY).elf -ex="target remote $(GDB_HOST):3336" $(GDB_ARGS) -ex "file $(BLD_DIR)/$(BINARY).elf"


