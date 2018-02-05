.section ".text.boot"

.global _start

_start:
    // Set up stack and bss
0:  
    mov sp, #0x80000
    ldr x9, =__bss_start
    ldr x10, =__bss_end
   	ldr x1, =_start
    sub x11, x10, x9
1:  
    cbz x11, 2f
    str xzr, [x1], #8
    sub x11, x11, #8
    cbnz x11, 1b
2:  
    bl main
halt:
    wfe
    b halt
