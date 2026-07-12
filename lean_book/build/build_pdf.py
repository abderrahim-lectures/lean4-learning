#!/usr/bin/env python3
"""Build a single professional PDF of the book via pandoc + xelatex.

Run from anywhere: `python build/build_pdf.py` (or `python build_pdf.py`
from inside `build/`) — paths are resolved relative to this script and to
the book root (its parent directory), not to the caller's working
directory.

Concatenates every chapter's markdown files in reading order, strips the
per-file navigation strips (breadcrumbs meant for browsing loose files, not
a linearly-read book), turns internal `.md` cross-references into plain
text (a single PDF has no separate files to jump between), rewrites
chapter-relative image paths to absolute, and renders every ```mermaid
fenced diagram to a PNG via mermaid-cli (falling back to the diagram's
source text, per the book's own stated design, if mermaid-cli isn't
available). Code blocks are syntax-highlighted for Lean via a custom Kate
definition (lean4.xml) — Pandoc/Skylighting has no built-in Lean lexer —
and get real syntax highlighting for Python out of the box.
"""
import hashlib
import os
import re
import shutil
import subprocess
import sys

BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
BOOK_DIR = os.path.dirname(BUILD_DIR)
MERMAID_CACHE_DIR = os.path.join(BUILD_DIR, "_mermaid_cache")

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
MD_LINK_RE = re.compile(r'(?<!!)\[([^\]]+)\]\((?!https?://)[^)]*\)')
IMAGE_RE = re.compile(r'(!\[[^\]]*\]\()([^)]+)(\))')
MERMAID_RE = re.compile(r'```mermaid\n(.*?)\n```', re.DOTALL)

_mermaid_available = shutil.which("npx") is not None


def chapter_files(folder):
    path = os.path.join(BOOK_DIR, folder)
    names = sorted(f for f in os.listdir(path) if f.endswith(".md"))
    return [os.path.join(path, n) for n in names]


def render_mermaid(source):
    """Render Mermaid source to a PNG via mermaid-cli, cached by content
    hash. Returns an absolute path to the PNG, or None on failure."""
    os.makedirs(MERMAID_CACHE_DIR, exist_ok=True)
    digest = hashlib.sha256(source.encode("utf-8")).hexdigest()[:16]
    mmd_path = os.path.join(MERMAID_CACHE_DIR, f"{digest}.mmd")
    png_path = os.path.join(MERMAID_CACHE_DIR, f"{digest}.png")
    if os.path.isfile(png_path):
        return png_path
    with open(mmd_path, "w", encoding="utf-8") as fh:
        fh.write(source)
    cmd = [
        "npx", "-y", "@mermaid-js/mermaid-cli",
        "-i", mmd_path, "-o", png_path,
        "-b", "white", "-s", "3",
    ]
    try:
        subprocess.run(cmd, check=True, capture_output=True, text=True,
                        shell=(os.name == "nt"))
    except subprocess.CalledProcessError as e:
        print(f"[mermaid] failed to render diagram {digest}: {e.stderr}", file=sys.stderr)
        return None
    return png_path if os.path.isfile(png_path) else None


def replace_mermaid(text):
    def _sub(m):
        source = m.group(1)
        if not _mermaid_available:
            return m.group(0)
        png_path = render_mermaid(source)
        if png_path is None:
            return m.group(0)
        png_path = png_path.replace("\\", "/")
        # mermaid-cli renders at -s 3 (3x scale, for crispness) with no
        # fixed physical size, so left unconstrained the image inserts at
        # its raw, huge pixel size. Cap the display width so it sits
        # comfortably on a book page. A bare image-only paragraph isn't
        # centered by LaTeX by default (it's inline, so it just sits at
        # the paragraph's start), so wrap it in a `center`-class Div —
        # pandoc's LaTeX writer maps that natively to a `center`
        # environment (a raw `\begin{center}` block doesn't survive
        # round-tripping through the markdown reader reliably).
        return f"\n::: center\n![]({png_path}){{width=50%}}\n:::\n"
    return MERMAID_RE.sub(_sub, text)


def clean(text, source_dir):
    text = replace_mermaid(text)
    # Drop navigation-strip lines (breadcrumb links to other .md files).
    text = NAV_LINE_RE.sub("", text)
    # Collapse the now-orphaned "---" separators that bordered them.
    text = re.sub(r'\n-{3,}\n\s*\n', '\n\n', text)
    # Rewrite image paths to absolute (they're relative to each chapter's
    # own folder, which breaks once every chapter is concatenated into one
    # combined markdown file living at the book root) *before* stripping
    # links, since image syntax `![alt](path)` would otherwise also match
    # the "plain .md link" pattern below.
    def _abs_image(m):
        target = m.group(2)
        if target.startswith("http") or os.path.isabs(target):
            return m.group(0)
        abs_path = os.path.normpath(os.path.join(source_dir, target)).replace("\\", "/")
        return f"{m.group(1)}{abs_path}{m.group(3)}"
    text = IMAGE_RE.sub(_abs_image, text)
    # Any remaining relative .md link becomes plain text (no cross-file
    # jumps make sense inside one linear PDF).
    text = MD_LINK_RE.sub(r'\1', text)
    # Collapse resulting multi-blank-lines.
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip() + "\n"


FRONT_MATTER = """\
# About this book

This book was written as an experiment in using **Claude Code**
(Anthropic's AI coding agent) to produce a complete technical book:
the author, **Abderrahim Adrabi**, directed the scope, structure,
audience, and every round of revision across many sessions; Claude wrote
the chapter text, Lean code, and LaTeX. No human Lean expert or
mathematician has independently reviewed the mathematical or Lean content
beyond the author's own direction and the automated checks described in
the README and CHANGELOG (every code block compiled against a real Lean 4
toolchain, plus several AI-driven review passes). Treat it as a
self-checked draft produced through human-directed AI authorship, not a
traditionally peer-reviewed text.

"""


def build_combined_markdown():
    parts = [FRONT_MATTER]
    for chapter in CHAPTERS:
        chapter_dir = os.path.join(BOOK_DIR, chapter)
        for path in chapter_files(chapter):
            with open(path, encoding="utf-8") as fh:
                parts.append(clean(fh.read(), chapter_dir))
    return "\n\n".join(parts)


def main():
    if not _mermaid_available:
        print("[mermaid] npx not found on PATH; Mermaid diagrams will fall "
              "back to source text.", file=sys.stderr)

    combined = build_combined_markdown()
    combined_path = os.path.join(BUILD_DIR, "_book_combined.md")
    with open(combined_path, "w", encoding="utf-8") as fh:
        fh.write(combined)
    print(f"Wrote combined markdown: {combined_path} ({len(combined)} bytes)")

    out_pdf = os.path.join(BOOK_DIR, "lean-for-working-algebraists.pdf")
    metadata_path = os.path.join(BUILD_DIR, "pdf-metadata.yaml")
    header_path = os.path.join(BUILD_DIR, "pdf-header.tex")
    syntax_path = os.path.join(BUILD_DIR, "lean4.xml")

    cmd = [
        "pandoc",
        metadata_path,
        combined_path,
        "-o", out_pdf,
        "--pdf-engine=xelatex",
        "--toc", "--toc-depth=2",
        "--number-sections",
        "--top-level-division=chapter",
        "--syntax-highlighting=tango",
        "--syntax-definition", syntax_path,
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
        "--include-in-header", header_path,
    ]
    print("Running:", " ".join(cmd))
    subprocess.run(cmd, check=True)
    print(f"Built: {out_pdf}")


if __name__ == "__main__":
    sys.exit(main())
