#!/usr/bin/env python3
"""Generate a LaTeX manuscript from the book's Markdown, one .tex file per
Markdown section file, mirroring the source layout exactly. This script
does not invoke a LaTeX engine and produces no PDF -- it stops at
emitting `.tex`, per this project's Phase 5 plan (a Springer submission
wants `.tex` source, not a pre-rendered PDF). This is the book's only
build pipeline; the previous Pandoc-direct-to-PDF script has been retired.

Run from anywhere: `python build/build_latex.py`. Requires `pandoc` on
PATH; does not require a LaTeX distribution to run (only to later compile
what this script emits).

Design, in short:
- Every chapter directory becomes `latex/<chapter>/`, containing one
  `.tex` per source `.md` (same stem) plus a `00-index.tex` driver that
  `\input`s them in order.
- `lean-for-working-algebraists.tex` (the top-level driver) `\input`s
  every chapter driver in reading order, plus the three root-level
  reference pages and a generated bibliography chapter.
- Every heading gets a hand-assigned, positionally unique LaTeX label
  (`sec:<chapter>:<stem>:<n>`), overriding Pandoc's own auto-slug labels,
  so that identical headings in different chapters (nearly every chapter
  has an "Exercises" section) never collide.
- Cross-file Markdown links (`[text](../foo/bar.md)`) become
  `\hyperref[sec:foo:bar:1]{text}` -- linking to the *file's* first
  heading. Fragment anchors (`#some-glossary-entry`) are not resolved to
  the specific sub-heading; this is a known, documented simplification
  (see the Phase 5 CHANGELOG entry) -- every such link still resolves to
  the correct *section*, just not the exact paragraph within it.
- Bibliography citations already written as `[KeyName]` reference-style
  links (Phase 4's bibliography consolidation) become `\cite{KeyName}`
  directly, since the key set matches `references.bib` by construction.
- Every ```mermaid fence is replaced, before Pandoc ever sees it, with a
  raw-LaTeX block `\input`-ing the corresponding hand-translated tikz-cd
  file in `latex/diagrams/` (see DIAGRAM_MAP below) -- Pandoc never
  touches Mermaid source at all in this pipeline.
- Code fences convert via Pandoc's `--listings` flag to `\begin{lstlisting}`,
  styled by `lean-listings.tex` (Lean) and plain `language=Python`
  (Python), both `\input` from the top-level driver.
- "**Mathematical reading.**"/"**Programmer's corner (Python).**"
  lead-in paragraphs become `mathreading`/`progcorner` environments
  (single-paragraph scope -- a following code block or list is not
  absorbed into the box; documented simplification, same as above).
  The two checkpoint-project files are wrapped whole in `pblproject`.
"""
import os
import re
import subprocess
import sys

BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
BOOK_DIR = os.path.dirname(BUILD_DIR)
LATEX_DIR = os.path.join(BOOK_DIR, "latex")
MAIN_TEX_NAME = "lean-for-working-algebraists.tex"

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
]

# Root-level pages, converted the same way but with no sub-sections/chapter
# driver of their own -- each is one .tex file directly under latex/.
# FRONT_MATTER_FILES are input right after frontmatter.tex, before Chapter 0
# -- a reader should see the learning paths before starting, not after
# finishing every chapter. ROOT_FILES are back-matter reference pages,
# input after the last chapter.
FRONT_MATTER_FILES = [
    "learning-paths.md",
    "notation-reference.md",
]
ROOT_FILES = [
    "tactic-and-library-reference.md",
    "lambda-calculus-dictionary.md",
]

# Whole-file pblproject wraps (checkpoint projects are one self-contained
# project per file, unlike Chapter 13 Sec.3's five-projects-in-one-file,
# which is left as plain sections -- see module docstring).
PBLPROJECT_FILES = {
    "05-rigor-check/06-checkpoint-project.md",
    "11-path-algebras/07-checkpoint-project.md",
}

# Mermaid fences, in file order, mapped to their hand-translated tikz-cd
# diagram (see latex/diagrams/*.tex and latex/smoketest/*-smoke.tex for
# each one's standalone compile smoke-test).
DIAGRAM_MAP = {
    "01-basics/04-terminology.md": [
        "universal-property",
        "initial-object",
        "forgetful-functor-chain",
        "subobject-commgroup",
    ],
    "03-propositions-and-proofs/05-and-or-not.md": [
        "and-product",
        "or-coproduct",
    ],
    "11-path-algebras/03-defining-a-quiver.md": [
        "quiver-example",
    ],
    "learning-paths.md": [
        "chapter-dependency-graph",
    ],
}

## A nav line is one or more `[text](url)` links, optionally `| `-separated
## ("[<- Prev](a.md) | [Index](00-index.md) | ..."), and nothing else on
## the line -- but that shape alone is not enough to identify one: a line
## consisting of a single body-text link (no surrounding words) is
## syntactically identical to a genuine one-link nav line like
## "[Table of contents](README.md)" (see e.g. 06-groups/02-translating.md's
## "...is a genuine\n[subobject](...)\nof the space of raw data.", where the
## link is just this book's own wrapping of an ordinary sentence). The
## actual distinguishing feature, true of every nav line this book inserts
## and false of every such accidental body line, is *position*: nav lines
## always sit directly against a `---` rule (the top one, right after the
## title, or the bottom one, right before EOF) with only blank lines
## possibly between. strip_nav_lines() below uses that adjacency instead
## of guessing from line content alone.
NAV_LINE_ONLY_RE = re.compile(r'^(?:\[[^\]]*\]\([^)]*\)\s*(?:\|\s*)?)+$')


def strip_nav_lines(text):
    lines = text.split("\n")
    is_rule = [line.strip() == "---" for line in lines]
    is_link_only = [bool(NAV_LINE_ONLY_RE.match(line)) for line in lines]
    keep = [True] * len(lines)
    for i, link_only in enumerate(is_link_only):
        if not link_only:
            continue
        j = i - 1
        while j >= 0 and lines[j].strip() == "":
            j -= 1
        j_rule = j >= 0 and is_rule[j]
        k = i + 1
        while k < len(lines) and lines[k].strip() == "":
            k += 1
        k_rule = k < len(lines) and is_rule[k]
        if j_rule or k_rule:
            keep[i] = False
    return "\n".join(line for i, line in enumerate(lines) if keep[i])
MERMAID_RE = re.compile(r'```mermaid\n(.*?)\n```', re.DOTALL)
BIB_CITE_RE = None  # built after bibliography keys are known


def bib_keys():
    bib_path = os.path.join(BOOK_DIR, "bibliography.md")
    with open(bib_path, encoding="utf-8") as fh:
        text = fh.read()
    return set(re.findall(r'\*\*\[(\w+)\]\*\*', text))


BIB_KEYS = bib_keys()


def file_key(chapter, stem):
    """Canonical registry key: 'chapter/stem' for chapter files, or just
    'stem' for root-level files (chapter == '')."""
    return f"{chapter}/{stem}" if chapter else stem


def primary_label(chapter, stem):
    return f"sec:{chapter}:{stem}:1" if chapter else f"sec:root:{stem}:1"


def build_registry():
    """Map every known .md file (by its own relative-path forms) to its
    primary label, so cross-file links can be resolved before Pandoc runs."""
    registry = {}
    for chapter in CHAPTERS:
        chapter_dir = os.path.join(BOOK_DIR, chapter)
        for name in sorted(os.listdir(chapter_dir)):
            if not name.endswith(".md"):
                continue
            stem = name[:-3]
            registry[f"{chapter}/{name}"] = primary_label(chapter, stem)
    for name in FRONT_MATTER_FILES + ROOT_FILES + ["bibliography.md"]:
        stem = name[:-3]
        registry[name] = primary_label("", stem)
    return registry


REGISTRY = build_registry()


def resolve_link_target(citing_chapter, target):
    """Resolve a Markdown link target (as written, e.g. '../06-groups/00-index.md'
    or '02-universes.md') to a registry key, relative to the file that
    contains the link."""
    if citing_chapter:
        base = os.path.join(BOOK_DIR, citing_chapter)
    else:
        base = BOOK_DIR
    abs_path = os.path.normpath(os.path.join(base, target))
    rel = os.path.relpath(abs_path, BOOK_DIR).replace("\\", "/")
    return rel


def replace_mermaid(text, relkey):
    diagrams = DIAGRAM_MAP.get(relkey, [])
    counter = {"i": 0}

    def _sub(m):
        idx = counter["i"]
        counter["i"] += 1
        if idx >= len(diagrams):
            raise ValueError(f"No diagram mapped for mermaid #{idx} in {relkey}")
        name = diagrams[idx]
        return (
            "\n```{=latex}\n"
            "\\begin{center}\n"
            f"\\input{{diagrams/{name}.tex}}\n"
            "\\end{center}\n"
            "```\n"
        )

    return MERMAID_RE.sub(_sub, text)


def _read_braced_group(s, start):
    """s[start] must be '{'; return (inner_content, index_just_past_the_matching_close)."""
    assert s[start] == '{'
    depth = 0
    for j in range(start, len(s)):
        if s[j] == '{':
            depth += 1
        elif s[j] == '}':
            depth -= 1
            if depth == 0:
                return s[start + 1:j], j + 1
    raise ValueError("unbalanced braces")


def unnumber_chapter(tex):
    """Convert Pandoc's numbered '\\chapter{...}' (as emitted for an H1
    heading) into an unnumbered '\\chapter*{...}' with a manual
    \\addcontentsline, so it still appears in the Table of Contents but
    without consuming a \\thechapter slot. Used for front-/back-matter
    reference pages (Learning paths, Notation reference, the tactic and
    library reference, the lambda-calculus dictionary, the appendix) --
    none of these are part of the book's own "Chapter N" sequence, so
    letting them eat numbered-chapter slots would shift every real
    chapter's LaTeX-internal number away from the number it states about
    itself in its own title text."""
    assert tex.startswith("\\chapter{"), tex[:40]
    content, after = _read_braced_group(tex, len("\\chapter"))
    if content.startswith("\\texorpdfstring{"):
        formatted, after_fmt = _read_braced_group(content, len("\\texorpdfstring"))
        plain, _ = _read_braced_group(content, after_fmt)
    else:
        formatted = plain = content
    return (
        f"\\chapter*{{{formatted}}}\n"
        f"\\addcontentsline{{toc}}{{chapter}}{{{plain}}}\n"
        # \chapter* never steps the chapter counter, so it never triggers
        # the usual "stepping a counter resets its children" reset of
        # \thesection either -- without this, this file's own subsections
        # would keep counting up from whatever the *previous* unnumbered
        # chapter left off, instead of starting fresh at .1.
        f"\\setcounter{{section}}{{0}}"
        + tex[after:]
    )


def unnumber_sections(tex):
    """Companion to unnumber_chapter(): every \\section{...} inside an
    unnumbered front-/back-matter chapter would otherwise display as
    "0.1", "0.2", etc. -- \\thesection there is \\thechapter.N, and
    \\thechapter reads 0 (its parent \\chapter* never having stepped the
    counter), which looks like these pages belong to a nonexistent
    "Chapter 0" rather than being front/back matter. Converts every
    \\section{...} in the file to \\section*{...} plus a manual
    \\addcontentsline, so it still appears in the Table of Contents
    (unnumbered, like a real book's front-matter subsections) instead of
    showing a misleading chapter-less "0.N"."""
    out = []
    i = 0
    marker = "\\section{"
    while True:
        j = tex.find(marker, i)
        if j == -1:
            out.append(tex[i:])
            break
        out.append(tex[i:j])
        content, after = _read_braced_group(tex, j + len("\\section"))
        if content.startswith("\\texorpdfstring{"):
            formatted, after_fmt = _read_braced_group(content, len("\\texorpdfstring"))
            plain, _ = _read_braced_group(content, after_fmt)
        else:
            formatted = plain = content
        out.append(f"\\section*{{{formatted}}}\n\\addcontentsline{{toc}}{{section}}{{{plain}}}")
        i = after
    return "".join(out)


def fix_cross_links(tex, citing_chapter):
    """Post-Pandoc: Pandoc already converts a Markdown link to a known
    in-book .md file into \\href{target}{text}, correctly rendering any
    Markdown *inside* the link text (nested code spans, emphasis, etc.)
    along the way. Rewriting that into a working, book-internal
    \\hyperref[...]{...} here -- after Pandoc has already done the hard
    part -- avoids ever needing to hand-roll LaTeX escaping/formatting for
    arbitrary link text (a raw-passthrough approach tried first broke on
    link text containing its own backtick-delimited code spans)."""
    out = []
    i = 0
    marker = "\\href{"
    while True:
        j = tex.find(marker, i)
        if j == -1:
            out.append(tex[i:])
            break
        out.append(tex[i:j])
        target, after_target = _read_braced_group(tex, j + len(marker) - 1)
        if after_target >= len(tex) or tex[after_target] != '{':
            # Not immediately followed by the text group; leave untouched.
            out.append(tex[j:after_target])
            i = after_target
            continue
        text_content, after_text = _read_braced_group(tex, after_target)
        if target.startswith("http"):
            out.append(f"\\href{{{target}}}{{{text_content}}}")
        else:
            relkey = resolve_link_target(citing_chapter, target.split("#")[0])
            label = REGISTRY.get(relkey)
            if label is None:
                out.append(text_content)
            else:
                out.append(f"\\hyperref[{label}]{{{text_content}}}")
        i = after_text
    return "".join(out)


def replace_bib_cites(text):
    # Drop the reference-style link definitions ("[Key]: ../bibliography.md#key")
    # *before* converting citation uses -- otherwise the substitution below
    # would corrupt these lines' own "[Key]" instead of leaving them intact
    # to be stripped whole.
    text = re.sub(r'^\[\w+\]: [^\n]*\n?', '', text, flags=re.MULTILINE)

    # Reference-style citation uses, e.g. "([Pierce2002])" or "Pierce ([Pierce2002])".
    def _sub(m):
        key = m.group(1)
        if key in BIB_KEYS:
            return f"`\\cite{{{key}}}`{{=latex}}"
        return m.group(0)

    text = re.sub(r'\[(\w+)\]', _sub, text)
    return text


def wrap_reading_boxes(text):
    """Wrap the single paragraph starting '**Mathematical reading.**' or
    '**Programmer's corner (Python).**' in the matching custom environment.
    Scope: one paragraph only (up to the next blank line) -- a following
    code block/list is not absorbed. See module docstring."""
    def _mathreading(m):
        return f"\n```{{=latex}}\n\\begin{{mathreading}}\n```\n{m.group(1)}\n```{{=latex}}\n\\end{{mathreading}}\n```\n"

    def _progcorner(m):
        return f"\n```{{=latex}}\n\\begin{{progcorner}}\n```\n{m.group(1)}\n```{{=latex}}\n\\end{{progcorner}}\n```\n"

    text = re.sub(r'\*\*Mathematical reading\.\*\*(.*?)(?=\n\n)', _mathreading, text, flags=re.DOTALL)
    text = re.sub(r"\*\*Programmer's corner \(Python\)[^*]*\*\*(.*?)(?=\n\n)", _progcorner, text, flags=re.DOTALL)
    return text


def wrap_pblproject_tex(tex, relkey, title):
    """Post-Pandoc: wrap the whole file in a pblproject box, dropping its
    own \\section{...} heading (the box supplies its own auto-numbered
    "Checkpoint Project N" title; this file's specific title becomes a
    bold first line inside the box body instead -- tcolorbox's own
    optional-argument bracket is reserved for its key=value options and
    cannot take a plain string containing a comma) but keeping that
    heading's \\label so cross-references into this file still resolve.
    Operates on the rendered .tex, not the source Markdown, so it can see
    (and strip) Pandoc's actual \\section command."""
    if relkey not in PBLPROJECT_FILES:
        return tex
    title = escape_latex_text(title.replace("`", ""))
    title_line = f"\\textbf{{\\large {title}}}\\par\\smallskip\n"
    if not tex.startswith("\\section{"):
        return f"\\begin{{pblproject}}\n{title_line}{tex}\n\\end{{pblproject}}\n"
    # \section{...} may itself contain nested braces (e.g. \texorpdfstring{A}{B}),
    # so a non-greedy regex up to the first "}" cuts it short; match braces
    # by hand to find where \section{...} actually ends.
    depth = 0
    i = len("\\section")
    end = None
    for j in range(i, len(tex)):
        if tex[j] == '{':
            depth += 1
        elif tex[j] == '}':
            depth -= 1
            if depth == 0:
                end = j + 1
                break
    rest = tex[end:] if end is not None else tex
    label_match = re.match(r'\s*(\\label\{[^}]*\})', rest)
    label = ""
    if label_match:
        label = label_match.group(1)
        rest = rest[label_match.end():]
    return f"\\begin{{pblproject}}\n{label}\n{title_line}{rest}\n\\end{{pblproject}}\n"


LATEX_SPECIAL_RE = re.compile(r'([\\#$%&_{}~^])')


def escape_latex_text(s):
    def _esc(m):
        ch = m.group(1)
        if ch == '\\':
            return r'\textbackslash{}'
        if ch == '~':
            return r'\textasciitilde{}'
        if ch == '^':
            return r'\textasciicircum{}'
        return '\\' + ch

    return LATEX_SPECIAL_RE.sub(_esc, s)


LONGTABLE_RE = re.compile(
    r'\{\\def\\LTcaptype\{none\}[^\n]*\n'
    r'\\begin\{longtable\}\[\]\{@\{\}(.*?)@\{\}\}\n'
    r'(.*?)'
    r'\\end\{longtable\}\n\}',
    re.DOTALL,
)
MINIPAGE_CELL_RE = re.compile(
    r'\\begin\{minipage\}\[b\]\{\\linewidth\}\\raggedright\n(.*?)\n\\end\{minipage\}',
    re.DOTALL,
)
def _extract_colspec_entries(colspec_block):
    """Split Pandoc's `>{...}p{...}` column-spec entries out of a longtable
    colspec, brace-depth aware -- a naive `[^}]*` regex breaks here because
    the `p{...}` width expression itself contains a nested brace group
    (`\\real{0.5000}`), so a non-nested pattern stops at that inner `}`
    instead of the outer one."""
    entries = []
    i = 0
    n = len(colspec_block)
    while i < n:
        if colspec_block[i] == '>' and colspec_block[i + 1:i + 2] == '{':
            start = i
            _, after_gt_group = _read_braced_group(colspec_block, i + 1)
            j = after_gt_group
            while j < n and colspec_block[j] in ' \t\n':
                j += 1
            if j < n and colspec_block[j] == 'p' and colspec_block[j + 1:j + 2] == '{':
                _, after_p_group = _read_braced_group(colspec_block, j + 1)
                entries.append(colspec_block[start:after_p_group])
                i = after_p_group
                continue
        i += 1
    return entries


def simplify_tables(tex):
    """Pandoc's default table output is `longtable` (paginated) plus a
    `caption`-package `\\LTcaptype{none}` no-caption marker and a
    `minipage`-wrapped cell for each header entry. This book's tables are
    all small, single-page lookup tables with no captions, so none of
    that machinery is needed; converting to plain `tabular` sidesteps a
    `caption`/`longtable` counter interaction that otherwise errors out
    in fragment mode (no Pandoc --standalone template to configure it).
    The column widths/wrapping and the bottom rule's position are still
    preserved (see below) -- only the longtable/caption machinery is
    dropped, not the table's actual layout."""
    def _sub(m):
        colspec_block, body = m.group(1), m.group(2)
        entries = _extract_colspec_entries(colspec_block)
        if len(entries) == 4:
            # Pandoc always splits columns equally (25% each here), but
            # this book's only 4-column tables (the notation-reference
            # ones) have a long "Meaning" column and a short "First
            # appears" one -- equal widths make "Meaning" wrap onto many
            # more lines than necessary. Skew toward the columns that
            # actually need the room instead.
            fracs = [0.34, 0.20, 0.28, 0.18]
            entries = [
                r'>{\raggedright\arraybackslash}p{(\linewidth - '
                r'8\tabcolsep) * \real{%.4f}}' % f
                for f in fracs
            ]
            colspec = "\n  " + "\n  ".join(entries) + "\n"
        elif entries:
            # Pandoc already computed wrapping p{...} column widths as a
            # fraction of \linewidth -- keep them verbatim instead of
            # collapsing to non-wrapping `l` columns (which let long cells
            # overflow the page margin instead of wrapping).
            colspec = "\n  " + "\n  ".join(entries) + "\n"
        else:
            # Abbreviated form, e.g. "ll" -- one letter per column, no
            # width info from Pandoc. Fall back to equal-width wrapping
            # columns so the table still wraps instead of overflowing.
            ncols = max(len(re.sub(r'[^a-zA-Z]', '', colspec_block)), 1)
            frac = 1.0 / ncols
            entry = (r'>{\raggedright\arraybackslash}p{(\linewidth - '
                      r'2\tabcolsep) * \real{%.4f}}' % frac)
            colspec = "\n  " + "\n  ".join([entry] * ncols) + "\n"
        body = MINIPAGE_CELL_RE.sub(lambda cm: cm.group(1), body)
        body = re.sub(r'\\toprule\\noalign\{\}', r'\\toprule', body)
        body = re.sub(r'\\midrule\\noalign\{\}', r'\\midrule', body)
        # Pandoc's longtable declares \bottomrule as part of \endlastfoot,
        # right after the header row/before the body -- that's where it
        # sits in the raw output, not at the table's actual bottom. Drop it
        # from there and re-attach it after the last body row below.
        body = re.sub(r'\\bottomrule(?:\\noalign\{\})?\n?', '', body)
        body = body.replace("\\endhead\n", "").replace("\\endlastfoot\n", "")
        body = body.rstrip("\n") + "\n\\bottomrule\n"
        # \small keeps reference tables compact -- a standard convention
        # for lookup tables in printed books, and this book's tables are
        # non-breaking (a real, page-spanning longtable turned out to be
        # broken in this toolchain's booktabs+longtable combination even
        # in total isolation, unrelated to anything in this pipeline), so
        # every row's height directly determines whether a table still
        # fits on one page at a given trim size.
        return (
            f"{{\\small\\begin{{tabular}}{{{colspec}}}\n{body}"
            f"\\end{{tabular}}}}\n"
        )

    return LONGTABLE_RE.sub(_sub, tex)


def fix_image_paths(tex, chapter):
    """Pandoc emits \\includegraphics{...} with the path exactly as
    written in the source Markdown (chapter-relative, e.g.
    "images/foo.png"). \\input resolves paths relative to the top-level
    driver's own directory (latex/), not the including sub-file's, so that path needs
    "../<chapter>/" prepended to reach the original image in the
    Markdown source tree (images are not duplicated into latex/)."""
    if not chapter:
        return tex

    def _sub(m):
        opts, path = m.group(1) or "", m.group(2)
        if path.startswith("http") or os.path.isabs(path):
            return m.group(0)
        return f"\\includegraphics{opts}{{../{chapter}/{path}}}"

    return re.sub(r'\\includegraphics(\[[^\]]*\])?\{([^}]+)\}', _sub, tex)


def fix_inline_code(tex):
    """Pandoc's --listings output renders inline code as
    \\passthrough{\\lstinline<delim>...<delim>}. \\lstinline's single-line,
    delimiter-scanned reading mode is fragile with the Unicode math symbols
    this book's Lean snippets use constantly (confirmed empirically: it
    breaks on plain Sigma/arrows even without any other interference) --
    unlike the block-level \\begin{lstlisting} environment, which handles
    the same characters (via newunicodechar) without issue. Convert every
    inline occurrence to \\texttt{...} instead. Pandoc has *already*
    LaTeX-escaped this content for text mode (\\#, \\_, \\&, etc. --
    verified directly: `` `#eval x` `` becomes `\lstinline!\#eval x!`, not
    a literal unescaped `#`), so it is used as-is; re-escaping it here
    (an earlier version of this function did, via escape_latex_text)
    double-escapes every special character (e.g. `\#` becomes
    `\textbackslash{}\#eval`, a literal backslash glyph in the output).

    \texttt content has no natural break points for TeX's line breaker --
    unlike a real word, a path/identifier like `lean_project/lean-toolchain`
    contains no space for the algorithm to break at, so a long one just
    overflows the right margin instead of wrapping. Inserting \allowbreak
    (a breakpoint with no visible mark, unlike \- which prints a hyphen)
    after each `/`, escaped underscore, and `-` gives the line breaker
    somewhere to wrap a long inline path/identifier without changing how
    it looks when it doesn't need to."""
    def _sub(m):
        content = m.group(2)
        content = re.sub(r'(/|\\_|-)', r'\1\\allowbreak{}', content)
        return "\\texttt{" + content + "}"

    pattern = re.compile(r'\\passthrough\{\\lstinline(.)(.*?)\1\}')
    return pattern.sub(_sub, tex)


def renumber_labels(tex, chapter, stem):
    counter = {"i": 0}

    def _sub(m):
        counter["i"] += 1
        n = counter["i"]
        chap = chapter if chapter else "root"
        return f"\\label{{sec:{chap}:{stem}:{n}}}"

    return re.sub(r'\\label\{[^}]*\}', _sub, tex)


def strip_hypertargets(tex):
    # Pandoc wraps headings as \hypertarget{slug}{\subsection{...}\label{slug}} --
    # drop the \hypertarget{...}{ ... } wrapper, keep the inner heading command.
    def _sub(m):
        return m.group(1)

    return re.sub(r'\\hypertarget\{[^}]*\}\{(\\(?:sub)*section\{.*?\}(?:\\label\{[^}]*\})?)\}', _sub, tex, flags=re.DOTALL)


def get_title(md_path):
    with open(md_path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("#"):
                return line.lstrip("#").strip()
    return os.path.basename(md_path)


def convert_file(chapter, name):
    stem = name[:-3]
    relkey = f"{chapter}/{name}" if chapter else name
    src_path = os.path.join(BOOK_DIR, chapter, name) if chapter else os.path.join(BOOK_DIR, name)
    title = get_title(src_path)

    with open(src_path, encoding="utf-8") as fh:
        text = fh.read()

    text = strip_nav_lines(text)
    text = re.sub(r'\n-{3,}\n\s*\n', '\n\n', text)
    text = replace_mermaid(text, relkey)
    text = replace_bib_cites(text)
    text = wrap_reading_boxes(text)
    text = re.sub(r'\n{3,}', '\n\n', text).strip() + "\n"

    # 00-index.md files open with an H1 chapter title ("# Chapter N: ...");
    # every other section file opens with an H2 section title ("## ...").
    # Pandoc's fragment-mode LaTeX writer needs different handling for each:
    # an H1 shifted down a level vanishes entirely (treated as document
    # title, dropped in fragment mode), so index files instead use
    # --top-level-division=chapter with no shift (H1 -> \chapter directly);
    # section files use --shift-heading-level-by=-1 with no top-level
    # override (H2 -> \section, H3 -> \subsection).
    if name == "00-index.md" or not chapter:
        heading_args = ["--top-level-division=chapter"]
    else:
        heading_args = ["--shift-heading-level-by=-1"]

    result = subprocess.run(
        [
            "pandoc",
            "-f", "markdown+raw_attribute",
            "-t", "latex",
            "--listings",
            "--wrap=none",
        ] + heading_args,
        input=text,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if result.returncode != 0:
        raise RuntimeError(f"pandoc failed on {relkey}:\n{result.stderr}")
    tex = result.stdout

    tex = strip_hypertargets(tex)
    tex = simplify_tables(tex)
    tex = fix_image_paths(tex, chapter)
    tex = fix_cross_links(tex, chapter)
    tex = fix_inline_code(tex)
    tex = renumber_labels(tex, chapter, stem)
    if not chapter or (chapter == "14-appendix-solutions" and name == "00-index.md"):
        tex = unnumber_chapter(tex)
        tex = unnumber_sections(tex)
    # listings' language names are case-sensitive; its built-in Python
    # support is registered as "Python", and Pandoc always capitalizes the
    # fence's info string to match (regardless of how it's written in this
    # book's Markdown source, e.g. lowercase ```python).
    tex = tex.replace("[language=Python]", "[language=Python,style=python]")
    tex = wrap_pblproject_tex(tex, relkey, title)

    out_dir = os.path.join(LATEX_DIR, chapter) if chapter else LATEX_DIR
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, f"{stem}.tex")
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(tex)
    return stem


def write_chapter_driver(chapter, stems):
    # 00-index.tex is *both* the converted 00-index.md (the chapter's own
    # \chapter{} heading and intro paragraph, already written by
    # convert_file) *and* the chapter driver: append the \input list for
    # every other section directly onto the end of that same file, rather
    # than overwriting it -- the two roles share one file by design,
    # mirroring 00-index.md's own dual role in the Markdown source.
    out_path = os.path.join(LATEX_DIR, chapter, "00-index.tex")
    lines = ["\n% Auto-appended: input every other section in order.\n"]
    for stem in stems:
        if stem == "00-index":
            continue
        lines.append(f"\\input{{{chapter}/{stem}.tex}}\n")
    with open(out_path, "a", encoding="utf-8") as fh:
        fh.writelines(lines)


def write_main_driver():
    out_path = os.path.join(LATEX_DIR, MAIN_TEX_NAME)
    lines = [
        "% Auto-generated top-level driver. Inputs the front matter (title\n"
        "% page, Preface, About this book, How to read this book, then the\n"
        "% learning-paths and notation-reference pages), every chapter\n"
        "% driver in reading order, the back-matter reference pages,\n"
        "% the generated bibliography, and a back-cover page. Preamble lives\n"
        "% in preamble.tex; front matter in frontmatter.tex; back cover in\n"
        "% backmatter.tex (both hand-written, not generated from Markdown).\n",
        "\\input{preamble.tex}\n",
        "\\begin{document}\n",
        # Professional-book convention: front matter (title page through
        # Notation reference) is paginated with lowercase roman numerals,
        # switching to arabic starting at Chapter 0 -- matches every real
        # print book's front-matter/body-matter page-numbering split.
        "\\pagenumbering{roman}\n",
        "\\input{frontmatter.tex}\n",
    ]
    for name in FRONT_MATTER_FILES:
        stem = name[:-3]
        lines.append(f"\\input{{{stem}.tex}}\n")
    # Front matter above is unnumbered (unnumber_chapter()), so the chapter
    # counter is still at its initial value here -- reset it to -1 so the
    # first real chapter (00-setup) becomes \thechapter=0, matching this
    # book's own "Chapter 0" numbering instead of LaTeX's default 1-index.
    lines.append("\\setcounter{chapter}{-1}\n")
    # \pagenumbering resets \thepage on whatever page is still open in
    # TeX's page builder, not on the next page that will actually start --
    # without forcing a break here first, the switch to arabic landed
    # retroactively on whatever page Notation reference's last section
    # happened to still be finishing, not cleanly at Chapter 0.
    lines.append("\\clearpage\n")
    lines.append("\\pagenumbering{arabic}\n")
    for chapter in CHAPTERS:
        lines.append(f"\\input{{{chapter}/00-index.tex}}\n")
    for name in ROOT_FILES:
        stem = name[:-3]
        lines.append(f"\\input{{{stem}.tex}}\n")
    lines.append("\\input{bibliography.tex}\n")
    lines.append("\\input{backmatter.tex}\n")
    lines.append("\\end{document}\n")
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.writelines(lines)


def write_bibliography_chapter():
    out_path = os.path.join(LATEX_DIR, "bibliography.tex")
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(
            "\\chapter{Bibliography}\n"
            "\\label{sec:root:bibliography:1}\n"
            "\\printbibliography[heading=none]\n"
        )


def main():
    os.makedirs(LATEX_DIR, exist_ok=True)
    total = 0
    for chapter in CHAPTERS:
        chapter_dir = os.path.join(BOOK_DIR, chapter)
        names = sorted(f for f in os.listdir(chapter_dir) if f.endswith(".md"))
        stems = []
        for name in names:
            stem = convert_file(chapter, name)
            stems.append(stem)
            total += 1
            print(f"  {chapter}/{name} -> latex/{chapter}/{stem}.tex")
        write_chapter_driver(chapter, stems)
    for name in FRONT_MATTER_FILES + ROOT_FILES:
        convert_file("", name)
        total += 1
        print(f"  {name} -> latex/{name[:-3]}.tex")
    write_bibliography_chapter()
    write_main_driver()
    print(f"Converted {total} section files. Wrote latex/{MAIN_TEX_NAME}.")


if __name__ == "__main__":
    sys.exit(main())
