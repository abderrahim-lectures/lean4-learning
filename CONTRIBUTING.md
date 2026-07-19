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
   (`lean_book/build/build_latex.py`) regenerates `lean_book/latex/`
   from Markdown automatically; don't hand-edit the `.tex` files.
3. Add a `lean_book/CHANGELOG.md` entry describing what changed and why,
   following the existing entries' format.
4. Open a pull request. Reference the issue it addresses with
   "Closes #N" (or "Fixes #N") so GitHub links and auto-closes it on
   merge.

## Book prose conventions

The book aims for plain, direct academic language throughout: no
metaphors, rhetorical questions used as a stylistic device, or casual
asides. Every type-theory or category-theory term introduced gets a
formal definition (ideally with a citation — see
[`lean_book/bibliography.md`](lean_book/bibliography.md)) followed by a
worked example. If a sentence needs two readings to parse, it's a
candidate for splitting into two plain sentences.

## Lean code

Every Lean snippet in the book is verified against the pinned toolchain
in [`lean_project/lean-toolchain`](lean_project/lean-toolchain) rather
than only described. If you add or change a code block, verify it
compiles with `lake build` in `lean_project/` before opening a PR.
