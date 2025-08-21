FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Minimal setup for developing with GoodMem APIs (Python + JS + .NET)" \
      org.opencontainers.image.version="1.1.0"

SHELL ["/bin/bash", "-c"]

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git unzip gnupg ca-certificates software-properties-common \
    build-essential apt-transport-https sudo \
    python3 python3-venv python3-pip python3-dev \
    libffi-dev libssl-dev libpq-dev cargo \
 && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (via NodeSource)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install .NET SDK 9.0
RUN wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0

# Set python defaults
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Python SDKs installed here (system-level, available everywhere)
RUN pip install --no-cache-dir --break-system-packages \
      goodmem_client \
      openai \
      requests \
      python-dotenv

# Create vscode user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
    chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
    mkdir -p /home/vscode/.goodmem/data/database && \
    chown -R vscode:vscode /home/vscode/.goodmem

USER vscode
WORKDIR /workspace

# --- Setup .NET GoodMemApp project inside workspace ---
RUN dotnet new console -n GoodMemApp && \
    cd GoodMemApp && \
    dotnet add package Pairsystems.Goodmem.Client && \
    dotnet build
