# Contributing

This repository accepts contributions from readers and developers alike.
Most contributions fall into one of three categories: a mistake in the
book's text (wording, a wrong cross-reference, a typo), a bug in the
build/tooling (LaTeX rendering, the companion Lean project, the Python
notebook), or a suggestion for new content.

## Reporting a problem

Open a [GitHub issue](https://github.com/abderrahim-lectures/lean4-learning/issues/new)
describing:

- **Where**: the file and, if possible, the line or section (e.g.
  "`lean_book/06-groups/03-integers-example.md`, the Mathlib equivalent
  box").
- **What's wrong**: a short quote of the problematic text, or the exact
  error message if it's a build/tooling issue.
- **Why it's wrong**, if not obvious (e.g. "this contradicts what
  Chapter 8 says" or "this cross-reference points at the wrong chapter").

Please open one issue per distinct problem rather than a single issue
listing several unrelated ones — this keeps each fix traceable to exactly
the issue it closes. See [PROJECT-HISTORY.md](PROJECT-HISTORY.md) for
examples of how past issues were scoped.

## Proposing a change

1. Fork the repository and create a branch for your change.
2. Make the edit. If you're changing book content, edit the Markdown
   source under `lean_book/<chapter>/` — the LaTeX/PDF pipeline
   (`lean_book_latex/build/build_latex.py`) regenerates `lean_book_latex/`
   from Markdown automatically; don't hand-edit the `.tex` files.
3. Add a `## Unreleased — <title>` entry to
   `lean_book/changelog/<current-unreleased-version>.md` describing what
   changed and why, following the existing entries' format (see
   `lean_book/changelog/README.md` for the index).
4. Open a pull request. Reference the issue it addresses with
   "Closes #N" (or "Fixes #N") so GitHub links and auto-closes it on
   merge.

## Book prose conventions

The book aims for plain, direct academic language throughout: no
metaphors, rhetorical questions used as a stylistic device, or casual
asides. If a sentence needs two readings to parse, it's a candidate for
splitting into two plain sentences.

New or rewritten sections follow a derivation-first exposition, in the
tradition of Arnold's and Gelfand's teaching rather than Bourbaki's: a
definition or theorem is not stated and then explained, it is *earned*.
Pose the question or concrete problem that forces it, walk the chain of
reasoning that discovers it, and only then name and formalize the result
— proof and motivation are one continuous argument, not two separated
blocks. There is no fixed Definition→Theorem→Proof→Remark skeleton to
fill in; structure follows the logic of the argument. (Chapters 8 and 10
are a deliberate exception: their theorem sections stand as a
reference-style catalog, so each entry does follow a fixed six-box
sequence, Claim → Finding the proof → Lean code → Mathematical reading →
Programmer note → Mathlib equivalent, chosen because a reader
consulting them wants a predictable layout, not fresh structure per
theorem.) Do not open a
section or chapter with a narrative "story" framing or a "Picture it like
this" analogy box in place of doing the derivation. Every type-theory or
category-theory term still gets a formal definition (ideally with a
citation — see [`lean_book/bibliography.md`](lean_book/bibliography.md))
and a worked example. Per Arnold's own account of this tradition ("On
Teaching Mathematics," 1997) and the practice of the Gelfand seminar, the
forcing question or problem that opens a section should itself be
**concrete first**: a specific number, a specific small case, a specific
broken computation, not the general phenomenon stated abstractly. Derive
the general definition or theorem *from* that concrete case, rather than
motivating it by structural analogy alone — "abstract or structural
motivation is preferred over a contrived real-world scenario" no longer
describes this book's convention; concrete motivation, worked in full
before any generalization, does. A contrived scenario is still to be
avoided, but a genuine concrete instance of the actual mathematical
object under discussion (a specific ring, a specific group element, a
specific failing proof attempt) is not contrived, it is the example the
definition is trying to capture. Exercises favor fewer, escalating,
proof-heavy problems ("Prove that...", "Show that...") over repetitive
drills, and should not give away their own answer inline — solutions
belong in `lean_book/15-appendix-solutions/`.
This convention now applies to the whole book, from Chapter 0 onward.

## Lean code

Every Lean snippet in the book is verified against the pinned toolchain
in [`lean_project/lean-toolchain`](lean_project/lean-toolchain) rather
than only described. If you add or change a code block, verify it
compiles with `lake build` in `lean_project/` before opening a PR.
