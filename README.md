# GitHub Codespace Quick Start
<!--
If you are seeing this text, you are not viewing the file in Preview (a readable format)
To open this file in Preview:
press `control + shift + v`
or
right click the file tab and click "Open Preview"
-->

This GitHub Codespace is a pre-configured development environment to help you start building with GoodMem immediately through the command line tool.

**Please make sure to read the requirements section.**

To get started with GoodMem navigate to the [quick start instructions section](#quick-start-instructions).

> Note: If you would prefer to interact with GoodMem through a Jupyter Notebook or an SDK, please navigate to the [optional features section](#optional-features)


## Requirements

- An OpenAI API key (access at https://platform.openai.com/)
- A running GoodMem server (already setup)
- A GoodMem API key (already setup, access with `goodmem apikey list`)

> If you do not want to use an OpenAI API key, please use an embedding provider we support
(Cohere, Jina, Voyage AI, vLLM, TEI, OpenAI)

# Quick Start Instructions

By now you should have installed GoodMem through the devcontainer. Below is a tutorial on how to use the Goodmem CLI. 

**Please follow the instructions in order**

1. **Setup The Terminal**

The terminal is usually located on the bottom half of the screen and should display the text `root@codespaces`

If the terminal is not already open, you can launch the terminal in a few ways:

- click the three bars (sandwich icon) at the top left of the screen -> View -> Terminal
- click the bottom left warning icon -> Terminal
- use the keyboard shortcut `control + j`
- use the keyboard shortcut ```control + ` ```

If the terminal is open but it does not display the text `root@codespaces` you can do the following to open a new terminal:

- click the '+' sign at the top right of the terminal
- use the keyboard shortcut ```control + shift + ` ```
- use the keyboard shortcut `control + shift + c`

2. **Save Your GoodMem API Key**

Copy paste this command, then copy and store your GoodMem API key.

`goodmem apikey list`

3. **Obtain your OpenAI API Key** from the [OpenAI dashboard](https://platform.openai.com/api-keys) and copy and store it.

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
> Dimensionality:   1536
> Created by:       xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> Created at:       2025-08-20T21:09:00Z

**SAVE THE ID**

5. **Create a space** linked to that embedder:

```bash
goodmem space create \
   --name "My OpenAI Small Space" \
   --embedder-id YOUR_EMBEDDER_ID_FROM_STEP_4
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

The next major step is to upload content into memory so it can be queried.
To do this, we will first upload a PDF and store it in memory. After that, we will run some queries. Follow the directions below: 

1. **Begin by creating a memory.** We will be using this pre-downloaded PDF:

An Excellent Study of Social Media and Its Positive and Negative Effects on Human Being’s Mental Health


Then run this command:

```bash
goodmem memory create \
   --space-id YOUR_SPACE_ID_FROM_STEP_5 \
   --file "social_media_study.pdf" \
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
   --space-id YOUR_SPACE_ID_FROM_STEP_5 \
   "what are the top three negative affects of social media?"
```

**Interactive mode (easier to retrieve results):**

```bash
goodmem memory retrieve \
   --space-id YOUR_SPACE_ID_FROM_STEP_5 \
   --post-processor-interactive "what are the top three negative affects of social media?"
```

# Optional Features

To enable optional features, follow the instructions below.
1. copy and paste this command in the terminal

`source optional-feature-installer.sh`

2. hit enter

3. follow the installer instructions

### Language Support
- **Python 3.10** — includes the GoodMem SDK and OpenAI integration
- **Java 17**
- **.NET 9**
- **Go 1.22**
- **Node.js 20** with `pnpm`

### Preinstalled Tooling
- **Visual Studio Code Extensions** — language servers, formatters, linters, and productivity tools for all supported languages
