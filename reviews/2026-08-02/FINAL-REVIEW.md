<<<FINAL_START>>>

# Final Adjudication Report — *Lean for Working Algebraists*

**Role:** Moderator (adversarial-book-reviewer skill)
**Input:** 6 Phase-1 reviews + 6 Phase-2 cross-critiques under `reviews/2026-08-02/`
**Ground truth:** independently re-verified against the live repo on the pinned toolchain (Lean 4.32.2, Mathlib rev `v4.32.2`).
**Adjudication rules:** CONFIRMED = 2+ reviewers OR verified against files; SINGLE = one reviewer, survives critiques; DISMISSED = refuted by text or a run. Severity ordered CRITICAL > HIGH > MEDIUM > LOW. Every surviving finding carries WHAT + WHY + FIX.

---

## Bottom line first

**Recommendation: Major revisions.** Three CRITICAL, one HIGH, and four LOW/MEDIUM findings survive. All are reader-facing promises that outrun evidence, none are typos, and none are mathematical errors — the mathematics and the Lean code that *is* compiled are sound. ~45 of the ~55 raw findings were dismissed, most because they were fabricated, mis-cited, or re-litigated deliberate design choices. The single most damaging fact in the whole corpus: **one reviewer (ling) actively certified the toolchain docs as clean while every file it claimed to have read says `v4.33.0` against a `v4.32.2` pin.**

---

## The keystone fact (verified)

`lean_project/lean-toolchain:1` = `leanprover/lean4:v4.32.2`; `lakefile.toml:7` pins Mathlib `rev = v4.32.2`. But the docs claim `v4.33.0` in **seven** reader-facing places:
- `README.md:108`
- `NOTICE.md:10`
- `NOTICE.md:43`
- `lean_book/README.md:40`
- `lean_book/00-setup/02-installing-toolchain.md:29`
- `lean_book/00-setup/04-mathlib-note.md:45`
- `lean_book/learning-paths.md:60`

---

## CRITICAL

### C1. Version mismatch — docs claim `v4.33.0`, the pinned toolchain is `v4.32.2`
**WHAT:** The seven locations above all instruct the reader to use `v4.33.0`; the shipped project pins `v4.32.2`. (Mathlib `v4.33.0` was not released when the book was built; the v1.4.25 changelog records a bump *to* `v4.32.2`.)
**WHY:** A reader following Setup will pin an unpublished version, fail to compile, and lose trust in the book's core claim that "every code block verified with `lake build`" (README.md:98-100). The reproduction trail does not reproduce the shipped book.
**FIX:** Change all seven occurrences to `v4.32.2` (and `NOTICE.md:43`'s "pinned to the `v4.33.0` tag" → `v4.32.2`), or add an explicit disclaimer that docs target `v4.33.0` while the companion project uses `v4.32.2`.
**Status: CONFIRMED** — verified against the files directly; caught by mimo (CRITICAL); **actively denied by ling**, whose "toolchain version hygiene is fine" finding asserted `v4.32.2` at every one of these lines. ling's verification log is fabricated line-by-line.

### C2. The "verified / one module per chapter" guarantee is false as scoped
**WHAT:** `README.md:107-110` — "a companion Lean 4 project … containing **every code block from the book, ported into one module per chapter** and verified to compile with `lake build`" — and `README.md:98-100` — "every Lean snippet in the book (**main text and solutions**) is verified." The `lean_project/LeanProject/` directory contains `Ch01*`–`Ch11*` + `Ch13CapstoneMathlib.lean` and **no** `Ch12*` module, **no** appendix/solutions module, and **no** module for Chapter 1's dependent-types material (`Fin`, `Vec`, `pick`, `mySigma`, `Sigma`, `Nat.rec`). Zero `dbg_trace` anywhere in `LeanProject/`. Chapter 12's own chapter ("Working efficiently") contains real, runnable Lean (`12-working-efficiently/01-search-tactics.md:30-36`) including the `exact?` example whose comment claims "verified on this book's toolchain."
**WHY:** The book's strongest credibility claim — that everything compiles — is falsified by its own directory listing. Contributors following the README will hunt for modules that do not exist. The honest scoping already lives in `lean_book/README.md:41` ("Every code block in **Chapters 1–11** … verified").
**FIX:** Either (a) add `Ch12WorkingEfficiently.lean`, port the Ch 1 dependent-types code (`Fin`/`Vec`/`pick`/`mySigma`/`dbg_trace`), and add a solutions module — then verify with `lake build`; or (b) downgrade both claims to "Chapters 1–11" and explicitly enumerate which chapters' snippets are not compiled.
**Status: CONFIRMED** — the most-corroborated finding family (ling ×2, deepseek #6, north-mini, laguna, mimo); verified against the directory listing. `Ch03Propositions.lean` **does exist** (67 lines) — the "missing Ch 3" sub-claim from north-mini is refuted and dropped.

### C3. Audience self-contradiction on programming background
**WHAT:** `README.md:34-37` — "…no prior exposure to Lean, formal logic, **or programming**"; `lean_book/README.md:7` — "We assume **no programming background**." But `REPRODUCING.md:31-34` (step 2) — "The audience is mathematicians … who **already have programming experience** — cut beginner-programmer explanations (what a function is, what a compiler does)"; and `REPRODUCING.md:124-129` (step 10) flips back to "**zero prior exposure** to programming, formal logic…"
**WHY:** The README's hook sells the book to non-programmers; the production doc that built the book explicitly told the author to cut exactly the explanations those readers need. Three contradictory audience specs in one repo; the "accessibility pass" reads as damage control rather than design.
**FIX:** Pick one audience and stamp it everywhere. Either (a) adopt "reader has programming experience" and delete "no prior exposure to programming" from `README.md:37` and `lean_book/README.md:7`, or (b) keep "no programming background" and rewrite `REPRODUCING.md` step 2 to match, making the beginner-friendly remediations complete.
**Status: CONFIRMED** — ling (CRITICAL, verbatim quotes) + mimo (jargon evidence); all three locations verified.

---

## HIGH

### H1. REPRODUCING.md tells authors to use "the latest stable toolchain"
**WHAT:** `REPRODUCING.md:15-17` — "a Lean 4 project using **the latest stable toolchain** … `lean-toolchain` pinned to **the latest release**." The shipped `lean_project/lean-toolchain:1` pins `leanprover/lean4:v4.32.2` and `NOTICE.md:10` states the same.
**WHY:** "Latest release" is a moving target; following the steps guarantees a different toolchain (and Mathlib) than the build the book was verified against, so `REPRODUCING.md:6-7`'s promise that the sequence "should reproduce a book with the same … constraints" is not met. This compounds C1 — even a reader who fixes the seven doc citations gets drifted instructions in the production doc.
**FIX:** Replace "latest stable toolchain" / "latest release" with an explicit pin to `leanprover/lean4:v4.32.2` and Mathlib `rev = v4.32.2`.
**Status: CONFIRMED** — ling (MEDIUM) + mimo; verified verbatim.

---

## MEDIUM / LOW (surviving)

### M1 (LOW) Navigation strips inconsistent across files
**WHAT:** Top vs bottom strips differ in link count: `00-setup/04-mathlib-note.md:3` (2 links top) vs `:60-62` (4 links bottom); appendix files vary too (`01-chapter-1.md:3` has 2, `03-chapter-4.md:3` has 3).
**WHY:** Copy-paste drift; reader gets different navigation depending on scroll position. Minor, but a quality-control signal.
**FIX:** Standardize all top/bottom strips to one format.
**Status: CONFIRMED** — mimo + deepseek, verified in multiple files.

### M2 (LOW) Appendix numbering skips Chapter 2 without explanation
**WHAT:** `14-appendix-solutions/00-index.md:14-23` lists Chapters 1, 3, 4, … 11 with files `01-chapter-1.md`, `02-chapter-3.md`, … `10-chapter-11.md`. Chapter 2 genuinely has no exercises (`02-functions-and-structures/00-index.md` has no exercises section), so the omission is correct — but the `02-` prefix invites a "where's Chapter 2?" glance.
**FIX:** Add a one-line "Chapter 2: no exercises" note in the index (or rename files to match chapter numbers).
**Status: CONFIRMED as observation** — deepseek; severity demoted from HIGH.

### M3 (LOW) Ch 13 story omits its Section 4 ("Solutions")
**WHAT:** `13-next-steps/00-index.md:7-19` frames the chapter as answering three questions, but the chapter has four sections (`04-solutions.md` exists); the Solutions section is outside the three-question frame.
**WHY:** Small structural inconsistency in the chapter's own narrative map.
**FIX:** Extend the story to mention the Solutions section, or fold it into the three-question frame.
**Status: SINGLE** — mimo; the structural fact verified against the index and directory listing.

### M4 (LOW) No direct install URL in Setup
**WHAT:** `00-setup/02-installing-toolchain.md:13-17` says "search 'leanprover elan install' or use a package manager" — no clickable link.
**WHY:** A first-time (especially non-programming) reader should not be told to search.
**FIX:** Provide the direct URL (e.g. https://lean-lang.org/lean4/doc/quickstart.html).
**Status: CONFIRMED** — mimo (+ ling/mimo folded the surrounding "jargon" material into C3; the standalone `uv`/VS Code jargon claims are mitigated by inline glosses and the parenthetical framing, and are not carried separately).

---

## Dismissed findings (most of the corpus)

**Refuted by reading the files they cite (nemotron, 7/7 invalid):** the "proof irrelevance conflates Prop with Σ" quote does not exist at `01-prop.md:84-95`; the `Perm3` proof-irrelevance claim is *correct* (its proof fields are `Prop`-valued; `Perm3.ext` closes via `mk.injEq`); no `linarith` anywhere in the book (repo-wide grep: zero); no `rw [← mul_one a]` at `02-theorem-1.md:35-40`; the checkpoint project is named `Monoid` (not `MyMonoid`) and has a full "Self-verification." section; the ND table defines `∧I`/`∧E` in prose; "cumulative" never appears in `05-rigor-check/02-universes.md`. Its verification-log claim "all markdown snippets match `lean_project/`" is false (contradicted by the directory listing and by four other reports).

**Refuted by running the pinned toolchain (north-mini):** `Nat.succ_add` **is** core Lean 4.32.2 (`#check Nat.succ_add` succeeds with no import; the book compiles); the `exact?` example's quoted term `Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)` **is** what Lean returns (three critiques ran it) — north-mini's "actual output is `h.symm`" is false; the `simp` example is not "accidental" (`Nat.add_zero` is a permanent core simp lemma, and Ch 4 explicitly warns about `simp`); `Mat2.ext` is not presented as broken — the book *supplies* it by hand with a complete proof (`08-rings/07-matrices.md:28-38`, verified) and never calls `ring`; `Ch03Propositions.lean` exists; `pick`'s `if b = true then` is Lean's own elaborated pretty-print; `Vec Int n` is a correct instantiation of `Vec (α : Type) : Nat → Type`.

**Refuted by the exercise files (deepseek, 2 fabricated CRITICALs):** Chapter 1's own Exercise 4 explicitly asks for `Path.append`'s signature as nested Π-types (`01-basics/06-exercises.md:52-58`, verified) — the appendix answer is correct, not "misplaced Ch 11 content"; `by decide` is used in Ch 1's *main text* (`05-pi-sigma-and-coc.md:186`), so the appendix's use is not a forward reference. The `rfl` "overuse" is refuted: every cited `rfl` is explained in prose precisely per the appendix's own style rule. `Bool.xor` by exhaustive `cases` is the canonical, more-explicit approach for finite types (the reviewer's proposed `decide` fix contradicts its own "decide unexplained" complaint). "No Ch 12 solutions" is moot — Chapter 12 has no exercises.

**Refuted by context (laguna, mostly fabricated):** `Path.length`/`Path.append_length` **are** in the checkpoint's self-verification block (`11-path-algebras/07-checkpoint-project.md:50-75`) and the appendix (`14-appendix-solutions/10-chapter-11.md:116-133`, verified) — their absence from `lean_project/` is a README-scope issue (C2), not an unverifiable deliverable; the `Submodule` definition (`10-modules/04-submodules.md:21-26`, verified) is complete for modules over a ring — `neg_mem` is derivable from `smul_mem` with `r := -1`, exactly Mathlib's design, and the "ℕ as ℤ-module" counterexample is incoherent (ℕ is not an abelian group); `intZModule` **is** fully verified (`Ch10Modules.lean:40`) and the book explicitly discloses the general ℤ-module proof "is left as an extended exercise"; zero-ring and `mul_zero_left`-circularity findings cite quotes that do not exist and no theorem shown false; `Mat2.mul_assoc` is a hand-written multi-line `rw` proof, not `rfl`; `decide`'s mechanism *is* explained (Ch 12).

**Refuted as deliberate/re-litigation (mimo, mostly):** Bloom-verb removal is a documented design choice (README.md:59-63; changelog v1.4.25) and most chapter indices retain outcome sentences — survives only as the narrow M3; "Mathlib-free" is qualified in the very chapter that discloses the Mathlib dependency; the Ch 13 "Aside: Church encodings" is explicitly labeled an aside; the learning-paths text self-explains its two-skip/two-how design; Socratic-question "redundancy" is a declared recurring device; the `MyGroup` appendix forward-reference resolves (`14-appendix-solutions/04-chapter-5.md:38`); the Thompson1991/TPIL4 link failures are already disclosed in the bibliography itself.

**Refuted as preference/noise (various):** landing-page link ordering, "two READMEs tell different voices," "all 14 chapters" counting, editorial-pass meta-history placement, notation-reference disclaimer, `Z/2` vs `Z/2Z` typo, `mypy --strict` nuance, `noncomm_ring` "unexplained," CT-box glossary complaints, `left_inverse_unique` cross-chapter reference.

---

## Reviewer reliability note

- **mimo** — caught the keystone version mismatch (C1); mostly reliable on the LOW/MEDIUM survivors.
- **ling** — strongest substantive findings (C3, C2, H1) but its "toolchain hygiene is clean" log is fabricated and denies the corpus's single most important defect. Findings are reliable *only* where independently verified.
- **deepseek** — one genuinely valuable finding (appendix not compiled → C2) + the numbering nit (M2); its two headline CRITICALs are fabricated.
- **north-mini** — its missing-modules claims feed C2, but its tool-behavior claims (`exact?`, `Nat.succ_add`) are demonstrably false and its BLOCK RELEASE verdict rests on them.
- **laguna** — weakest report; four fabricated citations; the one real observation (checkpoint blocks unported) is better stated as C2.
- **nemotron** — 7/7 findings invalid; contributes nothing usable.

---

## Surviving strengths (worth preserving)

1. **Ch 6/Ch 8 two-stage `GroupData`→`Group`, `RingData`→`Ring` pattern** — the clearest "structure with axioms" pedagogy in any Lean resource.
2. **Ch 7/Ch 9 theorem-search narrative** — "rewrite 0 as 0+0" and "relate both sides to a common third expression" taught by example, not assertion.
3. **Ch 1 abstraction ladder** — terms → types → dependent types → Π/Σ/CoC is excellent; the `dbg_trace` recursion-unwinding device is the book's unique contribution (even where unported, the concept is sound).
4. **Ch 11 `Path Q u v` construction + `Path.append` composability** — the most sophisticated Lean type in the book, and a masterclass in dependent typing.
5. **Ch 13 "Two theorems for free"** — ZMod 3 as Field and Lagrange on S₃ built from book-only objects: specific, verifiable, motivating.
6. **The `Mat2.ext` hand-supply note** — a model of honesty about what core Lean does and doesn't generate.
7. **Mathematics overall** — across all six reviews and six critiques, *not one mathematical claim or compiled proof was shown to be wrong*.

---

## Consolidated fix list (in priority order)

1. Fix `v4.33.0` → `v4.32.2` in the seven doc locations (C1) and pin REPRODUCING.md explicitly (H1).
2. Reconcile the audience promise in README / lean_book README / REPRODUCING (C3).
3. Either port Ch 12, Ch 1 dependent-types, and appendix code into `lean_project/`, or scope the "verified" claim to Chapters 1–11 (C2).
4. Add the "Chapter 2: no exercises" note (M2); standardize nav strips (M1); add the direct elan URL (M4); extend the Ch 13 story to its Section 4 (M3).

<<<FINAL_END>>>
