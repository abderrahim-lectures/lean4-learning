# Project history

This repository tracks every change — bug fix, new feature, or content
revision — as its own [GitHub issue](https://github.com/abderrahim-lectures/lean4-learning/issues),
closed by the [pull request](https://github.com/abderrahim-lectures/lean4-learning/pulls)
that addresses it. This page summarizes that history; the two GitHub
links above are always the current, authoritative view (issues/PRs
opened after this page was last updated will show there first).

For the reader-facing summary of what changed in each release, see
[`lean_book/CHANGELOG.md`](lean_book/CHANGELOG.md).

## Summary

As of this writing: **71 issues** (all closed) and **35 pull requests**
(all merged), covering:

- **Building out the book's content** — widening the audience beyond a
  category-theory background, adding Mathlib-equivalent boxes, Socratic
  questions, Project-Based-Learning checkpoint projects, learning
  objectives/key points, and a consolidated bibliography.
- **The LaTeX/PDF pipeline** — building a manuscript pipeline from
  Markdown, several rounds of typography and front-matter polish, and
  fixing rendering bugs (table overflow, a scrambled-Unicode-symbol bug
  in code listings, missing spacing around logic symbols).
- **The root README and repository presentation** — restructuring the
  README around a plain "read the book" call to action, adding a
  pedagogical-approach section, and adding GitHub Codespaces / Google
  Colab launch buttons for the companion Lean project and Python
  notebook.
- **Plain-academic-prose reviews** — three full-book passes removing
  metaphors, rhetorical questions used as a stylistic device, and casual
  asides, in favor of direct, plain language.
- **Type-theory rigor** — auditing the book for terms (judgment,
  definitional/propositional equality, universes, Curry–Howard,
  eliminators/recursors, decidability) introduced without a formal
  definition and citation, and fixing each; then two further passes
  fixing logic/reference errors, ambiguous pronouns, and overly dense
  sentences found the same way.
- **Release/changelog hygiene** — fixing a project-wide drift where every
  `CHANGELOG.md` entry still said "Unreleased" despite nine shipped
  releases, and tightening the release workflow to prevent it recurring.

## Merged pull requests

| PR | Title |
| --- | --- |
| [#1](https://github.com/abderrahim-lectures/lean4-learning/pull/1) | Widen audience accessibility: gloss/cut CT jargon, add logic recap, Python boxes |
| [#2](https://github.com/abderrahim-lectures/lean4-learning/pull/2) | Add Mathlib-equivalent boxes after every Chapter 6–11 example |
| [#3](https://github.com/abderrahim-lectures/lean4-learning/pull/3) | Phase 3: Project-Based Learning components |
| [#4](https://github.com/abderrahim-lectures/lean4-learning/pull/4) | Phase 4: learning objectives, key points, consolidated bibliography |
| [#5](https://github.com/abderrahim-lectures/lean4-learning/pull/5) | Add MIT license |
| [#6](https://github.com/abderrahim-lectures/lean4-learning/pull/6) | Phase 5: LaTeX manuscript generation, plus a learning-paths page |
| [#7](https://github.com/abderrahim-lectures/lean4-learning/pull/7) | Professional LaTeX styling; retire the old PDF pipeline |
| [#8](https://github.com/abderrahim-lectures/lean4-learning/pull/8) | Add Socratic questions to every chapter |
| [#9](https://github.com/abderrahim-lectures/lean4-learning/pull/9) | Fix LaTeX table overflow, Python listing style, and learning-paths diagram |
| [#10](https://github.com/abderrahim-lectures/lean4-learning/pull/10) | README: link to latest GitHub release |
| [#11](https://github.com/abderrahim-lectures/lean4-learning/pull/11) | Add Preface/How-to-read front matter, notation reference, KOMA-Script class |
| [#12](https://github.com/abderrahim-lectures/lean4-learning/pull/12) | Typography pass: bigger font, more paragraph spacing |
| [#13](https://github.com/abderrahim-lectures/lean4-learning/pull/13) | Revert KOMA-Script scrbook back to plain book class |
| [#14](https://github.com/abderrahim-lectures/lean4-learning/pull/14) | Front-matter polish, license/source link, drop web-nav sections |
| [#15](https://github.com/abderrahim-lectures/lean4-learning/pull/15) | Fix missing space after arrows/logic symbols in code listings |
| [#16](https://github.com/abderrahim-lectures/lean4-learning/pull/16) | README: fix stale Chapter 4 TOC subtitle |
| [#17](https://github.com/abderrahim-lectures/lean4-learning/pull/17) | Fix scrambled Unicode symbols in code listings |
| [#20](https://github.com/abderrahim-lectures/lean4-learning/pull/20) | Rewrite "Why Lean?" opening in plain academic prose |
| [#28](https://github.com/abderrahim-lectures/lean4-learning/pull/28) | Full-book review: rewrite 7 more passages in plain academic prose |
| [#29](https://github.com/abderrahim-lectures/lean4-learning/pull/29) | Restructure root README as a summary + learning objectives |
| [#30](https://github.com/abderrahim-lectures/lean4-learning/pull/30) | Add a Python companion notebook, runnable on Google Colab |
| [#31](https://github.com/abderrahim-lectures/lean4-learning/pull/31) | Add GitHub Codespaces launch button for lean_project |
| [#54](https://github.com/abderrahim-lectures/lean4-learning/pull/54) | Add a Pedagogical approach section to the root README |
| [#57](https://github.com/abderrahim-lectures/lean4-learning/pull/57) | Second-opinion prose review: rewrite 2 more passages |
| [#63](https://github.com/abderrahim-lectures/lean4-learning/pull/63) | Root README: lead with a plain PDF download, add Codespaces/Colab badges |
| [#65](https://github.com/abderrahim-lectures/lean4-learning/pull/65) | Fix CHANGELOG.md: every entry still said "Unreleased" |
| [#67](https://github.com/abderrahim-lectures/lean4-learning/pull/67) | Formally define "judgment" at its first use in Chapter 1 |
| [#69](https://github.com/abderrahim-lectures/lean4-learning/pull/69) | Follow the "judgment" definition with a worked example |
| [#75](https://github.com/abderrahim-lectures/lean4-learning/pull/75) | Formally cite and define five remaining type-theory notions |
| [#80](https://github.com/abderrahim-lectures/lean4-learning/pull/80) | Fix three logic/reference errors found during a full-book review |
| [#82](https://github.com/abderrahim-lectures/lean4-learning/pull/82) | Fix "the calculus" used with no antecedent in the judgment definition |
| [#84](https://github.com/abderrahim-lectures/lean4-learning/pull/84) | Simplify a wordy sentence in Chapter 1 Section 1 |
| [#86](https://github.com/abderrahim-lectures/lean4-learning/pull/86) | Disambiguate "it" in Chapter 1 Section 1 |
| [#92](https://github.com/abderrahim-lectures/lean4-learning/pull/92) | Full-book sweep for ambiguous "it" |
| [#106](https://github.com/abderrahim-lectures/lean4-learning/pull/106) | Split 13 dense sentences into plain, simple ones |

Every PR above is linked, via GitHub's "Closes #N"/"Fixes #N" mechanism,
to the specific issue(s) it addresses — see each PR's page for the exact
issue(s) it closed. Gaps in the numbering between PRs (and in the issue
numbers) are ordinary GitHub issue/PR numbering — issues and PRs share
one counter per repository — not missing content.
