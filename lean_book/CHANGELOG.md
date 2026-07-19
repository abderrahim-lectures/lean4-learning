# Changelog

Notable changes to this book, most recent first. Each entry links back to
the commit(s) it corresponds to where one exists.

## Unreleased — Split 13 dense sentences into plain, simple ones

Follow-up to the ambiguity sweeps: audited the book for sentences that
are grammatically correct and unambiguous but cram too much structure
into one sentence (nested parentheticals, "respectively" pairings,
dash/semicolon-joined independent clauses) and are hard to parse in one
read. Split 13 of these into 2-3 plain sentences each, across Chapters 1,
3, 4, 6, 8, 9, 11, 12, and three appendix solutions. No content changed,
only sentence structure.

## Unreleased — Full-book sweep for ambiguous "it"

Follow-up to the Chapter 1 §1 "it" fix: reviewed the whole book for the
same class of bug (a possessive noun phrase, or another plausible
singular noun, sitting right before "it" with a different intended
referent) and fixed five more instances: a quiver/path-algebra mixup
(Ch. 11 §6), Nat/Python's-int mixup (Ch. 1 §1), rw/its-effect mixup
(Ch. 11 §7), a Lean's-guarantees/Chapter-5 mixup (learning-paths.md), and
a this-system/Python's-tooling mixup (Ch. 5 §3). Left the thousands of
unambiguous "it"s in the book untouched.

## Unreleased — Disambiguate "it" in Chapter 1 §1

Reader-caught: in the sentence simplified in the prior entry, "impossible
for it" read ambiguously as referring to Lean rather than to the term
that type-checked. Changed to "impossible for that term."

## Unreleased — Simplify a wordy sentence in Chapter 1 §1

Reader-requested simplification of the closing sentence of "Why this
matters: types rule things out in advance" — tightened without changing
the claim.

## Unreleased — Fix "the calculus" used with no antecedent

Reader-caught: the judgment definition added to Chapter 1 §1 (PR #67/#69)
referred to "the calculus" before any calculus had been named in the
text. Clarified that it means the underlying formal system generally,
made concrete a few sentences later as the λ-calculus and named precisely
as the calculus of constructions in Chapter 1 §5.

## Unreleased — Fix three logic/reference errors found during review

A user-caught wording bug ("If Mathlib is Mathlib-free by design...", the
subject should be the book, not Mathlib itself) prompted a wider pass for
the same class of error: sentences that don't actually parse, or
contradict something stated elsewhere. Found and fixed two more: Chapter
8's finite-ring example cited "Chapter 7's matrix example" for content
that is actually this chapter's own §7; and a Chapter 12 Socratic question
claimed the book "insist[ed] on the hand-written version through Chapter
11," contradicted by Chapter 8's own `fin3Group`/`fin3Ring`, which already
used `decide`.

## v1.4.10 — Formally cite and define the remaining type-theory notions

Follow-up to the "judgment" fix: audited the whole book for other
type-theory notions introduced or used without a formal definition and a
citation to a source. Fixed five: definitional/propositional equality and
the universe hierarchy (both already had good definitions/examples, just
no References section — added citations to Pierce, Martin-Löf, Girard,
and TPIL4); the Curry–Howard correspondence (added a citation to Howard's
1980 paper, newly added to the Bibliography, plus TPIL4); "eliminator"/
"recursor," used twice with a formal treatment explicitly promised in
Chapter 1 §4 but never delivered (added the promised definition and a
`Nat.rec` worked example to Chapter 1 §5, cross-linked from Chapter 3 §5's
`Or.elim`); and decidability (added a Pierce/TAPL citation).

## v1.4.10 — Formally define "judgment" at its first use, with an example

Chapter 1 §1 used the type-theoretic term "judgment" (`#check e` is the
judgment $e : \tau$) without ever formally defining it — the term-first,
citation-never treatment that had crept in. Added a short formal
definition, cited to Martin-Löf's *Intuitionistic Type Theory*, right
before the term's first use, followed immediately by a worked example
($3 : \mathtt{Nat}$) illustrating what the definition means, plus a
matching Bibliography entry/reference link.

## v1.4.9 — Second-opinion prose review: 2 more passages

Follow-up to the two prior plain-academic-prose passes. An independent
second review, cast against a wider set of criteria (casual
interjections, rhetorical asides used as a stylistic tic, hedging
phrases), found two more instances: "Reassuringly" in the path-algebras
chapter, and a "sound familiar?" rhetorical aside in the Mathlib
chapter. Both rewritten as direct statements.

## v1.4.8 — Add a Python companion notebook

Added `lean_book/python-companion/python_companion.ipynb`, collecting
every "Programmer's corner (Python)" snippet in the book (8 snippets
across 6 chapters) into one runnable notebook that opens directly in
Google Colab, no Lean installation required. Each snippet is verified to
run and produce the output the book's comments claim. Linked from the
book's README reference list.

## v1.4.8 — Full-book review pass for plain academic prose

Follow-up to the "Why Lean?" rewording: a full read-through of every
chapter's prose turned up 7 further passages using a simile, metaphor,
or rhetorical framing in place of a direct statement of fact — a
"smallest possible dose" metaphor for `Fin` being a minimal dependent
type, a "referee" simile for why this book uses `structure` instead of
`class`, a "beating heart" metaphor for the path category being the
essential content of the path-algebra construction, a "training wheels"
metaphor for exercises without worked-example guidance, and two
rhetorical framings ("exactly the wrong thing to hide," "keeps... and
deliberately breaks...") in the Mathlib note. Each was rewritten as a
plain, direct statement. Everything else in the book was already in
this register.

## v1.4.8 — Plainer prose in "Why Lean?"

Reworded the opening paragraph of Chapter 0 §2 ("Why Lean?"), which used
a simile ("the way a compiler checks types") in place of a direct
statement — flagged as reading as performative rather than academic.
Rewritten as a plain, direct statement of what Lean is and how proof
checking works.

## v1.4.8 — Fix scrambled Unicode symbols in code listings (`{α` → `α{`, etc.)

Found while proofreading a rendered page: Chapter 1's
`def identity {α : Type} (x : α) : α := x` example rendered as
`identity α{ : Type} ...` -- the opening brace and the following symbol
visually swapped. Isolating this in minimal standalone test files (same
technique used for the two `listings` bugs below) showed it's much
broader than that one example: `listings`, under XeTeX, scrambles
character order and drops surrounding whitespace whenever two of this
book's `newunicodechar`-mapped symbols sit near each other with nothing
but a space between them and no plain ASCII character in between --
e.g. `α → Vec` (from Chapter 1's `Vec.replicate` example) rendered as
`α→  Vec`. This reproduced identically regardless of `columns=fixed` vs
`flexible` (the previous entry's fix), regardless of whether the
substitution went through `newunicodechar` or a `listings` `literate`
rule, and even with a font that has native glyphs for these symbols and
no substitution mechanism at all -- so it's a `listings`/XeTeX column-
bookkeeping bug specific to non-ASCII characters, not fixable by tuning
any of `listings`' own options.

The fix: every occurrence of one of these symbols inside a
`\begin{lstlisting}` body is now routed through `listings`'
`escapeinside={(*}{*)}` as real LaTeX (e.g. `α` becomes
`(*$\alpha$*)`), so `listings` treats it as an opaque pre-rendered span
instead of a character it measures and positions itself --
`build_latex.py`'s new `escape_lstlisting_unicode()`. `newunicodechar`
remains in place for every other context (inline `` `code` `` spans,
table cells), where it already worked correctly.

## v1.4.7 — Fix missing space after arrows/logic symbols in code listings

Found during a full review pass: every Lean type signature using an
arrow or logic/relation symbol (`→`, `∀`, `∃`, `∈`, `∘`, `∧`, `∨`, `≃`,
etc.) was silently missing the space that follows it in the source --
`M → M → M` rendered as `M →M →M` throughout the book. Root-caused to
`lean-listings.tex`'s `columns=flexible` listings option: it drops the
literal space immediately following any `newunicodechar`-substituted
symbol, confirmed by isolating this in a minimal test file with no
relation to this book's other packages. An earlier attempt at this fix
patched the symbol *mapping* itself (forcing a trailing space into every
`\newunicodechar` replacement), which happened to also fix the listings
case but broke the *other* place these same symbols appear --
standalone inline references like `` `→` `` in prose lists (e.g. "rules
for `∧`/`∨`/`¬`/`→`, write..."), where the forced space then showed up
as an unwanted gap before the following punctuation. Reverted that, and
fixed the actual root cause instead: switched `columns=flexible` to
`columns=fixed` in both the `lean` and `python` listings styles. No
newunicodechar mapping needed to change at all.

## v1.4.6 — Drop web-navigation-only "Next" sections from the PDF

Every chapter's trailing "## Next — Continue to [Chapter N: ...](...)."
section (13 files) was a GitHub/web reading aid pointing at the next
Markdown file — meaningless in a printed/PDF book, where the reader just
turns the page. `build_latex.py` now drops these via a new
`strip_next_section()` (Markdown source is untouched, so the web/GitHub
reading experience is unaffected). One file
(`04-tactics/06-exercises.md`) phrased the same transition inline rather
than under its own heading — hand-edited to drop just the "Continue
to..." clause, keeping the rest of its closing sentence.

## v1.4.6 — Front-matter polish: page numbering, author bio, license/source link

- **Fixed a genuine page/section-numbering bug**: front-matter reference
  pages (Learning paths, Notation reference) showed their subsections as
  "0.1", "0.2" etc., since their parent `\chapter*` never steps the
  chapter counter and `\thesection` (= `\thechapter.N`) read that
  counter's untouched initial value of 0 -- making them look like
  sections of a nonexistent "Chapter 0". Their `\section`s are now
  unnumbered (`\section*` + a manual `\addcontentsline`, so they still
  appear in the Table of Contents).
- **Front matter now uses lowercase roman-numeral page numbers**
  (i, ii, iii, ...), switching to arabic starting fresh at Chapter 0 --
  standard practice in printed books, previously this manuscript numbered
  every page in one continuous arabic sequence. (Fixed a follow-on bug in
  the same change: naively calling `\pagenumbering{arabic}` mid-stream
  renumbers whatever page TeX's output routine still has open, not the
  next page that starts — without an explicit `\clearpage` first, the
  switch landed one page early, retroactively renumbering the tail of
  Notation reference's own last table instead of Chapter 0.)
- Long unbroken inline paths/identifiers (e.g. `lean_project/lean-toolchain`)
  could overflow the page margin, since monospace text has no natural
  line-break point. `fix_inline_code()` now inserts `\allowbreak` (an
  invisible break opportunity, not a hyphen) after every `/`, escaped
  `\_`, and `-` in auto-generated inline code.
- Added the author's academic affiliation (Faculty of Sciences, Rabat;
  Faculty of Educational Sciences, Rabat, Morocco) to the title page and
  "About this book"; reworded the "About this book" AI-authorship
  disclosure, which previously read as if no mathematician had reviewed
  the content at all -- it now correctly states that the author (himself
  a mathematician) has reviewed the mathematical and Lean content
  directly, and that it's *additional, independent* review that hasn't
  happened yet.
- Added a copyright/license page (verso of the title page): MIT License
  notice and the source-repository URL, also linked directly on the title
  page itself.
- Tried, then reverted, decorative cover art (first a generic
  concentric-arc pattern, then a redesigned quiver/commutative-diagram
  motif tied to the book's actual category-theory content) -- neither
  landed; the title page and back cover are plain again.

## v1.4.4 — Revert KOMA-Script scrbook back to plain `book`

KOMA-Script `scrbook` (adopted to chase a Springer-Monographs-in-Mathematics
look) caused more churn than it was worth: it conflicts with `titlesec`
(had to be replaced with KOMA's own heading commands), its `DIV`/trim
tuning had to be re-derived at every page-size change, and each of those
changes reopened "does every table/code listing still fit" from scratch.
Reverted `preamble.tex` to plain `book`, keeping the typographic
improvements from the previous entry via plain-LaTeX equivalents instead
of KOMA options:

- `\documentclass[12pt,twoside]{book}` + `\usepackage[margin=1in,
  bindingoffset=0.3in]{geometry}` in place of `scrbook`'s `fontsize=`/
  `DIV=`/`paper=` options.
- `\setlength{\parskip}{0.5\baselineskip}` (keeps `\parindent`, unlike the
  `parskip` package) in place of KOMA's `parskip=half`.
- `\linespread{1.15}` carried over unchanged.
- Chapter/section styling reverted to the original `titlesec`-based
  `\titleformat` rules (the same visual result: a colored rule above/below
  the chapter title, no numeric chapter label, colored section headings)
  instead of KOMA's `\RedeclareSectionCommand`/`\chapterlinesformat`.
- The unnumbered-front-matter-chapter mechanism (`unnumber_chapter()` in
  `build_latex.py`, `\setcounter{chapter}{-1}` before Chapter 0) and the
  table column-ratio/`\small` fix from the previous entries are
  class-independent and needed no changes.

235 pages on A4, compiled clean: zero errors, zero `Overfull \hbox`, zero
`Missing character` warnings.

## v1.4.4 — Typography pass: bigger font, more paragraph spacing

Follow-up to the KOMA-Script switch: the default 11pt/dense-paragraph
look read too small and cramped.

- Bumped to `fontsize=13pt`, `parskip=half` (a visible gap between
  paragraphs, not just first-line indent), and `\linespread{1.15}`.
- Switched `DIV` from a hand-picked value to `DIV=calc`, letting KOMA's
  typearea compute the type area that actually matches the chosen font
  size — a fixed `DIV` was triggering KOMA's own "no optimal type area
  settings" warning and produced a narrower-than-intended text column.
- A smaller physical trim size (first A5, then Springer's actual 155mm x
  235mm monograph trim) was tried, on the theory that a fixed-layout PDF
  page shrinks as a whole to fit a phone/tablet screen, so a smaller
  page-to-margin ratio reads larger once shrunk. Reverted back to
  standard A4 — every trim change reopened the "does every table/code
  listing still fit" question from scratch, which wasn't worth it here.
- Along the way, fixed two things a narrower page made newly visible:
  - Three Lean/Python code blocks used manual leading-space alignment to
    visually continue a trailing comment onto a second line (a trick
    that only holds up on a wide page); with `breaklines=true` on a
    narrower measure, each wrapped line's leading spaces compounded into
    a progressively cascading rightward drift. Rewrote each as a single
    plain trailing comment that wraps normally instead.
  - The two notation-reference tables' four columns were split evenly
    (25% each), which was fine on a wide page but made the long
    "Meaning" column wrap onto far more lines than necessary once the
    page narrowed. `simplify_tables()` now gives 4-column tables an
    asymmetric 34/20/28/18 split, and wraps every table in `\small` — a
    real page-spanning `longtable` turned out to be broken in this
    toolchain's `booktabs`+`longtable` combination even in total
    isolation (confirmed with a minimal, unrelated test file), so every
    table in this book remains a non-breaking block, making its
    per-page fit sensitive to exactly this kind of column-width tuning.

## v1.4.2 — Preface, notation reference, and a KOMA-Script (Springer-style) class

Added the front matter a reader expects before Chapter 1, and switched
the LaTeX manuscript to a nicer, better-typeset class:

- **Preface** and **How to read this book** as their own front-matter
  chapters in `latex/frontmatter.tex` (hand-authored, adapted from the
  README's opening/reading-guide prose but rewritten in book-preface
  voice — no "this repo"/GitHub-specific wording, since the PDF is read
  outside that context).
- **Notation reference**: a new `notation-reference.md`, split into two
  one-page tables ("Logic and quantifiers," "Algebra, structure, and
  diagrams") connecting this book's mathematical notation to its Lean
  syntax — distinct from the existing tactic/library reference and
  λ-calculus dictionary, which deliberately don't cover this ground.
  Linked from the README's Reference list and built into the LaTeX front
  matter, right after Learning paths.
- **Chapter numbering now matches each chapter's own title text.**
  Previously, Learning paths/Notation reference/the tactic and library
  reference/the λ-calculus dictionary were auto-numbered like real
  chapters, silently consuming `\thechapter` slots and shifting Chapter
  0's LaTeX-internal number away from the "0" embedded in its own title
  (the Table of Contents showed "3 Chapter 0: Setting up Lean 4"). These
  reference pages are now unnumbered chapters with a manual
  `\addcontentsline` (still listed in the Table of Contents, still
  cross-reference by their own positional labels, just no longer eating a
  numbered slot), and `\setcounter{chapter}{-1}` before Chapter 0 makes
  its LaTeX number genuinely 0, matching the book's own numbering exactly
  through Chapter 13.
- **Switched `\documentclass` from plain `book` to KOMA-Script `scrbook`**,
  configured (`DIV=12,BCOR=8mm`) toward the type-area proportions of a
  Springer Monographs in Mathematics volume. This is *not* Springer's
  actual `svmono`/`svmult` class — that file is distributed directly from
  Springer's author-guidelines page, not via CTAN/MiKTeX, so it isn't
  something this pipeline can fetch or install; an actual Springer
  submission would swap in the real class file later. `titlesec` (which
  conflicts with KOMA's own heading machinery) was replaced with KOMA's
  native `\RedeclareSectionCommand`/`\chapterlinesformat` to keep the same
  chapter-rule/section-color styling.
- Fixed a real, pre-existing content bug found while authoring the new
  notation-reference page: `build_latex.py`'s nav-line stripper
  (`NAV_LINE_RE`) matched *any* line starting with a link to a `.md` file,
  which silently deleted whole sentences (link and all, plus whatever
  trailing text shared that physical line) across more than 20 generated
  files whenever a body-text link happened to word-wrap onto its own
  line — e.g. 06-groups/02-translating.md's "...is a genuine
  [subobject](...)\nof the space of raw data." lost the word "subobject"
  and its link entirely, and 09-ring-theorems/01-setup.md's "recovered by
  projecting along the\n[forgetful functors](...), so that..." lost that
  whole clause. Replaced with `strip_nav_lines()`, which only strips a
  link-only line when it sits directly against a `---` rule (the actual,
  provably-unique signature of a real nav line in this book) instead of
  guessing from line content alone.
- Added a missing `\newunicodechar{⊆}{\ensuremath{\subseteq}}` mapping
  (found via the new notation table's own "Subset" row).
- Verification habit reinforced from the previous rendering-fixes pass:
  full rebuild stayed at zero `Overfull \hbox` and zero `Missing
  character` warnings throughout every change in this entry.

## v1.4.1 — LaTeX rendering fixes: table overflow, Python listings, learning-paths diagram

Three rendering bugs found while proofreading the compiled PDF, all fixed
at the generator level (`build/build_latex.py`) rather than by hand-patching
generated `.tex`:

- **Tables overflowing the page margin.** `simplify_tables()` converted
  Pandoc's `longtable`+wrapping-`p{width}` columns to a plain `tabular`,
  but discarded the width info and emitted bare non-wrapping `l` columns —
  long cells (e.g. the universal-property table in Chapter 1 §5) ran off
  the right edge instead of wrapping. Now preserves Pandoc's own
  `p{...}` widths (brace-depth aware, since the width expression itself
  contains a nested `\real{...}` group), with an equal-width fallback for
  tables with no width info at all. The same function also left
  `\bottomrule` sitting between the header and body (where longtable's
  `\endlastfoot` had declared it) instead of after the last row — fixed to
  relocate it. Affects all 14 tables across 8 files.
- **Python code listings silently styled as Lean.** A case-mismatch bug
  (`build_latex.py` matched `[language=python]`, but Pandoc always emits
  `[language=Python]`, capitalized) meant `,style=python` was never
  appended, so all 8 Python listings in the book inherited Lean's tactic
  keyword list and `tabsize` instead of `lean-listings.tex`'s own
  `\lstdefinestyle{python}`. Fixed the match to Pandoc's actual output.
- **Learning-paths dependency graph was purely linear**, encoding none of
  the four named reading paths' actual skips. Added the two genuine
  skip points as dashed edges (the other two named paths change how a
  chapter is read, not which chapters are read, so they stay prose-only):
  Chapter 1 split into §1-3/§4-5 sub-nodes with a dashed bypass to Chapter
  2 (and a second bypass from Chapter 4 to Chapter 6, skipping Chapter 5)
  for "I already know Lean," and a dashed Chapter 0 → Chapter 6 bypass for
  "I want to see Lean do real mathematics as fast as possible." Applied to
  both `learning-paths.md`'s Mermaid source and the hand-authored
  `tikz-cd` diagram (re-verified via its standalone compile smoke-test
  before the full rebuild).
- Also fixed a pre-existing blank-page bug: `book` class's default
  `\cleardoublepage` (used before every `\chapter`, since `book` defaults
  to `openright`) doesn't set `\thispagestyle{empty}` on the blank page it
  inserts, so those pages showed the running header rule and page-number
  footer despite having no content. Redefined it to blank those pages
  properly.
- New verification habit: `xelatex`'s compile log already reports every
  margin overflow via `Overfull \hbox (Npt too wide)` warnings — grepping
  the log and filtering to anything above a few points catches this whole
  bug class across all ~230 pages systematically, instead of relying on
  spot-checking rendered pages by eye. All large-magnitude overflows
  (previously up to ~600pt, from the table bug above) are now gone.

## v1.4.0 — Socratic questions at the end of every chapter

Added a **"Socratic questions"** block to every chapter (14 in total),
positioned between the existing "Key points" recap and that chapter's
exercises (or, for Chapter 13, as a reflective close to the whole book,
right before the pointer to the solutions appendix). These are
deliberately a different genre from both neighbors: "Key points" states
facts; exercises ask the reader to prove something new; a Socratic
question poses a "why does X, not Y?" or "what would break if...?"
prompt with its own answer immediately following, aimed at surfacing a
plausible misconception before confirming or correcting it — closer to
oral-exam questioning than either a recap or a problem set. Each
chapter's three questions are specific to that chapter's own material
(e.g. Chapter 6 asks why the Group axioms split `id_left`/`id_right` when
`intGroup` never exercises the difference; Chapter 9 asks why `neg_seven`
closes by `rfl` when the general `neg_one_mul` needs five lines for the
"same" fact), not a generic template repeated fourteen times.

Caught and fixed two real bugs during this pass:
- **A Markdown nested-emphasis bug**: two questions wrapped their entire
  text in `*...*` and *also* emphasized one inner word the same way
  (`*...how Lean *finds* an instance...*`). CommonMark does not nest
  identical-delimiter emphasis reliably, and Pandoc's LaTeX output showed
  it directly — a stray literal asterisk mid-sentence in the compiled
  PDF, caught only by actually rendering the page, not by reading the
  source Markdown. Fixed by dropping the redundant inner emphasis in both
  places (`05-rigor-check/05-exercises.md`, `06-groups/07-exercises.md`).
- **A missing Unicode mapping**: one new question's inline code used ↦
  (maps-to), the first use of that character inside a code span anywhere
  in the book; `preamble.tex` had no `newunicodechar` entry for it, so
  Consolas reported a missing-glyph warning. Added
  `\newunicodechar{↦}{\ensuremath{\mapsto}}`.

## v1.4.0 — Professional LaTeX styling; retire the old PDF pipeline

- **Renamed the top-level LaTeX driver** from the generic `main.tex` to
  `lean-for-working-algebraists.tex`, matching the book's own name.
- **Moved `learning-paths.tex` into the front matter**, input right after
  "About this book" and before Chapter 0 — a reader should see the
  reading paths before starting, not find them buried in the back matter
  after every chapter.
- **Retired the old Pandoc-direct-to-PDF pipeline entirely**:
  `build/build_pdf.py`, `build/pdf-header.tex`, `build/pdf-metadata.yaml`,
  and `build/lean4.xml` are removed (`lean4.xml`'s keyword lists live on,
  transcribed into `latex/lean-listings.tex`). `build/build_latex.py` is
  now the book's only build pipeline. README's "Building a PDF" section
  replaced with "Building the LaTeX manuscript," describing the
  `xelatex`+`biber` compile sequence directly.
- **Real title page and back cover**, replacing the bare `\maketitle`:
  a designed title page (title, subtitle, decorative rules, author,
  toolchain version) in `frontmatter.tex`, and a new `backmatter.tex`
  with a back-cover-style blurb, highlights, and author line, input at
  the very end of the document.
- **Professional chapter/section styling** via `titlesec` (ruled chapter
  openings, colored section headings) and running headers/footers via
  `fancyhdr`. The book's recurring boxes (`mathreading`, `progcorner`,
  `pblproject`) are now colored, bordered `tcolorbox`es instead of plain
  `amsthm` remarks.
- **Fixed a real chapter-numbering bug** introduced by the styling pass:
  `\thechapter` (LaTeX's automatic counter, incrementing once per
  `\chapter{}` call including the unnumbered Appendix) does not line up
  with the book's own chapter numbers (Chapter 0 for `00-setup/`, etc.),
  so Chapter 6's opening page showed both "Chapter 8" (wrong, automatic)
  and "Chapter 6: ..." (correct, from the title text itself) stacked on
  top of each other. Fixed by dropping the automatic number entirely —
  every chapter's title already states its own correct number as prose.
- **Fixed a pervasive double-escaping bug**: Pandoc's `--listings` output
  already LaTeX-escapes inline code content (`` `#eval x` `` becomes
  `\lstinline!\#eval x!`, already correctly escaped), but this pipeline's
  conversion to `\texttt{}` was escaping it *again*, turning every
  inline-code `#`, `_`, and `&` into a visible literal backslash
  character (e.g. `norm\_num` displaying with the backslash showing,
  instead of rendering as `norm_num`) — affected essentially every
  inline code reference in the entire book. Verified directly against
  Pandoc's actual output before fixing, not assumed.
- `\newtcolorbox`'s own optional-argument bracket is reserved for its
  key=value options and cannot take a plain title string containing a
  comma (a second real bug, caught immediately since it's a hard
  compile error): the checkpoint-project title moved from that bracket
  to a bold first line inside the box body instead.

## v1.4.0 — LaTeX manuscript generation, and a learning-paths page

- Added [`learning-paths.md`](learning-paths.md): a chapter-dependency
  graph plus four named reading paths for readers starting from different
  backgrounds (already know Lean, already know algebra, want the formal
  foundations first, or want to see Lean prove real theorems as fast as
  possible), linked from the README and "How to read this book."
- Added **`build/build_latex.py`**, generating a full LaTeX manuscript
  from the finished Markdown into a new `lean_book/latex/` tree — one
  `.tex` per Markdown section file (108 in total, mirroring the source
  layout exactly), a driver per chapter, and a top-level
  `lean-for-working-algebraists.tex`. This
  phase stops at `.tex`; no PDF is produced by the script itself (a
  Springer submission wants LaTeX source, not a pre-rendered PDF), though
  the whole tree was compiled end to end via `xelatex`+`biber` repeatedly
  during development to verify it actually works (219 pages, zero errors,
  zero missing characters, zero unresolved cross-references in the final
  pass) — that verification PDF is not committed.
- **Every Mermaid diagram hand-translated to native `tikz-cd`** (8 in
  total: the universal-property/initial-object/forgetful-functor/subobject
  diagrams in Chapter 1 §4, the product/coproduct diagrams in Chapter 3
  §5, the quiver diagram in Chapter 11 §3, and the new chapter-dependency
  graph), each with its own standalone compile smoke-test in
  `lean_book/latex/smoketest/`.
- **Consolidated bibliography** carried over as `references.bib`
  (BibTeX, one entry per `bibliography.md` source, same keys), cited via
  `\cite{}`/biblatex — not a second, hand-maintained copy.
- **Custom `amsthm` environments** for the book's recurring boxes:
  `mathreading` ("Mathematical reading"), `progcorner` ("Programmer's
  corner (Python)"), and `pblproject` (the two checkpoint projects,
  wrapped whole).
- **Lean and Python code via `listings`**, not Pandoc's default
  Skylighting output: `lean-listings.tex` defines a `lean` language for
  `listings` (keywords and tactics carried over from `build/lean4.xml`,
  the same syntax definition the PDF-build pipeline uses) and a matching
  `python` style, styled identically (font, frame, colors).
- Cross-chapter references (`[Chapter 5 §2](../05-rigor-check/...)`)
  become working `\hyperref[...]{...}` links, not literal prose text —
  every section gets a unique, hand-assigned label
  (`sec:<chapter>:<file>:<n>`) rather than relying on Pandoc's own
  auto-slugged labels, which collide across chapters (nearly every
  chapter has a heading literally titled "Exercises"). **Known
  simplification:** links with a `#fragment` anchor resolve to the
  *file's* first heading, not the exact sub-heading; every such link
  still lands on the correct section, just not the precise paragraph.
- Real bugs hit and fixed while building the pipeline, each worth noting
  since they'd recur for any similar Pandoc-fragment-mode LaTeX
  generation: Pandoc's `\passthrough`/`\tightlist`/`\real` helper macros
  are normally supplied by its own `--standalone` template, which this
  per-section pipeline doesn't use, so they're provided by hand in
  `preamble.tex`; `\lstinline` (used for Pandoc's inline code spans)
  breaks on this book's Unicode math operators even without any other
  interference, so inline code renders as escaped `\texttt{}` instead;
  Pandoc's `longtable`+`caption` output for small lookup tables errored
  under a `caption`/`longtable` counter interaction with no `--standalone`
  template to configure it, so tables are simplified to plain `tabular`;
  and `\input` paths are resolved relative to the top-level driver's own
  directory, not the including section file's, which affects every
  diagram and image reference.
- Do not adopt Springer's `svmult`/`svmono` class files in this pass —
  a separate, later decision — `lean_book/latex/` uses plain, portable
  LaTeX throughout.

## v1.4.0 — Learning objectives, key points, and a consolidated bibliography

- Added a short **"Learning objectives"** paragraph to every chapter's
  `00-index.md` (Chapters 0–13), stating what a reader should be able to
  do by the end of that chapter.
- Added a brief **"Key points"** recap immediately before each chapter's
  exercises (or, for the three chapters without an exercises file —
  Chapters 0, 2, 12 — at the end of the chapter's last section). Chapter
  13 was left without one, since [01-what-we-built.md](13-next-steps/01-what-we-built.md)
  already serves as a whole-book recap.
- **Consolidated every chapter's References section into one
  [Bibliography](bibliography.md)**, de-duplicating first: Pierce's *Types
  and Programming Languages* alone was cited in full, with slightly
  different text, in five different chapters, and several other sources
  (Dummit & Foote, the Python `typing`/mypy docs, Milner 1978, the CoC
  paper, *Theorem Proving in Lean 4*) were repeated at least once. Every
  source now has exactly one full citation, on the bibliography page;
  each chapter's own References section keeps only a short pointer plus
  the section-specific reason for citing it. Three sources missed by the
  original per-chapter passes (Gentzen 1935, Gödel 1930, Martin-Löf 1984)
  were folded in during this consolidation. Added to the README's
  Reference list.
- No Lean code was touched in this pass; `lake build` on the companion
  `lean_project` re-confirmed unaffected.

## v1.4.0 — Project-Based Learning components

Distributed PBL scaffolding through the book instead of leaving it only at
the very end:

- Added a new **checkpoint project** at the end of Part I,
  [05-rigor-check/06-checkpoint-project.md](05-rigor-check/06-checkpoint-project.md):
  build a `Monoid` from scratch (`Group` minus inverses) and prove identity
  uniqueness for it, one chapter ahead of `Group` itself. Full worked
  solution (with a second instance) added to
  [Appendix, Chapter 5](14-appendix-solutions/04-chapter-5.md).
- Added a second **checkpoint project** at the end of Part II,
  [11-path-algebras/07-checkpoint-project.md](11-path-algebras/07-checkpoint-project.md):
  define `Path.length` and prove `Path.append` respects it. This surfaced
  a real, verified fact about Lean worth documenting directly — functions
  matching on an *indexed* inductive type like `Path` reduce only through
  their equation lemmas (`simp only [...]`), not plain `rfl`, once an
  abstract argument is involved. Full worked solution added to
  [Appendix, Chapter 11](14-appendix-solutions/10-chapter-11.md); [Chapter
  13's "What we built"](13-next-steps/01-what-we-built.md) updated to name
  this as a second explained exception to the book's no-`simp` discipline
  (alongside Chapter 6's `Perm3.ext`), rather than leave the claim
  overstated.
- Both new chapters' `00-index.md` and their exercises files' navigation
  updated to include the checkpoint project as the chapter's closing
  section.
- Expanded [Chapter 13 §3](13-next-steps/03-next-projects.md)'s five
  one-line "suggested next projects" into full scaffolds (learning
  objectives, prerequisites, milestones, a concrete deliverable, and a
  self-verification step the reader can run), modeled on §2's "Two
  theorems for free" capstone rigor. These remain genuinely open — no
  appendix solutions were added for them, unlike the two checkpoint
  projects, since they were never worked exercises with answers in the
  first place.

## v1.4.0 — Full-book review pass (Chapters 2, 4, 6–13, solutions appendix)

Applied the same verification discipline used for the type-theory rewrite
(every Lean snippet re-run against the pinned toolchain via `lake env
lean`/`lake build`; every factual and cross-reference claim checked) to
every remaining chapter. Found and fixed several real bugs a read-through
alone would have missed:

- **Wrong lemma name in a solution.** [Appendix, Chapter
  5](14-appendix-solutions/04-chapter-5.md)'s exercise 1 solution claimed
  `rw [Nat.two_mul]` closes `n * 2 = n + n`; running it fails, since
  `Nat.two_mul : 2 * n = n + n` has the arguments in the other order.
  Fixed to the correct `Nat.mul_two : n * 2 = n + n`.
- **A tool-output claim that didn't match the real toolchain.** [Chapter 12
  §1](12-working-efficiently/01-search-tactics.md) claimed `exact?` suggests
  `exact h.symm` for a simple symmetry goal; run against this book's pinned
  toolchain, it instead returns a correct but far less readable term.
  Rewrote the section to show the verified actual output and make the
  point honestly (search tactics find *a* closing term, not necessarily
  the most idiomatic one).
- **A missing exercise solution.** [Appendix, Chapter
  8](14-appendix-solutions/07-chapter-8.md) had solutions for exercises 1–2
  but not 3 (`mat2_not_comm`), even though the theorem was already proved
  and verified in the companion Lean project. Added the missing solution
  and explanation.
- **Repeated chapter mislabeling.** [Chapter
  12](12-working-efficiently/00-index.md) attributed the "find the proof
  by search, not just present the answer" discipline and its multi-step
  `rw`/`have` proofs to "Chapters 6 and 8" in five places across four
  files; that framing and those proofs are actually in Chapters 7 and 9
  (6 and 8 are the *definition* chapters). Corrected throughout.
- **A stale cross-reference.** [Chapter 10 §5](10-modules/05-linear-maps.md)
  attributed `evenSubmodule` to "Chapter 9"; it's defined earlier in the
  same chapter, in §4. Fixed to point to §4 directly.
- **An overclaim about the book's own tactic usage.** [Chapter
  13](13-next-steps/01-what-we-built.md) claimed "there is no `simp`"
  anywhere in the book; [Chapter 6 §4](06-groups/04-permutations-example.md)'s
  `Perm3.ext` genuinely uses `simp only [mk.injEq]`, since core Lean
  generates no field-wise extensionality lemma for a plain `structure`.
  Softened the claim and named the one explained exception.
- Added **References** sections (real, verified sources) to chapters that
  were missing them despite making external, checkable claims: [Chapter
  2](02-functions-and-structures/01-structure-basics.md) (structure-as-product,
  parametric polymorphism, forgetful functors), [Chapter
  8 §3](08-rings/03-ring.md) (Dummit & Foote, Aluffi), [Chapter 10
  §2](10-modules/02-translating-into-lean.md) (Dummit & Foote, Weibel), and
  [Chapter 11 §5](11-path-algebras/05-path-composition.md)
  (Assem–Simson–Skowroński, Schiffler).
- Fixed a stale "first used" location for `sorry` in the
  [tactic and library reference](tactic-and-library-reference.md) (claimed
  Chapter 7; it's actually introduced in Chapter 4 §3).
- Re-verified every Lean code block in Chapters 6–11 and 13 (both the
  from-scratch and "Mathlib equivalent" boxes) by rebuilding the entire
  companion `lean_project` — including its `LeanProjectMathlib` modules —
  against the pinned `v4.31.0` toolchain; confirmed every book code block
  still matches its ported module exactly, with no drift.
- Ran a full site-wide Markdown link-integrity sweep; the only unresolved
  link is a pre-existing, intentionally preserved historical reference in
  this changelog (see above, "09-chapter-11.md" predates the Appendix B
  renumbering).

## v1.4.0 — Type-theory chapters rewritten, Appendix B eliminated

- Rewrote [Chapter 1 §1](01-basics/01-everything-has-a-type.md) and
  [§3](01-basics/03-dependent-types.md) to lead with concrete,
  toolchain-verified examples (`Fin`, `Vec`/`Vec.replicate`/`Vec.head`/
  `Vec.dot`, `Sigma`, proof irrelevance) and Python-first comparisons
  before the categorical/formal framing, addressing confusion with the
  prior dependent-types explanation. Added a References section, citing
  real, checked sources, to every chapter touched by this pass.
- **Eliminated Appendix B entirely**, merging its ~9,000 words of formal
  λ-calculus/CoC material directly into the main chapters that already
  pointed to it, rather than leaving it as backmatter most readers would
  skip:
  - The standard-logic recap (natural deduction, soundness/completeness,
    classical vs. intuitionistic) is now [Chapter 3
    §2](03-propositions-and-proofs/02-logic-recap.md), immediately after
    the Curry–Howard table that motivates it, renumbering §2-§7 to §3-§8.
  - The untyped λ-calculus recap (grammar, α/β-reduction, currying,
    Church–Rosser, the $K$ combinator) is woven directly into [Chapter 1
    §4](01-basics/04-terminology.md)'s "Reduce/reduction" glossary entry.
  - Π-types, `Prop` irrelevance, Σ-types, and the CoC/CIC summary are now
    [Chapter 1 §5](01-basics/05-pi-sigma-and-coc.md); the simply typed
    λ-calculus's typing judgments/progress/preservation and the
    universe-formation typing rule are now a new [Chapter 5
    §3](05-rigor-check/03-typing-rules-and-safety.md), extending §2's
    informal universe discussion.
  - Church encodings (booleans, numerals) became a self-contained aside
    in [Chapter 13](13-next-steps/03-next-projects.md), since nothing
    else in the book depended on them.
  - The λ-calculus/Lean dictionary table is now a standalone
    [reference page](lambda-calculus-dictionary.md), sibling to
    `tactic-and-library-reference.md`.
  - Added a new Chapter 1 exercises section
    ([01-basics/06-exercises.md](01-basics/06-exercises.md)) with
    solutions, and renumbered the solutions appendix (`14-appendix-solutions/`)
    throughout to make room for it.
  - Every cross-reference into this content, in both directions, was
    rewritten to point at its new home; a full link-integrity sweep
    across every `.md` file in the book found zero broken internal links
    after the `15-lambda-calculus/` directory was removed.

## v1.2.0 — Capstone: two theorems for free

- Added "Two theorems for free" to [Chapter 13 §2](13-next-steps/02-moving-to-mathlib.md):
  a short capstone proving, for real via Mathlib, two facts this book's
  own from-scratch definitions explicitly could not state — that
  `ZMod 3` is a `Field` (Chapter 8 §5 built only a `Ring` and said so
  outright), and Lagrange's theorem applied to a genuine subgroup of
  `Equiv.Perm (Fin 3)` (Chapters 6-7's non-abelian example, which never
  had subgroups defined for it). Ported into `lean_project` as
  `Ch13CapstoneMathlib.lean` and compiled against real Mathlib — the
  first attempt's `decide` calls on `Nat.card`/`orderOf` failed to
  reduce (both are defined via classical choice), fixed by routing
  through `Nat.card_eq_fintype_card`/`Fintype.card_perm` and
  `orderOf_eq_prime` instead.

## v1.1.0 — Inline reference links, and a second screenshot

- Every tactic and Mathlib name across the whole book now gets a reference
  link right next to its first mention in each chapter's own prose (not
  only on the standalone `tactic-and-library-reference.md` lookup page
  added earlier) — tactics link to the official Lean 4 Tactic Reference,
  Mathlib names (in Chapters 6-11's "Mathlib equivalent" boxes) link via
  Loogle. Care was taken not to link the book's own from-scratch
  `Group`/`Ring`/`Module`/etc. as if they were the real Mathlib classes.
- Added a second real VS Code screenshot, in
  [Appendix A's Chapter 11 solutions](14-appendix-solutions/09-chapter-11.md),
  showing the Lean Infoview for `append_nil_left`'s `cons` case.

## v1.1.0 — PDF: real Mermaid diagrams, Lean syntax highlighting, honest front matter

- Mermaid diagrams now render as real images in the PDF (via
  `@mermaid-js/mermaid-cli`), not fenced source text — previously every
  `graph TD`/`graph LR` diagram just showed as a code block.
- Added a custom Kate syntax-highlighting definition for Lean 4
  (`build/lean4.xml`, since Pandoc's highlighter has no built-in Lean
  lexer) so Lean code blocks get real syntax coloring; Python code blocks
  already highlighted correctly.
- Long code lines now wrap instead of running off the page edge.
- The PDF's title page now names the actual author, Abderrahim Adrabi,
  and a new front-matter "About this book" page states plainly that the
  text was generated by Claude Code under the author's direction — not
  just noted in the repo's top-level README, but in the PDF itself.
- All PDF-build tooling (`build_pdf.py`, `pdf-header.tex`,
  `pdf-metadata.yaml`, `lean4.xml`) moved into a dedicated `build/`
  folder instead of sitting loose at the book root.

## v1.1.0 — Screenshot and reference links

- Added a real VS Code screenshot of the **Lean Infoview** to
  [Chapter 4 §1](04-tactics/01-goal-state.md), captured live against
  `my_add_comm`'s `succ` case, showing the hypotheses/goal split described
  in the surrounding text rather than only a text mock-up of it.
- Added [`tactic-and-library-reference.md`](tactic-and-library-reference.md),
  a lookup table linking every tactic used in the book to the official
  Lean 4 Tactic Reference, and every Mathlib name used in Chapters 6-11's
  "Mathlib equivalent" boxes to Loogle/Mathlib4 docs. Linked from the
  README, Chapter 4, Chapter 6, and Chapter 12.

## v1.0.0 — PDF build

- Added `build_pdf.py`, a Pandoc + XeLaTeX pipeline producing a single
  print-style PDF of the whole book (KOMA-Script `scrbook`, title page,
  numbered chapters, table of contents, syntax-highlighted code blocks).
  Per-file navigation strips are stripped and cross-file links flattened
  to plain text, since neither makes sense inside one linear PDF.

## v1.0.0 — Plain-English pass

- **Rewrote the book's prose to roughly CEFR B2 English** (upper-intermediate)
  across every chapter and the appendix: shorter sentences, plainer everyday
  words, fewer stacked em-dash asides. The goal is that a non-native English
  reader spends effort on Lean and math, not on decoding vocabulary. Code
  blocks, LaTeX math, links, headers, and the recurring section labels
  ("Mathematical reading.", "Programmer's corner (Python).", "Read more:",
  "Mathlib equivalent.") were left untouched — only the surrounding English
  glue changed, with no loss of technical content or nuance.
- The shared glossary (Chapter 1 §4) was restructured so every term
  (Elaborate/elaboration, Unify/unification, Reduce/reduction/normal form,
  Motive, and the four category-theory terms) has its own heading and a
  stable link anchor, ready for other chapters to link to on first use.
- Fixed a real bug surfaced while touching Chapter 11's Mathlib-equivalent
  boxes: an `open Quiver` in two code samples silently clashed with
  Mathlib's own root-level `Path` (continuous paths,
  `Mathlib.Topology.Path`), the same ambiguity already fixed in
  `lean_project` but never carried back into the book text. Fixed by
  spelling out `Quiver.Path` throughout instead.

## v1.0.0 — Mathlib-equivalent boxes

- **Every worked example in Chapters 6–11 (groups, group theorems, rings,
  ring theorems, modules, path algebras) is now followed by a "Mathlib
  equivalent" box**, showing the same statement or construction phrased
  against Mathlib's real `Group`/`Ring`/`Module`/`Quiver` API. The
  from-scratch construction stays the primary teaching path (see
  [the Mathlib note](00-setup/04-mathlib-note.md), updated to explain the
  framing); the Mathlib box is a deliberate peek ahead, so that Chapter
  13's move to Mathlib in full isn't the reader's first sight of it.
- Every added Mathlib snippet is ported into `lean_project/LeanProject/`
  as a matching `Ch0*Mathlib.lean` module per chapter (kept separate from
  the from-scratch modules so it's obvious which files pull in the
  Mathlib dependency) and verified with `lake build` against real
  Mathlib, not just read over.
- `lean_project` now depends on Mathlib (pinned to the `v4.31.0` tag,
  matching the toolchain).

## v1.0.0 — Mermaid diagrams

- **Category-theory diagrams upgraded from plain ASCII art to
  [Mermaid](https://mermaid.js.org/)** (the universal-property/
  initial-object/forgetful-functor/subobject entries in the Chapter 1 §4
  glossary, the product/coproduct pictures in Chapter 3, the running
  quiver example in Chapter 11) — real boxes and arrows on GitHub and in
  Mermaid-aware viewers, falling back to a readable code block showing the
  diagram source everywhere else, still without depending on
  `tikz-cd`/`amscd`-style LaTeX packages the book's MathJax/KaTeX
  rendering path doesn't guarantee.

## [Readability & navigation pass](https://github.com/abderrahim-lectures/lean4-learning/commit/fa7b258)

- **One block per example.** Sections that used to dump several `theorem`/
  `def`/`structure` examples into one big code fence, then explain all of
  them together afterward, now interleave: one small code block, then the
  explanation for *that* example, repeated — across Chapters 1–11 and the
  appendix solutions. A `def`/helper immediately followed by the one thing
  that uses it (e.g. a `structure` and its `.ext` lemma) is kept together
  rather than artificially split.
- **"Mathematical reading" boxes** that discussed multiple examples at
  once were split the same way, so each box sits with the specific example
  it's explaining; boxes that genuinely synthesize *across* several
  examples (compare them, generalize over them) were left intact.
- **"Programmer's corner (Python)" boxes** were checked and repositioned
  to sit immediately after the one example each is illustrating, rather
  than trailing at the end of a section that had since grown other content.
- **Category-theory diagrams** added at the natural spots: the shared
  glossary's universal-property/initial-object/forgetful-functor/subobject
  entries, the product/coproduct reading of `∧`/`∨`, and a literal arrow
  diagram for the book's running quiver example (originally plain ASCII,
  later upgraded to Mermaid — see above).
- **Chapter 3's `∃` section** expanded from one example to two: the
  original `⟨2, rfl⟩` (smallest non-degenerate even number, chosen instead
  of the original `⟨0, rfl⟩` to avoid looking like a trick), plus a second
  example proving "there's a prime bigger than 3" — introducing a
  proof that isn't `rfl`, a nested `∧`-inside-`∃`, and an explicit note
  on why the *general* infinitude-of-primes theorem needs induction
  (not yet introduced) and where Mathlib's real proof lives.
- **Bare "Chapter *N* §*M*" text mentions** turned into actual clickable
  links throughout, wherever one had been left as plain prose instead of
  a cross-reference.

## Accessibility pass — merged [PR #1](https://github.com/abderrahim-lectures/lean4-learning/pull/1)

- Added a shared glossary (Chapter 1 §4) for the category-theory terms
  used repeatedly in "Mathematical reading" boxes but never previously
  defined — *universal property*, *initial object*, *forgetful functor*,
  *subobject/full subcategory* — and linked every later use back to it.
- Cut one-off category-theory flourishes past the book's own promised
  baseline (adjunction/counit, biproduct, presheaf category, proper
  class/Grothendieck universe, bifunctor, contravariant/anti-automorphism).
- Added **Appendix B §0**, a from-scratch recap of standard propositional
  and first-order logic and natural deduction, for readers meeting formal
  logic for the first time; wired Chapter 4's proof-theory asides to it.
- Fixed remaining HoTT-jargon residue (*transport*, *fiber*,
  *propositional truncation*) and dropped programming-background asides
  (Haskell/ML-family/`rustup` comparisons) that contradicted the book's
  own "no programming background" promise.
- Added five "Programmer's corner (Python)" boxes as an optional third
  reading track alongside "Mathematical reading," for readers with
  programming background but no formal-logic/type-theory background.
- Documented the pass itself in the README.

## [Expert-review pass](https://github.com/abderrahim-lectures/lean4-learning/commit/a07c15a8f78c0ead802dcd645efcccb4d4d56652) (2026)

- Full connective-by-connective Curry–Howard table for Chapter 3, replacing
  a one-line slogan.
- A "Terminology" section (Chapter 1 §4) defining *elaborate*, *unify*,
  *reduce/normal form*, and *motive* the first time each is needed.
- At least one worked example beyond the "obvious" one in every algebraic
  chapter (a genuinely non-abelian finite group in Chapter 6, a finite
  commutative ring in Chapter 8, a concrete linear map and direct-sum
  instance in Chapter 10, a computed path composition in Chapter 11).
- "Read more" pointers threaded throughout rather than concentrated only
  in the closing chapters.

## [Correct stale verification claim](https://github.com/abderrahim-lectures/lean4-learning/commit/1d910968f0facb2d84e0437c898d50440e766113)

- Fixed the README's verification notice and stated the exact Lean
  toolchain version (`v4.31.0`) the book's code is checked against.

## [Add Appendix B](https://github.com/abderrahim-lectures/lean4-learning/commit/1f7a82abe64c4e0630ea018a2f786dd2b4d08b8a)

- Added the λ-calculus and type-theory appendix: untyped λ-calculus,
  Church encodings, the simply typed λ-calculus, dependent types and the
  calculus of constructions, and a term-by-term dictionary from
  λ-calculus to Lean.

## [Port book code into lean_project](https://github.com/abderrahim-lectures/lean4-learning/commit/c1a1e5110c18ff9bd729f925cb1ee1c08d6f53f9)

- Every code block in Chapters 1–11 ported into `lean_project/LeanProject/`
  (one module per chapter) and verified with `lake build` against the real
  compiler — not just read over. Several bugs only surfaced this way (a
  missing extensionality lemma, `rw` steps that over-rewrote, a reference
  to an undefined `intZModule`, Mathlib's `ring` tactic used without
  Mathlib ever being imported) and were fixed in both the book text and
  the project.

## [Restructure into per-chapter folders](https://github.com/abderrahim-lectures/lean4-learning/commit/25896e6d96cab760acc7df45deb7bfbb9cd40e8f)

- Moved from a flat layout into one folder per chapter, each with a
  `00-index.md` overview and one file per section.
- Added the Chapter 5 "Rigor check" (structures vs. classes, universes,
  definitional vs. propositional equality) and the "Mathematical reading"
  boxes tying Lean constructs back to standard algebra/category-theory
  language.

## [Add matrix ring and module theory chapters](https://github.com/abderrahim-lectures/lean4-learning/commit/59753f68de1b6abe210e5657077b41c83485b69e)

- Added the matrix-ring worked example, Chapter 10 (modules over a ring),
  and chapter-to-chapter navigation strips.

## [Initial commit](https://github.com/abderrahim-lectures/lean4-learning/commit/9ece99a9f33777d8d8d96dc1ec6968190c960365)

- First version of the book: groups, rings, and quiver path algebras,
  with a companion `lean_project` Lean 4 project.
