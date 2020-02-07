# Makefile for user application

# Any bigger and it just straight up fails to load
APP_HEAP_SIZE=512
TOOLCHAIN=riscv64-unknown-elf
LAYOUT=hifive1.ld

# Specify this directory relative to the current application.
TOCK_USERLAND_BASE_DIR = /home/labbott/libtock-c/

# Which files to compile.
C_SRCS := $(wildcard *.c)

# Include userland master makefile. Contains rules and flags for actually
# building the application.
include $(TOCK_USERLAND_BASE_DIR)/AppMakefile.mk
