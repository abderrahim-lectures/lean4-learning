# Project history

This repository tracks every change — bug fix, new feature, or content
revision — as its own [GitHub issue](https://github.com/abderrahim-lectures/lean4-learning/issues),
closed by the [pull request](https://github.com/abderrahim-lectures/lean4-learning/pulls)
that addresses it. This page summarizes that history; the two GitHub
links above are always the current, authoritative view (issues/PRs
opened after this page was last updated will show there first).

For the reader-facing summary of what changed in each release, see
[`lean_book/changelog/`](lean_book/changelog/README.md).

## Summary

As of this writing: **148 issues** (147 closed, 1 open) and
**98 pull requests** (all merged), covering:

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
- **Mathematical rigor and citation discipline** — a sustained audit
  (prompted by reader questions on Chapter 1's categorical box) fixing
  ambiguous pronouns, dense run-on sentences, wrong cross-references, and
  imprecise categorical claims (e.g. correctly naming `Nat` as the
  initial algebra for the endofunctor `1 + (-)`, not just an "initial
  object" of an ad-hoc category), then extending a strict rule — every
  new notion gets a link or citation at first use, book chapter/section
  numbers where possible, direct hyperlinks for web sources — across
  Chapters 1 through 11.
- **Citation verification against primary sources** — checked every
  external citation across the book against the actual cited text
  (rather than trusting author/book names alone) and fixed six
  mischaracterizations found this way: an overclaimed 1988 paper
  (`CoquandHuet1988`), a wrong chapter/notation for a 1984 book
  (`MartinLof1984`), a wrong chapter for a length-indexed-vector example
  (`Chlipala2013`), a source described as covering material it
  explicitly does not (`Pierce2002`, twice — once for dependently-typed
  eliminators, once for a wrong Ch. 9–11 range), and a paradox
  misattributed to the wrong paper by the same author (`Girard1971` vs.
  the actual 1972 thesis). Also fixed stale, 404ing `TPIL4` bibliography
  links, replaced the book's three remaining nLab wiki-page citations
  with book citations, and ran a full external-link audit (68 URLs).
- **Font portability and a designed cover** — replaced proprietary
  fonts (Consolas, Palatino Linotype) that silently broke the PDF
  build on any machine without them installed with free, metrically
  similar equivalents (DejaVu Sans Mono, TeX Gyre Pagella); designed a
  front/back cover and wired it into the PDF as full-bleed pages,
  fixing two build bugs (a `\newgeometry`-caused blank leading page,
  and image stretching) discovered along the way.
- **v1.6.0: splitting Chapter 1, and a book-wide consistency pass** —
  Chapter 1 had grown to more than twice the length of any other
  chapter, so it was split into two (Chapter 1, "Basics," and a new
  Chapter 2, "Terminology and the calculus of constructions"),
  renumbering every later chapter, cross-reference, and the appendix
  accordingly; cleared a book-wide backlog of roughly 145 prose colons,
  em-dashes, and possessives; fixed several regressions the split
  introduced (a mistitled Chapter 0, an appendix off-by-one across 9
  files, stale `learning-paths.md` citations, a stale checkpoint-project
  reference in the README); balanced Chapter 3 with a new exercises
  section and matching appendix solutions; and added a "Programmer's
  corner (Python)" worked example to every main chapter that lacked one,
  each grounding the value of Lean and functional programming in a
  concrete Python bug rather than an abstract claim.

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
| [#108](https://github.com/abderrahim-lectures/lean4-learning/pull/108) | Add CONTRIBUTING.md and a project-history summary to the root README |
| [#110](https://github.com/abderrahim-lectures/lean4-learning/pull/110) | Gloss alpha/beta at first use in Chapter 1 Section 1 |
| [#112](https://github.com/abderrahim-lectures/lean4-learning/pull/112) | Make explicit that f : alpha -> beta is a morphism, not a functor |
| [#114](https://github.com/abderrahim-lectures/lean4-learning/pull/114) | Rewrite the Chapter 1 Section 1 categorical Mathematical reading box |
| [#117](https://github.com/abderrahim-lectures/lean4-learning/pull/117) | Name Nat as the initial algebra for 1 + (-), precisely |
| [#119](https://github.com/abderrahim-lectures/lean4-learning/pull/119) | Disambiguate overloaded + in the Chapter 1 Section 1 categorical box |
| [#121](https://github.com/abderrahim-lectures/lean4-learning/pull/121) | Link Unit/Sum to Lean documentation at first use |
| [#130](https://github.com/abderrahim-lectures/lean4-learning/pull/130) | Extend the "every notion gets a citation" rule to Chapters 6-11 |
| [#132](https://github.com/abderrahim-lectures/lean4-learning/pull/132) | Add a "view PDF in browser" option to the root README |
| [#134](https://github.com/abderrahim-lectures/lean4-learning/pull/134) | Fix broken "View PDF in browser" link (CORS + forced download) |
| [#139](https://github.com/abderrahim-lectures/lean4-learning/pull/139) | Verify Ch.1 and Ch.11 citations against primary source texts |
| [#140](https://github.com/abderrahim-lectures/lean4-learning/pull/140) | Verify Ch.2 citations; eliminate remaining nLab links |
| [#141](https://github.com/abderrahim-lectures/lean4-learning/pull/141) | Ch.3: enrich Howard1980 citation with grounded detail |
| [#144](https://github.com/abderrahim-lectures/lean4-learning/pull/144) | Verify Ch.5 citations; fix Girard/Pierce mischaracterizations |
| [#145](https://github.com/abderrahim-lectures/lean4-learning/pull/145) | chore: untrack NOTEBOOK-SOURCE-GAPS.md |
| [#147](https://github.com/abderrahim-lectures/lean4-learning/pull/147) | Ch.12: fix Decidable citation mischaracterization |
| [#148](https://github.com/abderrahim-lectures/lean4-learning/pull/148) | Ch.3: verify Gentzen/VanDalen citations with newly added sources |
| [#149](https://github.com/abderrahim-lectures/lean4-learning/pull/149) | Ch.13: verify Church1941 citation |
| [#150](https://github.com/abderrahim-lectures/lean4-learning/pull/150) | Pre-release link audit: flag possibly-dead Thompson1991 URL |
| [#151](https://github.com/abderrahim-lectures/lean4-learning/pull/151) | Bump to v1.4.12 |
| [#152](https://github.com/abderrahim-lectures/lean4-learning/pull/152) | Restore PR #150 content lost in a history rewrite |
| [#153](https://github.com/abderrahim-lectures/lean4-learning/pull/153) | Sync latex/references.bib with bibliography.md |
| [#154](https://github.com/abderrahim-lectures/lean4-learning/pull/154) | Replace proprietary fonts with free, portable equivalents |
| [#155](https://github.com/abderrahim-lectures/lean4-learning/pull/155) | Bump to v1.4.13 |
| [#156](https://github.com/abderrahim-lectures/lean4-learning/pull/156) | Add a book cover image to the README |
| [#157](https://github.com/abderrahim-lectures/lean4-learning/pull/157) | Revert the book cover addition |
| [#158](https://github.com/abderrahim-lectures/lean4-learning/pull/158) | Add front and back cover images |
| [#159](https://github.com/abderrahim-lectures/lean4-learning/pull/159) | Wire covers into PDF as full-bleed page backgrounds |
| [#161](https://github.com/abderrahim-lectures/lean4-learning/pull/161) | Bump to v1.4.14 |
| [#162](https://github.com/abderrahim-lectures/lean4-learning/pull/162) | Split CHANGELOG into per-version files; badge/link updates |
| [#163](https://github.com/abderrahim-lectures/lean4-learning/pull/163) | Link the new GitHub Pages site and Try Lean page |
| [#165](https://github.com/abderrahim-lectures/lean4-learning/pull/165) | Dummit & Foote citation precision + direct-sums mischaracterization fix |
| [#166](https://github.com/abderrahim-lectures/lean4-learning/pull/166) | Release v1.4.15 |
| [#167](https://github.com/abderrahim-lectures/lean4-learning/pull/167) | Clarify the Nat-as-initial-algebra optional math box |
| [#168](https://github.com/abderrahim-lectures/lean4-learning/pull/168) | Release v1.4.16 |
| [#169](https://github.com/abderrahim-lectures/lean4-learning/pull/169) | Cite the terminology glossary; fix F-algebra citation; fix leaked blockquote markers |
| [#170](https://github.com/abderrahim-lectures/lean4-learning/pull/170) | Release v1.4.17 |
| [#171](https://github.com/abderrahim-lectures/lean4-learning/pull/171) | Add Recall subsections across the whole book |
| [#172](https://github.com/abderrahim-lectures/lean4-learning/pull/172) | Release v1.4.18 |
| [#175](https://github.com/abderrahim-lectures/lean4-learning/pull/175) | Fix confusing Nat-overload in two Chapter 1 Section 3 Vec examples |
| [#177](https://github.com/abderrahim-lectures/lean4-learning/pull/177) | Fix a stale "Download PDF" badge in the root README |
| [#179](https://github.com/abderrahim-lectures/lean4-learning/pull/179) | Release v1.4.19 |
| [#184](https://github.com/abderrahim-lectures/lean4-learning/pull/184) | Fix a Pi-type family/type conflation, a forward reference, and a LaTeX build crash |
| [#189](https://github.com/abderrahim-lectures/lean4-learning/pull/189) | Fix a leaked blockquote marker, and add two worked examples |
| [#190](https://github.com/abderrahim-lectures/lean4-learning/pull/190) | Release v1.4.20 |
| [#193](https://github.com/abderrahim-lectures/lean4-learning/pull/193) | Add a Pi vs Sigma comparison table |
| [#194](https://github.com/abderrahim-lectures/lean4-learning/pull/194) | Release v1.4.21 |
| [#197](https://github.com/abderrahim-lectures/lean4-learning/pull/197) | Name the arrow symbol, matching how x is glossed right next to it |
| [#203](https://github.com/abderrahim-lectures/lean4-learning/pull/203) | Fix a false claim that "e" reappears later in the categorical box |
| [#205](https://github.com/abderrahim-lectures/lean4-learning/pull/205) | Use full section numbers instead of § shorthand book-wide; retitle root README |
| [#213](https://github.com/abderrahim-lectures/lean4-learning/pull/213) | PR A: quick surgical fixes (grammar, Sort 0, citations, examples) |
| [#221](https://github.com/abderrahim-lectures/lean4-learning/pull/221) | PR B (part 1): plain academic English, cut confusing parentheticals |
| [#223](https://github.com/abderrahim-lectures/lean4-learning/pull/223) | PR C1 (part 1): F-algebra diagram for Chapter 1 |
| [#225](https://github.com/abderrahim-lectures/lean4-learning/pull/225) | Give same-chapter cross-references full Chapter+Section citations |
| [#227](https://github.com/abderrahim-lectures/lean4-learning/pull/227) | Add categorical-product diagram to Chapter 2's universal-property box |
| [#230](https://github.com/abderrahim-lectures/lean4-learning/pull/230) | Add multi-parent forgetful and biproduct diagrams (Ch. 2, Ch. 10) |
| [#233](https://github.com/abderrahim-lectures/lean4-learning/pull/233) | PR E1: add dbg_trace tracing to Chapter 1's recursive code |
| [#237](https://github.com/abderrahim-lectures/lean4-learning/pull/237) | PR E10/E11/E14: dbg_trace for all remaining recursive Lean blocks |
| [#238](https://github.com/abderrahim-lectures/lean4-learning/pull/238) | Full-book AMS-style rigor and narrative pass (v1.4.24) |
| [#240](https://github.com/abderrahim-lectures/lean4-learning/pull/240) | Rewrite book prose to avoid colons, em-dashes, and possessives |
| [#241](https://github.com/abderrahim-lectures/lean4-learning/pull/241) | Add binder styles, def transparency, and arrow-notation coverage |
| [#247](https://github.com/abderrahim-lectures/lean4-learning/pull/247) | v1.6.0: split Chapter 1, book-wide style pass, Python-comparison examples |
| [#248](https://github.com/abderrahim-lectures/lean4-learning/pull/248) | v1.6.2: bibliography citations for Chapter 4, Ring, Module, and LinearMap |

Every PR above is linked, via GitHub's "Closes #N"/"Fixes #N" mechanism,
to the specific issue(s) it addresses — see each PR's page for the exact
issue(s) it closed. Gaps in the numbering between PRs (and in the issue
numbers) are ordinary GitHub issue/PR numbering — issues and PRs share
one counter per repository — not missing content.
