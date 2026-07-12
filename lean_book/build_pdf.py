#!/usr/bin/env python3
"""Build a single professional PDF of the book via pandoc + xelatex.

Concatenates every chapter's markdown files in reading order, strips the
per-file navigation strips (breadcrumbs meant for browsing loose files, not
a linearly-read book), and turns internal `.md` cross-references into plain
text (a single PDF has no separate files to jump between). Code blocks,
LaTeX math, and Mermaid diagrams (which fall back to their source text, by
the book's own stated design) are left untouched.
"""
import os
import re
import subprocess
import sys

BOOK_DIR = os.path.dirname(os.path.abspath(__file__))

CHAPTERS = [
    "00-setup",
    "01-basics",
    "02-functions-and-structures",
    "03-propositions-and-proofs",
    "04-tactics",
    "05-rigor-check",
    "06-groups",
    "07-group-theorems",
    "08-rings",
    "09-ring-theorems",
    "10-modules",
    "11-path-algebras",
    "12-working-efficiently",
    "13-next-steps",
    "14-appendix-solutions",
    "15-lambda-calculus",
]

NAV_LINE_RE = re.compile(r'^\[.*\]\([^)]*\.md[^)]*\).*$', re.MULTILINE)
# A lone "---" horizontal rule left dangling after a nav line is stripped too.
BARE_HR_RE = re.compile(r'\n---\n')
MD_LINK_RE = re.compile(r'\[([^\]]+)\]\((?!https?://)[^)]*\)')


def chapter_files(folder):
    path = os.path.join(BOOK_DIR, folder)
    names = sorted(f for f in os.listdir(path) if f.endswith(".md"))
    return [os.path.join(path, n) for n in names]


def clean(text):
    # Drop navigation-strip lines (breadcrumb links to other .md files).
    text = NAV_LINE_RE.sub("", text)
    # Collapse the now-orphaned "---" separators that bordered them.
    text = re.sub(r'\n-{3,}\n\s*\n', '\n\n', text)
    # Any remaining relative .md link becomes plain text (no cross-file
    # jumps make sense inside one linear PDF).
    text = MD_LINK_RE.sub(r'\1', text)
    # Collapse resulting multi-blank-lines.
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip() + "\n"


def build_combined_markdown():
    parts = []
    for chapter in CHAPTERS:
        for path in chapter_files(chapter):
            with open(path, encoding="utf-8") as fh:
                parts.append(clean(fh.read()))
    return "\n\n".join(parts)


def main():
    combined = build_combined_markdown()
    combined_path = os.path.join(BOOK_DIR, "_book_combined.md")
    with open(combined_path, "w", encoding="utf-8") as fh:
        fh.write(combined)
    print(f"Wrote combined markdown: {combined_path} ({len(combined)} bytes)")

    out_pdf = os.path.join(BOOK_DIR, "lean-for-working-algebraists.pdf")
    metadata_path = os.path.join(BOOK_DIR, "pdf-metadata.yaml")

    cmd = [
        "pandoc",
        metadata_path,
        combined_path,
        "-o", out_pdf,
        "--pdf-engine=xelatex",
        "--toc", "--toc-depth=2",
        "--number-sections",
        "--top-level-division=chapter",
        "--highlight-style=tango",
        "--standalone",
        "-V", "documentclass=scrbook",
        "-V", "geometry:margin=1in",
        "-V", "fontsize=11pt",
        "-V", "linkcolor=blue",
        "-V", "urlcolor=blue",
        "-V", "toccolor=black",
        "-V", "mainfont=Palatino Linotype",
        "-V", "mathfont=Cambria Math",
        "-V", "colorlinks=true",
        "--include-in-header", os.path.join(BOOK_DIR, "pdf-header.tex"),
    ]
    print("Running:", " ".join(cmd))
    subprocess.run(cmd, check=True)
    print(f"Built: {out_pdf}")


if __name__ == "__main__":
    sys.exit(main())
