# GitHub Codespace Quick Start
<!--
If you are seeing this text, you are not viewing the file in Preview (a readable format)
To open this file in Preview:

press `control + shift + v`

or

right click the tab "README.md" above and click "Open Preview"
-->

This GitHub Codespace is a pre-configured development environment to help you start building with GoodMem immediately through the command line tool.

**Please make sure to read the requirements section.**

> If you would prefer to interact with GoodMem through a Jupyter Notebook or an SDK, please navigate to the [optional features section](#optional-features)

To get started with GoodMem navigate to the [quick start instructions section](#quick-start-instructions).

## Requirements

- An OpenAI API key (access at https://platform.openai.com/)
- A running GoodMem server (already setup)
- A GoodMem API key (already setup, access with `grep key ~/.goodmem/config.toml`)

> If you do not want to use an OpenAI API key, please use an embedding provider we support
(Cohere, Jina, Voyage AI, vLLM, TEI, OpenAI)

# Quick Start Instructions

Below is a tutorial on how to use the Goodmem CLI (command line interface).

You can use `control + c`, `control + shift + c`, `control + v`, and `control + shift + v` to copy paste commands and data for the tutorial below.

**Please follow the instructions in order**

1. **Setup The Terminal**

The terminal is usually located on the bottom half of the screen and should display the text `devcontainer-codespace`.

If the terminal displays "Running postCreateCommand" please wait a few seconds for GoodMem to complete installation.

You can also adjust the size of the terminal by dragging the top edge of the terminal screen.

If the terminal is not already open, you can launch the terminal in a few ways:

- use the keyboard shortcut `control + j`
- use the keyboard shortcut ```control + ` ```
- click the bottom left warning icon -> Terminal
- click the three horizontal bars at the top left of the screen -> Terminal -> New Terminal
- click the three horizontal bars at the top left of the screen -> View -> Terminal

If the terminal is open but it does not display the text `devcontainer-codespace` try these options to open a new terminal:

- use the keyboard shortcut ```control + shift + ` ```
- click the '+' sign at the top right of the terminal
- click the three bars (sandwich icon) at the top left of the screen -> Terminal -> New Terminal

2. **Save Your GoodMem API Key**

Copy paste the command below into the terminal using `control + shift + v`.

`grep key ~/.goodmem/config.toml`

Copy and store the value, this is your GoodMem API key.

3. **Obtain your OpenAI API Key** from the [OpenAI dashboard](https://platform.openai.com/api-keys) and copy and store it.

4. **Create an embedder** (must be created before a space):

```bash
goodmem embedder create \
   --display-name "OpenAI Small Embedder" \
   --provider-type OPENAI \
   --endpoint-url "https://api.openai.com/v1" \
   --model-identifier "text-embedding-3-small" \
   --dimensionality 1536 \
   --cred-api-key YOUR_OPENAI_API_KEY_FROM_STEP_3
```
The command should output:

```
Embedder created successfully!

ID:               xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Display Name:     OpenAI Small Embedder
Owner:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Provider Type:    OPENAI
Distribution:     DENSE
Endpoint URL:     https://api.openai.com/v1
API Path:         /embeddings
Model:            text-embedding-3-small
Dimensionality:   1536
Created by:       xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Created at:       2026-03-17T22:51:57Z
```

**SAVE THE ID**

5. **Create a space** linked to that embedder:

```bash
goodmem space create \
   --name "My OpenAI Small Space" \
   --embedder-id YOUR_EMBEDDER_ID_FROM_STEP_4
```

The command should output:

```
Space created successfully!

ID:         xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Name:       My OpenAI Small Space
Owner:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Created by: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Created at: 2026-03-17T23:04:06Z
Public:     false
Embedder:   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (weight: 1)
```

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

```
LLM created successfully!

ID:               xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Display Name:     My GPT-4
Owner:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Provider Type:    OPENAI
Endpoint URL:     https://api.openai.com/v1
API Path:         /chat/completions
Model:            gpt-4o
Modalities:       TEXT
Capabilities:     Chat, Completion, Functions, System Messages, Streaming, Sampling Parameters
Created by:       xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Created at:       2026-03-17T23:06:04Z

Capability Inference:
  ✓ Chat Support: true (detected from model family 'gpt-4o')
  ✓ Completion Support: true (detected from model family 'gpt-4o')
  ✓ Function Calling: true (detected from model family 'gpt-4o')
  ✓ System Messages: true (detected from model family 'gpt-4o')
  ✓ Streaming: true (detected from model family 'gpt-4o')
  ✓ Sampling Parameters: true (detected from model family 'gpt-4o')
```

**SAVE THE ID**

## Testing the Queries

The next major step is to upload content into memory so it can be queried.
To do this, we will first upload a PDF and store it in memory. After that, we will run some queries.

1. **Begin by creating a memory.** We will be using this pre-downloaded PDF:

[An Excellent Study of Social Media and Its Positive and Negative Effects on Human Being’s Mental Health](https://dr.lib.iastate.edu/server/api/core/bitstreams/8d3ccb03-cbc4-4b8a-b452-0ebccf0dde55/content)

Then run this command:

```bash
goodmem memory create \
   --file "social_media_study.pdf" \
   --content-type "application/pdf" \
   --space-id YOUR_SPACE_ID_FROM_STEP_5
```

It should output:

```
Memory created successfully!

ID:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Space ID:      xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Content Type:  application/pdf
Page images:   enabled
Status:        PENDING
Created by:    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Created at:    2026-03-17T23:18:33Z
Metadata:
  filename: social_media_study.pdf
```

**SAVE THE ID** (not the space ID since you already have that)

2. To run a query, you have two options: non-interactive mode and interactive mode.

**Non-interactive mode:**  
```bash
goodmem memory retrieve \
   "what are the top three negative affects of social media?" \
   --space-id YOUR_SPACE_ID_FROM_STEP_5
```

**Interactive mode (easier to retrieve results):**

```bash
goodmem memory retrieve \
   --post-processor-interactive "what are the top three negative affects of social media?" \
   --space-id YOUR_SPACE_ID_FROM_STEP_5
```

# Optional Features

To enable optional features, follow the instructions below.
1. copy and paste this command in the terminal

`source .devcontainer/optional-feature-installer.sh`

2. hit enter

3. follow the installer instructions

### optional features Language Support
- **Python 3.10** - includes the GoodMem SDK and OpenAI integration
- **Java 17**
- **.NET 9**
- **Go 1.22**
- **Node.js 20** with `pnpm`

### Preinstalled Tooling
- **Visual Studio Code Extensions** — language servers, formatters, linters, and productivity tools for all supported languages
