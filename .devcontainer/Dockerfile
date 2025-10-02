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
    libffi-dev libssl-dev libpq-dev cargo 

# Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# .NET SDK 9.0
RUN add-apt-repository ppa:dotnet/backports && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0

#Go 
ARG GO_VERSION=1.24.6
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tgz \
 && rm -rf /usr/local/go \
 && tar -C /usr/local -xzf /tmp/go.tgz \
 && rm /tmp/go.tgz
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/vscode/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
# quick sanity
RUN go version

# ---- Java (OpenJDK 21) ----
RUN apt-get install -y --no-install-recommends \
      openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

# quick sanity
RUN java -version && javac -version

# ---- Gradle (official binary) ----
RUN curl -fsSL https://services.gradle.org/distributions/gradle-8.9-bin.zip -o /tmp/gradle.zip \
 && unzip -q /tmp/gradle.zip -d /opt \
 && ln -s /opt/gradle-8.9 /opt/gradle \
 && rm -f /tmp/gradle.zip
ENV PATH="/opt/gradle/bin:${PATH}"


# quick sanity
RUN gradle -v

# Python defaults
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# Global Python deps
RUN pip install --no-cache-dir --break-system-packages \
      goodmem_client openai requests python-dotenv \
      jupyter lab

# Dotnet Interactive (for Jupyter)
RUN dotnet tool install --global Microsoft.dotnet-interactive
ENV PATH="/root/.dotnet/tools:${PATH}"
RUN dotnet interactive jupyter install

# IJavascript (Node.js kernel for Jupyter)
RUN npm config set prefix $HOME
RUN npm install -g ijavascript
ENV PATH="/root/bin:${PATH}"
RUN ijsinstall

# JJava (Java kernel for Jupyter)
RUN curl -fsSL https://github.com/dflib/jjava/releases/download/1.0-a5/jjava-1.0-a5-kernelspec.zip -o /tmp/jjava.zip && \
    unzip -q /tmp/jjava.zip -d /tmp/jjava-1.0-a5-kernelspec && \
    cd /tmp && \
    jupyter kernelspec install jjava-1.0-a5-kernelspec --user --name=java

# GONB (Go kernel for Jupyter)
RUN go install github.com/janpfeifer/gonb@latest && \
  go install golang.org/x/tools/cmd/goimports@latest && \
  go install golang.org/x/tools/gopls@latest
RUN gonb --install

# APT clean up
RUN rm -rf /var/lib/apt/lists/*

# Dev user
# EDIT: DISABLED for now to avoid permission issues with mounted volumes
# RUN useradd -m -s /bin/bash vscode && \
#     echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
#     chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
#     mkdir -p /home/vscode/.goodmem/data/database && \
#     chown -R vscode:vscode /home/vscode/.goodmem

# USER vscode

# Use Codespaces default; the repo will be mounted at /workspaces/<repo>
WORKDIR /workspaces
