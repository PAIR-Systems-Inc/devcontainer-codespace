# GoodMem DevContainer

The **GoodMem DevContainer** is a pre-configured, zero-setup development environment designed to help you start building immediately. It includes all necessary SDKs, tools, and extensions in a single, consistent container image.

---

## Features

### Language Support
- **Python 3.10** — includes the GoodMem SDK and OpenAI integration  
- **Java 17**  
- **.NET 8**  
- **Go 1.22**  
- **Node.js 20** with `pnpm`

### Preinstalled Tooling
- **Visual Studio Code Extensions** — language servers, formatters, linters, and productivity tools for all supported languages  
- **Default User Configuration** — shell access as the `vscode` user with all tools and settings preloaded  
- **Environment Variables and Volume Mounts** — automatically configured `.env` file and persistent Docker volumes  

---

## Advantages

- **Zero Setup Required**: no need to install compilers, SDKs, or extensions manually  
- **Consistent Environments**: all developers use the exact same setup, eliminating "it works on my machine" issues  
- **Easy Upgrades**: switching to a newer version is as simple as updating a tag  
- **Reliable Initialization**: everything is baked into the image—no fragile post-creation scripts  
- **Works Offline**: once the image is pulled, you can work without an internet connection  

---

## Getting Started

### Option 1: Launch a New Project (Recommended)

To create a new development workspace using this container:

1. Click below to open a Codespace using the GoodMem template repository:  
   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?repo=pair-systems-inc/goodmem-template-repository)

2. After your Codespace launches, check the **bottom-left corner** of VS Code. Click on the `Codespaces: [name]` badge and choose **View Creation Logs**.

3. In the logs, locate output similar to the following:

   ```text
   Connecting to gRPC API at https://localhost:9090
   Using TLS with certificate verification disabled (insecure mode)
   System initialized successfully
   Root API key: gm_xxxxxxxxxxxxxxxxxxxxxxxx
   User ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

4. **Save the Root API Key** — it will not be shown again. This is critical for authentication.

5. Obtain your **OpenAI API Key** from the OpenAI dashboard and paste it into the `.env` file that was automatically generated in your workspace. Also paste the Root API key from step 4.  

   Example `.env` file:

   ```env
   OPENAI_API_KEY=sk-...
   ADD_API_KEY=gm_xxxxxxxxxxxxxxxxxxxxxxxx
   ```

6. **Create an embedder** (must be created before a space):

   ```bash
   goodmem embedder create \
     --display-name "OpenAI Small Embedder" \
     --provider-type OPENAI \
     --endpoint-url "https://api.openai.com/v1" \
     --model-identifier "text-embedding-3-small" \
     --dimensionality 1536 \
     --credentials "YOUR_OPENAI_API_KEY_FROM_STEP_5"
   ```

7. The command will output an **Embedder ID**. **Save it** — you'll need it for the next step.

8. **Create a space** linked to that embedder:

   ```bash
   goodmem space create \
     --name "My OpenAI Small Space" \
     --embedder-id <YOUR_EMBEDDER_ID_FROM_STEP_7>
   ```

9. **Verify your setup**:  
   - Navigate to the `src/test/` directory  
   - Choose a test in your preferred language (Python, Java, Go, etc.)  
   - Run it and confirm that it connects successfully to the local GoodMem server and returns the expected output
