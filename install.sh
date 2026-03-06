#!/usr/bin/env bash
# install.sh — Set up SafariMarkdown on your Mac.
#
# This script installs the required Python dependency (html2text) and makes
# safari2md.sh executable.  Run once after cloning the repository.
#
# Usage:
#   ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing Python dependencies..."
pip3 install --user -r "$SCRIPT_DIR/requirements.txt"

echo "==> Making safari2md.sh executable..."
chmod +x "$SCRIPT_DIR/safari2md.sh"

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  1. Open a webpage in Safari."
echo "  2. Run:  $SCRIPT_DIR/safari2md.sh"
echo "     Or for clipboard output:  $SCRIPT_DIR/safari2md.sh -c"
echo "     Or to save to a file:     $SCRIPT_DIR/safari2md.sh -o page.md"
echo ""
echo "Optional: add an alias to your shell profile:"
echo "  echo \"alias safari2md='$SCRIPT_DIR/safari2md.sh'\" >> ~/.zshrc"
