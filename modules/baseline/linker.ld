OUTPUT_FORMAT(elf64-x86-64)
ENTRY(pvh_entry)

SECTIONS
{
    . = 0x100000;

    .note.Xen : {
        KEEP(*(.note.Xen))
    }

    .text : {
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
