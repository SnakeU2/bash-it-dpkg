#!/bin/bash

# Script to resolve symlinks in bash-it directory
# Called from Makefile to handle symbolic links properly

set -eo pipefail
# Disabled pipefail for find | while loop as it can cause issues with IFS= read -r

OPT_DIR="${1:-}"

if [[ -z "$OPT_DIR" ]]; then
    echo "Error: OPT_DIR not specified" >&2
    exit 1
fi

if [[ ! -d "$OPT_DIR" ]]; then
    echo "Error: Directory does not exist: $OPT_DIR" >&2
    exit 1
fi

# Find and process symbolic links
find "$OPT_DIR" -type l -name "*.rst" -o -type l -name "*.md" | while IFS= read -r symlink; do
    # Get the target of the symlink
    target="$(readlink "$symlink")"
    dir="$(dirname "$symlink")"
    base="$(basename "$symlink")"
    
    echo "⚠️ Found symlink: $symlink -> $target"
    
    # Remove the symlink
    rm "$symlink"
    
    # Process based on target type
    if [[ "$target" == /* ]]; then
        # Absolute path - documentation not included in package
        echo "[Documentation not included in package]" > "$symlink"
    elif [[ -f "$dir/$target" ]]; then
        # Relative path within the same directory
        cp "$dir/$target" "$symlink"
    elif [[ -f "$OPT_DIR/$target" ]]; then
        # Relative path within the bash-it directory
        cp "$OPT_DIR/$target" "$symlink"
    else
        # Target not found
        echo "[Original link: $target]" > "$symlink" || true
        echo "📄 Placeholder created for missing target" || true
    fi
done

exit 0