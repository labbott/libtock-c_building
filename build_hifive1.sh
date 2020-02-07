#!/usr/bin/env bash

set -eux

FLASH_START=0x20430000
SRAM_START=0x80000000
HEADER_SIZE=0x2C
STACK_SIZE=2048
APP_HEAP_SIZE=512
KERNEL_HEAP_SIZE=1024
TOCK_KERNEL=/home/labbott/tock/

build_binary() {
	f_start=$1
	s_start=$2
	h_size=$3
	stack_size=$4
	cp hifive1_template.ld hifive1.ld
	sed -i s/__FLASH_START__/$f_start/ hifive1.ld
	sed -i s/__SRAM_START__/$s_start/ hifive1.ld
	sed -i s/__HEADER_SIZE__/$h_size/ hifive1.ld
	sed -i s/__STACK_SIZE__/$stack_size/ hifive1.ld

	STACK_SIZE=$STACK_SIZE APP_HEAP_SIZE=$APP_HEAP_SIZE KERNEL_HEAP_SIZE=$KERNEL_HEAP_SIZE ELF2TAB_ARGS=`echo -n "--verbose "` make &> /tmp/bad
}

build_binary $FLASH_START $SRAM_START $HEADER_SIZE $STACK_SIZE

_ACTUAL_HEADER=`cat /tmp/bad | grep header_size | tr -s ' ' | cut -d ' ' -f 4`
_ACTUAL_START=`riscv32-unknown-elf-nm $TOCK_KERNEL/boards/hifive1/target/riscv32imac-unknown-none-elf/release/hifive1.elf | grep start_app_memory | cut -d ' ' -f 1`
echo $_ACTUAL_HEADER
echo $_ACTUAL_START
NEW_SRAM=0x$_ACTUAL_START

build_binary $FLASH_START $NEW_SRAM $_ACTUAL_HEADER $STACK_SIZE

