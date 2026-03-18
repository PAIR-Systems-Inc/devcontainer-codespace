#!/usr/bin/env bash
set -euo pipefail

echo "[setup.sh] start  PWD=$(pwd)  USER=$(whoami)"

BASE_DIR="src"
mkdir -p "$BASE_DIR"



########## Java sample (GoodMemJavaApp via Gradle) ##########
if command -v javac >/dev/null 2>&1; then
  JAVA_APP_DIR="$BASE_DIR/GoodMemJavaApp"

  if [[ ! -d "$JAVA_APP_DIR" ]]; then
    echo "[setup.sh] creating $JAVA_APP_DIR"
    mkdir -p "$JAVA_APP_DIR"
    cd "$JAVA_APP_DIR"

    printf "1\n" | gradle -q init \
      --type java-application \
      --dsl kotlin \
      --test-framework junit \
      --project-name GoodMemJavaApp \
      --package com.pairsystems.goodmem.sample \
      --java-version 21

    if [[ -f "build.gradle.kts" ]]; then
      awk '1;/dependencies *\{/ && !x{print "    implementation(\"com.pairsystems:goodmem-client:1.0.0\")"; x=1}' \
        build.gradle.kts > build.gradle.kts.tmp && mv build.gradle.kts.tmp build.gradle.kts
    fi
  else
    cd "$JAVA_APP_DIR"
  fi

  echo "[setup.sh] ./gradlew build"
  ./gradlew --no-daemon build || echo "[setup.sh] WARN: build failed (artifact may not be published yet)"
  cd - >/dev/null
else
  echo "[setup.sh] Java not installed; skipping GoodMemJavaApp"
fi

echo "[setup.sh] done"
