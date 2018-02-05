SRCS = $(wildcard src/*.c)
OBJS = $(SRCS:.c=.o)
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles

all: clean kernel8.img

init.o: src/init.S
	aarch64-elf-gcc $(CFLAGS) -c src/init.S -o src/init.o

%.o: %.c
	aarch64-elf-gcc $(CFLAGS) -c $< -o $@

kernel8.img: src/init.o $(OBJS)
	aarch64-elf-ld -nostdlib -nostartfiles src/init.o $(OBJS) -T src/link.ld -o kernel8.elf
	aarch64-elf-objcopy -O binary kernel8.elf kernel8.img

cleanall: 
	rm kernel8.img kernel8.elf src/*.o >/dev/null 2>/dev/null || true

clean:
	rm kernel8.img kernel8.elf >/dev/null 2>/dev/null || true
