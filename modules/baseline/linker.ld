OUTPUT_FORMAT(elf64-x86-64)
ENTRY(pvh_entry)

PHDRS
{
    note   PT_NOTE FLAGS(4);   /* R */
    text   PT_LOAD FLAGS(5);   /* R + X */
    rodata PT_LOAD FLAGS(4);   /* R */
    data   PT_LOAD FLAGS(6);   /* R + W */
}

SECTIONS
{
    . = 0x100000;
    
    /* Xen PVH note MUST be in PT_NOTE segment */
    .note.Xen : {
        KEEP(*(.note.Xen))
    } :note :text

    . = ALIGN(4K);
    _kernel_start = .;

    .text : ALIGN(4K) {
        *(.text*)
    } :text

    .rodata : ALIGN(4K) {
        *(.rodata*)
    } :rodata

    .data : ALIGN(4K) {
        *(.data*)
    } :data

    .bss (NOLOAD) : ALIGN(4K) {
        *(COMMON)
        *(.bss*)
    }

    _kernel_end = .;
}
