<<<CRITIQUE_START>>>
# Cross-Critique: Peer Review Reports for *Lean for Working Algebraists*
**Reviewer:** laguna-s-2.1-free (adversarial cross-critique, per skills/adversarial-book-reviewer/SKILL.md)
**Method:** Every cited finding was checked against the actual files. Claims about Lean behavior were re-run against the pinned toolchain (`lean` 4.32.2, `/home/adrabi/.elan/bin/lean`). Verdicts: VALID (evidence-backed, correct citation, corroborated) / UNVERIFIED (plausible, needs check) / INVALID (contradicted by text or fabricated evidence).

Ground-truth facts established independently (cited throughout below):
- `lean_project/lean-toolchain` = `leanprover/lean4:v4.32.2`; `lakefile.toml` pins Mathlib `rev = v4.32.2`.
- The docs read `v4.33.0` in **six** places: README.md:108, NOTICE.md:10, NOTICE.md:43, lean_book/README.md:40, lean_book/00-setup/02-installing-toolchain.md:29, lean_book/00-setup/04-mathlib-note.md:45, lean_book/learning-paths.md:60.
- `lean_project/LeanProject/` contains `Ch01Basics.lean` (24 lines, no dependent types), `Ch03Propositions.lean` (67 lines, present), `Ch04Tactics.lean` (present), through Ch11 + `Ch13CapstoneMathlib.lean`; **no Ch12 module, no appendix module**.
- On Lean 4.32.2: `#check Nat.succ_add` succeeds (it is core, not Mathlib); `exact?` on `example (a b : Nat) (h : a = b) : b = a` reports `[apply] exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)` — exactly the term the book quotes.
- `grep -rn linarith lean_book/` returns **zero** matches. `grep -rn cumulative lean_book/05-rigor-check/` returns **zero** matches.
- `lean_book/01-basics/06-exercises.md:52-58` — Ch 1 Exercise 4 explicitly asks for `Path.append`'s signature as nested Π-types.
- `lean_book/14-appendix-solutions/04-chapter-5.md:38` — "**2. `MyGroup` as a type class**" exists.
- `lean_book/01-basics/05-pi-sigma-and-coc.md:186` — Ch 1 main text itself uses `by decide`.

---

## 1. nemotron-3-ultra-free-math-theorems.md

### LOW: Proof-irrelevance conflates closed propositions with Σ-types — `01-prop.md:84-95`
**INVALID.** The quoted text ("a proof of `P ∧ Q` carries no more data…", "two proofs of the same proposition are definitionally equal") does **not appear** at `01-prop.md:84-95`. Those lines are the Curry–Howard "Mathematical reading" paragraph about proof-sets and inhabitation (`01-prop.md:84-95`). The proof-irrelevance claim the reviewer is paraphrasing lives elsewhere (`01-basics/05-pi-sigma-and-coc.md:96-98`, `01-basics/06-exercises.md:32`). Moreover the book *does* distinguish `Prop` (proof-irrelevant, `05-pi-sigma-and-coc.md:93-112`) from `Σ` (witness-carrying, `05-pi-sigma-and-coc.md:114+`) in the same chapter — so the claimed conflation is not established even in substance. Fabricated citation + unsubstantiated pedagogical prediction. Uncorroborated.

### LOW: `Perm3` proof fields "don't matter" but `Perm3 : Type`
**INVALID.** The reviewer's own technical premise is wrong. `Perm3`'s proof fields are `left_inv : ∀ x, invFun (toFun x) = x` and `right_inv : …` (`06-groups/04-permutations-example.md:22-26`), i.e. **Prop-valued**. Proof irrelevance applies to Prop-typed fields regardless of whether the enclosing structure lives in `Type`; two `Perm3` records differing only in those fields are equal. The book's sentence ("the proof fields do not matter, by proof irrelevance", `04-permutations-example.md:176`) is correct, and `Perm3.ext` (`:132-139`) genuinely closes its proof-field goals via `mk.injEq`+rfl, which is exactly proof irrelevance at work. The reviewer misidentified a correct statement as an error.

### LOW: `intGroup.inv_left` uses `linarith` before its introduction — `06-groups/03-integers-example.md:65-70`
**INVALID.** `grep -rn linarith lean_book/` = zero matches in the entire book. `inv_left` is `exact Int.add_left_neg a` (`03-integers-example.md:27-30`); lines 65-70 are the Mathlib-equivalent `neg_add_cancel`/`add_neg_cancel` examples. The cited evidence does not exist.

### LOW: `rw [← mul_one a]` forward reference — `07-group-theorems/02-theorem-1.md:35-40`
**INVALID.** The proof at `02-theorem-1.md:33-38` uses `rw [← step2]` where `step2 : Grp.op e' Grp.id = e' := Grp.id_right e'`. `mul_one` appears only as a Mathlib-equivalent Loogle link name (`02-theorem-1.md:63`), never as `rw [← mul_one a]`. The finding describes code that is not in the book.

### LOW: `MyMonoid` checkpoint lacks self-verification — `05-rigor-check/06-checkpoint-project.md:15-20`
**INVALID.** The project is named `Monoid`, not `MyMonoid`, and it has an explicit **"Self-verification."** section with compilable Lean (`structure Monoid`, `listMonoid`, `monoid_id_unique`, `#check`) at `06-checkpoint-project.md:43-71`. The cited lines 15-20 are "Learning objectives." Both the name and the substance are wrong.

### Minor 1: ND table uses `∧I`/`∧E` undefined — `02-logic-recap.md:105-110`
**INVALID.** The notation is spelled out as `($\wedge$-intro)` inference-rule fractions (`02-logic-recap.md:83`), and the text explicitly explains the notation ("Each rule above is stated once so it can be pointed to by name… need not be memorized", `:115-118`). The cited lines 105-110 contain ¬-intro/⊥-elim, not ∧ rules.

### Minor 2: "universe hierarchy is cumulative" undefined — `02-universes.md:40-45`
**INVALID.** `cumulative` never appears in `05-rigor-check/` (grep zero). Lines 40-45 discuss `Group (G : Type)` and `Group Int : Type`, not cumulativity.

### Verification-log defect (not a book finding)
nemotron claims "All markdown Lean snippets match `lean_project/` … Ch 1…7 ✅". This is false for Chapter 1: `Ch01Basics.lean` (24 lines) contains none of the dependent-types material (`Fin`, `Vec`, `pick`, `mySigma`, `dbg_trace`) from `01-basics/03-dependent-types.md` and `05-pi-sigma-and-coc.md` (see §2). The "verified match" log is overstated.

**Net for nemotron:** 7/7 findings INVALID; the one solid contribution (lake build passes, math sound) is corroborated by north-mini and is a confirmation, not a finding.

---

## 2. north-mini-code-free-lean-code.md

### CRITICAL: Bloom verbs/learning objectives removed
**VALID fact; overstated severity.** The removal is confirmed by the changelog: "Removed the explicit '**Learning objectives.**' paragraph from every chapter's `00-index.md` (Chapters 0–13)" (`lean_book/changelog/v1.4.25.md:25-32`), corroborated by mimo (§5 HIGH #3). But the "violates constructive alignment / students cannot self-assess" framing re-litigates a documented deliberate design (root README.md:59-63 explicitly says objectives are "never listed as explicit objectives, always embedded in the narrative flow"), and the claim "**Every** chapter index lost them" is only true of chapter indices: the Ch 5 checkpoint (`06-checkpoint-project.md:16`) and all Ch 13 projects (`13-next-steps/03-next-projects.md`) still carry explicit "Learning objectives." Downgrade to MEDIUM; the fact is real, the crisis is not.

### CRITICAL: LaTeX "Story"/"Sections" removed → markdown "ghost refs"
**INVALID.** The v1.5.0 changelog states the change is "purely presentational… Markdown source is unchanged" and "All cross-references (`\hyperref` links)… remain functional" (`lean_book/changelog/v1.5.0.md`). Only the redundant `\section{Sections}` *enumerate* was removed from the PDF drivers; the sections themselves remain in the compiled output, and the story text retains its hyperlinked section list. "Section 3's `Vec.replicate`" (`05-pi-sigma-and-coc.md:24`) points at real section 3 of Ch 1 (`03-dependent-types.md`). No ghost references exist.

### CRITICAL: `exact?` example reports wrong term
**INVALID — refuted by direct execution.** On the pinned Lean 4.32.2, `exact?` on `example (a b : Nat) (h : a = b) : b = a` prints `[apply] exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)` — the *exact* term the book claims in its comment (`12-working-efficiently/01-search-tactics.md:33-35`). The book's "verified on this book's toolchain" claim is accurate; the reviewer's counterclaim ("actual output is `h.symm` (verified)") is false and is presented with no evidence.

### CRITICAL: `dbg_trace` examples have no lean_project counterpart
**PARTIALLY VALID.** Confirmed: `Ch01Basics.lean` (24 lines) contains no `Fin`/`Vec`/`pick`/`mySigma`/`dbg_trace` code, so the Chapter 1 trace examples are not compiled. The "some examples use `#reduce` where it prints nothing" sub-claim is unverified. The core gap (Ch 1 dependent-types material unported) is real. Corroborated by the directory listing.

### HIGH: `Vec.replicate` / `Vec` missing from lean_project
**VALID.** No `Vec` in any lean_project module. Same gap as above.

### HIGH: `#print Fin` output unverified
**VALID but trivial.** Follows from the missing dependent-types port; standalone it is a restatement.

### HIGH: `Nat.succ_add` "doesn't exist in core Lean 4.32.2"
**INVALID — refuted by direct execution.** `#check Nat.succ_add` on Lean 4.32.2 returns `Nat.succ_add (n m : Nat) : n.succ + m = (n + m).succ`. It is core Lean, not Mathlib. `Ch04Tactics.lean:62` and `04-tactics/05-worked-example.md:39` both compile. This also contradicts the reviewer's **own** summary ("The Lean code in `lean_project/` compiles cleanly") — the report contradicts itself.

### HIGH: `simp` example "works by accident"
**INVALID.** `Nat.add_zero` is a `[simp]` lemma in core Lean (`#check Nat.add_zero` succeeds); `simp` deterministically closes `n + 0 = n`. "Not guaranteed" is wrong; simp's behavior is fixed, not accidental.

### HIGH: Chapter 8 `Mat2.ext` note — "book presents non-working code"
**INVALID — misreads the text.** The book does not present broken code; it *supplies* the extensionality lemma by hand and says so: "Core Lean 4 does not auto-generate a field-wise extensionality lemma… we supply one by hand, using the `mk.injEq` lemma core Lean *does* generate" (`08-rings/07-matrices.md:28-36`). The code compiles (it is in `lean_project/`). The cited lines ("95-100") do not exist in the file.

### HIGH: Missing `Ch03Propositions.lean`
**INVALID.** The file **exists** (`lean_project/LeanProject/Ch03Propositions.lean`, 67 lines, compiles — it contains the `and_example`, `not_example`, `exists_even`, etc. examples and documents one compiler-found fix). Only the separate dependent-types port is missing. The "40+ Lean snippets unverified" number is therefore wrong.

### MEDIUM #11: `pick` "uses `if b then Nat else Bool` vs `#check` shows `if b = true`"
**INVALID.** `if b then` and `if b = true then` are the same elaborated term for `Bool`; the `#check` pretty-printer at `05-pi-sigma-and-coc.md:67` prints the elaborated form. Not a mismatch.

### MEDIUM #12: `Vec.dot` "uses `Vec Int n` but `Vec` defined as `Vec (α : Type) : Nat → Type`"
**INVALID.** `Vec Int n` is a correct instantiation of the type parameter `α := Int` of `Vec (α : Type) : Nat → Type` (`03-dependent-types.md:102, 242`). No mismatch exists.

### MEDIUM #13/#14 (decision-procedure guidance gives no procedure; `exact?` env-warning no mitigation)
**UNVERIFIED / weak.** No concrete reader harm or contradiction shown; these read as preference. Not corroborated.

### MEDIUM #15: term-vs-tactic-mode guidance "contradicts Ch 4"
**UNVERIFIED.** No specific Ch 4 quote is given; `12-working-efficiently/04-term-vs-tactic-mode.md:11-20` is internally coherent (term mode for short single-expression proofs, tactic mode for multi-step). A contradiction with Ch 4 is asserted, not demonstrated.

### LOW #1: "Section 4's untyped-λ-calculus recap" is wrong because "Section 4 is Terminology"
**INVALID.** Section 4 (`01-basics/04-terminology.md`) *does* contain the λ-calculus recap (`:82`, `:172-173`). The reference resolves. (Also, the reference is in the exercises file, `06-exercises.md:38`, not Socratic questions.)

**Net for north-mini:** 3 of its 4 CRITICALs are INVALID (exact?, ghost refs, Nat.succ_add), two HIGHs are INVALID (Ch03Propositions, Mat2.ext, simp). The genuinely valid items are the missing Ch 12 module, the missing dependent-types port, and the Bloom-verbs removal — the last two already covered better by ling/deepseek/changelog. This report's counterfactual Lean claims (exact?, Nat.succ_add) are the most damaging because they are confidently stated and demonstrably false.

---

## 3. deepseek-v4-flash-free-solutions.md

### CRITICAL #1: Ch 1 Ex 4 solution is "Chapter 11 content, mislabeled and misplaced"
**INVALID — refuted by the exercise itself.** Ch 1 Exercise 4 (`01-basics/06-exercises.md:52-58`) explicitly asks: "Chapter 11's `Path Q : V → V → Type` was described as 'a family of types indexed by a pair of vertices.' Write down the Π-type expression… so that it matches `Path.append`'s signature `{u v w : V} → …`… Identify $A$ and $B$ explicitly at each nesting level." The appendix solution (`01-chapter-1.md:88-107`) answers exactly this, and the solution's own prose anchors it to "Chapter 1, Sections 3/5" (`:107`). This is a deliberate forward-looking exercise, not a copy-paste error. The reviewer read the solution without reading the exercise it answers. This is the report's headline CRITICAL and it is wrong.

### CRITICAL #2: Solutions overuse `rfl`
**INVALID.** Every cited `rfl` is followed by an explicit justification. `nat_mul_zero`'s `rfl` (`03-chapter-4.md:24`) is explained at `:27-30` ("`Nat.mul` is defined by recursion on its second argument, and `n * 0 = 0` is the base clause"); the `boolXorGroup` `rfl`s (`05-chapter-6.md:18-42`) are justified at `:45-51` ("Each field reduces to a finite check… `rfl` closes it"). The appendix's own rule (`00-index.md:8-10`) permits `rfl` "when a step is truly definitional and there is nothing left to explain" — precisely the case here. "Unexplained `rfl`" is a mischaracterization.

### CRITICAL #3: `Bool.xor` uses `cases` instead of algebraic reasoning
**INVALID / preference.** The solution is explicit, explained, and matches the appendix style mandate. The proposed fix ("use `decide`") *contradicts* the appendix's own "avoid shortcuts" rule (`00-index.md:8-10`), and the book's main text uses exhaustive `cases`-style reasoning for finite instances throughout (`04-permutations-example.md:160-169`). "It trains readers to brute-force" is a pedagogical preference dressed as a fault (triage: re-litigating a deliberate, documented style).

### HIGH #4: appendix numbering mismatch
**PARTIALLY VALID, severity overstated.** The index (`00-index.md:14-23`) numbers sections 1-10 mapping to Chapters 1, 3, 4, …, 11 while files are `01-chapter-1.md`, `02-chapter-3.md`, …; Ch 2's absence is unexplained in the index. The observation is real, but "a reader may think the file is missing" is speculative (every filename spells out its chapter), and this is a LOW/MEDIUM navigation nit, not HIGH. The underlying "Ch 2 has no exercises" fact is confirmed.

### HIGH #5: No Ch 12 solutions
**VALID.** The appendix index stops at Chapter 11; Ch 12 contains runnable Lean (`12-working-efficiently/01-search-tactics.md:30-36`). Corroborated by north-mini and ling.

### HIGH #6: Solutions lack `lean_project` modules
**VALID.** No `Ch14Appendix` or per-chapter solution modules exist in `LeanProject/` (confirmed by directory listing).

### HIGH #7: Ch 1 Ex 3 `anotherSigma` uses `by decide` "before it's introduced"
**INVALID.** Ch 1's *main text* uses `by decide` (`05-pi-sigma-and-coc.md:186`, the `mySigma` example) and Ch 1's own exercises reference that example (`06-exercises.md:49`). A Ch 1 solution using `by decide` is consistent with the chapter's content, not a forward reference to a "Chapter 4 tactic."

### MEDIUM #8: `rfl` vs `Nat.mul_zero` explanation "misleading"
**INVALID/weak.** The explanation at `03-chapter-4.md:27-30` is correct for Lean 4's `Nat.mul` (recursion on second argument: `n * 0` is base, `0 * n` is not). Adding "in Lean's current definition" is a polish nicety, not a fault; the book's claim is accurate.

### MEDIUM #9: `inv_left`/`inv_right` discussion not demonstrated in code
**INVALID.** Ch 6 Exercise 2 is a paper exercise ("Verify on paper that `inv_left` and `inv_right` are genuinely…", `06-groups/07-exercises.md:45`); no Lean proof is required or expected. The solution (`05-chapter-6.md:53-67`) is a correct prose answer. The "missed pedagogical opportunity" is a preference.

### MEDIUM #10: Ch 3 solutions trivial
**INVALID.** Each Ch 3 solution (`02-chapter-3.md:7-44`) carries an explanation paragraph; the "no intermediate reasoning" claim is false, and the exercises themselves are trivially simple by design. The complaint targets exercise difficulty, not solution quality.

### LOW #11: Navigation strips inconsistent
**VALID.** `01-chapter-1.md:3` has two links; `03-chapter-4.md:3` has three. Real inconsistency, correctly rated LOW.

### LOW #12: `Vec.toList` uses `dbg_trace` before it's introduced
**INVALID.** `dbg_trace` is introduced in Chapter 1 Section 3 (`03-dependent-types.md:133-149`). A Ch 1 solution using it is not a forward reference.

### LOW #13: Σ/Fin explanation uses `Sort` terminology from "Chapter 5"
**INVALID.** Ch 1 Section 5 covers universes and `Sort` (the book itself says `Prop` is "formally named `Sort 0` in [Chapter 1, Section 5]", `03-dependent-types.md:338-339`; see also `05-pi-sigma-and-coc.md:451, 494`). The solution's terminology is in-chapter.

### LOW typo: `\mathbb{Z}/2` should be `\mathbb{Z}/2\mathbb{Z}`
**INVALID.** `Z/2` is standard shorthand; this is noise.

**Net for deepseek:** All three CRITICALs INVALID; the two strongest VALID items (#5, #6) duplicate north-mini/ling territory. The report's biggest error — calling a correct, well-placed answer to an existing exercise a "copy-paste from the wrong chapter's answer key" — indicates the solutions were critiqued without reading the exercise files.

---

## 4. ling-3.0-flash-free-root-notice.md

### (LOW) "Toolchain version hygiene is actually fine… all live references read `v4.32.2`"
**INVALID — directly contradicted by the files, and it contradicts a correct peer finding.** The live references read `v4.33.0`, not `v4.32.2`: README.md:108, NOTICE.md:10, NOTICE.md:43, lean_book/README.md:40, `00-setup/02-installing-toolchain.md:29`, `00-setup/04-mathlib-note.md:45`, `learning-paths.md:60`. The reviewer's own verification log asserts "`v4.32.2` live hits = README.md:108, NOTICE.md:10,43" — every one of those lines actually says `v4.33.0`. This is the single worst failure in the batch: the reviewer affirmed a clean bill of health on the exact defect that mimo correctly flagged as CRITICAL (see §5), and its log misquotes the version strings it claims to have read. A reader trusting this report would ship the reproducibility break.

### (CRITICAL) Audience contradiction
**VALID — this report's strongest finding.** README.md:34-37 ("no prior exposure to Lean, formal logic, **or programming**") vs REPRODUCING.md:31-34 ("mathematicians … who **already have programming experience** — cut beginner-programmer explanations") vs REPRODUCING.md:126-129 (re-flip to "zero prior exposure to programming"). All quotes verified verbatim. A genuine, unresolved contradiction in the repo's own sales pitch.

### (HIGH) "Every code block… one module per chapter" false for Chapter 12
**VALID.** Root README.md:107-110 promises "every code block from the book, ported into one module per chapter"; no `Ch12*` module exists; Ch 12 has real runnable Lean (`12-working-efficiently/01-search-tactics.md:30-36`). Corroborated by north-mini and deepseek.

### (HIGH) Verification-scope inconsistency between the two READMEs
**VALID.** Root README.md:98-100 ("every Lean snippet in the book (**main text and solutions**) is verified") vs lean_book/README.md:41 ("Every code block in **Chapters 1–11**"). The broader claim is unsupported.

### (MEDIUM) Reproduction steps use "latest stable toolchain"
**VALID.** REPRODUCING.md:15-17 ("the latest stable toolchain… pinned to the **latest release**") vs pinned `v4.32.2`. Compounds the version-drift problem ling otherwise missed.

### (MEDIUM) Repro doc structure denies its linear narrative
**VALID (minor).** REPRODUCING.md:6-7 ("following it in order… should reproduce a book") vs step 2 ("sequence these as separate follow-up instructions, not one prompt", `:22-23`) and the "later session"/"further session" labels on steps 10-13 (`:123,141,158,172`). A real, if small, editorial inconsistency.

### (MEDIUM) Two READMEs tell the spine in different voices
**UNVERIFIED.** The textual difference is real (root README.md:44-52 flat competency list vs lean_book/README.md:51-62 staged search-process arc), but "inconsistent branding" impact is speculative; this is an editorial judgment call, not a defect.

### (LOW) Landing page leads with legal/meta links
**UNVERIFIED / weak.** Placement (README.md:10 before Summary at `:32`) is real; "the first navigation the eye meets is administrative" is a preference, not a fault.

### Minor: "all 14 chapters" vs appendix numbered "14"
**INVALID.** Chapters 0-13 are 14 chapters; "all 14 chapters" (README.md:57) is accurate. The TOC labels the appendix explicitly ("**Appendix**" at lean_book/README.md:130; "14. Solutions to exercises" at `:132`). The "may infer 15 chapters" reader is manufactured.

**Net for ling:** The audience contradiction, Ch-12 gap, README-scope inconsistency, and toolchain-drift items are VALID and well-cited. But the version-hygiene finding is INVALID and actively dangerous (it denies the one true CRITICAL found by a peer), and the remaining LOW items drift toward preference.

---

## 5. mimo-v2.5-free-prose-setup.md

### CRITICAL #1: Version mismatch — docs claim `v4.33.0`, toolchain is `v4.32.2`
**VALID — the single most important finding in the whole batch.** Verified in six documents (root README.md:108, NOTICE.md:10/43, lean_book/README.md:40, `00-setup/02-installing-toolchain.md:29`, `04-mathlib-note.md:45`, `learning-paths.md:60`) against `lean_project/lean-toolchain` = `v4.32.2`, corroborated by the v1.4.25 changelog ("bumped from `v4.31.0` to `v4.32.2`", `changelog/v1.4.25.md:11`). A reader following Setup will pin a different toolchain than the one the code was verified against. Two minor citation defects: the quote "Code blocks are valid Lean 4 (toolchain `v4.33.0`, matching `../lean_project`)" is at **lean_book/README.md:40**, not root README.md:40; and "four occurrences" undercounts (there are six). Neither affects the substance.

### CRITICAL #2: "No programming background" broken by Setup jargon
**PARTIALLY VALID, severity overstated.** The jargon points are real (`00-setup/02-installing-toolchain.md:9-11` parenthetical about `uv`; `:13-17` "search 'leanprover elan install'"; `00-setup/03-editor.md` VS Code/extension assumptions), and the audience promise is real (lean_book/README.md:7-8, README.md:34-37). But the citation "README.md:7" is wrong (root README.md:7 is a download badge; the promise is at lean_book/README.md:7), the `uv` aside is a throwaway that doesn't strand the reader, and the sharper, fully documented statement of this contradiction is ling's (which adds REPRODUCING.md:31-34, the actual smoking gun). As a standalone "Setup is jargon-y," it is a real tension; as CRITICAL it is over-claimed.

### HIGH #3: Bloom objectives removed, narrative insufficient
**VALID fact; PARTIAL on fault.** Removal confirmed by changelog (`v1.4.25.md:25-32`), corroborated by north-mini. The cognitive-level analysis (Ch 0 story "missing apply/analyze/evaluate/create") is a framework applied to prose, i.e. a preference; the "story" sections are a documented deliberate replacement (root README.md:59-63).

### HIGH #4: "Mathlib-free by design" is false
**UNVERIFIED / largely INVALID as a fault.** The quote is real but at **lean_book/README.md:63-64**, not root README.md:63-65 (root README.md:63 is inside the "Chapter narratives" bullet). The book explicitly scopes the claim ("This book is Mathlib-free by design **through Chapter 11's from-scratch constructions**; Mathlib appears only in the 'Mathlib equivalent' boxes…", `04-mathlib-note.md:24`), and explicitly rebuts the alleged contradiction twice ("This isn't a contradiction of the from-scratch approach — it's a second, parallel track", lean_book/README.md:66-73; REPRODUCING.md step 12). This re-litigates a documented, deliberate framing (triage gate). The residue — that the companion project's lakefile *requires* Mathlib while the pitch says "from scratch" — is a fair wording quibble, not HIGH.

### HIGH #5: Ch 13 "Aside: Church encodings" structurally incoherent
**UNVERIFIED / weak.** The Aside is explicitly labeled "**Aside:**" (`03-next-projects.md:181`); asides are definitionally not projects and need no deliverable. "The book never teaches λ-calculus" is questionable (Ch 1 Ex 1 is β-reduction; the book ships a `lambda-calculus-dictionary.md`), and the Aside defines its own encodings from scratch (`:190-234`). Editorial preference.

### MEDIUM #6: Socratic questions in `04-mathlib-note.md` repeat the main text
**PARTIALLY VALID / preference.** The Q&A at `04-mathlib-note.md:29-55` does re-cover ground from `:7-27`, but "Socratic questions" is a documented recurring device (root README.md:89-91), so the redundancy is by-design reinforcement, not an editorial slip.

### MEDIUM #7: Navigation strips inconsistent
**VALID.** Top strip (2 links) vs bottom strip (4 links) differ (`04-mathlib-note.md:3` vs `:60-62`). Corroborates deepseek's nav-strip finding in a different file.

### MEDIUM #8: learning-paths graph misrepresents path equivalence
**INVALID — the text explains exactly what the reviewer says is missing.** `learning-paths.md:40-43` states: dashed arrows are "the two named paths below that actually skip material outright… the other two named paths change *how* a chapter is read, not which chapters are read, so they have **no edge of their own**." The graph's dashed edges match the two skip-paths ("already know Lean", "fastest path"); the how-paths are edge-free *by the text's own design*. The reviewer's "five paths vs two dashed" mismatch is resolved by the sentence immediately above the graph's description. Misread.

### Minor 1 (`01-why-lean.md:13-15` "simple enough to build from scratch" unsubstantiated): UNVERIFIED — a judgment call, arguably fair for path algebras of *finite* quivers; hostile-reader puffery.
### Minor 2 (no direct elan URL): VALID but trivial — real, easily fixed.
### Minor 3 (mathlib-note.md:45 `v4.33.0`): VALID — subset of CRITICAL #1.
### Minor 4 (`01-what-we-built.md:22-25` "simp only in Ch 6 and 11" fragile): UNVERIFIED — actual wording is "used sparingly outside Chapter 12's own discussion of it," which holds roughly (simp counts: Ch 4 = 9, Ch 6 = 1, Ch 10 = 1, Ch 11 = 3, Ch 13 = 4 vs Ch 12 = 23); the "only Ch 6 and 11" paraphrase is not the book's claim.
### Minor 5 (Loogle links untested): honest UNTESTED — fine.
### Minor 6 ("Chapter 5 appendix's `MyGroup` (exercise 2)" doesn't exist): **INVALID** — `14-appendix-solutions/04-chapter-5.md:38` contains "**2. `MyGroup` as a type class**"; the reference resolves.
### Minor 7-11 (bibliography link health, editorial-pass history, dictionary duplication, notation meta-commentary): preference items; the link-health findings are documented *in the bibliography itself* as known-broken, so the "finding" restates the book's own disclaimer.

**Report-quality defect:** mimo's "Surviving Strengths" section is duplicated verbatim (lines 167-179 and 181-192) — the report repeats itself; a sign of unchecked generation that the other four do not share.

**Net for mimo:** One true CRITICAL (version mismatch — VALID, and the batch's most valuable finding), two VALID facts (Bloom removal, nav strips), and a long tail of INVALID/overstated items (learning-paths, Church-encodings aside, `MyGroup` ref, Mathlib-free). Its win rate is low but its one hit outweighs several peers' misses.

---

## Cross-Review Corroboration Matrix

| # | Finding | nemotron | north-mini | deepseek | ling | mimo | My verification | Adjudicated |
|---|---------|:--:|:--:|:--:|:--:|:--:|---|:--:|
| 1 | Docs say `v4.33.0`, toolchain pins `v4.32.2` | — | — | — | **DENIED** (called clean) | CRITICAL | 6 docs vs lean-toolchain | **CONFIRMED** — ling wrong |
| 2 | Ch 12 runnable Lean, no Ch12 module | — | CRITICAL | HIGH #5 | HIGH | — | dir listing + file | **CONFIRMED** (3x) |
| 3 | No appendix solutions in `lean_project/` | — | — | HIGH #6 | — | — | dir listing | **CONFIRMED** (single) |
| 4 | Ch 1 dependent-types material unported | — | CRITICAL/HIGH | — | — | — | Ch01Basics 24 lines | **CONFIRMED** (single) |
| 5 | Bloom-verbs objectives removed | — | CRITICAL | — | — | HIGH #3 | changelog v1.4.25 | **CONFIRMED** (2x + changelog) |
| 6 | Audience contradiction (no-programming vs has-programming) | — | — | — | CRITICAL | CRITICAL | README vs REPRODUCING verbatim | **CONFIRMED** (2x) |
| 7 | `exact?` output | — | says book WRONG | — | — | — | **ran Lean 4.32.2: book RIGHT** | **REFUTED** — north-mini false |
| 8 | `Nat.succ_add` is Mathlib-only | — | HIGH | — | — | — | **ran Lean 4.32.2: it is core** | **REFUTED** — north-mini false |
| 9 | `Ch03Propositions.lean` missing | — | HIGH | — | — | — | file exists | **REFUTED** — north-mini false |
| 10 | Ch 1 Ex 4 solution is misplaced Ch-11 content | — | — | CRITICAL | — | — | exercise 4 exists at 06-exercises.md:52 | **REFUTED** — deepseek false |
| 11 | `Perm3` proof-irrelevance claim wrong | LOW | — | — | — | — | fields are Prop; claim correct | **REFUTED** — nemotron false |
| 12 | `linarith` used before Ch 12 | LOW | — | — | — | — | zero `linarith` in book | **REFUTED** — nemotron false |
| 13 | `MyMonoid` lacks self-verification | LOW | — | — | — | — | "Self-verification." section exists | **REFUTED** — nemotron false |
| 14 | `MyGroup` appendix ref broken | — | — | — | — | Minor 6 | 04-chapter-5.md:38 | **REFUTED** — mimo false |
| 15 | learning-paths graph "misleading" | — | — | — | — | MEDIUM | text self-explains at :40-43 | **REFUTED** — mimo false |
| 16 | `Vec.toList` uses `dbg_trace` too early | — | — | LOW #12 | — | — | dbg_trace introduced in Ch 1 §3 | **REFUTED** — deepseek false |
| 17 | Nav strips inconsistent | — | — | LOW #11 | — | MEDIUM #7 | verified in 2 files | **CONFIRMED** (2x, LOW) |
| 18 | Ch 2 no exercises (appendix skips it) | — | — | HIGH #4 | — | — | Ch 2 has no exercises file | **CONFIRMED** — but severity overstated |
| 19 | Verification-scope inconsistency (READMEs) | — | — | — | HIGH | — | README:98 vs lean_book README:41 | **CONFIRMED** (single) |
| 20 | REPRODUCING uses "latest stable" toolchain | — | — | — | MEDIUM | — | REPRODUCING:15-17 | **CONFIRMED** (single) |

## Triage summary
- **Genuine, fix-ready findings (all CONFIRMED):** version mismatch `v4.33.0` vs `v4.32.2` (mimo — the only reviewer to get it right; ling actively denied it); Ch 12 missing from `lean_project/` and from the appendix; Ch 1 dependent-types material unported; Bloom-verb removal (fact, low urgency); audience contradiction (ling's formulation is the best); README verification-scope inconsistency; nav-strip drift; Ch 2 numbering nit.
- **Peer findings refuted by direct execution of the pinned toolchain:** north-mini's `exact?` and `Nat.succ_add` claims (both false — the book is right on both).
- **Peer findings refuted by reading the files they cite:** nemotron 7/7 (fabricated quotes, nonexistent `linarith`/`mul_one`/`cumulative`, misnamed checkpoint), deepseek's CRITICAL #1-#3 and most HIGHs, mimo's learning-paths/`MyGroup`/Mathlib-free.
- **Most dangerous peer claim:** ling's "toolchain version hygiene is fine." It is the exact inverse of the truth and would suppress the one CRITICAL defect, which every other reader of the actual files would trip on.
- **Meta-observation:** all five reports reviewed the book; only ling and mimo read the root documents, only deepseek read the appendix, and only north-mini actually ran claims against the toolchain — but the two reviewers who ran/read code produced the most false confidence (north-mini's invented counter-evidence, nemotron's fabricated quotes). The version mismatch is the highest-value finding and was found by the reviewer who made the least pretension to verification.

<<<CRITIQUE_END>>>
