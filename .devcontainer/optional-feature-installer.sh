#!/bin/bash

# This script provides an interactive menu for users to choose which GoodMem SDK or tool they want install in the dev container.

# Logic for printing menu
options=(
  "Jupyter Notebook"
  "Python SDK"
  ".NET SDK"
  "Node.js SDK"
  "Java SDK"
  "Go SDK"
)

selected=0
total=${#options[@]}

print_menu() {
  for i in "${!options[@]}"; do
    if [ "$i" -eq "$selected" ]; then
      echo "  > ${options[$i]}"
    else
      echo "    ${options[$i]}"
    fi
  done
}

# Print header once
echo ""
echo "======================================"
echo "   Welcome to GoodMem Dev Container"
echo "======================================"
echo ""
echo "Use UP/DOWN arrows to select, then press ENTER:"
echo ""

# Print menu for the first time
print_menu

while true; do
  IFS= read -rsn1 key
  if [[ $key == $'\x1b' ]]; then
    read -rsn2 -t 0.1 key
    case $key in
      '[A') (( selected = (selected - 1 + total) % total )) ;;  # Up
      '[B') (( selected = (selected + 1) % total )) ;;          # Down
      *) continue ;;
    esac
    # Move cursor up $total lines and redraw only the menu
    printf '\033[%dA' "$total"
    print_menu
  elif [[ $key == '' ]]; then
    break # Enter
  fi
done

echo ""
echo "Selected: ${options[$selected]}"
echo ""

case $selected in
  0)
    echo "Installing Jupyter VS Code extension..."
    code --install-extension ms-toolsai.jupyter 2>/dev/null || true

    echo "Installing Jupyter and python kernel..."
    sudo apt-get update && sudo apt-get install -y --no-install-recommends \
      python3 python3-pip python3-dev
    sudo rm -rf /var/lib/apt/lists/*
    # the --break-system-packages flag installs to the native Python installation instead of a virtual environment
    pip install --no-cache-dir --break-system-packages jupyter lab python-dotenv

    # clone the goodmem-samples repository
    GOODMEM_REPO_DIR="goodmem-samples"
    if [ ! -d "$GOODMEM_REPO_DIR" ]; then
        git clone https://github.com/PAIR-Systems-Inc/goodmem-samples.git "$GOODMEM_REPO_DIR"
        echo "GoodMem repository cloned to $GOODMEM_REPO_DIR"
    else
        echo "GoodMem repository already exists at $GOODMEM_REPO_DIR"
    fi

    # echo "Starting Jupyter Lab..."
    echo "Jupyter environment ready"
    echo "  - Open any .ipynb file in VS Code to start"
    ;;
  ###############################################################
  ##################### installing Python #######################
  ###############################################################
  1)
    echo "Installing Python VS Code extension..."
    code --install-extension ms-python.python 2>/dev/null || true

    echo "Installing Python dependencies..."
    sudo apt-get update && sudo apt-get install -y --no-install-recommends \
      python3 build-essential python3-pip python3-dev \
      libffi-dev libssl-dev
    sudo rm -rf /var/lib/apt/lists/*
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

    echo "Installing Python SDK packages..."
    pip install --no-cache-dir --break-system-packages goodmem_client openai requests python-dotenv
    # jupyter lab

    echo "Python environment ready"
    ;;
  ###############################################################
  ###################### installing .NET ########################
  ###############################################################
  2)
    echo "Installing .NET SDK 8.0..."
    sudo apt-get update && sudo apt-get install -y dotnet-sdk-8.0
    sudo rm -rf /var/lib/apt/lists/*
    echo "Creating .NET sample app with GoodMem client..."

    DOTNET_APP_DIR="src/GoodMemDotnetApp"
    if [ ! -d "$DOTNET_APP_DIR" ]; then
      dotnet new console -o "$DOTNET_APP_DIR" -n GoodMemDotnetApp
      ( cd "$DOTNET_APP_DIR" && dotnet add package Pairsystems.Goodmem.Client )
    fi
    ( cd "$DOTNET_APP_DIR" && dotnet restore && dotnet build )

    echo ".NET environment ready"
    echo "  - Sample app: $DOTNET_APP_DIR"
    ;;
  ###############################################################
  ################### installing Node.js ########################
  ###############################################################
  3)
    echo "Installing Node.js 20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
    sudo apt-get install -y nodejs
    sudo rm -rf /var/lib/apt/lists/*

    npm install -g pnpm

    node --version
    pnpm --version

    echo "Creating Node.js sample app with GoodMem client..."
    NODE_APP_DIR="src/GoodMemNodeApp"

    if [ ! -d "$NODE_APP_DIR" ]; then
      mkdir -p "$NODE_APP_DIR"
      cd "$NODE_APP_DIR"

      cat > package.json <<'NODEPKG'
{
  "name": "goodmem-js-example",
  "version": "1.0.0",
  "description": "Automated dev environment for the GoodMem JS SDK",
  "main": "index.js",
  "type": "module",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "dotenv": "^16.4.5",
    "goodmem": "0.1.0"
  }
}
NODEPKG

      pnpm install
      cd - >/dev/null
    fi

    echo "Node.js environment ready"
    echo "  - Sample app: $NODE_APP_DIR"
    ;;
  ###############################################################
  ###################### installing Java ########################
  ###############################################################
  4)
    echo "Installing Java (OpenJDK 21) and Gradle 8.9..."
    sudo apt-get update && sudo apt-get install -y --no-install-recommends openjdk-21-jdk
    sudo rm -rf /var/lib/apt/lists/*

    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
    export PATH="$JAVA_HOME/bin:$PATH"

    curl -fsSL https://services.gradle.org/distributions/gradle-8.9-bin.zip -o /tmp/gradle.zip
    sudo unzip -q /tmp/gradle.zip -d /opt
    sudo ln -sf /opt/gradle-8.9 /opt/gradle
    rm -f /tmp/gradle.zip
    export PATH="/opt/gradle/bin:$PATH"

    if ! grep -q 'JAVA_HOME' ~/.bashrc; then
      echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
      echo 'export PATH="$JAVA_HOME/bin:/opt/gradle/bin:$PATH"' >> ~/.bashrc
    fi

    java -version
    gradle -v

    echo "Creating Java sample app with GoodMem client..."

    JAVA_APP_DIR="src/GoodMemJavaApp"

    if [ ! -d "$JAVA_APP_DIR" ]; then
      mkdir -p "$JAVA_APP_DIR"
      cd "$JAVA_APP_DIR"

      printf "1\n" | gradle -q init \
        --type java-application \
        --dsl kotlin \
        --test-framework junit \
        --project-name GoodMemJavaApp \
        --package com.pairsystems.goodmem.sample \
        --java-version 21

      if [ -f "build.gradle.kts" ]; then
        awk '1;/dependencies *\{/ && !x{print "    implementation(\"com.pairsystems:goodmem-client:1.0.0\")"; x=1}' \
          build.gradle.kts > build.gradle.kts.tmp && mv build.gradle.kts.tmp build.gradle.kts
      fi
    else
      cd "$JAVA_APP_DIR"
    fi

    ./gradlew --no-daemon build || echo "WARN: build failed (artifact may not be published yet)"
    cd - >/dev/null

    echo "Java environment ready"
    echo "  - Sample app: $JAVA_APP_DIR"
    ;;
  ###############################################################
  ######################## installing Go ########################
  ###############################################################
  5)
    echo "Installing Go 1.24.6..."
    GO_VERSION=1.24.6
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tgz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tgz
    rm /tmp/go.tgz

    export GOROOT=/usr/local/go
    export GOPATH="$HOME/go"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

    if ! grep -q 'GOROOT' ~/.bashrc; then
      echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
      echo 'export GOPATH="$HOME/go"' >> ~/.bashrc
      echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> ~/.bashrc
    fi

    go version

    echo "Creating Go sample app with GoodMem client..."

    GO_APP_DIR="src/GoodMemGoApp"
    GO_SDK_MOD="github.com/PAIR-Systems-Inc/goodmem/clients/go@v1.0.10"

    if [ ! -d "$GO_APP_DIR" ]; then
      mkdir -p "$GO_APP_DIR"
    fi

    cd "$GO_APP_DIR"

    if [ ! -f go.mod ]; then
      go mod init goodmem-app
    fi

    go get "$GO_SDK_MOD"

    if [ ! -f main.go ]; then
      cat > main.go <<'EOF'
package main

import (
  "fmt"
  _ "github.com/PAIR-Systems-Inc/goodmem/clients/go"
)

func main() {
  fmt.Println("Go SDK wired; import ok")
}
EOF
    fi

    go mod tidy
    go build ./...
    
    cd - >/dev/null
    echo "Go environment ready"
    echo "  - Sample app: $GO_APP_DIR"
    ;;
esac
