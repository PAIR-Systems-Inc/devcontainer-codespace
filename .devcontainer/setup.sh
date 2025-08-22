#!/bin/bash
set -e

# .NET sample
if [ ! -d GoodMemDotnetApp ]; then
  dotnet new console -n GoodMemDotnetApp
  (cd GoodMemDotnetApp && dotnet add package Pairsystems.Goodmem.Client)
fi
(cd GoodMemDotnetApp && dotnet restore && dotnet build)

# Go sample
if command -v go >/dev/null 2>&1; then
  if [ ! -d GoodMemGoApp ]; then
    mkdir -p GoodMemGoApp
    cd GoodMemGoApp
    go mod init goodmem-app
    go get github.com/PAIR-Systems-Inc/goodmem/clients/go@v1.0.10
    cat > main.go <<'EOF'
package main

import (
  "fmt"
  gm "github.com/PAIR-Systems-Inc/goodmem/clients/go"
)

func main() {
  fmt.Println("Go SDK wired; import ok")
  _ = gm.NewClient
}
EOF
    go mod tidy
  fi
  (cd GoodMemGoApp && go build ./...)
fi
