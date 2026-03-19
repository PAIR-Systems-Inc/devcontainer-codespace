#!/bin/bash

# Install GoodMem and initialize (create root user and generate API key while saving it to config.toml)
echo "Installing GoodMem..."
curl -s "https://get.goodmem.ai" | bash -s -- --handsfree --db-password "my-secure-password"

# Extract API key and add to ~/.bashrc
echo "Configuring GoodMem API key..."
if [ -f ~/.goodmem/config.toml ]; then
    API_KEY=$(grep "^api_key" ~/.goodmem/config.toml | cut -d"'" -f2)
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

echo "GoodMem installation and configuration complete!"
