ENTRY(_start)

OUTPUT_FORMAT(elf64-x86-64)

SECTIONS
{
    . = 0x00100000; /* load at 1MB */

    .text : {
        *(.multiboot)
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(COMMON)
        *(.bss*)
    }
}
