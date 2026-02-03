FROM mcr.microsoft.com/devcontainers/base:debian AS base

# By default /workspaces is owned by `root`.
# When the Dev Container extension mounts the source directory, it changes the mounted file owner to `vscode`.
# A directory is created under /workspaces which is owned by `vscode` and acts as a scratch pad to store
# miscellaneous ephemeral files.
RUN <<EOF
mkdir -p /workspaces/dev
chown vscode:vscode /workspaces/dev
EOF

# Update packages
RUN <<EOF
apt update
apt upgrade -y
EOF

# Build dependencies for experimental apps
RUN <<EOF
apt install -y --no-install-recommends \
    nasm \
#   gnu-efi
EOF

# Install COSMIC build tool dependencies
RUN <<EOF
apt install -y --no-install-recommends \
  cmake
EOF

# Install runtime dependencies
RUN <<EOF
apt install -y --no-install-recommends \
  gdb \
  ovmf \
  qemu-system-x86
EOF
