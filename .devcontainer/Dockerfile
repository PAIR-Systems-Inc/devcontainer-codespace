FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Preinstalled GoodMem SDKs for Python, Java, Go, .NET, and JavaScript" \
      org.opencontainers.image.version="1.0.0"

SHELL ["/bin/bash", "-c"]

# Base system & languages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git unzip gnupg ca-certificates software-properties-common \
    build-essential apt-transport-https sudo \
    python3 python3-venv python3-pip python3-dev \
    libffi-dev libssl-dev libpq-dev cargo \
    openjdk-17-jdk maven \
    dotnet-sdk-8.0 \
    golang-go \
    nodejs npm \
 && rm -rf /var/lib/apt/lists/*

# Python environment
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Python SDKs
RUN pip install --no-cache-dir --break-system-packages \
    goodmem_client \
    openai \
    requests \
    python-dotenv

# JavaScript SDK
RUN npm install -g @pairsystems/goodmem-client

# .NET SDK - cache via dummy project
RUN dotnet new console -n tempApp && \
    cd tempApp && \
    dotnet add package Pairsystems.Goodmem.Client && \
    dotnet restore && \
    cd .. && rm -rf tempApp

# Go SDK - pre-cached using dummy import
ENV GOPATH=/home/vscode/go
ENV PATH="$GOPATH/bin:$PATH"
RUN mkdir -p /tmp/goodmem-go && cd /tmp/goodmem-go && \
    go mod init goodmem-test && \
    go get github.com/PAIR-Systems-Inc/goodmem/clients/go@latest && \
    rm -rf /tmp/goodmem-go

# Java SDK - preload via Maven
RUN mvn dependency:get -Dartifact=ai.pairsys.goodmem:goodmem-client-java:1.0.2


# Create dev user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
    chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
    mkdir -p /home/vscode/.goodmem/data/database && \
    chown -R vscode:vscode /home/vscode/.goodmem

USER vscode
WORKDIR /workspace
