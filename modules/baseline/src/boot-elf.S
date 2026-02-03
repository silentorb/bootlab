[bits 16]             ; Run in 16-bit real mode

start:
    cli                 ; Disable interrupts
    xor ax, ax
    mov ds, ax          ; Set DS = 0
    mov es, ax          ; Set ES = 0
    mov ss, ax          ; Set SS = 0
    mov sp, 0x7C00      ; Stack grows down from here
    sti                 ; Enable interrupts

    ; Print "Hello" using BIOS interrupt 0x10
    mov si, message
print_loop:
    lodsb               ; Load next char into AL
    cmp al, 0
    je hang
    mov ah, 0x0E        ; BIOS teletype function
    mov bh, 0x00
    mov bl, 0x07        ; Text color (light gray)
    int 0x10
    jmp print_loop

; Tell QEMU to stop execution
    mov dx, 0xf4        ; Move the I/O port address to the DX register
    mov al, 0x01        ; Move the exit value to the AL register (must be an odd value)
    out dx, al          ; Output the value to the port, triggering the QEMU exit

hang:
    cli                 ; Disable interrupts
    hlt                 ; Halt CPU
    jmp hang

message db "Hello from bootloader!", 0

; Boot sector must be exactly 512 bytes with 0xAA55 signature
times 510-($-$$) db 0
dw 0xAA55
