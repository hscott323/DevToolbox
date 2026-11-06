#!/bin/bash

BUILD_DIR="build"
GENERATOR="Ninja"

cmake -S . -B "$BUILD_DIR" -G "$GENERATOR" -DCMAKE_CXX_COMPILER=clang++
if [ $? -ne 0 ]; then
    exit 1
fi

cmake --build "$BUILD_DIR"
if [ $? -ne 0 ]; then
    exit 1
fi

PROJECT_NAME=$(sed -nE 's/^[[:space:]]*project[[:space:]]*\([[:space:]]*([^[:space:])]+).*/\1/p' CMakeLists.txt | head -n 1)

if [ -z "$PROJECT_NAME" ]; then
    echo "ERROR: Could not determine project name."
    exit 1
fi

EXECUTABLE="$BUILD_DIR/$PROJECT_NAME"

if [ ! -x "$EXECUTABLE" ]; then
    echo "ERROR: Executable not found."
    exit 1
fi

clear
"$EXECUTABLE"