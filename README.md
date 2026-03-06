# SafariMarkdown

Convert the current Safari page to Markdown — entirely on your Mac, no server required.

## Requirements

- macOS with Safari
- Python 3 (comes with macOS)

## Installation

```bash
git clone https://github.com/elijah-pelton/SafariMarkdown.git
cd SafariMarkdown
./install.sh
```

`install.sh` installs the [`html2text`](https://pypi.org/project/html2text/) Python package and marks `safari2md.sh` as executable.

### Optional alias

Add a convenient alias to your shell profile so you can run `safari2md` from anywhere:

```bash
echo "alias safari2md='$(pwd)/safari2md.sh'" >> ~/.zshrc
source ~/.zshrc
```

## Usage

Open a page in Safari, then run one of the following commands from the project directory (or via the alias):

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

Paste the result anywhere — a note, a chat window, or directly into an AI prompt.

> **Note:** The script uses AppleScript to read the rendered HTML from the
> active Safari tab, so it captures the page exactly as Safari sees it
> (JavaScript-rendered content included).

## How it works

1. `safari2md.sh` uses AppleScript to ask Safari for the current tab's URL,
   title, and rendered HTML.
2. The HTML is piped to `convert.py`, which uses `html2text` to produce clean
   Markdown.
3. The result is printed to stdout, saved to a file, or sent to the clipboard —
   depending on the flags you pass.
