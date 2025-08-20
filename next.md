# Next Steps

By now you should have installed GoodMem, either manually or through the devcontainer. If you have not completed this step, please proceed with the installation.

### Devcontainer Setup (Skip if you installed GoodMem manually)

1. Click below to open a Codespace using the GoodMem template repository:

[Open Codespace](https://github.com/codespaces/new?repo=PAIR-Systems-Inc/devcontainer-codespace)


2. After your Codespace launches, check the **bottom-left corner** of VS Code. Click on the `Codespaces: [name]` badge and choose **View Creation Logs**.

### Configuration Steps

1. In the logs, locate output similar to the following:

   ```text
   Connecting to gRPC API at https://localhost:9090
   Using TLS with certificate verification disabled (insecure mode)
   System initialized successfully
   Root API key: gm_xxxxxxxxxxxxxxxxxxxxxxxx
   User ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

2. **CRITICAL: SAVE THE ROOT API KEY IMMEDIATELY**
   
   **THE ROOT API KEY WILL NOT BE SHOWN AGAIN AND CANNOT BE RECOVERED**
   
   Copy and paste the Root API key (`gm_xxxxxxxxxxxxxxxxxxxxxxxx`) from the logs above and store it in a secure location RIGHT NOW. Without this key, you will need to restart the entire setup process. This is absolutely essential for authentication and all subsequent operations.

3. **Obtain your OpenAI API Key** from the [OpenAI dashboard](https://platform.openai.com/api-keys) and keep it ready for the next step.

4. **Create an embedder** (must be created before a space):

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

5. **Create a space** linked to that embedder:

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

6. **Create an LLM**:

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

### Testing the CLI 

The next major step is to actually test the CLI. To do this, we will first upload a PDF and store it in memory. After that, we will run some queries. Follow the directions below: 

1. **Begin by creating a memory.** In this case, I will be using this PDF, which I recommend you use as well for testing:

   [Why Sleep Is Important For Optimizing Learning And Memory](https://sleepresearchsociety.org/wp-content/uploads/2021/05/Why_Sleep_Is_Important_For_Optimizing_Learning_And_Memory.pdf)

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

2. To run a query, execute this command:

   ```bash
   goodmem memory retrieve \
     "what is it about sleep that is so important?" \
     --space-id <YOUR_SPACE_ID_FROM_STEP_5>
   ```

### Next Step: Test Your SDK (for devcontainer)

**Setup your environment**:

1. Obtain your **OpenAI API Key** from the OpenAI dashboard and paste it into the `.env` file that was automatically generated in your workspace. Also paste the Root API key from step 4.

   Example `.env` file:

   ```env
   OPENAI_API_KEY=sk-...
   ADD_API_KEY=gm_xxxxxxxxxxxxxxxxxxxxxxxx
   ```

**Verify your setup**:
- Navigate to the `src/test/` directory
- Choose a test in your preferred language (Python, Java, Go, etc.)
- Run it and confirm that it connects successfully to the local GoodMem server and returns the expected output
