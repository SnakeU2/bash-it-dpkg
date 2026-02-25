#!/bin/bash
set -euo pipefail

echo "🔧 Setting up build environment for bash-it-dpkg..."

OPT_DIR="opt/bash-it"

# Check if opt/bash-it already exists
if [ -d "$OPT_DIR" ]; then
    echo "⚠️ $OPT_DIR already exists. Remove and re-clone? [y/N]"
    read -r answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        rm -rf "$OPT_DIR"
    else
        echo "Keeping existing $OPT_DIR."
        exit 0
    fi
fi

# Clone upstream bash-it into opt/bash-it
echo "📥 Cloning Bash-it from https://github.com/Bash-it/bash-it..."
git clone --depth=1 https://github.com/SnakeU2/bash-it-fork-for-dpkg "$OPT_DIR"

# Remove .git to avoid including git metadata in package
echo "🗑️ Removing .git directory..."
rm -rf "$OPT_DIR/.git"

# Remove documentation and screenshots to reduce size and avoid issues
echo "🗑️ Removing docs/ and screenshots/..."
rm -rf "$OPT_DIR/docs" "$OPT_DIR/screenshots"

# Resolve symbolic links that cause dpkg-source errors
# dpkg-source cannot handle symlinks properly, especially those pointing outside the tree
echo "🧹 Resolving symbolic links (e.g. README.rst -> ../../docs/...)..."

find "$OPT_DIR" -type l -name "*.rst" -o -type l -name "*.md" | while read -r symlink; do
    target="$(readlink "$symlink")"
    dir="$(dirname "$symlink")"
    base="$(basename "$symlink")"

    echo "⚠️ Found symlink: $symlink -> $target"

    # Remove the symlink
    rm "$symlink"

    # Try to resolve the target path
    if [[ "$target" == /* ]]; then
        # Absolute path — cannot resolve safely
        echo "[Documentation not included in package]" > "$symlink"
    elif [ -f "$dir/$target" ]; then
        # Relative path, target exists in same dir
        cp "$dir/$target" "$symlink"
    elif [ -f "$OPT_DIR/$target" ]; then
        # Target is relative to root of bash-it
        cp "$OPT_DIR/$target" "$symlink"
    else
        # Target not found — create a stub
        echo "[Original link: $target]" > "$symlink"
        echo "📄 Placeholder created for missing target"
    fi
done

# Final message
echo "✅ Setup complete. You can now build the package:"
echo "   debuild -us -uc"

