# Next Steps 

By now you should have installed goodmem, either manually or through the devcontainer. If you have not completed this step, then please go ahead and do so. Instructions for installing using a devcontainer are shown below. 


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
The command should output:

   > Embedder created successfully!\
   >
   > ID:               xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Display Name:     OpenAI Small Embedder\
   > Owner:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Provider Type:    OPENAI\
   > Distribution:     DENSE\
   > Endpoint URL:     https://api.openai.com/v1\
   > API Path:         /embeddings\
   > Model:            text-embedding-3-s\
   
**SAVE THE ID**


7. The command will output an **Embedder ID**. **Save it** — you'll need it for the next step.

8. **Create a space** linked to that embedder:

   ```bash
   goodmem space create \
     --name "My OpenAI Small Space" \
     --embedder-id <YOUR_EMBEDDER_ID_FROM_STEP_7>
   ```

The command should output:

   > Space created successfully!\
   >
   > ID:         xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Name:       My OpenAI Small Space\
   > Owner:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Created by: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
   > Created at: 2025-08-20T21:08:20Z\
   > Public:     false\
   > Embedder:   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (weight: 1.0)\

**SAVE THE ID**

9. **Create an LLM**: 

```bash
goodmem llm create \
  --display-name "My GPT-4" \
  --provider-type OPENAI \
  --endpoint-url "https://api.openai.com/v1" \
  --model-identifier "gpt-4o" \
```
The command should output:

   > LLM created successfully!\
   > **ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx**\
   > Name: My GPT-4\
   > Provider: LLM_PROVIDER_TYPE_OPENAI\
   > Model: gpt-4o

**SAVE THE ID**

12. 

***The next major step is to acutally test out the CLI. To do so we will first push a pdf and store it into the memory. After that we will run some queries. Follow the direciotns below: 

1. **Begin by creating a memory. In this case I will be using this PDF which I reccomend you use as well to test.
      https://sleepresearchsociety.org/wp-content/uploads/2021/05/Why_Sleep_Is_Important_For_Optimizing_Learning_And_Memory.pdf

   Then go ahead and run this command:

   ```bash
   goodmem memory create \
   --space-id <YOUR_SPACE_ID_FROM_STEP_8> \ 
   --file "path to where you downloaded the pdf" \
   --content-type "application/pdf"
   ```

   It should output:
      > Memory created successfully!\
      >
      > ID:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
      > Space ID:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
      > Content Type:  application/pdf\
      > Status:        PENDING\
      > Created by:    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\
      > Created at:    2025-08-20T21:2

   **SAVE THE ID (not space ID since you already have that)**

2. To run a query, run this command:

```bash
   goodmem memory retrieve "what is it about sleep that is so important?" --space-id 7dd2cf07-8d5c-43ab-ba69-d1f97ba18cbf
```



NEXT STEP Test your SDK (for devcontainer)

**Verify your setup**:  
   - Navigate to the `src/test/` directory  
   - Choose a test in your preferred language (Python, Java, Go, etc.)  
   - Run it and confirm that it connects successfully to the local GoodMem server and returns the expected output
