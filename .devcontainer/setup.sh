#!/usr/bin/env bash
set -euo pipefail

echo "[setup.sh] start: PWD=$(pwd)"

############################
# .NET sample (GoodMemDotnetApp)
############################
if [[ ! -d "GoodMemDotnetApp" ]]; then
  dotnet new console -n GoodMemDotnetApp
  ( cd GoodMemDotnetApp && dotnet add package Pairsystems.Goodmem.Client )
fi
( cd GoodMemDotnetApp && dotnet restore && dotnet build )

############################
# Go sample (GoodMemGoApp)
############################
if command -v go >/dev/null 2>&1; then
  GO_APP_DIR="GoodMemGoApp"

  # Ensure app dir exists
  [[ -d "$GO_APP_DIR" ]] || mkdir -p "$GO_APP_DIR"

  # If someone accidentally created go.mod at repo root, quarantine it
  if [[ -f "go.mod" && ! -f "$GO_APP_DIR/go.mod" ]]; then
    echo "[setup.sh] Found stray ./go.mod at repo root; moving it to $GO_APP_DIR/.go.mod.bak"
    mv -f go.mod "$GO_APP_DIR/.go.mod.bak" || true
    [[ -f go.sum ]] && mv -f go.sum "$GO_APP_DIR/.go.sum.bak" || true
  fi

  # Work ONLY inside the app dir from here on
  pushd "$GO_APP_DIR" >/dev/null

  # Init module if missing
  [[ -f go.mod ]] || go mod init goodmem-app

  # Pin SDK version; idempotent if already present
  go get github.com/PAIR-Systems-Inc/goodmem/clients/go@v1.0.10

  # Create a minimal main.go if absent
  if [[ ! -f main.go ]]; then
    cat > main.go <<'EOF'
package main

import (
  "fmt"
  gm "github.com/PAIR-Systems-Inc/goodmem/clients/go"
)

func main() {
  fmt.Println("Go SDK wired; import ok")
  _ = gm.NewClient // adjust if constructor has a different name
}
EOF
  fi

  go mod tidy
  go build ./...

  popd >/dev/null
else
  echo "[setup.sh] Skipping Go sample (go not installed)"
fi

echo "[setup.sh] done"
