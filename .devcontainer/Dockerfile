FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Minimal setup for developing with GoodMem API through GoodMem CLI" \
      org.opencontainers.image.version="1.2.0"

SHELL ["/bin/bash", "-c"]

# Base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git unzip gnupg ca-certificates software-properties-common \
    apt-transport-https sudo

# # Node.js 20
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
#     apt-get install -y nodejs

### JUPYTER KERNELS (optional, for users who want to use Jupyter notebooks in the container)

# # Dotnet Interactive (for Jupyter)
# RUN dotnet tool install --global Microsoft.dotnet-interactive
# ENV PATH="/root/.dotnet/tools:${PATH}"
# RUN dotnet interactive jupyter install

# # IJavascript (Node.js kernel for Jupyter)
# RUN npm config set prefix $HOME
# RUN npm install -g ijavascript
# ENV PATH="/root/bin:${PATH}"
# RUN ijsinstall

# # JJava (Java kernel for Jupyter)
# RUN curl -fsSL https://github.com/dflib/jjava/releases/download/1.0-a5/jjava-1.0-a5-kernelspec.zip -o /tmp/jjava.zip && \
#     unzip -q /tmp/jjava.zip -d /tmp/jjava-1.0-a5-kernelspec && \
#     cd /tmp && \
#     jupyter kernelspec install jjava-1.0-a5-kernelspec --user --name=java

# # GONB (Go kernel for Jupyter)
# RUN go install github.com/janpfeifer/gonb@latest && \
#   go install golang.org/x/tools/cmd/goimports@latest && \
#   go install golang.org/x/tools/gopls@latest
# RUN gonb --install

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
