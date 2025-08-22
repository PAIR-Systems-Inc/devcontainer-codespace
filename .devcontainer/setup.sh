#!/usr/bin/env bash
set -euo pipefail

echo "[setup.sh] start  PWD=$(pwd)  USER=$(whoami)"

########## .NET sample (GoodMemDotnetApp) ##########
if [[ ! -d "GoodMemDotnetApp" ]]; then
  echo "[setup.sh] creating GoodMemDotnetApp"
  dotnet new console -n GoodMemDotnetApp
  ( cd GoodMemDotnetApp && dotnet add package Pairsystems.Goodmem.Client )
else
  echo "[setup.sh] GoodMemDotnetApp exists; skipping scaffold"
fi

echo "[setup.sh] restoring/building GoodMemDotnetApp"
( cd GoodMemDotnetApp && dotnet restore && dotnet build )

########## Go sample (GoodMemGoApp) ##########
if command -v go >/dev/null 2>&1; then
  GO_APP_DIR="GoodMemGoApp"
  GO_SDK_MOD="github.com/PAIR-Systems-Inc/goodmem/clients/go@v1.0.10"

  # Ensure app dir exists, then work ONLY inside it
  if [[ ! -d "$GO_APP_DIR" ]]; then
    echo "[setup.sh] creating $GO_APP_DIR"
    mkdir -p "$GO_APP_DIR"
  fi

  pushd "$GO_APP_DIR" >/dev/null

  # Init module if missing
  if [[ ! -f go.mod ]]; then
    echo "[setup.sh] go mod init goodmem-app"
    go mod init goodmem-app
  fi

  # Ensure SDK dependency is present (idempotent)
  echo "[setup.sh] ensuring Go SDK: $GO_SDK_MOD"
  go get "$GO_SDK_MOD"

  # Minimal main.go (blank import to prove linkability without guessing symbols)
  if [[ ! -f main.go ]]; then
    echo "[setup.sh] writing main.go"
    cat > main.go <<'EOF'
package main

import (
  "fmt"
  _ "github.com/PAIR-Systems-Inc/goodmem/clients/go"
)

func main() {
  fmt.Println("Go SDK wired; import ok")
}
EOF
  else
    echo "[setup.sh] main.go exists; leaving as-is"
  fi

  echo "[setup.sh] go mod tidy && go build"
  go mod tidy
  go build ./...

  popd >/dev/null
else
  echo "[setup.sh] Go not installed; skipping GoodMemGoApp"
fi

echo "[setup.sh] done"
