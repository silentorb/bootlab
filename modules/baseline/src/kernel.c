#include <stdint.h>

static volatile uint16_t* const VGA = (uint16_t*)0xB8000;

static uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t)c | (uint16_t)color << 8;
}

void kernel_main(void) {
    const char* msg = "Booting micro-vm kernel...";
    uint8_t color = 0x0F; // white on black

    for (int i = 0; msg[i]; i++) {
        VGA[i] = vga_entry(msg[i], color);
    }

    // Halt indefinitely
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
