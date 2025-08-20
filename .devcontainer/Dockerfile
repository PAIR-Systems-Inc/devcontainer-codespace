
FROM ubuntu:24.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Minimal setup for developing with GoodMem APIs (Python only)" \
      org.opencontainers.image.version="1.0.0"

SHELL ["/bin/bash", "-c"]

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


RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
RUN pip install --no-cache-dir --break-system-packages \
      goodmem_client \
      openai \
      requests \
      python-dotenv

RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
    chmod 0440 /etc/sudoers.d/vscode-nopasswd && \
    mkdir -p /home/vscode/.goodmem/data/database && \
    chown -R vscode:vscode /home/vscode/.goodmem

# Create prefilled JS test project (for dev/demo use)
RUN mkdir -p /home/vscode/goodmem-js-test && \
    cd /home/vscode/goodmem-js-test && \
    npm init -y && \
    npm install dotenv && \
    npm install --save @pairsystems/goodmem-client && \
    echo "ADD_API_KEY=" > .env && \
    echo 'import { Client } from "@pairsystems/goodmem-client";\nimport "dotenv/config";\n\nconst client = new Client("http://localhost:8080");\nclient.setApiKey(process.env.ADD_API_KEY || "your-api-key");\n\nasync function run() {\n  try {\n    const apiKeysApi = client.getApiKeysApi();\n    const response = await apiKeysApi.listApiKeys();\n    console.log("API Keys:", response);\n  } catch (error) {\n    console.error("Error:", error?.response?.data || error);\n  }\n}\n\nrun();' > test.js && \
    chown -R vscode:vscode /home/vscode/goodmem-js-test


USER vscode
WORKDIR /workspace
