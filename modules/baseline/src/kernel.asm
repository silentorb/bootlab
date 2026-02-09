BITS 64
default rel

global pvh_entry
extern kernel_main

; -------------------------
; REQUIRED Xen PVH ELF NOTE
; -------------------------
section .note.Xen note alloc
align 4
    dd 4                  ; namesz
    dd 8                  ; descsz (64-bit entry)
    dd 18                 ; XEN_ELFNOTE_PVH_ENTRY
    db "Xen", 0
    align 4
    dq pvh_entry           ; entry point QEMU will jump to

; -------------------------
; Code
; -------------------------
section .text
align 16
pvh_entry:
    cli
    cld                 ; Required for C code

    ; rdi = struct hvm_start_info * (can ignore for now)
    mov rsp, stack_top
    xor rbp, rbp

    call kernel_main

.hang:
    hlt
    jmp .hang

section .bss
align 16
stack:
    resb 8192
stack_top:
