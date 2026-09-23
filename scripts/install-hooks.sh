#!/bin/bash
# Installs Syzygy org pre-push hook into .git/hooks/
set -e
HOOKS_DIR="$(git rev-parse --git-dir)/hooks"
mkdir -p "$HOOKS_DIR"
cat > "$HOOKS_DIR/pre-push" << 'EOF'
#!/bin/bash
# Syzygy AI iOS — pre-push hook
# Runs swift build before allowing push
echo "Running swift build before push..."
swift build 2>&1
if [ $? -ne 0 ]; then
  echo "Build failed — push blocked."
  exit 1
fi
echo "Build passed."
EOF
chmod +x "$HOOKS_DIR/pre-push"
echo "Pre-push hook installed successfully."
