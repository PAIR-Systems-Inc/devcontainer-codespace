FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Minimal setup for developing with GoodMem API through GoodMem CLI" \
      org.opencontainers.image.version="1.2.0"

SHELL ["/bin/bash", "-c"]

# Base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git unzip gnupg ca-certificates software-properties-common \
    apt-transport-https sudo

# Dev user
# EDIT: DISABLED for now to avoid permission issues with mounted volumes
# RUN useradd -m -s /bin/bash vscode && \
#     echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
#     chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
#     mkdir -p /home/vscode/.goodmem/data/database && \
#     chown -R vscode:vscode /home/vscode/.goodmem

# APT clean up
RUN rm -rf /var/lib/apt/lists/*

# USER vscode

# # Use Codespaces default; the repo will be mounted at /workspaces/<repo>
# WORKDIR /workspaces
