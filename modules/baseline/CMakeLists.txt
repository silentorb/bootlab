cmake_minimum_required(VERSION 3.20)
project(microvm_kernel C ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set(CMAKE_ASM_NASM_FLAGS "-g")

enable_language(ASM_NASM)

# Disable standard library and other defaults for bare-metal kernel
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostdlib -fno-builtin -fno-stack-protector -fno-pie")

# Define output directories
set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Assemble 64-bit kernel entry point
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel_entry.o
    COMMAND nasm
    ARGS -f elf64 -o ${BUILD_DIR}/kernel_entry.o ${SRC_DIR}/kernel.asm
    DEPENDS ${SRC_DIR}/kernel.asm
    COMMENT "Assembling kernel.asm (elf64)"
    VERBATIM
)

# Compile C kernel code
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.o
    COMMAND gcc
    ARGS -nostdlib -fno-builtin -fno-stack-protector -fno-pie -c -o ${BUILD_DIR}/kernel.o ${SRC_DIR}/kernel.c
    DEPENDS ${SRC_DIR}/kernel.c
    COMMENT "Compiling kernel.c"
    VERBATIM
)

# Link into a 64-bit ELF kernel
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.elf
    COMMAND ld
    ARGS -m elf_x86_64 -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -nostdlib -o ${BUILD_DIR}/kernel.elf ${BUILD_DIR}/kernel_entry.o ${BUILD_DIR}/kernel.o
    DEPENDS ${BUILD_DIR}/kernel_entry.o ${BUILD_DIR}/kernel.o
    COMMENT "Linking kernel.elf (x86_64 micro-vm)"
    VERBATIM
)

add_custom_target(kernel.elf ALL DEPENDS ${BUILD_DIR}/kernel.elf)