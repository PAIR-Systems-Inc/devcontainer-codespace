#!/bin/bash

echo "Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • Smart GoodMem server configuration"
echo "  • Ready-to-use development workspace"
echo ""

# Create .env file template if it doesn't exist
WORKSPACE_DIR="/workspaces"
ENV_FILE="$WORKSPACE_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Creating .env configuration file..."
    cat > "$ENV_FILE" << 'EOF'
# GoodMem Configuration
GOODMEM_SERVER_URL=http://localhost:8080

# API Keys (set these for your applications)
# OPENAI_API_KEY=your-openai-key-here
# ADD_API_KEY=your-goodmem-api-key-here

# Development Settings
GOODMEM_DEBUG=true
EOF
    echo "Created .env file at $ENV_FILE"
    echo ""
fi

# Force install mode
MODE="install"

echo ""
echo "Installing GoodMem server with persistent data..."
echo ""

if curl -s --max-time 5 http://localhost:8080/v1/system/health > /dev/null 2>&1; then
    echo "✅ GoodMem server already running!"
    echo "   Using existing installation at http://localhost:8080"
else
    echo "📦 Installing GoodMem server with persistent volumes..."
    docker volume create goodmem_data || true
    docker volume create goodmem_pgdata || true
    curl -s https://get.goodmem.ai | bash -s -- --debug-install --no-openai-embedder-registration
fi

echo ""
echo "GoodMem server installation complete!"
echo ""
echo "Access Points:"
echo "  • REST API: http://localhost:8080"
echo "  • gRPC API: localhost:9090"
echo "  • Database: localhost:5432 (accessible for development)"
echo "  • JobRunr Dashboard: http://localhost:8001"
echo ""
echo "Configuration:"
echo "  • Settings file: $ENV_FILE"
echo "  • Data persists between rebuilds (Docker volumes)"
echo ""
echo "Getting Started:"
echo "  1. Your GoodMem server is running and ready to use"
echo "  2. Update API keys in .env file as needed"
echo "  3. Use the pre-installed client libraries to start building"
echo ""
echo "Setup Complete..."
