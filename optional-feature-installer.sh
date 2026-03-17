#!/bin/bash

options=(
  "Jupyter Notebook"
  "Python SDK"
  "Java SDK"
  ".NET SDK"
  "Go SDK"
)

selected=0
total=${#options[@]}

print_menu() {
  for i in "${!options[@]}"; do
    if [ "$i" -eq "$selected" ]; then
      echo "  > ${options[$i]}"
    else
      echo "    ${options[$i]}"
    fi
  done
}

# Print header once
echo ""
echo "======================================"
echo "   Welcome to GoodMem Dev Container"
echo "======================================"
echo ""
echo "Use UP/DOWN arrows to select, then press ENTER:"
echo ""

# Print menu for the first time
print_menu

while true; do
  IFS= read -rsn1 key
  if [[ $key == $'\x1b' ]]; then
    read -rsn2 -t 0.1 key
    case $key in
      '[A') (( selected = (selected - 1 + total) % total )) ;;  # Up
      '[B') (( selected = (selected + 1) % total )) ;;          # Down
      *) continue ;;
    esac
    # Move cursor up $total lines and redraw only the menu
    printf '\033[%dA' "$total"
    print_menu
  elif [[ $key == '' ]]; then
    break  # Enter
  fi
done

echo ""
echo "Selected: ${options[$selected]}"
echo ""

case $selected in
  0)
    echo "Installing Jupyter VS Code extension..."
    code --install-extension ms-toolsai.jupyter 2>/dev/null || true
    echo "Starting Jupyter Lab..."

    # clone the goodmem-samples repository
    GOODMEM_REPO_DIR="goodmem-samples"
    if [ ! -d "$GOODMEM_REPO_DIR" ]; then
        git clone https://github.com/PAIR-Systems-Inc/goodmem-samples.git "$GOODMEM_REPO_DIR"
        echo "GoodMem repository cloned to $GOODMEM_REPO_DIR"
    else
        echo "GoodMem repository already exists at $GOODMEM_REPO_DIR"
    fi

    jupyter lab --ip=0.0.0.0 --no-browser --allow-root
    ;;
  1)
    echo "Installing Python VS Code extension..."
    code --install-extension ms-python.python 2>/dev/null || true
    echo "Starting Python with GoodMem SDK..."
    echo "  - SDK docs: https://docs.goodmem.ai/python"
    echo "  - Sample:   src/test.py"
    echo ""
    python3
    ;;
  2)
    echo "Java SDK selected."
    echo "  - SDK docs: https://docs.goodmem.ai/java"
    echo "  - Add to build.gradle:"
    echo "      implementation 'ai.goodmem:goodmem-client:<version>'"
    echo ""
    ;;
  3)
    echo ".NET SDK selected."
    echo "  - SDK docs: https://docs.goodmem.ai/dotnet"
    echo "  - Install package:"
    echo "      dotnet add package Pairsystems.GoodMem.Client"
    echo ""
    ;;
  4)
    echo "Go SDK selected."
    echo "  - SDK docs: https://docs.goodmem.ai/go"
    echo "  - Install package:"
    echo "      go get github.com/PAIR-Systems-Inc/goodmem-go-client"
    echo ""
    ;;
esac
