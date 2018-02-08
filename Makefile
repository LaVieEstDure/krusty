SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles
BLDIR = ./builddir
all: clean kernel8.img

$(BLDIR)/init.o: ./src/init.S
	aarch64-elf-gcc $(CFLAGS) -c ./src/init.S -o $(BLDIR)/init.o 

$(BLDIR)/kernel.o: ./src/kernel.c
	aarch64-elf-gcc $(CFLAGS) -c ./src/kernel.c -o $(BLDIR)/kernel.o
%.o: %.c
	aarch64-elf-gcc $(CFLAGS) -c $< -o $@

kernel8.img: $(BLDIR)/init.o $(BLDIR)/kernel.o $(OBJS)
	aarch64-elf-ld -nostdlib -nostartfiles $(BLDIR)/init.o $(BLDIR)/kernel.o -T ./src/link.ld -o $(BLDIR)/kernel8.elf
	aarch64-elf-objcopy -O binary $(BLDIR)/kernel8.elf $(BLDIR)/kernel8.img

clean:
	rm $(BLDIR)/kernel8.elf *.o >/dev/null 2>/dev/null || true
