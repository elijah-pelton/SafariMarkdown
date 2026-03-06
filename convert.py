#!/usr/bin/env python3
"""Convert HTML content to Markdown."""

import sys
import html2text


def convert(html: str, url: str = "", title: str = "") -> str:
    """Convert an HTML string to Markdown.

    Args:
        html: Raw HTML content.
        url: Source URL, included as a header if provided.
        title: Page title, included as an H1 heading if provided.

    Returns:
        Markdown string.
    """
    converter = html2text.HTML2Text()
    converter.ignore_links = False
    converter.ignore_images = False
    converter.body_width = 0  # don't wrap lines
    converter.unicode_snob = True
    markdown = converter.handle(html)

    parts = []
    if title:
        parts.append(f"# {title}\n")
    if url:
        parts.append(f"Source: {url}\n")
    if parts:
        parts.append("")
    parts.append(markdown)
    return "\n".join(parts)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: convert.py <url> [title]", file=sys.stderr)
        sys.exit(1)

    url = sys.argv[1]
    title = sys.argv[2] if len(sys.argv) > 2 else ""
    html_content = sys.stdin.read()
    print(convert(html_content, url=url, title=title))
