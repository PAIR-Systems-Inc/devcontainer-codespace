#!/bin/bash

echo "=== Post-setup script started ==="

# 1. Initialize GoodMem (binary already installed in image; re-run installer to set up DB and API key)
echo "Initializing GoodMem..."
curl -s "https://get.goodmem.ai" | bash -s -- --handsfree --db-password "my-secure-password"
# curl -s "https://get.goodmem.ai" | bash -s -- --handsfree --db-password "hjsaFGDGHS1726HSBD"

# 2. Extract API key and add to ~/.bashrc
echo "Configuring GoodMem API key..."
if [ -f ~/.goodmem/config.toml ]; then
    API_KEY=$(grep -o '"api_key"[[:space:]]*:[[:space:]]*"[^"]*"' ~/.goodmem/config.toml | cut -d'"' -f4)
    if [ -n "$API_KEY" ]; then
        if ! grep -q "GOODMEM_API_KEY" ~/.bashrc; then
            echo "export GOODMEM_API_KEY=\"$API_KEY\"" >> ~/.bashrc
            echo "Added GOODMEM_API_KEY to ~/.bashrc"
        else
            echo "GOODMEM_API_KEY already exists in ~/.bashrc"
        fi
        echo "***REMEMBER GOODMEM_API_KEY=\"$API_KEY\"***"
    else
        echo "Warning: Could not extract api_key from config.toml"
    fi
else
    echo "Warning: ~/.goodmem/config.toml not found"
fi


echo "=== Post-setup script completed ==="

echo "====================================="
echo "====================================="
echo "====================================="
echo "                                     "
echo "Welcome to the GoodMem Dev Container! 🎉"
echo "Click on the README.md file to get started!"
echo "                                     "
echo "====================================="
echo "====================================="
echo "====================================="

