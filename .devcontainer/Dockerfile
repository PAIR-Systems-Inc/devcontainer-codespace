FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Minimal setup for developing with GoodMem APIs (Python + JS + .NET)" \
      org.opencontainers.image.version="1.1.0"

SHELL ["/bin/bash", "-c"]

# Base deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git unzip gnupg ca-certificates software-properties-common \
    build-essential apt-transport-https sudo \
    python3 python3-venv python3-pip python3-dev \
    libffi-dev libssl-dev libpq-dev cargo \
 && rm -rf /var/lib/apt/lists/*

# Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# .NET SDK 8.0 (update to 9.0 if desired by changing the package name)
RUN wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

#Go 
ARG GO_VERSION=1.22.5
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tgz \
 && rm -rf /usr/local/go \
 && tar -C /usr/local -xzf /tmp/go.tgz \
 && rm /tmp/go.tgz
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/vscode/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
# quick sanity
RUN go version

#Java

# ---- Java (OpenJDK 21) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
      openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

# quick sanity
RUN java -version && javac -version

# ---- Gradle (official binary) ----
ARG GRADLE_VERSION=8.9
ARG GRADLE_SHA256=5a3f7c46d90513f28ed312e82c1948d45f407b7a2a3dcb17b3d2610fcb8e5b25
RUN curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle.zip \
 && echo "${GRADLE_SHA256}  /tmp/gradle.zip" | sha256sum -c - \
 && unzip -q /tmp/gradle.zip -d /opt \
 && ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle \
 && rm -f /tmp/gradle.zip
ENV PATH="/opt/gradle/bin:${PATH}"

# quick sanity
RUN gradle -v

# Python defaults
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# Global Python deps
RUN pip install --no-cache-dir --break-system-packages \
      goodmem_client openai requests python-dotenv

# Dev user
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
    chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
    mkdir -p /home/vscode/.goodmem/data/database && \
    chown -R vscode:vscode /home/vscode/.goodmem

USER vscode

# Use Codespaces default; the repo will be mounted at /workspaces/<repo>
WORKDIR /workspaces
