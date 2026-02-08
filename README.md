# Bootlab

Will It Boot?

Yes, it boots!

Bootlab is a playground for experimenting with lightweight virtualization using QEMU's microvm machine type.

## Architecture: Micro-VM Booting

The project now uses QEMU's **microvm** machine type, a lightweight virtual machine optimized for minimal overhead and startup time. This bootlab demonstrates:

1. **Direct 64-bit kernel boot**: The kernel boots directly in x86_64 long mode without transitioning from 32-bit protected mode
2. **Minimal bootloader overhead**: QEMU's hypervisor handles CPU initialization, paging, and hardware setup
3. **Bare-metal kernel development**: Pure 64-bit x86_64 kernel with minimal dependencies
4. **Lightweight VM experimentation**: Perfect for testing kernel features and VM behavior

## Building

```bash
cd /workspaces/bootlab
mkdir -p build
cd build
cmake ..
make
```

The kernel will be compiled to: `build/modules/baseline/kernel.elf`

## Running with QEMU

The project includes a VS Code task to run the kernel with QEMU:

```bash
# Via VS Code: Run the "run-qemu-baseline" task
# Or manually:
qemu-system-x86_64 -machine microvm -m 256 -kernel build/modules/baseline/kernel.elf -serial stdio
```

## Kernel Components

- **kernel.asm**: 64-bit entry point and boot code
- **kernel.c**: Main kernel functionality (VGA output demonstration)
- **linker.ld**: Linker script for 64-bit flat kernel layout

## Debugging

The QEMU task includes debugging support with GDB:
- GDB listens on localhost:1234
- Kernel symbols are preserved in the ELF binary
- Use VS Code's "Baseline QEMU+GDB" launch configuration to debug
