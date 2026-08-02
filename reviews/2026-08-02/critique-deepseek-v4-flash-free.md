<<<CRITIQUE_START>>>

# Cross-Critique: Five Peer Review Reports on *Lean for Working Algebraists*

**Method.** Every finding below was checked against the actual text (verified `file:line`, verbatim quotes) and, for tool-behavior claims, by executing Lean 4.32.2 (the pinned toolchain) directly. I attacked each report the way this skill requires: quote must exist, citation must resolve, claim must survive the text.

**Headline results, before the per-report sections:**
- The single most important discovery: **ling-3.0's "toolchain version hygiene is fine" finding is fabricated.** The actual files say `v4.33.0` in seven reader-facing places (README.md:108, NOTICE.md:10/43, lean_book/README.md:40, learning-paths.md:60, 00-setup/02-installing-toolchain.md:29, 00-setup/04-mathlib-note.md:45), while `lean_project/lean-toolchain` pins `v4.32.2`. **mimo's CRITICAL version-mismatch finding is correct; ling actively misreported the file contents.**
- **nemotron's entire findings list is invalid** — zero of its six cited findings survive contact with the text (two quoted non-existent sentences, two wrong file:lines, two refuted by the actual files).
- **north-mini's three central tool-behavior claims are all wrong.** I compiled the exact examples: `Nat.succ_add` IS in core Lean 4.32.2; `exact?` returns exactly the roundabout term the book quotes; and the book supplies `Mat2.ext` by hand. north-mini fabricated the "actual output is `h.symm`" claim.
- **laguna's two CRITICAL/HIGH findings are mischaracterized**: the `Path.length` deliverables exist in the book and appendix (only missing from `lean_project/`), and the `Submodule` definition is the standard one (negation is derivable; the cited counterexample is mathematically nonsensical).

---

## Report 1 — nemotron-3-ultra-free-math-theorems (Ch 3, 5, 6, 7)

| # | Finding | Verdict | Basis |
|---|---------|---------|-------|
| 1 | LOW: proof irrelevance conflates closed props with Σ at `01-prop.md:84-95` | **INVALID** | The quoted sentence "In Lean, a proof of `P ∧ Q` carries no more data…" does not exist. `rg "no more data|two proofs|carries no|same proposition"` over the entire Chapter 3 returns nothing. The actual text at 01-prop.md:84–95 is the Curry–Howard "Mathematical reading" ("up to proof irrelevance, has exactly one element"). The evidence is fabricated. |
| 2 | LOW: `Perm3` proof fields "don't matter" is wrong because `Perm3 : Type` | **INVALID** | The quote is real (06-groups/04-permutations-example.md:173–176) but the finding is mathematically backwards. `Perm3`'s proof fields `left_inv`/`right_inv` are `Prop`-valued (04-permutations-example.md:25–26), and in Lean proof irrelevance *does* make them irrelevant to structure equality — which is exactly why the book's `Perm3.ext` (line 138–145) closes with only the two function-equality goals. nemotron's own "fix" ("the whole record matters for equality of Group instances") states the opposite of Lean's actual semantics. |
| 3 | LOW: `intGroup.inv_left` uses `linarith` at `06-groups/03-integers-example.md:65-70` | **INVALID** | `linarith` appears **nowhere in the entire book** (`rg -n linarith .` over lean_book = zero hits). The cited lines are a Mathlib-equivalent block using `inferInstance`/`add_assoc`. Fabricated. |
| 4 | LOW: `rw [← mul_one a]` forward reference at `07-group-theorems/02-theorem-1.md:35-40` | **INVALID** | Lines 35–40 contain `rw [← step2]`, not `rw [← mul_one a]`. The `← mul_one b` rewrite lives in **03-theorem-2.md:72**, and `mul_one` there is a Mathlib lemma referenced via a loogle link, not a "not-yet-introduced" book lemma. Wrong file, wrong line, wrong characterization. |
| 5 | LOW: MyMonoid checkpoint lacks self-verification | **INVALID** | 05-rigor-check/06-checkpoint-project.md has an explicit "**Self-verification.**" section (lines 42–44) with the full `Monoid`/`listMonoid`/`monoid_id_unique` code and a `#check`. |
| 6 | LOW: ND table uses `∧I`/`∧E` without definition | **INVALID** | No `∧I`/`∧E` notation exists in 02-logic-recap.md (grep for `∧I|∧E|\land` = zero hits). The rules are written out in full LaTeX (⇒-elim, ⇒-intro, ¬-intro, ⊥-elim) each with a prose explanation. |
| 7 | LOW: "Lean's universe hierarchy is cumulative" unexplained at `05-rigor-check/02-universes.md:40-45` | **INVALID** | The word "cumulative"/"cumulativ" does not appear anywhere in 02-universes.md. Fabricated quote. |

**Report verdict.** All six findings fail the evidence bar; the report's "the mathematics is sound" summary is unfalsifiable padding. Its verification log ("`lake build` passes… 8677 jobs, 0 errors") is byte-identical to laguna's, a shared-figure red flag. This report contributes nothing usable to the Moderator.

---

## Report 2 — laguna-s-2.1-free-math-algebra (Ch 8–11)

| # | Finding | Verdict | Basis |
|---|---------|---------|-------|
| 1 | CRITICAL: `Path.length`/`Path.append_length` missing from `lean_project` | **PARTIAL** (fact true, impact false, severity inflated) | True: `rg "Path.length|append_length"` in Ch11PathAlgebras.lean returns nothing. But the "reader cannot self-verify" impact is false: the full definitions, proofs, `#eval` checks, and the entire self-verification block are in **11-path-algebras/07-checkpoint-project.md:50–75**, and a full worked solution is in **14-appendix-solutions/10-chapter-11.md:116–133**. The real (minor) harm is a README promise violation ("every code block in Chapters 1–11 ported"), not an unverifiable deliverable. Should be MEDIUM, not CRITICAL. |
| 2 | HIGH: `Submodule` omits `neg_mem` | **INVALID** | The actual structure (10-modules/04-submodules.md:18–23) bundles `zero_mem`, `add_mem`, **and** `smul_mem`. `neg_mem` is derivable via `smul_mem` with `r = -1` in any ring-with-module satisfying the module axioms — this is exactly Mathlib's own definition. The counterexample offered ("ℕ as ℤ-module: closed under +, contains 0, closed under •, but not closed under negation") is nonsense: ℕ is not a ℤ-module at all, and its negation-closure objection cannot arise for a submodule of an abelian-group-based module. |
| 3 | HIGH: Z-module axioms "asserted not proved" | **INVALID** | The book states the opposite of what laguna claims. 03-z-module-example.md:55–58 says the axiom check "is a genuine, if somewhat long, proof by induction… **The full verification is left as an extended exercise**," and lines 88–91 repeat it. The book does *not* claim to formalize the axioms (and there are no `sorry`s — grep confirms). The finding mischaracterizes a deliberate, disclosed exercise as an assertion, and ignores the uniqueness argument the chapter does give. |
| 4 | MEDIUM: zero ring silently permitted | **UNVERIFIED** | Legitimate general concern, but laguna cites no theorem that is actually false in the zero ring, and the book's proved theorems (`a·0=0`, `0·a=0`, sign rules) all hold there. Without a specific false statement this fails the evidence bar ("theorem technically false" is asserted, not demonstrated). |
| 5 | MEDIUM: circular `mul_zero_left` forward reference at `09-ring-theorems/02-theorem-1.md:55-60` | **INVALID** | The quoted sentence "Compare with `0 * a = 0`, which is not a base clause…" does not exist in the file. `mul_zero_left` is not mentioned in 02-theorem-1.md at all (grep: all hits are in 03-theorem-2.md, where it is *proved*, not referenced). The cited lines 55–60 contain the `congrArg` discussion. Fabricated evidence. |
| 6 | MEDIUM: `Mat2.mul_assoc` proved "by `rfl`" in Ch08Rings.lean | **INVALID** | Ch08Rings.lean:190–211 proves `mul_assoc` for `Mat2` with an explicit `apply Mat2.ext <;> … Int.mul_assoc` chain (≈20 lines), not `rfl`, and lines 164–166 explicitly discuss the 12-variable computation. |
| 7 | MEDIUM: `decide` mechanism unexplained | **INVALID** | Chapter 12's 02-decision-procedures.md does explain it ("A proposition `P` is `Decidable` when there is an algorithm that computes its truth value. In categorical terms…"). The cited location (03-z-module-example.md:85–90) is the Mathlib-equivalent block containing no `decide` at all. Wrong citation, contradicted substance. |
| m1 | LOW: CommGroup construction "repeated from Chapter 6" | **INVALID** | 08-rings/02-comm-group.md is ~25 lines using `extends Group` with one axiom. There is no repetition to extract. |
| m2 | LOW: "Chapter 7's `left_inverse_unique`" forward reference | **NOISE** | A normal cross-chapter reference in a book. |
| m3 | LOW: "`Path.length` is not defined in the chapter" | **INVALID** | The checkpoint's Milestone 1 (07-checkpoint-project.md:30) *asks the reader to define it*; that is the exercise. The self-verification block supplies it. |
| m4 | LOW: Fin 3 `decide` unexplained | **INVALID** | Same as finding 7 — the mechanism is explained in Ch 12. |

**Report verdict.** One partially-valid finding (Path.length absent from `lean_project/` — but for the wrong reason and at the wrong severity) out of eleven. The two headline findings are refuted by the text.

---

## Report 3 — north-mini-code-free-lean-code (Ch 1–4, 12)

| # | Finding | Verdict | Basis |
|---|---------|---------|-------|
| 1 | CRITICAL: Bloom verbs removed (v1.5.0 "implicit") | **UNVERIFIED / NOISE** | The v1.4.25 changelog confirms "Bloom verbs made implicit." But the current root README.md:59–63 documents this as a deliberate design ("never listed as explicit objectives, always embedded in the narrative flow"). This is relitigating a scoping decision, not a broken promise. Partially corroborated by mimo (see matrix). |
| 2 | CRITICAL: LaTeX "Story"/"Sections" removal leaves ghost refs | **INVALID (overstated)** | Changelog v1.5.0 confirms the heading removal but states (v1.5.0.md:28–29) that "The Markdown source is **unchanged**" and "All cross-references (`\hyperref` links) remain functional." The sections still exist in the compiled output; only the chapter-level TOC heading was stripped. "Section 3's `Vec.replicate`" (05-pi-sigma-and-coc.md:24) still resolves to Chapter 1 §3. The claimed harm ("point to nothing") is contradicted by the changelog's own words. |
| 3 | CRITICAL: `exact?` example reports wrong term (`h.symm` actual) | **INVALID — REFUTED BY COMPILATION** | I ran the book's exact example on the pinned toolchain. Lean 4.32.2 emits: `Try this: [apply] exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`. The book's comment (12-working-efficiently/01-search-tactics.md:33–35) states precisely this and explains that `h.symm` is the human-shorter form. **The book is right; north-mini's "verified" `h.symm` claim is fabricated.** |
| 4 | CRITICAL: `dbg_trace` examples have no lean_project file | **VALID (core)** | True: `rg "dbg_trace" lean_project/` returns zero hits, while root README.md:77–83 promises every recursive definition has a "`dbg_trace`-annotated sibling … verified against the real toolchain." That promise is unsubstantiated. (The sub-claim "some examples use `#reduce` where it prints nothing" is unverified.) |
| 5 | HIGH: `Vec.replicate` missing / signature mismatch | **PARTIAL** | True that `Vec`/`Fin`/`pick`/`mySigma` are absent from `lean_project/` (grep empty; Ch01Basics.lean is 24 lines). The "signature mismatch" half is unsupported — `(n : Nat) → Vec α n` is a coherent dependent type. |
| 6 | HIGH: `#print Fin` output unverified | **PARTIAL / WEAK** | Factually grounded (Fin isn't compiled) but purely speculative about toolchain drift. |
| 7 | HIGH: `Nat.succ_add` is Mathlib-only, proof fails in core | **INVALID — REFUTED BY COMPILATION** | `#check Nat.succ_add` succeeds in plain Lean 4.32.2 with **no Mathlib import**: `Nat.succ_add (n m : Nat) : n.succ + m = (n + m).succ`. It is a core theorem. The claim that "the proof fails to compile without Mathlib" is false. |
| 8 | HIGH: Ch 4 `simp` example "works by accident"; teaches `simp` as magic | **INVALID** | 04-tactics/04-more-tactics.md:14–20 explicitly warns that `simp` "hides *which* facts were used," states "This book avoids `simp` and `rfl`-as-a-shortcut," and cross-references Ch 12 §3 ("`simp`, now that you understand what it replaces"). The chapter does exactly the teaching north-mini claims it doesn't. |
| 9 | HIGH: book's `apply Mat2.ext` doesn't work in core Lean | **INVALID** | The book does not present broken code: 08-rings/07-matrices.md:33–44 defines `theorem Mat2.ext` by hand and explains *why* ("Core Lean 4 does not auto-generate a field-wise extensionality lemma…; we supply one by hand"). All call sites use the supplied lemma; no `ring` tactic appears in the markdown (the `ring` note in Ch08Rings.lean is a stale historical comment). |
| 10 | HIGH: `Ch03Propositions.lean` missing from lean_project | **INVALID** | The file **exists** (67 lines, compiled) and contains the chapter's code, including a documented fix for the book's `Nat.noConfusion` example. north-mini's summary item (2) and its Formalizer table are contradicted by the directory. (The `Ch01DependentTypes.lean` half is true.) |
| 11 | MEDIUM: `pick` uses `if b then Nat else Bool` vs `#check` shows `if b = true …` | **INVALID** | The markdown's own comment (05-pi-sigma-and-coc.md:62–66) *shows* the `#check` output `if b = true then Nat else Bool`; that is Lean's elaborated form and is correct. north-mini flags the book's own accurate annotation as a mismatch. |
| 12 | MEDIUM: `Vec.dot` uses `Vec Int n` but `Vec : (α : Type) → Nat → Type` | **INVALID** | `Vec Int n : Type` is exactly consistent with `Vec (α : Type) : Nat → Type`. There is no mismatch of any kind. |
| 13 | MEDIUM: Ch 12 decision-procedure guidance "gives no decision procedure" | **INVALID** | 02-decision-procedures.md:37–48 gives the decision rule (decidable fragment vs general structure) and explains `Decidable` via algorithms. |
| 14 | MEDIUM: `exact?`/`apply?` warning "no mitigation" | **INVALID** | 01-search-tactics.md:22–28 gives the mitigation: paste the concrete result rather than leaving the search tactic in the proof. |
| 15 | MEDIUM: term-vs-tactic contradicts Ch 4 | **UNVERIFIED** | No contradicting Ch 4 quote is cited. 04-term-vs-tactic-mode.md:8–22 is a reasonable tradeoff discussion. |
| n1–n5 | MINOR: "Section 4's untyped-λ-calculus recap" wrong section; `noncomm_ring` unexplained; Exercises not in story; `mypy --strict`; CT boxes assume glossary | **INVALID / NOISE** | (n1) Section 4 = 04-terminology.md, which **does** cover untyped λ-calculus (line 172). (n2) `noncomm_ring` is explained at 08-rings/07-matrices.md:340–346 and labeled "Ch. 8 (Mathlib equivalent)" in the reference. (n3) True but trivial (every chapter does this). (n4) vague, external. (n5) the book has a dedicated CT glossary (Ch 1 §4) and repeatedly links to it. |

**Report verdict.** Three of four CRITICALs are refuted by compilation or the changelog; the highest-value real finding (missing dependent-types / Ch12 code vs the README's "every code block … verified" claim) is corroborated by ling. Its confidence is inversely correlated with its accuracy.

---

## Report 4 — ling-3.0-flash-free-root-notice (README / NOTICE / CONTRIBUTING / REPRODUCING)

| # | Finding | Verdict | Basis |
|---|---------|---------|-------|
| 1 | (LOW) Toolchain version hygiene is fine; README.md:108 and NOTICE.md:10/43 read `v4.32.2` | **INVALID — FABRICATED** | The actual text reads **`v4.33.0`** at README.md:108, NOTICE.md:10, and NOTICE.md:43. ling's "read in full" verification log asserts file contents that do not exist. Worse, this finding *discourages* the one fix the book most needs: seven reader-facing files claim an unpublished toolchain (`v4.33.0`) against a `v4.32.2` pin. |
| 2 | CRITICAL: audience contradiction on programming background | **VALID** | Verified verbatim: README.md:34–37 "no prior exposure to Lean, formal logic, or programming" vs REPRODUCING.md:31–34 "mathematicians… who **already have programming experience** — cut beginner-programmer explanations," and REPRODUCING.md:126–129 (step 10) "zero prior exposure to programming." Three contradictory audience specs in one repo. Corroborated by mimo. |
| 3 | HIGH: "every code block… one module per chapter" false for Ch 12 | **VALID** | Root README.md:107–110 (every code block, one module per chapter, `lake build`-verified) vs `lean_project/LeanProject/` containing Ch01–Ch11 + Ch13CapstoneMathlib but **no Ch12 module**, while 12-working-efficiently/01-search-tactics.md:30–36 contains real Lean. |
| 4 | HIGH: verification-scope inconsistency between the two READMEs | **VALID** | Root README.md:98–99 ("every Lean snippet… main text and solutions… verified") vs lean_book/README.md:41 ("Every code block in **Chapters 1–11**…"). The broader claim is unsupported. |
| 5 | MEDIUM: REPRODUCING uses "latest stable toolchain" not the pin | **VALID** | REPRODUCING.md:15–17 verbatim; contradicts NOTICE.md:10 and the shipped `lean-toolchain` pin. |
| 6 | MEDIUM: REPRODUCING's own structure denies its "follow in order" claim | **PARTIAL (VALID but LOW severity)** | REPRODUCING.md:6–7 "following it in order" vs :22–23 "not one prompt" and steps 10–13 pre-labeled "a later session." Real tension, minor. |
| 7–11 | MEDIUM/LOW: two READMEs tell different spines; landing leads with legal links; "all 14 chapters" ambiguity; CONTRIBUTING lacks version number; title vs "introduction" framing | **NOISE** | All subjective/editorial preferences. On "14 chapters": chapters 0–13 *are* 14 chapters, so README.md:57 is internally consistent; the appendix being numbered "14" is a TOC formatting choice. ling itself calls several of these "harmless." |

**Report verdict.** Four genuine, evidence-backed findings (audience contradiction; Ch 12 scope; verification-scope inconsistency; toolchain-pin drift) — the strongest accuracy rate of the five — **but** its version-hygiene "clean result" is actively false and would steer the Moderator away from the book's most consequential defect.

---

## Report 5 — mimo-v2.5-free-prose-setup (Ch 0, 13 + reference files)

| # | Finding | Verdict | Basis |
|---|---------|---------|-------|
| 1 | CRITICAL: docs claim `v4.33.0`, actual toolchain `v4.32.2` | **VALID — the strongest finding in all five reports** | All four citations verified, and the mismatch is even broader than claimed: **seven** locations say `v4.33.0` (README.md:108; NOTICE.md:10,43; lean_book/README.md:40; learning-paths.md:60; 00-setup/02-installing-toolchain.md:29; 00-setup/04-mathlib-note.md:45) against `lean_project/lean-toolchain = leanprover/lean4:v4.32.2`, with changelog v1.4.25 documenting the bump *to* v4.32.2. A reader following the docs pins an unpublished version. |
| 2 | CRITICAL: "no programming background" promise broken by Setup jargon | **VALID (severity inflated)** | Verified: `uv` parenthetical at 02-installing-toolchain.md:10–11; "search 'leanprover elan install'" with no URL at :13–17; VS Code/extension/jargon at 03-editor.md. Mitigating: the `uv` remark is explicitly parenthetical and the install path is the official guide. Corroborated by ling's audience finding. Call it HIGH, not CRITICAL. |
| 3 | HIGH: Ch 0/Ch 13 stories fail to replace Bloom objectives | **PARTIAL / UNVERIFIED** | Quotes verified accurate (00-setup/00-index.md:7–13; 13-next-steps/00-index.md:7–19). But the conclusion is an editorial judgment about pedagogy that the book's own README.md:59–63 documents as deliberate ("never listed as explicit objectives"). Corroborated (weakly) by north-mini; both overstate. |
| 4 | HIGH: "Mathlib-free by design" claim is false | **INVALID as stated** | The very document cited discloses the dependency: 00-setup/04-mathlib-note.md:31–36 ("`lean_project` already has Mathlib installed as a dependency (it is what powers the 'Mathlib equivalent' boxes)"), and the "Mathlib-free" claims are immediately qualified in the same paragraphs (lean_book/README.md:63–73). No reader is misled. At most a LOW wording nit. |
| 5 | HIGH: Ch 13 "Aside: Church encodings" structurally incoherent | **NOISE** | The section is explicitly headed "### Aside: Church encodings" (03-next-projects.md:181) and follows the five scaffolded projects, each of which does have the template. An aside labeled as an aside is not a broken promise; re-scoping it is a preference. |
| 6 | MEDIUM: Socratic Q&A in 04-mathlib-note.md redundant | **NOISE** | The Q&A (lines 29–55) adds the version-pinning rationale and the "preview not replacement" distinction — not pure repetition. |
| 7 | MEDIUM: navigation strips inconsistent | **UNVERIFIED** | The specific evidence is wrong: 04-mathlib-note.md's bottom is 2 links + a "## Next" prose block, not the claimed 4-link strip. A weaker version (different files use 2- vs 3-link strips) is real. |
| 8 | MEDIUM: learning-paths graph/text mismatch | **PARTIAL (VALID-ish)** | Real numeric tension: prose says "two named paths… skip" + "the other two" (4 paths) while five named paths are listed and the graph draws three dashed edges. Genuine, if minor, inconsistency. |
| n1 | LOW: "path algebras… simple enough to build from scratch" unsubstantiated | **NOISE** | Editorial. |
| n2 | LOW: no direct elan URL | **VALID (small)** | Duplicates CRITICAL #2's sub-point. |
| n3 | LOW: v4.33.0 in Socratic Q3 | **VALID** | Duplicates CRITICAL #1. |
| n4 | LOW: absolute "Every other proof avoids `simp`" claim | **UNVERIFIED** | Plausible; the two exceptions (Ch 6 `Perm3.ext`, Ch 11 checkpoint) are exactly what 13-next-steps/01-what-we-built.md:22–25 names. |
| n5 | LOW: Loogle links untested | **NOISE** | Self-acknowledged as untested. |
| n6 | LOW: "Chapter 5 appendix's `MyGroup` (exercise 2)" references non-existent structure | **INVALID** | 14-appendix-solutions/04-chapter-5.md:38–51 contains exactly "2. `MyGroup` as a type class" with a `class MyGroup` and instance. The reference resolves. |
| n7/n8 | LOW: Thompson1991 broken; TPIL4 404s | **NOISE** | The bibliography *already documents both* (bibliography.md:69 and :71–72 flag the TLS failure and provide corrected URLs). mimo reports as news what the file already fixed. |
| n9–n11 | LOW: README editorial meta-history; dictionary duplication; notation-reference disclaimer | **NOISE** | Subjective. |

**Report verdict.** One CRITICAL that is fully vindicated and directly contradicted by a peer (ling), one valid audience finding corroborated by ling, and otherwise a high noise ratio (six findings relitigate deliberate design choices or re-report already-disclosed content).

---

## Cross-Review Corroboration Matrix

| Issue | Reviewers | Text verdict | Moderator tag |
|-------|-----------|--------------|---------------|
| `v4.33.0` docs vs `v4.32.2` pin (7 files) | mimo (CRITICAL, VALID); **ling (INVALID — denies it)** | 7 files say v4.33.0; toolchain = v4.32.2 | **CONFIRMED — highest priority.** ling's denial is actively harmful |
| Audience: "no programming background" vs "has programming experience" | ling (CRITICAL, VALID); mimo (CRITICAL, VALID) | README.md:37 vs REPRODUCING.md:31–34, 126–129 | **CONFIRMED (2 reviewers)** |
| No `Ch12` module despite "every code block / every snippet verified" | ling (HIGH, VALID); north-mini (missing-files, VALID) | No Ch12 in `LeanProject/`; README:107–110 + :98–99 overclaim | **CONFIRMED (2 reviewers)** |
| `dbg_trace` siblings promised "verified against real toolchain" but absent from `lean_project` | north-mini (CRITICAL, VALID core) | Zero `dbg_trace` in project vs README.md:77–83 | **SINGLE (VALID)** |
| Bloom objectives removed | north-mini (CRITICAL); mimo (HIGH) | Changelog confirms; root README documents as deliberate | **DISMISSED as fault / demoted to editorial note** (both overstate) |
| `exact?` output | north-mini: "actual is `h.symm`" (INVALID) | Compiled: book's quoted roundabout term is exactly what Lean returns | **Book correct; north-mini refuted** |
| `Nat.succ_add` Mathlib-only | north-mini (INVALID) | Compiled: in core Lean 4.32.2 | **Refuted** |
| `Path.length`/`append_length` absent from `lean_project` | laguna (CRITICAL, PARTIAL) | In book text + appendix; only missing from project | **SINGLE — demote to MEDIUM, re-scope as README-promise violation** |
| `Submodule` `neg_mem` | laguna (HIGH, INVALID) | Structure has zero/add/smul; negation derivable; counterexample nonsensical | **DISMISSED** |
| Verbatim quotes fabricated / wrong file:lines | nemotron (6/6), laguna (#5, #7), north-mini (#3, #7, #9, #11, #12) | Checked against text | **DISMISSED with bias flagged: nemotron's entire report; most of laguna; north-mini's tool claims** |

**Severity promotions per the Moderator role:** audience contradiction and Ch 12 / verification-scope are confirmed by two independent reviewers and stand. The version mismatch is confirmed by the text itself (seven citations) despite ling's dissent. Everything else in nemotron's report, most of laguna's, and north-mini's tool-behavior claims should be dismissed. The two reports with the strongest *tone* (nemotron, north-mini) have the weakest evidence; the two that found real faults (ling, mimo) are reliable in opposite directions on the version question.

**Bottom line for the Moderator:** the actionable set across all five reports is small — (1) fix the `v4.33.0`/`v4.32.2` mismatch in seven files, (2) reconcile the audience promise, (3) either add `Ch12WorkingEfficiently.lean` (+ dependent-types/dbg_trace code) or soften the "every code block verified" claims, (4) add `Path.length`/`Path.append_length` to `lean_project` to honor that same promise, and (5) drop roughly 30 of the 40+ findings the peers produced, which are fabricated, wrong-cited, or re-litigations of deliberate design choices.

<<<CRITIQUE_END>>>
