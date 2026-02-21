#include <stdint.h>

// QEMU debug exit
#define DEBUG_EXIT_PORT 0x501

// COM1 UART base and registers
#define COM1_BASE 0x3F8
#define UART_DATA (COM1_BASE + 0)
#define UART_IER (COM1_BASE + 1)
#define UART_FCR (COM1_BASE + 2)
#define UART_LCR (COM1_BASE + 3)
#define UART_MCR (COM1_BASE + 4)
#define UART_LSR (COM1_BASE + 5)

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t val;
    __asm__ volatile("inb %1, %0" : "=a"(val) : "Nd"(port));
    return val;
}

static void uart_init(void) {
    // Disable interrupts
    outb(UART_IER, 0x00);
    // Enable DLAB to set divisor
    outb(UART_LCR, 0x80);
    // Divisor = 1 (115200 baud)
    outb(UART_DATA, 0x01);
    outb(UART_IER, 0x00);
    // 8N1
    outb(UART_LCR, 0x03);
    // Enable FIFO, clear, 14-byte threshold
    outb(UART_FCR, 0xC7);
    // RTS/DSR set
    outb(UART_MCR, 0x03);
}

static void uart_putc(char ch) {
    while ((inb(UART_LSR) & 0x20) == 0) {
        __asm__ volatile ("pause");
    }
    outb(UART_DATA, (uint8_t)ch);
}

static void __attribute__((noinline)) print(const char* str) {
    while (*str) {
        uart_putc(*str++);
    }
}

void kernel_main(void) {
    uart_init();
    // Hello world!
    print("A\n");
    print("Bootlab micro-vm kernel running in 64-bit mode\n");
    print("SUCCESS: Kernel initialized\n");
    
    // Signal success and exit
    outb(DEBUG_EXIT_PORT, 0x10);
    
    // Halt if debug exit doesn't work
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
