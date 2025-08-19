# GoodMem DevContainer

The **GoodMem DevContainer** is a pre-configured, zero-setup development environment designed to help you start building immediately. It includes all necessary SDKs, tools, and extensions in a single, consistent container image.

---

## Features

### Language Support
- **Python 3.10** — Includes the GoodMem SDK and OpenAI integration
- **Java 17**
- **.NET 8**
- **Go 1.22**
- **Node.js 20** with `pnpm`

### Preinstalled Tooling
- **Visual Studio Code Extensions** — Language servers, formatters, linters, and productivity tools for all supported languages
- **Default User Configuration** — Shell access as the `vscode` user with all tools and settings preloaded
- **Environment Variables and Volume Mounts** — Automatically configured `.env` file and persistent Docker volumes

---

## Advantages

- **Zero Setup Required**: No need to install compilers, SDKs, or extensions manually.
- **Consistent Environments**: All developers use the exact same setup, eliminating “it works on my machine” issues.
- **Easy Upgrades**: Switching to a newer version is as simple as updating a tag.
- **Reliable Initialization**: The container includes everything baked in—no reliance on post-creation setup scripts.
- **Works Offline**: Once the image is pulled, you can work without an internet connection.

---

## Getting Started

### Option 1: Launch a New Project (Recommended)

To create a new development workspace using this container:

1. Click below to open a Codespace using the GoodMem template repository:  
   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?repo=pair-systems-inc/goodmem-template-repository)

2. After your Codespace launches, check the **bottom-left corner** of VS Code. Click on the `Codespaces: [name]` badge and choose **View Creation Logs**.

3. In the logs, locate output similar to the following (scroll if needed):

   ```text
   Connecting to gRPC API at https://localhost:9090
   Using TLS with certificate verification disabled (insecure mode)
   System initialized successfully
   Root API key: gm_xxxxxxxxxxxxxxxxxxxxxxxx
   User ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
4. Save the Root API Key — it will not be shown again. This is critical for authentication.

5. Obtain your OpenAI API Key from the OpenAI dashboard and paste it into the .env file that was automatically generated in your workspace. Also paste the Root API key you saved in step 4

6. To verify your setup, run one of the sample SDK tests:

    Navigate to the src/test/ directory.

    Choose a test that matches your preferred language (Python, Java, Go, etc.).

    Run the test script and confirm that it connects successfully to the local GoodMem server and returns expected output.
