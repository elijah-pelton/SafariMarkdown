#!/usr/bin/env bash
# safari2md.sh — Convert the current Safari page to Markdown.
#
# Usage:
#   ./safari2md.sh                  # prints Markdown to stdout
#   ./safari2md.sh -o output.md     # saves to a file
#   ./safari2md.sh -c               # copies to clipboard (pbcopy)
#   ./safari2md.sh -o output.md -c  # saves to file AND copies to clipboard
#
# Requires: Python 3 with html2text installed (run install.sh first).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OUTPUT_FILE=""
COPY_CLIPBOARD=false

usage() {
    echo "Usage: $0 [-o <output_file>] [-c] [-h]"
    echo "  -o <file>   Write Markdown to <file>"
    echo "  -c          Copy Markdown to clipboard"
    echo "  -h          Show this help message"
    exit 1
}

while getopts ":o:ch" opt; do
    case $opt in
        o) OUTPUT_FILE="$OPTARG" ;;
        c) COPY_CLIPBOARD=true ;;
        h) usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
        \?) echo "Unknown option: -$OPTARG" >&2; usage ;;
    esac
done

# Ensure Safari is running
if ! pgrep -x "Safari" > /dev/null; then
    echo "Error: Safari is not running." >&2
    exit 1
fi

# Retrieve the current tab's URL, title, and full HTML from Safari via three
# separate AppleScript calls to avoid any delimiter-collision issues.
PAGE_URL=$(osascript -e \
    'tell application "Safari" to return URL of current tab of front window')
PAGE_TITLE=$(osascript -e \
    'tell application "Safari" to return name of current tab of front window')
PAGE_HTML=$(osascript -e \
    'tell application "Safari" to return do JavaScript "document.documentElement.outerHTML" in current tab of front window')

# Convert HTML to Markdown via the Python helper.
MARKDOWN=$(printf '%s' "$PAGE_HTML" | python3 "$SCRIPT_DIR/convert.py" "$PAGE_URL" "$PAGE_TITLE")

# Output
if [[ -n "$OUTPUT_FILE" ]]; then
    printf '%s\n' "$MARKDOWN" > "$OUTPUT_FILE"
    echo "Saved to $OUTPUT_FILE"
fi

if [[ "$COPY_CLIPBOARD" == true ]]; then
    printf '%s\n' "$MARKDOWN" | pbcopy
    echo "Copied to clipboard"
fi

if [[ -z "$OUTPUT_FILE" && "$COPY_CLIPBOARD" == false ]]; then
    printf '%s\n' "$MARKDOWN"
fi
