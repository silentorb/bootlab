project(baseline C ASM)

add_executable(baseline 
    src/main.c 
)

set(BOOTLOADER_BIN ${CMAKE_CURRENT_BINARY_DIR}/boot.bin)
set(BOOTLOADER_ELF ${CMAKE_CURRENT_BINARY_DIR}/boot.elf)

add_custom_command(
    OUTPUT ${BOOTLOADER_ELF}
    COMMAND nasm -f bin -o ${BOOTLOADER_BIN} ${CMAKE_CURRENT_SOURCE_DIR}/src/boot.S
    COMMAND nasm -f elf64 -o ${BOOTLOADER_ELF} ${CMAKE_CURRENT_SOURCE_DIR}/src/boot-elf.S
)

add_custom_target(bootloader
    DEPENDS ${BOOTLOADER_ELF}
)

add_dependencies(baseline bootloader)

set(CMAKE_ASM_COMPILER nasm)
