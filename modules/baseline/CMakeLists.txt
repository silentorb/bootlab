cmake_minimum_required(VERSION 3.20)
project(hello_kernel ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set(CMAKE_ASM_NASM_FLAGS "-g")

enable_language(ASM_NASM)

# Define output directories
set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Assemble 64-bit-capable ELF object from NASM
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.o
    COMMAND nasm
    ARGS -f elf64 -o ${BUILD_DIR}/kernel.o ${SRC_DIR}/kernel.asm
    DEPENDS ${SRC_DIR}/kernel.asm
    COMMENT "Assembling kernel.asm (elf64)"
    VERBATIM
)

# Link into a 64-bit ELF
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.elf
    COMMAND ld
    ARGS -m elf_x86_64 -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -nostdlib -o ${BUILD_DIR}/kernel.elf ${BUILD_DIR}/kernel.o
    DEPENDS ${BUILD_DIR}/kernel.o
    COMMENT "Linking kernel.elf (x86_64)"
    VERBATIM
)

add_custom_target(kernel.elf ALL DEPENDS ${BUILD_DIR}/kernel.elf)