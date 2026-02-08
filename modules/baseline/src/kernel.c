#include <stdint.h>

// QEMU debugcon port and debug exit
#define DEBUGCON_PORT 0xe9
#define DEBUG_EXIT_PORT 0x501

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

static void print(const char* str) {
    while (*str) {
        outb(DEBUGCON_PORT, *str++);
    }
}

void kernel_main(void) {
    // Hello world!
    print("Hello, World!\n");
    print("Bootlab micro-vm kernel running in 64-bit mode\n");
    print("SUCCESS: Kernel initialized\n");
    
    // Signal success and exit
    outb(DEBUG_EXIT_PORT, 0x10);
    
    // Halt if debug exit doesn't work
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
