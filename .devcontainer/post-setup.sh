#!/bin/bash
set -e

echo "=== Post-setup script started ==="

# 0. Clone the goodmem-samples repository
GOODMEM_REPO_DIR="goodmem-samples"
if [ ! -d "$GOODMEM_REPO_DIR" ]; then
    git clone https://github.com/PAIR-Systems-Inc/goodmem-samples.git "$GOODMEM_REPO_DIR"
    echo "GoodMem repository cloned to $GOODMEM_REPO_DIR"
else
    echo "GoodMem repository already exists at $GOODMEM_REPO_DIR"
fi

# 1. Install GoodMem
echo "Installing GoodMem..."
curl -s https://get.goodmem.ai | bash -s -- --prod-install --no-openai-embedder-registration --local-db

# 2. Extract API key and add to ~/.bashrc
echo "Configuring GoodMem API key..."
if [ -f ~/.goodmem/config.json ]; then
    API_KEY=$(grep -o '"api_key"[[:space:]]*:[[:space:]]*"[^"]*"' ~/.goodmem/config.json | cut -d'"' -f4)
    if [ -n "$API_KEY" ]; then
        if ! grep -q "GOODMEM_API_KEY" ~/.bashrc; then
            echo "export GOODMEM_API_KEY=\"$API_KEY\"" >> ~/.bashrc
            echo "Added GOODMEM_API_KEY to ~/.bashrc"
        else
            echo "GOODMEM_API_KEY already exists in ~/.bashrc"
        fi
        echo "***REMEMBER GOODMEM_API_KEY=\"$API_KEY\"***"
    else
        echo "Warning: Could not extract api_key from config.json"
    fi
else
    echo "Warning: ~/.goodmem/config.json not found"
fi


echo "=== Post-setup script completed ==="
