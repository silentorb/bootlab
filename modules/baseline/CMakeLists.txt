cmake_minimum_required(VERSION 3.20)
project(microvm_kernel C)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type (Debug, Release, RelWithDebInfo, MinSizeRel)" FORCE)
endif()

# Define output directories
set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Compile C code using CMake's built-in compilation
add_compile_options($<$<CONFIG:Debug>:-gdwarf-3>)
add_library(kernel_c OBJECT ${SRC_DIR}/kernel.c)
target_compile_options(kernel_c PRIVATE -nostdlib -fno-builtin -fno-stack-protector -fno-pie -fno-pic -ffreestanding -mcmodel=kernel -mno-red-zone -fno-omit-frame-pointer)

# Assemble 64-bit kernel entry point
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel_entry.o
    COMMAND nasm
    ARGS -f elf64 -g -F dwarf -o ${BUILD_DIR}/kernel_entry.o ${SRC_DIR}/kernel.asm
    DEPENDS ${SRC_DIR}/kernel.asm
    COMMENT "Assembling kernel.asm (elf64)"
    VERBATIM
)

# Create a target for the assembly step
add_custom_target(kernel_entry DEPENDS ${BUILD_DIR}/kernel_entry.o)

# Link into a 64-bit ELF kernel
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.elf
    COMMAND ld
    ARGS -m elf_x86_64 -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -nostdlib -o ${BUILD_DIR}/kernel.elf ${BUILD_DIR}/kernel_entry.o $<TARGET_OBJECTS:kernel_c>
    DEPENDS ${BUILD_DIR}/kernel_entry.o kernel_c linker.ld
    COMMENT "Linking kernel.elf (x86_64 micro-vm)"
    VERBATIM
)

# Create the final kernel target
add_custom_target(kernel.elf ALL DEPENDS ${BUILD_DIR}/kernel.elf kernel_entry)