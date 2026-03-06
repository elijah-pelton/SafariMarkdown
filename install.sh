#!/usr/bin/env bash
# install.sh — Set up SafariMarkdown on your Mac.
#
# This script:
#   1. Installs the required Python dependency (html2text).
#   2. Makes safari2md.sh executable.
#   3. Installs the "Page to Markdown" Quick Action (macOS Service) so it
#      appears under right-click → Services → "Page to Markdown" in Safari
#      (and any other app).
#
# Usage:
#   ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_NAME="SafariMarkdown.workflow"
SERVICES_DIR="$HOME/Library/Services"
DEST="$SERVICES_DIR/$SERVICE_NAME"
TEMPLATE="$SCRIPT_DIR/service/$SERVICE_NAME/Contents/document.wflow"

echo "==> Installing Python dependencies..."
pip3 install --user -r "$SCRIPT_DIR/requirements.txt"

echo "==> Making safari2md.sh executable..."
chmod +x "$SCRIPT_DIR/safari2md.sh"

echo "==> Installing macOS Quick Action (Service)..."
mkdir -p "$DEST/Contents"

# Copy the static Info.plist unchanged.
cp "$SCRIPT_DIR/service/$SERVICE_NAME/Contents/Info.plist" "$DEST/Contents/Info.plist"

# Substitute __INSTALL_DIR__ with the real path so the workflow can find the
# script regardless of where the user cloned the repository.
sed "s|__INSTALL_DIR__|$SCRIPT_DIR|g" "$TEMPLATE" > "$DEST/Contents/document.wflow"

# Notify the Services subsystem of the new workflow.
# pbs (Pasteboard Server) maintains the Services menu registry.
# Failures are non-fatal — the service will still be discovered on next login
# or the user can re-run with: /System/Library/CoreServices/pbs -update
if ! /System/Library/CoreServices/pbs -update 2>/dev/null; then
    echo "Note: Could not auto-refresh the Services menu (pbs -update failed)."
    echo "      Log out and back in, or run:"
    echo "      /System/Library/CoreServices/pbs -update"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Terminal usage:"
echo "  1. Open a webpage in Safari."
echo "  2. Run:  $SCRIPT_DIR/safari2md.sh"
echo "     Or for clipboard output:  $SCRIPT_DIR/safari2md.sh -c"
echo "     Or to save to a file:     $SCRIPT_DIR/safari2md.sh -o page.md"
echo ""
echo "Right-click / Services menu usage:"
echo "  1. Open a webpage in Safari."
echo "  2. Right-click anywhere on the page (or use the Safari menu bar)."
echo "  3. Choose Services → \"Page to Markdown\"."
echo "     The Markdown is copied to your clipboard automatically."
echo ""
echo "If the service does not appear, go to:"
echo "  System Settings → Keyboard → Keyboard Shortcuts → Services"
echo "  and make sure \"Page to Markdown\" is enabled under the General section."
echo ""
echo "Optional: add a terminal alias to your shell profile:"
echo "  echo \"alias safari2md='$SCRIPT_DIR/safari2md.sh'\" >> ~/.zshrc"
