CC = arm-none-eabi-gcc
CPP = arm-none-eabi-g++
LD = arm-none-eabi-ld

# Banderas específicas para el STM32C5A3ZG (Cortex-M33 + FPU)
CFLAGS = -mcpu=cortex-m33 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16 -O2
CPPFLAGS = $(CFLAGS) -std=c++20 -fno-exceptions -fno-rtti

all: kernel.elf

kernel.elf: main.o startup.o
	$(CPP) $(CPPFLAGS) -T linker_script.ld main.o startup.o -o kernel.elf
