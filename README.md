# SafariMarkdown

Convert the current Safari page to Markdown — entirely on your Mac, no server required.

Trigger it from the **terminal**, or straight from the **right-click menu** (macOS Services).

## Requirements

- macOS with Safari
- Python 3 (comes with macOS)

## Installation

```bash
git clone https://github.com/elijah-pelton/SafariMarkdown.git
cd SafariMarkdown
./install.sh
```

`install.sh`:
1. Installs the [`html2text`](https://pypi.org/project/html2text/) Python package.
2. Marks `safari2md.sh` as executable.
3. Installs a **macOS Quick Action** (Service) to `~/Library/Services/` so
   "Page to Markdown" appears in the right-click menu inside Safari (and any
   other app).

> **First-run prompt:** macOS may ask you to grant permission for the Service
> to control Safari via AppleScript. Click **OK** when prompted.

### If the menu item doesn't appear

Go to **System Settings → Keyboard → Keyboard Shortcuts → Services** and make
sure **"Page to Markdown"** is enabled under the *General* section.

### Optional terminal alias

```bash
echo "alias safari2md='$(pwd)/safari2md.sh'" >> ~/.zshrc
source ~/.zshrc
```

## Usage

### Right-click menu (macOS Service)

1. Open any webpage in Safari.
2. Right-click anywhere on the page → **Services → Page to Markdown**.
3. The Markdown is copied to your clipboard automatically.
4. Paste it anywhere — a note, a chat window, or an AI prompt.

You can also access the service from the **Safari menu bar**:
Safari → Services → Page to Markdown.

### Terminal

Open a page in Safari, then run one of the following commands:

| Command | Effect |
|---------|--------|
| `./safari2md.sh` | Print Markdown to the terminal |
| `./safari2md.sh -c` | Copy Markdown to the clipboard |
| `./safari2md.sh -o page.md` | Save Markdown to `page.md` |
| `./safari2md.sh -o page.md -c` | Save to file **and** copy to clipboard |

### Example

```
$ ./safari2md.sh -c
Copied to clipboard
```

> **Note:** The script uses AppleScript to read the rendered HTML from the
> active Safari tab, so it captures the page exactly as Safari sees it
> (JavaScript-rendered content included).

## How it works

1. `safari2md.sh` (or the Quick Action) uses AppleScript to ask Safari for the
   current tab's URL, title, and rendered HTML.
2. The HTML is piped to `convert.py`, which uses `html2text` to produce clean
   Markdown.
3. The result is printed to stdout, saved to a file, or sent to the clipboard —
   depending on how you invoked it.

## File structure

```
SafariMarkdown/
├── safari2md.sh          # Main conversion script (CLI entry point)
├── convert.py            # HTML → Markdown converter (uses html2text)
├── requirements.txt      # Python dependency: html2text
├── install.sh            # One-step installer (deps + Quick Action)
└── service/
    └── SafariMarkdown.workflow/   # macOS Quick Action template
        └── Contents/
            ├── Info.plist         # Service metadata
            └── document.wflow     # Automator workflow (path filled by install.sh)
```
