<<<CRITIQUE_START>>>

# Cross-Critique: "north-mini-code-free" adversarial review of five peer reports

**Method.** I verified every file:line cited by all five reports against the actual text under `/home/adrabi/dev/lean/lean4-learning/`, the companion project under `lean_project/LeanProject/`, and the root notice files. Verdicts are per-finding. Baseline fact established first: the pinned toolchain is `leanprover/lean4:v4.32.2` (`lean_project/lean-toolchain:1`, `lakefile.toml:7`), while **every** documentation site — `README.md:108`, `NOTICE.md:10`, `NOTICE.md:43`, `lean_book/README.md:40`, `00-setup/02-installing-toolchain.md:29`, `00-setup/04-mathlib-note.md:45`, `learning-paths.md:60` — reads `v4.33.0`. This single fact decides the biggest dispute between reports (see Report 4).

---

## Report 1 — nemotron-3-ultra-free-math-theorems

**LOW-1 "proof irrelevance conflates closed propositions with data-carrying existentials" — INVALID.**
The quoted sentence "In Lean, a proof of `P ∧ Q` carries no more data than the fact that both `P` and `Q` hold" appears nowhere in `03-propositions-and-proofs/01-prop.md` (grep: zero hits repo-wide). The actual text at `01-prop.md:84-95` is a correct statement about `Prop` ("every proposition's proof-set is either empty (false) or, up to proof irrelevance, has exactly one element"). Worse, the claimed harm is inverted: the report says "a reader who *later* encounters `Σ` (Chapter 1, Section 5)" — but `Σ`-types are introduced in `01-basics/05-pi-sigma-and-coc.md`, **before** Chapter 3. A Chapter 3 reader has already met `Σ`. Fabricated quote + wrong temporal claim.

**LOW-2 "Perm3 proof fields 'don't matter' but `Perm3 : Type`" — INVALID.**
The cited text at `06-groups/04-permutations-example.md:172-178` is **correct**: "the proof fields do not matter, by proof irrelevance." The proof fields (`left_inv`, `right_inv`) are `Prop`-valued, and proof irrelevance makes them equality-neutral even inside a `Type`-valued record — the text's claim holds exactly. The finding attacks a correct statement and confuses "record lives in `Type`" with "its `Prop` fields are not proof-irrelevant."

**LOW-3 "`∧I`/`∧E` used without defining" — INVALID.** `02-logic-recap.md:105-110` actually lands on ¬-intro/⊥-elim, and the `∧` rules at lines 82-88 use the spelled-out labels "($\wedge$-intro)"/"($\wedge$-elim)" glossed in prose ("Each connective gets an introduction rule (how to *prove*…)", line 75-78, tied back to Section 1). The notation is defined.

**LOW-4 "universe hierarchy cumulative, unexplained" — INVALID.** The word "cumulative" does not occur anywhere in `05-rigor-check/02-universes.md` (grep: zero hits). Fabricated quote.

**LOW-5 "`intGroup.inv_left` uses `linarith`" — INVALID.** `linarith` appears nowhere in `lean_book/` (grep across the whole book: zero hits). The report's premise "the book claims 'no `linarith` until Chapter 12'" is doubly fabricated — no such claim exists and no `linarith` exists.

**LOW-6 "`rw [← mul_one a]` forward reference" — INVALID.** `07-group-theorems/02-theorem-1.md:32-38` proves with `rw [← step2]`, where `step2 := Grp.id_right e'` (a `Group` field, available for free). `mul_one` appears only as a Loogle link in the "Mathematical reading" box at line 63, never as a rewrite lemma in a proof. No forward reference exists.

**LOW-7 "`MyMonoid` checkpoint lacks self-verification" — INVALID.** `05-rigor-check/06-checkpoint-project.md:43` has an explicit `**Self-verification.**` section with runnable code and a success criterion (lines 43-75). The file also calls the structure `Monoid`, not `MyMonoid`. Directly contradicted by the text.

**Bottom line.** All seven findings are fabricated, mis-cited, or attack correct text. Zero valid findings. The report also misses the CRITICAL `v4.33.0`/`v4.32.2` doc mismatch entirely (it asserts the toolchain story is clean at "v4.32.2"). This is a complete evidence-bar failure — it belongs in the Moderator's DISCARDED pile.

---

## Report 2 — laguna-s-2.1-free-math-algebra

**CRITICAL "Path.length/append_length missing from Lean project" — INVALID as stated.** The *fact* is true: `Ch11PathAlgebras.lean` contains `Path.append` (line 32) but no `Path.length`/`append_length`. But the framing — "the chapter's main pedagogical payoff is unverifiable," "reader cannot self-verify" — misreads the checkpoint-project design. `11-path-algebras/07-checkpoint-project.md:47` has a `Self-verification.` section, and the full solution **with** `Path.length` and `Path.append_length` is in the appendix `14-appendix-solutions/10-chapter-11.md`. The reader's job is to *build* these. The real, defensible issue is that the appendix solution code is not compiled in `lean_project/`, contradicting `README.md:98-99` ("every Lean snippet… (main text and solutions) is verified"). That is a README-scope issue corroborated by ling (Report 4) and deepseek (Report 3), not a checkpoint defect. Reframe or drop; as written, CRITICAL/"must fix before release" is wrong.

**HIGH "`Submodule` omits `neg_mem`" — UNVERIFIED with a wrong justification.** The structural observation is real: `10-modules/04-submodules.md:15-24` defines `Submodule` with `carrier`, `zero_mem`, `add_mem`, `smul_mem` — no `neg_mem` — while the prose promises closure "under the abelian-group operations" (lines 36-40). But the justification is mathematically broken: "ℕ as ℤ-module" is not a module at all (no closure under negative scalars), so it cannot demonstrate that `add_mem`+`smul_mem` fail to imply `neg_mem`. And for a module over a ring, negation follows from `smul (-1)` once `(-1)•m = -m` is known, so the definition is *equivalent* to the standard one, not "mathematically incomplete." The prose-vs-structure mismatch is a genuine MEDIUM; the stated reasoning and HIGH severity are not.

**HIGH "Z-module axioms not formalized" — INVALID as stated.** Both concrete claims are false. (a) `lean_project/LeanProject/Ch10Modules.lean:40` *does* contain `intZModule : Module Int intRing Int` with full proof fields. (b) The book never "asserts them with `rfl` or `sorry`-equivalent" — `10-modules/03-z-module-example.md:55-62` explicitly leaves the four-axiom verification "as an extended exercise," a deliberate design choice with stated pedagogy. (Ironically the *real* gap — `evenSubmodule` referencing `intZModule` that the book's main text never defines — is documented in the project's own comments at `Ch10Modules.lean:4-7` and `36-38`; the report gropes toward it but cites the wrong thing.) The finding as written should be discarded; the actual gap deserves a correctly-cited MEDIUM.

**MEDIUM "zero ring silently permitted" — INVALID.** No concrete book theorem is named that fails in the zero ring, and the book's own theorems (`a*0=0`, `0*a=0`, sign rules) hold in the zero ring. The blanket claim "any theorem stated as 'for all rings' is technically false for the zero ring" is itself false for the theorems in this slice. Generic concern, zero evidence — the exact failure the evidence bar bans.

**MEDIUM "forward reference to `mul_zero_left`" — INVALID.** The quoted sentence "Compare with `0 * a = 0`, which is not a base clause and does require induction on `a`" appears **nowhere** in `09-ring-theorems` (grep: zero hits for "base clause"). It is, in fact, the solutions-appendix prose about `Nat.mul` (`14-appendix-solutions/03-chapter-4.md:27-30`) — misattributed to the ring chapter. The real text at `02-theorem-1.md:55-60` discusses `congrArg` vs `rw [h1]`. And `mul_zero_left` is proved in the *next* section, `03-theorem-2.md:32`. Fabricated quote, wrong file, no forward reference.

**MEDIUM "`Mat2.mul_assoc` by `rfl`" — INVALID.** `Ch08Rings.lean`'s `mat2Ring.mul_assoc` is a hand-written multi-step `rw` proof (lines 190-206, using `Int.add_mul`/`Int.mul_assoc`/`add4_reorder`), explicitly matching the book's no-automation philosophy (comment at lines 164-170). The `mul_assoc := by decide` at line 79 belongs to `fin3Ring`, not `Mat2`. The claim is contradicted by the very file it cites.

**MEDIUM "`decide` mechanism never explained" — INVALID.** Chapter 12 has a dedicated section, `12-working-efficiently/02-decision-procedures.md`, which explains `decide` ("evaluates a `Decidable` proposition to `true`/`false`", lines 18-20), its constructive meaning (lines 49-52), and points to docs. `08-rings/05-finite-ring-example.md` also glosses `by decide` in a Programmer's-corner box. "Never explains" is false.

**Minors — all INVALID.** `CommGroup` repetition: preference. "Chapter 7 not in this slice": a backward reference, the reviewer confusing its own slice with the book's order. "Project assumes `Path.length` exists": Milestone 1 is literally "Define `Path.length`" (`07-checkpoint-project.md:29-30`); misread. Fin-3 `decide`: duplicates the invalid decide finding.

**Bottom line.** One partially-valid observation (`neg_mem` prose/code mismatch, wrong justification), one true fact mischaracterized (`Path.length` not compiled), five fabricated/mis-cited findings. The "Major revisions" recommendation rests almost entirely on invalid evidence.

---

## Report 3 — deepseek-v4-flash-free-solutions

**CRITICAL-1 "Ch 1 Ex 4 solution is Chapter 11 content, misplaced" — INVALID.** The report's premise is demolished by the actual exercise set: `01-basics/06-exercises.md:52-58` — Chapter 1's own exercise 4 — explicitly asks: "Write down the Π-type expression $\prod_{x:A}B(x)$ instantiated so that it matches `Path.append`'s signature `{u v w : V} → Path Q u v → Path Q v w → Path Q u w`," opening with "Chapter 11's `Path Q : V → V → Type` was described as…". The solution at `01-chapter-1.md:88-107` answers exactly this, forward-reference framing and all. The reviewer never read the exercise file and even misquotes line 102 ("references 'Chapter 11' explicitly" — line 102 says only "since it appears as an index into `Path` later"). This is the report's headline CRITICAL and it is simply wrong.

**CRITICAL-2 "solutions overuse unexplained `rfl`" — INVALID.** The rule (Appendix `00-index.md:7-8`) bans *unexplained* `rfl`. Every cited `rfl` is explained in surrounding prose: `03-chapter-4.md:27-30` explains exactly why `n * 0 = 0` is the base clause of `Nat.mul`; `05-chapter-6.md:45-51` explains "once every variable is replaced by a concrete constructor… the resulting equation holds by definition and `rfl` closes it." The reviewer quotes these explanations and then faults them for not being present — self-defeating.

**CRITICAL-3 "`Bool.xor` uses `cases` instead of algebraic reasoning" — INVALID as a fault.** The report concedes the proof is correct. It is a preference, and it self-contradicts CRITICAL-2 (which demands showing computation) and MEDIUM-7 (which faults `decide` being used without explanation) — the proposed fixes pull in opposite directions. A finite-type exhaustive `cases`+`rfl`, explained in prose, is the canonical approach at this point in the book.

**HIGH-4 "appendix numbering mismatch" — VALID as an observation, severity inflated.** Confirmed: files are `01-chapter-1.md`, `02-chapter-3.md`, … `10-chapter-11.md`; the index lists "2. Chapter 3". A cosmetic prefix oddity (the `02-` filename invites a "where's Chapter 2?" glance). HIGH is wrong; this is LOW.

**HIGH-5 "no solutions for Chapter 12" — INVALID.** Chapter 12 has **no exercises** — its structure is `00-index`, `01-search-tactics`, `02-decision-procedures`, `03-simp`, `04-term-vs-tactic-mode`, `05-structuring-lemmas`, with no exercises file. An appendix of exercise solutions has nothing to cover. The "unverified `exact?` example" point belongs to the README-verification-scope finding (ling), not to "missing Ch12 solutions."

**HIGH-6 "solutions lack `lean_project` modules" — PARTIAL.** The blanket claim "the build pipeline only ports main-text code blocks, not appendix solutions" is contradicted by `Ch06Groups.lean:144`, which carries `boolXorGroup` labeled "-- Chapter 6 exercise 1: Bool under xor" — a solution snippet in a chapter module. The narrower truth: the Chapter 1 appendix code (`Vec.toList`, `anotherSigma`) is not in `Ch01Basics.lean`. The README's "main text and solutions" verification claim is indeed unsupported — corroborated by ling-4 and laguna-CRITICAL — but the report overstates it.

**MEDIUM-7 "`anotherSigma` uses `decide`; Ch 1 hasn't introduced it" — INVALID.** The main text uses `by decide` in Chapter 1: `01-basics/05-pi-sigma-and-coc.md:186` (`def mySigma : Σ n : Nat, Fin n := ⟨3, ⟨2, by decide⟩⟩`), and the Ch 1 exercise itself tells the reader to build a term "other than the text's `⟨3, ⟨2, by decide⟩⟩` example." The claim "decide is introduced in Chapter 4" is false.

**MEDIUM-8 "Ch 4 Ex 2 explanation confuses `rfl` with `Nat.mul_zero`" — INVALID.** The reviewer's own proposed fix — "add 'in Lean 4's definition of `Nat.mul` (recursion on second argument)'" — is already in the text at `03-chapter-4.md:27-28`: "`Nat.mul` is defined by recursion on its second argument." The finding asks to add what is already there.

**MEDIUM-9 "Ch 6 Ex 2 discussion not demonstrated in code" — NOISE.** The reviewer admits it is correct; the meta-level discussion is explicitly meta-level. Preference.

**MEDIUM-10 "Ch 3 solutions are trivial" — NOISE.** The reviewer admits the exercises are simple. A one-line solution to a one-line exercise is not a fault.

**LOW-11 "navigation strips inconsistent" — VALID.** Verified: `01-chapter-1.md:3` and `02-chapter-3.md:3` have 2 links; `03-chapter-4.md:3` has 3. Trivial, but accurate.

**LOW-12 "`dbg_trace` in Ch 1 solution unexplained" — INVALID.** `dbg_trace` is used in the Chapter 1 main text itself (`01-basics/03-dependent-types.md`, `05-pi-sigma-and-coc.md`) as a deliberate book-wide device (per `README.md:77-83`). The claim it is "introduced later" is false.

**LOW-13 "`Sort` terminology from Chapter 5" — INVALID.** `Sort 0`/`Sort 1` are defined in the Chapter 1 main text (`05-pi-sigma-and-coc.md:494`, and used in `06-exercises.md:27`). False.

**Typo "Z/2 should be Z/2Z"** — pedantry; `Z/2` is standard shorthand. Noise.

**Bottom line.** Both headline CRITICALs are wrong (one falsified by the Ch 1 exercise file, one falsified by the very prose it quotes). One trivial VALID (nav strips), one PARTIAL (solution modules), and its Chapter 2 "confirmation" cites a non-existent statement in `02-functions-and-structures/00-index.md:51-55` (the fact — no Ch 2 exercises — is true; the citation is invented).

---

## Report 4 — ling-3.0-flash-free-root-notice

**(LOW) "Toolchain version hygiene is actually fine" — INVALID, and the worst fact-check failure in the whole batch.** The report asserts `README.md:108`, `NOTICE.md:10`, `NOTICE.md:43`, `00-setup/02-installing-toolchain.md:29`, `learning-paths.md:60`, `04-mathlib-note.md:45` all read `v4.32.2`, and its verification log ("all consistent") is presented as a grep result. Every one of those lines actually reads **`v4.33.0`** (verified directly: `README.md:108` "toolchain `v4.33.0`", `NOTICE.md:10` "`leanprover/lean4:v4.33.0`", `NOTICE.md:43` "pinned to the `v4.33.0` tag", `02-installing-toolchain.md:29` "`leanprover/lean4:v4.33.0`", `learning-paths.md:60` "matches `v4.33.0`", `04-mathlib-note.md:45` "`leanprover/lean4:v4.33.0`"). The toolchain file is `v4.32.2`. The report's single "confirming clean result" is a fabricated grep log, and it directly contradicts mimo's CRITICAL (which is correct). A Fact-Checker persona report that fails its own fact check is disqualifying for this slice.

**(CRITICAL) Audience contradiction — VALID.** `README.md:34-37` "no prior exposure to Lean, formal logic, or programming" vs `REPRODUCING.md:31-34` (step 2) "already have programming experience — cut beginner-programmer explanations" vs `REPRODUCING.md:126-129` (step 10) "zero prior exposure to programming." A genuine, verifiable self-contradiction in the production doc, and the two READMEs' promise is at odds with step 2. I would argue severity HIGH (REPRODUCING is a meta-doc, not reader-facing), but the finding is real and well-cited.

**(HIGH) "Every code block… one module per chapter" false for Ch 12 — VALID (with an embedded citation error).** `README.md:107-110` makes the claim; `lean_project/LeanProject/` has `Ch01`–`Ch11` + `Ch13CapstoneMathlib.lean` and **no** `Ch12*` module (confirmed by directory listing); and `12-working-efficiently/01-search-tactics.md:30-36` contains real Lean (`exact?`) with the comment "verified on this book's toolchain to be…" at lines 33-35. Core claim stands. But the report's own quote of the README is wrong — it parenthetically writes "(toolchain `v4.32.2`)" where the README says `v4.33.0`; the same version error that infects its LOW finding.

**(HIGH) Verification-scope inconsistency between the two READMEs — VALID.** `README.md:98-99` "every Lean snippet in the book (main text and solutions) is verified" vs `lean_book/README.md:40-41` "Every code block in Chapters 1–11 has been ported… and verified with `lake build`." Both quotes verified verbatim. Real, checkable scope conflict, and it subsumes deepseek's and laguna's weaker "not compiled" complaints.

**(MEDIUM) Reproduction uses "latest stable toolchain" — VALID.** `REPRODUCING.md:15-17` "the latest stable toolchain… pinned to the latest release" vs the actual pin `leanprover/lean4:v4.32.2` (`lean_project/lean-toolchain:1`, `NOTICE.md:10`), against `REPRODUCING.md:6-7`'s "should reproduce a book with the same… constraints." Accurate.

**(MEDIUM) Reproduction doc's own structure denies its linear narrative — VALID (weak).** `REPRODUCING.md:6-7` "following it in order" vs `:22-23` "sequence these as separate follow-up instructions, not one prompt" and steps 10-13 prelabeled "a later session"/"a further session." Textually supported; severity is borderline LOW.

**(LOW) README audience line redundant** — real drift, but a restatement of the CRITICAL finding; deduplicate.

**(MEDIUM) Two READMEs tell different stories** — quotes accurate, but "inconsistent branding" is editorial preference. LOW.

**(LOW) Landing-page leads with legal links** — accurate (`README.md:10`). Trivial.

**Minors.** "all 14 chapters" vs appendix numbered "14. Solutions" — accurate nitpick; CONTRIBUTING version-naming — accurate; REPRODUCING step-8 completion — trivial.

**Bottom line.** The strongest report on the root files: four valid, verifiable findings (audience contradiction, Ch 12 module, verification-scope, toolchain pin in REPRODUCING). But the "toolchain clean" finding is not merely wrong — it is a fabricated verification log that flips the single most important issue in the batch, and the version misquote reappears inside its otherwise-valid Ch 12 finding. It gets the substance right where it reads carefully and catastrophically wrong where it greps.

---

## Report 5 — mimo-v2.5-free-prose-setup

**(CRITICAL) Version mismatch v4.33.0 vs v4.32.2 — VALID, and the batch's single most important finding.** Verified: `00-setup/02-installing-toolchain.md:29`, `00-setup/04-mathlib-note.md:45`, `learning-paths.md:60` all read `v4.33.0`; the toolchain file and `lakefile.toml:7` pin `v4.32.2`. One citation is misdirected: the quoted sentence "Code blocks are valid Lean 4 (toolchain `v4.33.0`, matching `../lean_project`)" is `lean_book/README.md:40`, not root `README.md:40` (root line 40 says "building every definition from scratch…"). The root README's own `v4.33.0` lives at `:108`. Citation sloppiness; substance fully correct and the only finding that survives contact with the text in the cross-review. It directly and correctly contradicts ling's clean bill of health.

**(CRITICAL) Audience promise broken by jargon — PARTIAL.** The promise is real (`lean_book/README.md:7` "We assume no programming background"; root `README.md:37`), and `uv` at `02-installing-toolchain.md:10` is genuinely unexplained. But two of the sub-claims misfire: the "no programming background" quote is at `lean_book/README.md:7`, not "README.md:7"; the "Mermaid/MathJax/Pandoc" references are in `lean_book/README.md:29-36` (book-rendering instructions for maintainers), not root `README.md:27-38` (badges); and `03-editor.md:7-14` actually parenthetically glosses each term ("the editor command that navigates to where a name was originally introduced"). The `uv` example carries a real MEDIUM; CRITICAL and the broader "every term is jargon" claim are overstated.

**(HIGH) Ch 0/Ch 13 narrative fails to replace Bloom objectives — PARTIAL.** The Bloom-level mapping (remember/understand vs apply/analyze) is unverifiable interpretation — no reviewer can mechanically map "story of this chapter" prose onto Bloom levels, and the changelog (`v1.4.25.md:25-33`) shows the replacement was a deliberate design decision, so the bulk of this re-litigates a scoping choice. But the one checkable sub-claim is true: the Ch 13 story's three questions (`13-next-steps/00-index.md:9-18`) cover sections 1-3 only, and the "Solutions" section 4 is unaccounted for. That is a genuine small inconsistency worth a MEDIUM.

**(HIGH) "Mathlib-free by design" false — INVALID as a fault.** The book discloses its Mathlib usage repeatedly and explicitly: root `README.md:41-43` and `73-76` ("Starting in Chapter 6, each worked example is followed by a 'Mathlib equivalent'"), `04-mathlib-note.md:17-19` ("`lean_project` already has Mathlib installed as a dependency…"), and its own Socratic Q3 (`04-mathlib-note.md:52-55`) answers the exact objection the finding raises. "Builds the main track from scratch" and "installs Mathlib for labeled boxes" are not in contradiction per the book's own stated scope; the finding re-litigates a disclosed, deliberate decision.

**(HIGH) Church-encodings "Aside" incoherent — PARTIAL.** Structural facts are accurate: `13-next-steps/03-next-projects.md:181-260` is an 80-line aside with no milestones/deliverable/self-verification. But it is explicitly and prominently titled "### Aside: Church encodings…" and framed "worth knowing, purely as a curiosity" (`:181-185`) — the claim "reader expects a 6th project, gets a random theory dump" is contradicted by the header. MEDIUM at most; the "structural incoherence" framing overreaches.

**(MEDIUM) Socratic Q&A redundancy — INVALID as a fault.** Socratic questions are a declared, book-wide device (root `README.md:89-91`), and Q2's answer on `elan` pinning is genuinely new content, not repetition. Preference.

**(MEDIUM) Nav strips inconsistent — VALID.** `04-mathlib-note.md` top (`:3`, 2 links) vs bottom (`:60-63`, 4 links). Confirmed; LOW severity, and corroborated by deepseek's LOW-11.

**(MEDIUM) Learning-paths graph misrepresents paths — INVALID as a fault.** The text at `learning-paths.md:37-41` explicitly explains the design the finding complains about: dashed edges are "the two named paths below that actually skip material outright…; the other two named paths change *how* a chapter is read… so they have no edge of their own." The book's prose answers the reviewer's objection verbatim; the graph scope is deliberate.

**Minors.** "path algebras… simple enough" — noise (subjective; and the book did build them). "search 'leanprover elan install', no direct URL" — accurate, trivial. `v4.33.0` in Socratic Q3 — duplicates the CRITICAL. `simp` only in Ch 6/11 — inaccurate, the text itself names Chapter 12's discussion (`01-what-we-built.md:20-22`). Loogle links untested — honestly flagged. "Chapter 5 appendix's `MyGroup` (exercise 2)" — **INVALID**: the appendix solution `14-appendix-solutions/04-chapter-5.md:38-77` contains exactly `MyGroup` as "2. `MyGroup` as a type class"; the reference resolves. Thompson1991/TPIL4 broken links — accurate, but the book *already documents* both failures in `bibliography.md:69-72`, so the finding is stale. Editorial-pass history placement, dictionary duplication, notation disclaimer — preferences.

**Bottom line.** One genuine CRITICAL (version mismatch), one partial (audience), two partial (narrative, Church aside), one trivial VALID (nav strips), and a tail of preferences. Its version finding is the keystone of the whole cross-review.

---

## Cross-review corroboration matrix

| # | Finding | nemotron | laguna | deepseek | ling | mimo | Actual text | Verdict |
|---|---------|----------|--------|----------|------|------|-------------|---------|
| A | Docs say `v4.33.0`, toolchain file is `v4.32.2` | — | — | — | **DENIED** ("clean") | **FLAGGED** | Confirmed (7 doc sites vs `lean-toolchain`, `lakefile.toml:7`) | **CONFIRMED** — mimo right, ling's "clean" finding is fabricated |
| B | No `Ch12*` module; README overclaims "every code block… one module per chapter" | — | (near-miss: Path.length) | (variant: no solution modules) | **FLAGGED** | — | Confirmed (`LeanProject/` listing; `12-working-efficiently/01-search-tactics.md:30-36`; `README.md:107-110`) | **CONFIRMED** |
| C | Verification-scope inconsistency: "main text and solutions" vs "Chapters 1–11" | — | (Path.length not compiled) | (solution modules absent) | **FLAGGED** | — | Confirmed (`README.md:98-99` vs `lean_book/README.md:40-41`) | **CONFIRMED** |
| D | Audience contradiction on programming background | — | — | — | **FLAGGED** | **FLAGGED** | Confirmed (`README.md:37`, `lean_book/README.md:7`, `REPRODUCING.md:31-34`, `126-129`) | **CONFIRMED** |
| E | Nav-strip inconsistency (solution/appendix files) | — | — | **FLAGGED** | — | **FLAGGED** | Confirmed (2 vs 3 vs 4 links) | **CONFIRMED** (trivial) |
| F | Submodule omits `neg_mem` | — | **FLAGGED** | — | — | — | Partial: structure lacks it; prose claims abelian-group closure | **SINGLE**, justification flawed, MEDIUM |
| G | Appendix Ch 1 solution code not compiled | — | — | **FLAGGED** | — | — | Partial: `boolXorGroup` *is* in `Ch06Groups.lean:144`; Ch 1 defs are not | **SINGLE**, over-broad |
| H | Ch 13 story omits "Solutions" section | — | — | — | — | **FLAGGED** | Confirmed (`13-next-steps/00-index.md:9-18`) | **SINGLE**, MEDIUM |
| I | Z-module axioms "asserted," missing from project | — | **FLAGGED** | — | — | — | Contradicted: `Ch10Modules.lean:40` has `intZModule`; book leaves exercise | **DISMISSED** (real gap exists but wrongly cited) |
| J | `Mat2.mul_assoc` by `rfl` | — | **FLAGGED** | — | — | — | Contradicted: hand-written `rw` proof (`Ch08Rings.lean:190-206`) | **DISMISSED** |
| K | `mul_zero_left` forward reference | — | **FLAGGED** | — | — | — | Contradicted: quote is from appendix `03-chapter-4.md:27-30`; no such text in ring chapter | **DISMISSED** |
| L | `linarith` in Ch 6 | **FLAGGED** | — | — | — | — | Contradicted: zero `linarith` in `lean_book/` | **DISMISSED** |
| M | Universe "cumulative" unexplained | **FLAGGED** | — | — | — | — | Contradicted: word never appears in `02-universes.md` | **DISMISSED** |
| N | Ch 1 Ex 4 `Path.append` "misplaced" | — | — | **FLAGGED** | — | — | Contradicted: `01-basics/06-exercises.md:52-58` asks for it | **DISMISSED** |
| O | Checkpoint "lacks self-verification" (nemotron) / "assumes `Path.length`" (laguna) | **FLAGGED** | **FLAGGED** | — | — | — | Contradicted: `05-rigor-check/06-checkpoint-project.md:43`; `11-path-algebras/07-checkpoint-project.md:29-30,47` | **DISMISSED** |
| P | `decide` / `rfl` / `dbg_trace` / `Sort` "unexplained at first use" | — | **FLAGGED** | **FLAGGED** | — | — | Contradicted: Ch 12 section + Ch 1 main-text usage | **DISMISSED** |
| Q | "MyGroup" appendix forward-ref | — | — | — | — | **FLAGGED** | Contradicted: `04-chapter-5.md:38-77` | **DISMISSED** |

**Cross-review scorecard.** Valid findings by report: ling 4 (but 1 disqualifying fabrication), mimo 1 confirmed-critical + 4 partial, deepseek 1 trivial + 1 partial, laguna 1 partial, nemotron 0. Five of the seven findings that two or more reviewers flagged independently (A, B, C, D, E) are confirmed against the text; every *exclusive* finding in the two math-slice reports (nemotron, laguna) failed verification. The most damning pattern: the free-tier models did not just guess — they manufactured verbatim quotes (`01-prop.md`, `02-universes.md`, `09-ring-theorems/02-theorem-1.md`), invented grep logs (ling), and cited files they demonstrably never opened (deepseek on the Ch 1 exercise set, laguna on `Ch08Rings.lean`). The Moderator should promote A–D one level, keep E and H, and **dismiss every other finding above**, with special note that ling's "toolchain clean" result must be inverted.

<<<CRITIQUE_END>>>
