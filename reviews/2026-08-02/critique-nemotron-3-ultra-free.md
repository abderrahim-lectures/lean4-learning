<<<CRITIQUE_START>>>

# Adversarial Cross-Critique — Five Peer Reviews of *Lean for Working Algebraists*

**Critic:** nemotron-3-ultra-free (adversarial-book-reviewer skill)
**Scope:** `reviews/2026-08-02/{laguna,north,deepseek,ling,mimo}-*.md`, cross-checked against the live repo.
**Method:** Every cited `file:line` re-opened and read; every quoted "actual" output checked for type-correctness or existence; every verdict requires a reproducible fact, not a paraphrase.
**Date:** 2026-08-02

---

## 0. Verdict summary (read this first)

| Peer report | Fully valid | Fabricated / contradicted | Net value |
|---|---|---|---|
| **ling** (root-notice) | 3 CRITICAL/HIGH + 1 MEDIUM (audience, Ch12 scope, README scope, toolchain drift) | Its flagship "toolchain hygiene is clean" log is **fabricated** — it asserts every live reference reads `v4.32.2`, while every cited line actually reads `v4.33.0` | Highest signal, single worst credibility breach |
| **mimo** (Ch0/13+refs) | 1 CRITICAL (version mismatch, with one mis-cited path), 2 LOW (missing URL, nav strips) | ~7 findings misread or contradicted (Church-encodings "Aside", learning-paths graph, MyGroup appendix, λ-dictionary duplication) | One big catch + useful LOWs; much noise |
| **deepseek** (appendix) | 1 VALID (solutions not compiled), 1 cosmetic VALID (numbering), several PARTIAL | 2 CRITICALs fabricated (Ch 1 Ex 4 "misplaced"; `by decide` "breaks learning sequence") | Appendix verification gap is real; most of its CRITICALs collapse |
| **north** (Ch1–4,12) | 0 fully valid | ~15 of 20 findings false on the record, incl. `Nat.succ_add` "Mathlib-only", Mat2.ext "non-working", LaTeX "ghost refs", `pick`/`Vec.dot` "mismatches" | Mainly refutable; a few PARTIAL kernels |
| **laguna** (Ch8–11) | 0 fully valid | 4 fabricated citations (`03-z-module-example.md:85–90`, `02-theorem-1.md:55–60`, `mul_assoc`-by-`rfl`, `Submodule:35–45`), 1 internal contradiction | Weakest report; the one real gap is shared with ling/deepseek |

**The single most important finding in the whole corpus is that ling — the one reviewer assigned the root files where the bug lives — assertively certified the toolchain docs as clean while every file it claims to have read says `v4.33.0` and the actual pin is `v4.32.2`.** The version mismatch is real, is CRITICAL, is in ling's slice, and ling's own verification log denies it. mimo caught it; ling actively, and with fabricated evidence, cleared it.

---

## 1. ling-3.0-flash-free — root-notice

### 1.1 Its CRITICAL/HIGH findings that survive

- **CRITICAL — audience contradiction. VALID.** `README.md:34–37` ("…no prior exposure to Lean, formal logic, or programming") vs `REPRODUCING.md:31–34` (step 2: readers "who already have programming experience — cut beginner-programmer explanations (what a function is, what a compiler does)") vs `REPRODUCING.md:126–129` (step 10: "zero prior exposure to programming"). All three locations verified verbatim. The self-contradiction is real and reader-facing. This is the strongest finding in the corpus and no other reviewer states it with this precision.
- **HIGH — "every code block… one module per chapter" false for Ch 12. VALID.** `README.md:107–110` makes the promise; `lean_project/LeanProject/` contains `Ch01*`…`Ch11*` + `Ch13CapstoneMathlib.lean` and **no** `Ch12*` module; `12-working-efficiently/01-search-tactics.md:30–36` contains runnable Lean. Verified. Corroborated by deepseek #5 and north #3.
- **HIGH — verification-scope inconsistency between the two READMEs. VALID.** `README.md:98–100` ("every Lean snippet in the book (**main text and solutions**) is verified against the pinned toolchain") vs `lean_book/README.md:40–43` ("Every code block in **Chapters 1–11**… verified with `lake build`"). The root claim is unsupported for Ch 12, Ch 13, and the entire appendix. Verified. This is the deepest framing of the corpus's most-corroborated theme (see §7).
- **MEDIUM — "latest stable toolchain" in REPRODUCING. VALID.** `REPRODUCING.md:15–17` ("using the latest stable toolchain… pinned to the latest release") vs `lean_project/lean-toolchain:1` (`leanprover/lean4:v4.32.2`) and `lakefile.toml:7` (`rev = "v4.32.2"`). Following the recipe does not reproduce the shipped book. Verified.

### 1.2 Its LOW finding that is affirmatively false

- **"(LOW) — Toolchain version hygiene is actually fine within scope. INVALID — and the verification log is fabricated.** ling's own log (report lines 90–95) claims: "`v4.32.2` live hits = README.md:108, NOTICE.md:10,43, lean_project/lean-toolchain, lakefile.toml:7, 02-installing-toolchain.md:29, learning-paths.md:60, 04-mathlib-note.md:45 (all consistent)." I re-read every one of those lines in the live tree:
  - `README.md:108` → "toolchain `v4.33.0`"
  - `NOTICE.md:10` → "toolchain `leanprover/lean4:v4.33.0`"; `NOTICE.md:43` → "pinned to the `v4.33.0` tag"
  - `lean_book/00-setup/02-installing-toolchain.md:29` → "`leanprover/lean4:v4.33.0`"
  - `lean_book/00-setup/04-mathlib-note.md:45` → "`leanprover/lean4:v4.33.0`"
  - `lean_book/learning-paths.md:60` → "confirm your toolchain matches `v4.33.0`"
  Only `lean_project/lean-toolchain:1` and `lakefile.toml:7` read `v4.32.2`. So **six of the seven lines ling certified as "all consistent" say the wrong version, and the one correct pair is the actual pin.** The reviewer missed the single biggest reproducibility defect in its own slice and certified the opposite of the file contents. A reviewer whose verification log can be refuted line-by-line cannot be trusted on any un-verifiable claim it also asserts (its Ch12 claim happens to be checkable — and there it is right).

### 1.3 Editorial/voice findings (LOW/MEDIUM)

- "Reproduction doc structure denies its linear narrative" (`REPRODUCING.md:6–7` vs steps 10–13 prelabeled "a later session") — **PARTIAL.** The multi-session nature is disclosed inline in the same document; the "following it in order" phrasing is mildly misleading but the steps themselves carry their own session labels. Downgrade to LOW.
- "Two READMEs tell the spine in different voices" — **INVALID as defect.** A landing page competency list (`README.md:44–52`) and an in-book staged-journey description are different genres; no factual contradiction is shown.
- "Landing page leads with legal/meta links" — **INVALID (pure ordering preference)**; excluded by triage.

---

## 2. mimo-v2.5-free — Ch 0, 13 + reference files

### 2.1 CRITICAL version mismatch — **VALID (with one citation error)**

Every quoted occurrence is real except the first:
- `00-setup/02-installing-toolchain.md:29` = `v4.33.0` ✓
- `00-setup/04-mathlib-note.md:45` = `v4.33.0` ✓
- `learning-paths.md:60` = "confirm your toolchain matches `v4.33.0`" ✓
- **"README.md:40: 'Code blocks are valid Lean 4 (toolchain v4.33.0, matching ../lean_project)'" — mis-cited.** That exact text is at **`lean_book/README.md:40`**, not root `README.md:40`. Root `README.md:108` is where the root file carries `v4.33.0`. The substance stands; the citation is wrong on the one line that mattered.

Actual pin: `lean_project/lean-toolchain:1` = `leanprover/lean4:v4.32.2`; `lakefile.toml:7` Mathlib = `v4.32.2`. **VALID CRITICAL** — and the only reviewer besides my own audit to catch it.

### 2.2 CRITICAL "no-programming-background broken by jargon" — **OVERSTATED; downgrade**

The kernel is real but the severity is not. Verified context:
- The `uv` remark (`02-installing-toolchain.md:9–11`) is explicitly scoped "(Readers familiar with `uv`'s…)" — an optional parenthetical, not a requirement, and `elan` was just defined one line up ("a version manager… installs and switches between different versions").
- The editor terms (`03-editor.md:9–13`) are each glossed inline ("the 'Lean infoview'", "the editor command that navigates to where a name was originally introduced").
- The genuinely weak bit is real: "search 'leanprover elan install' or use a package manager" (`02-installing-toolchain.md:13–14`) supplies no URL, and "Mermaid/MathJax/Pandoc/VS Code extensions" (`README.md:27–38`) is only in the build-notes block, not the reader's path.
- Also mis-cited: "README.md:7: 'We assume no programming background'" — that sentence is at **`lean_book/README.md:7`**; the root README's audience claim is at `README.md:34–37`.

The "strands the promised reader immediately / cannot complete Setup" harm is not demonstrated; the correct, sharp version of this finding is ling's (the internal contradiction, §1.1). Verdict: PARTIAL — rescue the "no direct URL" LOW and fold the rest into ling's CRITICAL.

### 2.3 HIGH — Ch 0/Ch 13 stories fail to replace Bloom objectives — **PARTIAL**

Accurate observation: `00-setup/00-index.md:7–13` and `13-next-steps/00-index.md:7–19` are "story" intros; Ch 0's covers only the remember/understand half. But the framing is wrong in two ways. First, `README.md:59–63` documents the replacement as deliberate ("never listed as explicit objectives, always embedded in the narrative flow"), so this re-litigates a disclosed decision. Second, most chapter indices **do** retain outcome statements — `01-basics/00-index.md:51` ("By the last section…"), `02-functions-and-structures/00-index.md:47`, `03-propositions-and-proofs/00-index.md:49`, `05-rigor-check/00-index.md:56`, `06-groups/00-index.md:46`, `08-rings/00-index.md:50`, `10-modules/00-index.md:51`, `11-path-algebras/00-index.md:55`. The defensible kernel is narrow: README's claim that each story frames the full "remember → … → create" chain is not met by Ch 0's story. North's version of this finding is the more distorted one (§3.1).

### 2.4 HIGH — "Mathlib-free by design" claim false — **OVERSTATED**

`04-mathlib-note.md:24–27` itself qualifies: "This book is Mathlib-free by design **through Chapter 11's from-scratch constructions**; Mathlib appears only in the 'Mathlib equivalent' boxes from Chapter 6 onward." The unqualified `README.md:40` ("building every definition from scratch rather than relying on Mathlib") is loose phrasing immediately bounded by the in-book qualification. No reader is actually told the project imports nothing — the opposite is explained in the same chapter. Downgrade to LOW; no factual breakage.

### 2.5 HIGH — Ch 13 "Aside: Church encodings" structurally incoherent — **INVALID**

The header is literally `### Aside: Church encodings — data from nothing but functions` (`03-next-projects.md:181`). The text is self-aware: "None of this is meant to suggest that one should ever program this way… purely as a curiosity" (`:236–239`), ending with an optional self-check exercise (`:244–247`). The claim that it "assumes λ-calculus knowledge the book never teaches" is false: Ch 1 §4 has an untyped-λ-calculus recap with a worked $K$-combinator reduction (`04-terminology.md:82–117`), Ch 1 Exercise 1 exercises β-reduction, and a whole `lambda-calculus-dictionary.md` exists. Placement at the end of "next projects" is a taste call, not an incoherence.

### 2.6 MEDIUM — learning-paths graph misrepresents path equivalence — **INVALID (misread)**

`learning-paths.md:40–43` says: "Dashed arrows are the **two** named paths below that actually skip material outright… **the other two** named paths change *how* a chapter is read… so they have no edge of their own." Five named paths exist (`:55–93`): Full, already-know-Lean, already-know-algebra, formal-foundations, see-real-math-fast. That is exactly 1 full + 2 skip (already-know-Lean; see-real-math-fast) + 2 how-to-read (already-know-algebra; formal-foundations). The dashed edges in the graph (`:32–34`) are the two skip paths. The text is internally consistent; the reviewer read "the two named paths" as "only two paths exist."

### 2.7 Remaining LOWs

- **LOW 6 (MyGroup "no Chapter 5 appendix exists") — INVALID.** `14-appendix-solutions/04-chapter-5.md` exists and contains "2. MyGroup as a type class"; the appendix index lists Chapter 5. The forward reference at `03-next-projects.md:21–22` is valid.
- **LOW 7 (Thompson1991 TLS failure) — PARTIAL.** `bibliography.md:69` documents the TLS handshake failure with a link-check date. The book is *disclosing* the break, not hiding it; the suggestion to find a mirror is fair, but this is not an undisclosed defect.
- **LOW 8 (TPIL4 fix "should be in chapter files") — INVALID.** Grep shows the stale `dependent_type_theory.html` scheme appears **only** in `bibliography.md:71`'s own historical note; no chapter file contains the stale URLs. The fix is already in the right place.
- **LOW 10 (λ-dictionary "duplicated from Chapter 1") — INVALID.** `lambda-calculus-dictionary.md:36–40` says the two facts are "explained where their own dictionary rows live **rather than repeated here**" — the note is an anti-duplication pointer.
- **LOW 11 (notation-reference disclaimer "clutters") — INVALID.** Pure preference; excluded by triage.
- **MEDIUM Socratic-redundancy (`04-mathlib-note.md:29–55`) — VALID at LOW.** The main text (`:7–27`) covers from-scratch/Mathlib (7–11), Mathlib boxes (13–20), and pinning (22–27); Socratic Q1/Q2/Q3 restate those three. Genuine redundancy, mild severity.
- **MEDIUM nav-strips inconsistent — VALID at LOW.** `04-mathlib-note.md:3` has 2 links top vs 4 at bottom (`:60–62`); corroborated across files.

---

## 3. north-mini-code-free-lean-code — Ch 1–4, 12

### 3.1 CRITICAL — "Bloom verbs/objectives removed" — **OVERSTATED; INVALID as stated**

"Every chapter index previously had explicit 'By the end of this chapter you will be able to…' — **now only narrative 'story' remains**." False as a blanket: eight indices retain "By the end / By the last section" outcome sentences (list in §2.3). `README.md:59–63` documents the design change. "Students cannot self-assess" is contradicted by those sentences. The only true residue is "the Bloom-verb list format is gone," which is a documented choice, not a regression to be blocked.

### 3.2 CRITICAL — "LaTeX 'Story'/'Sections' removed but markdown retains ghost refs" — **INVALID**

The LaTeX export keeps real `\section`/`\subsection` numbering and labels (`01-basics/00-index.tex:1`, `04-terminology.tex:1`, `06-exercises.tex:1`, etc.). Prose references like "Section 3's `Vec.replicate`" (`05-pi-sigma-and-coc.md:24`) resolve to the actual Section 3 in the compiled PDF. What changed is that the index's "Story"/"Sections" headings were re-rendered as a prose intro with `\hyperref` links — and those hyperref targets exist. "Point to nothing in compiled book" is false.

### 3.3 CRITICAL — "`exact?` example reports wrong output (actual: `h.symm`)" — **UNVERIFIED; the book's term type-checks**

`01-search-tactics.md:30–36` claims verified output `Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`. I reduced that term by hand against the goal `b = a`: `id (Eq.symm h) : b = a`; `congrArg HAdd.hAdd … : HAdd.hAdd b = HAdd.hAdd a`; `congrFun … a : b + a = a + a`; `Nat.add_right_cancel … : b = a`. **The term is type-correct.** The book's claim is therefore plausible, and it explicitly acknowledges "not the shorter `h.symm` a human would write." North asserts the contrary "actual output" with no evidence log at all — while demanding the book's claim be reproducible. Both claims need a live `lake env lean` run; until one is provided, this is a draw, not a North win. North's severity (CRITICAL) is unsupported.

### 3.4 CRITICAL — "`dbg_trace` examples not in lean_project" — **PARTIAL (fact true, severity inflated)**

No `Ch01DependentTypes.lean` exists; the Ch 1 §3/§5 traced code is absent from `lean_project/`. That is a real slice of the verification-scope gap (see §7). But "readers cannot reproduce" overstates: the code and trace output are in the markdown, and the book's own `README.md:77–83` documents the tracing device. This belongs under ling's README-scope finding, not as a standalone CRITICAL.

### 3.5 HIGH — "`Nat.succ_add` is Mathlib; doesn't exist in core 4.32.2" — **INVALID**

`Ch04Tactics.lean:62` uses `rw [Nat.succ_add]` in a file with **no imports**, and the project compiles — north itself says so ("The Lean code in `lean_project/` compiles cleanly"). `Nat.succ_add` is a core Nat theorem in Lean 4; "Mathlib-only" is simply wrong. (The same report's claim that `Nat.succ_add` was "not in core" while simultaneously logging the project as compiling is internally inconsistent.)

### 3.6 HIGH — "Ch 4 `simp` works by accident / teaches magic" — **INVALID**

`04-tactics/04-more-tactics.md:14` explains "`simp` automatically searches for known 'simplification' lemmas and applies"; `:17` warns "avoids `simp` and `rfl`-as-a-shortcut wherever the point is to understand"; `:20` says "`simp` should be treated as a tool for later." Using the core simp set's `Nat.add_zero` is exactly simp's design. The claim that "Ch 12 correctly warns but Ch 4 doesn't" is contradicted by the Ch 4 file it cites.

### 3.7 HIGH — "Mat2.ext note admits book's `apply Mat2.ext` doesn't work in core" — **INVALID (stale reading)**

The current markdown hand-proves `Mat2.ext` (`08-rings/07-matrices.md:33–43`: "supplied by hand right alongside"), proves `mul_assoc` by explicit entrywise rewrites (`:206–228`), and **never calls `ring` in code** — it explicitly flags `ring` as Mathlib-only in its own note (`:288–289`). The `Ch08Rings.lean:1–12` header describes an *earlier* version's `apply Mat2.ext <;> ring` proofs. North's citation "Ch08Rings.lean:95–100" is also out of range (file is 79 lines). "Book presents non-working code as if it works" is false of the current text.

### 3.8 HIGH — "Missing Ch03Propositions.lean / Ch01DependentTypes.lean" — **PARTIAL**

`Ch03Propositions.lean` **exists** (and at `:35–41` documents a genuine book bug it fixed — the `Nat.noConfusion` term — which is a point in the book's favor, not against it). The genuine half is Ch 1's dependent-types content (§§3/5: `Fin`, `Vec`, `pick`, `mySigma`, `Sigma`, `Nat.rec`) having no module — same verification-scope gap as §3.4.

### 3.9 MEDIUMs 11–15

- **11 (`pick` signature) — INVALID.** The book shows `#check @pick` printing `(b : Bool) → if b = true then Nat else Bool` (`05-pi-sigma-and-coc.md:62–67`). That *is* Lean's own output; the "mismatch" is the reviewer not recognizing `if b = true then…` as elaboration-printed syntax.
- **12 (`Vec.dot` vs `Vec (α : Type) : Nat → Type`) — INVALID.** `Vec Int n` is exactly the type family applied to `Int`; there is no mismatch (`03-dependent-types.md:200,242`).
- **13 (Ch 12 gives no decision procedure) — INVALID.** `02-decision-procedures.md:18–23` defines `decide`'s mechanism and fragment, `:24–35` defines `omega` (Presburger, exact fragment) and `norm_num`, `:46–57` gives the "Mathematical reading," `:59–62` further reading. The citation `:37–44` is the "judgment call" guidance, not a gap.
- **14 (`exact?` env warning has no mitigation) — INVALID.** `01-search-tactics.md:22–25` gives the mitigation: "paste in the concrete result, rather than leaving the search tactic itself in the finished proof."
- **15 (term vs tactic mode contradicts Ch 4) — UNVERIFIED.** `04-term-vs-tactic-mode.md:11–23` gives standard, consistent guidance; no specific Ch 4 contradiction is cited.

### 3.10 LOWs

- **1 ("Section 4's untyped-λ-calculus recap" doesn't exist) — INVALID.** `04-terminology.md:82–117` contains the recap with the worked $K = \lambda x.\lambda y.\,x$ reduction, and the exercise itself (`06-exercises.md:37–41`) says "Section 4's untyped-λ-calculus recap." The reference is correct.
- **2 (`noncomm_ring` never explained) — INVALID.** `07-matrices.md:340–346` explains it as "the noncommutative-ring counterpart of the `ring` tactic that the book's own note above states is not available," with an example.
- **3 (Ch 1 index lists Exercises as Section 6 but "no Story entry") — INVALID.** The story is the chapter intro; exercises are legitimately Section 6. Non-finding.
- **4 (mypy `--strict` nuance) — INVALID.** mypy is used as an explicitly-flagged analogy (`01-everything-has-a-type.md:75–79`; `05-rigor-check/03-typing-rules-and-safety.md:39–59`); `--strict` is irrelevant to the point.
- **5 (CT boxes assume CT knowledge without glossary) — INVALID.** `04-terminology.md:81–205` is a "Category-theory terms used beyond the baseline" glossary (Universal property, Initial object, Forgetful functor, Subobject/full subcategory).

### 3.11 Verdict on north

Highest fabrication density of the five: 15 of its findings are refuted by the very files they cite. Its verification log ("Actual (Lean 4.32.2)… ❌ WRONG") contains zero reproducible commands. Rescue: §3.4's verification-gap kernel and the §3.3 "needs a real run" demand.

---

## 4. deepseek-v4-flash-free — Appendix 14

### 4.1 CRITICAL — "Ch 1 Ex 4 is Ch 11 content, mislabeled and misplaced" — **INVALID**

Chapter 1's own Exercise 4 asks for exactly this: "Chapter 11's `Path Q : V → V → Type`… Write down the Π-type expression… so that it matches `Path.append`'s signature `{u v w : V} → Path Q u v → Path Q v w → Path Q u w` (treat the implicit `{u v w : V}` as outer Π-binders)" (`01-basics/06-exercises.md:52–58`). The appendix solution (`01-chapter-1.md:88–107`) answers it and even ties back to "Chapter 1, Sections 3/5" (`:107`). "Copy-pasted from the wrong chapter's answer key" is a confident fabrication.

### 4.2 CRITICAL — "solutions overuse unexplained `rfl`" — **PARTIAL; the flagship example collapses**

- Ch 4 Ex 2 (`03-chapter-4.md:22–30`): the solution **explains** the `rfl` explicitly — "`rfl` does succeed here. `Nat.mul` is defined by recursion on its second argument, and `n * 0 = 0` is the base clause. Hence this holds by definition, with no induction required." That is precisely the appendix's own style rule ("unexplained `rfl`" prohibited; `rfl` allowed "when a step is truly definitional and there is nothing left to explain"). This half of the finding is refuted.
- Ch 6 `boolXorGroup` (`05-chapter-6.md:14–42`): the `id_left`/`id_right`/`inv_left`/`inv_right` `rfl`s carry only generic prose. For a concrete finite type these closures are genuinely definitional-by-computation, so this is a fair **LOW** style quibble — the book's own Ch 12 (`02-decision-procedures.md:18–23`) teaches that finite closed cases are exactly what computation (`decide`/`rfl`) settles. Not CRITICAL.

### 4.3 CRITICAL — "`Bool.xor` uses exhaustive `cases` instead of algebraic reasoning" — **PARTIAL/OVERSTATED**

Three nested `cases` on a finite type is the canonical way to close a Bool group in Lean; the chapter's own generic Ch 7 machinery exists precisely to give the algebraic route. "The solution models the *opposite* of what the book teaches" is a preference presented as a defect. Downgrade to LOW.

### 4.4 HIGH — numbering mismatch — **VALID but LOW, not HIGH**

`14-appendix-solutions/00-index.md:14–23` lists Chapters 1,3,4,5,6,7,8,9,10,11 with files `01-chapter-1.md`…`10-chapter-11.md`; Ch 2 genuinely has no exercises (`02-functions-and-structures/00-index.md:51–55` lists only three sections, none an exercise — confirmed). A reader inferring "02-chapter-3.md" as Chapter 2's file is a mild cosmetic trap. The claim "Chapter 2 has no exercises" is correct.

### 4.5 HIGH — no Ch 12 solutions — **PARTIAL (framing wrong, core right)**

The appendix genuinely stops at Ch 11. But **Ch 12 has no exercises** (`12-working-efficiently/` contains no exercises file, no exercise references), so "add `11-chapter-12.md` with solutions" is moot. The real, valid core is the same as ling's HIGH #2/#3: Ch 12's runnable code is unverified against the "every snippet" claim.

### 4.6 HIGH — appendix snippets lack `lean_project` modules — **VALID (the report's best finding)**

No `Ch14*`/appendix module exists; `README.md:98–100` promises "every Lean snippet in the book (main text and solutions) is verified." The appendix is not compiled by `lake build`. This is a genuine, central, verifiable gap — corroborated by ling §1.1 and by the other reviewers' Ch12/Ch11 findings.

### 4.7 HIGH — "Ch 1 Ex 3 uses `by decide` before Ch 4 introduces it" — **INVALID**

The main text of Ch 1 itself uses `by decide` — `05-pi-sigma-and-coc.md:186` (`⟨3, ⟨2, by decide⟩⟩`), and `01-basics/06-exercises.md:48–49` refers to "the text's `⟨3, ⟨2, by decide⟩⟩` example." The appendix matches main-text usage. If this is a defect, it's a Ch 1 main-text defect, not an appendix one — and it is a documented forward-usage pattern (fully explained in Ch 12).

### 4.8 MEDIUMs 8–10 and LOWs

- **8 (Ch 4 Ex 2 "confuses `rfl` with `Nat.mul_zero`") — INVALID.** The text already says "`Nat.mul` is defined by recursion on its second argument" — i.e., it already attributes the result to Lean's definition, which is exactly what the reviewer demands it add.
- **9 (Ch 6 Ex 2 discussion correct but code doesn't illustrate) — PARTIAL at LOW.** Accurate observation; it's a suggested improvement, not a defect.
- **10 (Ch 3 solutions trivial) — PARTIAL at LOW.** The exercises are genuinely one-liners; expanding with `have` steps would be padding.
- **11 (nav strips inconsistent) — VALID (LOW).** Confirmed at `01-chapter-1.md:3` vs `02-chapter-3.md:3` vs `03-chapter-4.md:3`.
- **12 (`Vec.toList'` uses `dbg_trace` unexplained) — INVALID.** The appendix explains the trace in prose (`01-chapter-1.md:67–71`), and `dbg_trace` is a book-wide documented device (`README.md:77–83`).
- **13 (`Sort` terminology too dense for Ch 1) — INVALID-leaning.** `Sort 0` vs `Type` is used in Ch 1's own main text and §5's calculus-of-constructions discussion; the appendix solution mirrors the book's vocabulary.

### 4.9 Verdict on deepseek

Rescues: #6 (appendix not compiled — genuinely valuable) and the numbering observation. Two fabricated CRITICALs (#1, #7) both depend on not checking whether the *exercise itself* asks for the "misplaced" content.

---

## 5. laguna-s-2.1-free-math-algebra — Ch 8–11

### 5.1 CRITICAL — checkpoint deliverables missing from lean_project — **PARTIAL; severity inflated; internally self-contradicting**

Fact: `Ch11PathAlgebras.lean` contains `Path`/`Path.append` but not `Path.length`/`Path.append_length`. Verified. But:
- The checkpoint chapter **provides** `Path.length` and a full `Path.append_length` proof as its own "Self-verification" block (`07-checkpoint-project.md:49–75`), and points to the appendix's worked solution (`07-checkpoint-project.md:118–119` → `10-chapter-11.md:116–133`, which contains both, verified). The reader **can** self-verify.
- These are explicitly the reader's **deliverables** ("**Deliverable.** `Path.length` and the proved theorem…", `:44–45`) — their absence from the pre-built project is by design.
- Laguna's own **LOW 3** then claims "`Path.length` is not defined in the chapter (only `Path.append` is)" — refuted by `07-checkpoint-project.md:50–52`, and directly contradicting its own CRITICAL, which quotes the `Path.length` signature from the checkpoint.
What survives is only the recurring verification-scope gap (these blocks are not compiled in `lean_project/`). Downgrade to MEDIUM and merge into §7.

### 5.2 HIGH — `Submodule` omits `neg_mem` — **INVALID (mathematically wrong)**

The field list is real (`04-submodules.md:21–26`: carrier, zero_mem, add_mem, smul_mem — not `:35–45` as cited). But the argument is unsound:
- The counterexample "ℕ as ℤ-module" is impossible: ℕ is not an abelian group (no inverses), and the book's `Module` is over a **Ring** (`Ch10Modules.lean:16–22`).
- Negation closure is **derivable** from the structure: `add_smul` + `one_smul` + the ring's `-1` give `smul (-1) m = -m` (by `smul (1 + -1) m = smul 1 m + smul (-1) m = m + smul(-1) m = smul 0 m = 0`), so `smul_mem` already implies `neg_mem`.
- No submodule theorem "using negation" is shown false; the book's own reading says "closed under the abelian-group operations" (`04-submodules.md:31–40`).
The residue is a LOW explicitness preference (state `neg_mem` for symmetry), not a HIGH incompleteness.

### 5.3 HIGH — "Z-module axiom verification not formalized (asserts them with `rfl` or `sorry`-equivalent)" — **INVALID**

The file deliberately, and in plain text, defers the verification: "The full verification is left as an extended exercise, since carrying it out directly is the best way to see *why* modules over $\mathbb{Z}$ are forced" (`03-z-module-example.md:56–62`). There is no `rfl`-verification and no `sorry` anywhere in the file. The "asserted not proved" accusation mischaracterizes a disclosed design decision. (The `:22–28` citation lands on the `intSmul` code, not on the claim.)

### 5.4 MEDIUM — zero ring silently permitted — **INVALID as noise**

True that `Ring` has no `one_ne_zero`. But no theorem is shown false; standard convention varies; and every theorem the book proves (e.g., `a*0=0`) holds in the zero ring. "Technically false for all rings" is asserted with no instance.

### 5.5 MEDIUM — "forward reference to `mul_zero_left` before definition (02-theorem-1.md:55–60)" — **INVALID (fabricated citation)**

`02-theorem-1.md:55–60` is the tail of the Lean proof (`rw [id_left] at h2` / `exact h2.symm`). No "Compare with `0 * a = 0`…" sentence exists there. The quoted phrasing is a misattributed paraphrase of the **appendix's** Ch 4 Ex 2 explanation (`14-appendix-solutions/03-chapter-4.md:27–30`). In Ch 9, `mul_zero_left` is first proved in `03-theorem-2.md:32` and only *then* referenced at `04-exercises.md:43` — not a forward reference at all.

### 5.6 MEDIUM — "`mul_assoc` for `Mat2` proved by `rfl`" — **INVALID (fabricated)**

Neither the book nor the project proves `Mat2.mul_assoc` by `rfl`. The markdown gives an explicit entrywise proof via `Mat2.ext` + `Int.add_mul`/`mul_add`/`mul_assoc`/`add4_reorder` (`07-matrices.md:206–228`); `Ch08Rings.lean` proves the `Int` instance with `exact Int.mul_assoc` (`:38–40`) and the finite ring with `by decide` (`:79–83`). No "20-line computation hidden by `rfl`" exists.

### 5.7 MEDIUM — "`decide` mechanism unexplained (03-z-module-example.md:85–90)" — **INVALID (fabricated citation)**

The file is 95 lines; `:85–90` is the "Mathlib equivalent" prose (`Module Int M` `inferInstance`). There is **no `decide` and no `Fin 5`** in this file. `decide`'s mechanism is explained fully in `12-working-efficiently/02-decision-procedures.md:18–23`. (Its LOW 4 makes the same "decide unexplained" claim against `05-finite-ring-example.md`, which in fact *does* explain why `decide` handles its finite statement, with a pointer to Ch 12 — also refuted.)

### 5.8 Verdict on laguna

Weakest report: four fabricated/out-of-range citations, one internally contradictory CRITICAL, and the "zero ring"/"Z-module" findings built on unread context. Its verification log ("`lake build` ✅ PASS 8677 jobs, 0 errors"; "Mathematical claims recompute ✅") cites no commands, and its own citations fail at check time. Rescued content: none that isn't already better stated by ling/deepseek.

---

## 6. Verification-log audit (the five reports' own evidence)

- **ling**: log is line-by-line refutable (see §1.2) — its "all consistent" version table is inverted from reality. **This is the corpus's single most damaging failure**, because it cleared the one bug that blocks every reader's build.
- **laguna**: claims `lake build` on 30 files "✅ PASS," "no sorry/admit/axioms ✅," "Mathematical claims recompute ✅" with no commands reproduced, while four of its own citations don't exist. Logs that cannot be reproduced, on findings that cannot be checked, do not certify anything.
- **north**: "Counterexample Hunter — Actual (Lean 4.32.2)" table lists `Nat.succ_add` ❌ "Not in core" and `exact?` → "Suggests h.symm" with no `lake env lean` invocation anywhere. Two of its seven "actual" rows are wrong, one is unverifiable.
- **deepseek**: "Lean code compiles in lean_project ❌ FAIL (no Ch14)" is the one log row that matters and it is right; "Solutions match chapter content ❌ FAIL" is wrong (see §4.1).
- **mimo**: log row "Toolchain version consistency ❌ FAIL, 4 files claim v4.33.0" — correct (its count is even short: seven files, not four).

---

## 7. Cross-review corroboration matrix

| Finding | north | deepseek | ling | mimo | laguna | Verdict |
|---|---|---|---|---|---|---|
| **Docs claim `v4.33.0`; actual pin `v4.32.2`** | — | — | ❌ *certifies clean* | ✅ CRIT | — | **VALID — the bug of the corpus**; ling is the outlier, on the wrong side |
| **"Every snippet/code block verified" unsupported (Ch 12 / appendix / Ch 11 checkpoint)** | ✅ (dbg_trace) | ✅ #5,6 | ✅ HIGH ×2 | — | ✅ CRIT | **VALID — the most-corroborated family**; ling frames it best |
| **Audience contradiction (no programming vs has programming)** | — | — | ✅ CRIT | ✅ (jargon) | — | **VALID** |
| **Bloom objectives removed / story inadequate** | ✅ CRIT | — | — | ✅ HIGH | — | **PARTIAL** — documented choice; 8 indices retain "By the end"; both reviewers overstate |
| **`exact?` reported output** | ✅ CRIT (h.symm) | — | (embedded) | — | — | **UNVERIFIED** — book's term type-checks; no live run exists |
| **Solutions not compiled** | — | ✅ #6 | ✅ | — | — | **VALID** |
| **`Path.length` absent from project** | — | — | — | — | ✅ CRIT | **PARTIAL** — fact true; severity inflated; in-chapter code exists |
| **Ch 1 Ex 4 "misplaced"** | — | ✅ CRIT | — | — | — | **INVALID** — the exercise asks for it |
| **`by decide` "too early" in Ch 1** | — | ✅ CRIT | — | — | — | **INVALID** — main text uses it first |
| **`Submodule` missing `neg_mem`** | — | — | — | — | ✅ HIGH | **INVALID** — derivable; counterexample impossible |
| **`Nat.succ_add` Mathlib-only** | ✅ HIGH | — | — | — | — | **INVALID** — core theorem; project compiles |
| **Mat2.ext/ring broken in core** | ✅ HIGH | — | — | — | — | **INVALID** — current text hand-supplies `ext`, never calls `ring` |
| **LaTeX "ghost" cross-refs** | ✅ CRIT | — | — | — | — | **INVALID** — sections & labels retained |

---

## 8. What the peer reviews got right (highest-priority real findings, consolidated)

1. **CRITICAL — toolchain mismatch.** `README.md:108`, `NOTICE.md:10,43`, `lean_book/README.md:40`, `00-setup/02-installing-toolchain.md:29`, `00-setup/04-mathlib-note.md:45`, `learning-paths.md:60` all say `v4.33.0`; `lean_project/lean-toolchain:1` and `lakefile.toml:7` pin `v4.32.2`. Readers who follow the docs get a broken environment. **(mimo; ling denied it.)**
2. **CRITICAL — audience self-contradiction.** `README.md:34–37` / `lean_book/README.md:5–8` promise "no programming background"; `REPRODUCING.md:31–34` (step 2) mandates cutting "beginner-programmer explanations" for "readers who already have programming experience"; `REPRODUCING.md:126–129` (step 10) flips back to "zero prior exposure." **(ling, precisely; mimo, diffusely.)**
3. **HIGH — verification claim outruns evidence.** Root `README.md:98–100` ("every Lean snippet in the book (main text and solutions) is verified") and `README.md:107–110` ("every code block… one module per chapter") are falsified by: no `Ch12*` module; no appendix/solutions module; Ch 1's `Fin`/`Vec`/`pick`/`mySigma`/`dbg_trace` content; and the Ch 11 checkpoint blocks. The honest scoping sits in `lean_book/README.md:40–43` ("Chapters 1–11"). **(ling best; deepseek #6; north/laguna as fragments.)**
4. **MEDIUM — reproduction drift.** `REPRODUCING.md:15–17` tells authors to pin "the latest stable toolchain" / "latest release," guaranteeing a different build than the shipped v4.32.2. **(ling.)**
5. **LOW but real —** version citations in two reports are path-inaccurate (`mimo` "README.md:40" → `lean_book/README.md:40`; `mimo` "README.md:7" → `lean_book/README.md:7`); appendix numbering skips Ch 2 without a note (**deepseek**, correct); nav strips are inconsistent (**deepseek**, **mimo**).

## 9. The meta-finding

Three of the five reviewers (laguna, north, deepseek) manufacture citations that do not survive a single `sed`/`rg` — out-of-range lines, quotes transplanted from other files, and "actual outputs" asserted with no command run. One reviewer (ling) fabricated the verification log that *denied the biggest real bug in the repo*. The only independently verifiable cluster of true findings — the toolchain mismatch and the overclaimed verification scope — was caught in full by one reviewer (mimo for the former) and by the convergence of ling+deepseek+north+laguna for the latter. The lesson for the harness: findings that multiple reviewers reach independently (scope of the "verified" claim, audience contradiction) are gold; findings only one reviewer asserts, especially with precise-looking line numbers, are the likeliest to be invented.

<<<CRITIQUE_END>>>
