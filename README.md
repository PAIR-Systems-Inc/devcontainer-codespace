# GoodMem DevContainer

The **GoodMem DevContainer** is a pre-configured, zero-setup development environment designed to help you start building immediately. It includes all necessary SDKs, tools, and extensions in a single, consistent container image.

---

## Features

### Language Support
- **Python 3.10** — includes the GoodMem SDK and OpenAI integration  
- **Java 17**  
- **.NET 9**  
- **Go 1.22**  
- **Node.js 20** with `pnpm`

### Preinstalled Tooling
- **Visual Studio Code Extensions** — language servers, formatters, linters, and productivity tools for all supported languages  

---

# Next Steps

By now you should have installed GoodMem through the devcontainer. Below is a tutorial on how to use the Goodmem CLI. 

1. In the logs, locate output similar to the following:

   ```text
   Connecting to gRPC API at https://localhost:9090
   Using TLS with certificate verification disabled (insecure mode)
   System initialized successfully
   Root API key: gm_xxxxxxxxxxxxxxxxxxxxxxxx
   User ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

2. **Save Your Root API Key**
   
     The Root API Key `(gm_xxxxxxxxxxxxxxxxxxxxxxxx)` is shown only once. It’s best to copy and store it now.
     You may also locate the `api_key` under `~/.goodmem/config.json`

4. **Obtain your OpenAI API Key** from the [OpenAI dashboard](https://platform.openai.com/api-keys) and keep it ready for the next step.

5. **Create an embedder** (must be created before a space):

   ```bash
   goodmem embedder create \
     --display-name "OpenAI Small Embedder" \
     --provider-type OPENAI \
     --endpoint-url "https://api.openai.com/v1" \
     --model-identifier "text-embedding-3-small" \
     --dimensionality 1536 \
     --credentials "YOUR_OPENAI_API_KEY_FROM_STEP_3"
   ```
   The command should output:

   > Embedder created successfully!\
   >\
   > ID:               xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Display Name:     OpenAI Small Embedder\
   > Owner:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Provider Type:    OPENAI\
   > Distribution:     DENSE\
   > Endpoint URL:     https://api.openai.com/v1\
   > API Path:         /embeddings\
   > Model:            text-embedding-3-small

   **SAVE THE ID**

6. **Create a space** linked to that embedder:

   ```bash
   goodmem space create \
     --name "My OpenAI Small Space" \
     --embedder-id <YOUR_EMBEDDER_ID_FROM_STEP_4>
   ```

   The command should output:

   > Space created successfully!\
   >\
   > ID:         xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Name:       My OpenAI Small Space\
   > Owner:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Created by: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Created at: 2025-08-20T21:08:20Z\
   > Public:     false\
   > Embedder:   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (weight: 1.0)

   **SAVE THE ID**

7. **Create an LLM**:

   ```bash
   goodmem llm create \
     --display-name "My GPT-4" \
     --provider-type OPENAI \
     --endpoint-url "https://api.openai.com/v1" \
     --model-identifier "gpt-4o"
   ```

   The command should output:

   > LLM created successfully!\
   > ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Name: My GPT-4\
   > Provider: LLM_PROVIDER_TYPE_OPENAI\
   > Model: gpt-4o

   **SAVE THE ID**

### Testing the Queries

The next major step is to upload content into memory so it can  be queried. To do this, we will first upload a PDF and store it in memory. After that, we will run some queries. Follow the directions below: 

1. **Begin by creating a memory.** In this case, I will be using this PDF, which I recommend you use as well for testing:

   [An Excellent Study of Social Media and Its Positive and Negative Effects on Human Being’s Mental Health](https://dr.lib.iastate.edu/server/api/core/bitstreams/8d3ccb03-cbc4-4b8a-b452-0ebccf0dde55/content)


   Then run this command:

   ```bash
   goodmem memory create \
     --space-id <YOUR_SPACE_ID_FROM_STEP_5> \
     --file "path to where you downloaded the pdf" \
     --content-type "application/pdf"
   ```

   It should output:

   > Memory created successfully!\
   >\
   > ID:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Space ID:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Content Type:  application/pdf\
   > Status:        PENDING\
   > Created by:    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Created at:    2025-08-20T21:20:00Z

   **SAVE THE ID** (not the space ID since you already have that)

2. To run a query, you have two options: non-interactive mode and interactive mode.

   **Non-interactive mode:**  
      ```bash
      goodmem memory retrieve \
        "what are the top three negative affects of social media?" \
        --space-id <YOUR_SPACE_ID_FROM_STEP_5>
      ```

   **Interactive mode (easier to retrieve results):**

   ```bash
      goodmem memory retrieve \
     --space-id  <YOUR_SPACE_ID_FROM_STEP_5>\
     --post-processor-interactive "what are the top three negative affects of social media?"
   ```
