; 32-bit -> Long mode (x86_64) bootstrap
BITS 32

section .multiboot
align 4
    dd 0x1BADB002
    dd 0
    dd -(0x1BADB002)

section .text
global _start
extern long_mode_entry

_start:
    cli

    ; --- Load GDT for protected mode with 64-bit code descriptor ---
    lgdt [gdt_descriptor]

    ; Ensure data segments are null (flat setup)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Enable PAE in CR4 (bit 5)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Load physical address of PML4
    mov eax, pml4_table
    mov cr3, eax

    ; Enable long mode via EFER MSR (MSR 0xC0000080) LME bit (bit 8)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging (set CR0.PG)
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ; Far jump to 64-bit code selector
    ; Use a far jump to flush pipeline and switch to the 64-bit code segment
    jmp 0x08:long_mode_entry

; ------------------------------------------------------------------
; 64-bit code
; We assemble the long-mode entry as 64-bit (BITS 64)
section .text
align 16
bits 64
global long_mode_entry
long_mode_entry:
    ; Clear registers and set stack (RSP must be set)
    xor rbp, rbp
    mov rsp, stack_top

    ; Simple infinite loop
hang64:
    hlt
    jmp hang64

; ------------------------------------------------------------------
section .data
; 64-bit GDT (null, code64, data)
align 8
gdt:
    dq 0x0000000000000000
    dq 0x00af9a000000ffff    ; 64-bit code descriptor (type=code, L=1)
    dq 0x00af92000000ffff    ; data descriptor

gdt_descriptor:
    dw gdt_end - gdt - 1
    dq gdt

gdt_end:

; ------------------------------------------------------------------
; Simple 1:1 identity-mapped page tables for the first 2MB using 2MB pages
align 4096
pml4_table:
    dq pdpt_table | 0x3
    times 511 dq 0

align 4096
pdpt_table:
    dq pd_table | 0x3
    times 511 dq 0

align 4096
pd_table:
    ; map 0-2MB using 2MB page (present, rw, ps)
    dq 0x0000000000200B3
    times 511 dq 0

section .bss
align 16
stack_bottom:
    resb 4096
stack_top:
