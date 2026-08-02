<<<CRITIQUE_START>>>

# Cross-Critique of Five Peer Reports (ling-3.0-flash-free, adversarial pass)

Verification method: every file:line claim was re-checked against the book sources under `/home/adrabi/dev/lean/lean4-learning/lean_book/` and `/home/adrabi/dev/lean/lean4-learning/lean_project/`. Where claims turned on actual Lean behavior, I ran the code with `lake env lean` on the pinned toolchain (Lean 4.32.2, Mathlib v4.32.2). Findings are graded VALID / UNVERIFIED / INVALID; "INVALID" covers fabricated quotes, citations pointing at the wrong text, and claims my direct runs contradicted.

---

## Report 1: `nemotron-3-ultra-free-math-theorems.md`

This report's verification log (build passes, no `sorry`, math recomputes) is accurate — I confirmed `lake build LeanProject` exits 0. But **every single finding it lists is INVALID**. Each is either fabricated, mis-cited, or contradicted by the text.

**1.1 Proof-irrelevance conflation (`01-prop.md:84-95`) — INVALID.**
The finding quotes "a proof of `P ∧ Q` carries no more data…" and "the proof itself is irrelevant… two proofs of the same proposition are definitionally equal." These strings do not exist anywhere in `03-propositions-and-proofs/01-prop.md` (grep for "carries", "irrelevant", "definitionally equal": zero hits in that file). Lines 84-95 are the Curry–Howard "Mathematical reading," which says only "every proposition's proof-set is either empty (false) or, up to proof irrelevance, has exactly one element (true)" — a correct statement confined to `Prop`. The `Prop`/`Σ` distinction the report wants is handled correctly in Chapter 1 §5 (`01-basics/05-pi-sigma-and-coc.md:248-294`). Fabricated evidence; the section attacked does not make the claim.

**1.2 `Perm3` proof fields "don't matter" (`06-groups/04-permutations-example.md:172-178`) — INVALID.**
The report quotes "The proof fields (`assoc`, `id_left`, etc.) don't matter…" and claims the book is wrong because `Perm3 : Type`. Two errors. (a) `Perm3`'s fields are `toFun`, `invFun`, `left_inv`, `right_inv` (lines 29-33); `assoc`/`id_left` are `Group` fields, so the report is quoting a structure that does not exist. (b) The book's claim is *correct*: the two `Prop`-valued fields are proof-irrelevant, so equality reduces to `toFun`+`invFun`, which the book's own `Perm3.ext` (lines 132-139) proves. I verified `Perm3 : Type` with Prop proof fields does not block `cases`+`mk.injEq`+`simp` — the book's proof is sound. The report attacks a strawman it misquotes.

**1.3 ND table uses undefined `∧I`/`∧E` (`02-logic-recap.md:105-110`) — INVALID.**
The file writes the rules as `($\wedge$-intro)`, `($\wedge$-elim)`, etc. (lines 83-106) — spelled out, with a prose definition of "introduction rule" and "elimination rule" (lines 76-80) and an explanation of how to read them (lines 109-125). No `∧I`/`∧E` abbreviation appears anywhere.

**1.4 "Universe hierarchy is cumulative" unexplained (`05-rigor-check/02-universes.md:40-45`) — INVALID.**
The string "cumulative" does not occur in that file (nor in the book outside a changelog). The cited lines discuss why `Type → Type : Type 1`, not cumulativity. The claim is invented.

**1.5 `intGroup.inv_left` uses `linarith` (`06-groups/03-integers-example.md:65-70`) — INVALID.**
`linarith` does not appear anywhere in the book (repo-wide grep: zero hits). The cited lines are the "Mathlib equivalent" box (zero_add/add_assoc), which uses no `linarith` either.

**1.6 `rw [← mul_one a]` forward reference (`07-group-theorems/02-theorem-1.md:35-40`) — INVALID.**
The proof at those lines is `rw [← step2]`, where `step2` is a local `have` from `Grp.id_right`; `mul_one` does not appear in the proof (and would be a ring lemma, inapplicable in a group chapter). The cited code does not exist.

**1.7 `MyMonoid` lacks self-verification (`05-rigor-check/06-checkpoint-project.md:15-20`) — INVALID.**
The file contains a full "**Self-verification.**" section (lines 43-71) with `structure Monoid`, `listMonoid`, and `monoid_id_unique`. The opposite of the claim.

---

## Report 2: `laguna-s-2.1-free-math-algebra.md`

**2.1 Checkpoint deliverables missing from `lean_project` (`11-path-algebras/07-checkpoint-project.md`) — PARTIALLY VALID.**
Verified: `Path.length`/`append_length` are not in `LeanProject/Ch11PathAlgebras.lean` (grep: no hits), so the README's claim that "Every code block in Chapters 1–11 has been ported… and verified with `lake build`" (lean_book/README.md:39-42) is indeed broken for the checkpoint's own self-verification block. But two components of the finding are false: (a) the checkpoint does **not** require proving `Path.append` associative — its Milestones 1-3 and Deliverable are `Path.length` and `Path.append_length` only; (b) the impact claim "reader cannot self-verify" is false — the full working solution is embedded in the checkpoint file itself (07-checkpoint-project.md:49-75) and again in the appendix (14-appendix-solutions/10-chapter-11.md:116-132). The real defect is a verification-gap, not a missing deliverable; CRITICAL is inflated, and the associativity sub-claim is fabricated.

**2.2 `Submodule` omits `neg_mem` (`10-modules/04-submodules.md:35-45`) — INVALID.**
The structure indeed has only `zero_mem`/`add_mem`/`smul_mem` (lines 56-60), but for modules over a *ring* this is complete: `(-1) • x = -x` follows from the module axioms, so `neg_mem` is derivable from `smul_mem` with `r := -1`. This is exactly Mathlib's own design (`Submodule` has no `neg_mem` field). The report's counterexample — "`ℕ` as `ℤ`-module" — is incoherent: ℕ is not an additive group, so it is not a module over anything. No gap exists; the math is wrong.

**2.3 `Z`-module axioms "asserted with `rfl` or `sorry`-equivalent" (`10-modules/03-z-module-example.md:22-28`) — INVALID.**
Contradicted on both counts. The concrete `intZModule` **is** fully verified in the book (04-submodules.md:51-61) with real proofs (`Int.mul_add`, `Int.add_mul`, `Int.mul_assoc`, `Int.one_mul`) — no `rfl`-stubs, no `sorry`. The general claim (every `CommGroup` is a `ℤ`-module) is *explicitly and transparently* "left as an extended exercise" (03-z-module-example.md:57-58, 88). The citation 22-28 is the `natSmul`/`intSmul` definitions, not the claim. The finding describes code that does not exist.

**2.4 Zero ring silently permitted — INVALID.**
No specific theorem in the book is shown to fail for the zero ring; the theorems actually proved (Chapter 9's `mul_zero`, sign rules) hold in the zero ring. Allowing `0 = 1` is standard textbook practice, and the report cannot name a broken promise. Speculative generality, per the triage gate.

**2.5 Forward reference to `mul_zero_left` (`09-ring-theorems/02-theorem-1.md:55-60`) — INVALID.**
The file never mentions `mul_zero_left` (which is defined in *03-theorem-2.md:32*) and never says "Compare with `0 * a = 0`… induction." Both quoted phrases are fabricated; nothing in 02-theorem-1.md is circular.

**2.6 `Mat2` `mul_assoc` proved by opaque `rfl` (`Ch08Rings.lean`) — INVALID.**
The proof is a multi-line explicit `rw` chain using `Int.add_mul`/`Int.mul_add`/`Int.mul_assoc`/`add4_reorder` over four `Mat2.ext` goals, in both the book (08-rings/07-matrices.md:195-228) and the project (Ch08Rings.lean:190-215). It is the opposite of an opaque `rfl`. (Line 79's `by decide` is the unrelated `Fin 3` ring.)

**2.7 `decide` mechanism unexplained (`10-modules/03-z-module-example.md:85-90`) — INVALID.**
No `decide` appears in that file (grep: zero hits in `10-modules/`). The book explains `decide`'s mechanism in Chapter 12 (12-working-efficiently/02-decision-procedures.md:12-14: "evaluates a `Decidable` proposition to `true`/`false` directly"), and its earlier uses (08-rings/05-finite-ring-example.md:31) explicitly defer to Chapter 12. The cited lines are wrong and the mechanism *is* explained.

**Minor items:** `CommGroup` repetition (preference, drop); `left_inverse_unique` "forward reference" is a *backward* reference that the report itself calls acceptable; `Path.length` "not defined in the chapter" is false (it is Milestone 1 of the checkpoint, 07-checkpoint-project.md:30-32).

---

## Report 3: `north-mini-code-free-lean-code.md`

The report's most important verified claims concern genuinely missing Lean files, but its flagship CRITICALs are empirically wrong.

**3.1 Bloom verbs removed (CRITICAL) — VALID (corroborated).**
Current chapter indexes (01-basics/00-index.md, 04-tactics/00-index.md) have "The story of this chapter" and no verb-driven objectives; changelog v1.4.25.md:25-36 documents the removal. Corroborated by mimo 3. Caveat: it was a deliberate, documented choice, so severity is editorial, not factual.

**3.2 LaTeX "Story"/"Sections" removed leaving ghost refs (CRITICAL) — INVALID.**
The v1.5.0 changelog explicitly states the Markdown is unchanged and only the LaTeX pipeline drops the two headings (changelog/v1.5.0.md:28). The cited "Section 3's `Vec.replicate`" (01-basics/05-pi-sigma-and-coc.md:24) points to Section 3, which still exists in both Markdown and the compiled book. The reference resolves; no ghost.

**3.3 `exact?` reports wrong term; "actual output is `h.symm`" (CRITICAL) — INVALID.**
I ran the exact example from the book (12-working-efficiently/01-search-tactics.md:30-36) on this toolchain: `lake env lean` with `import Mathlib` reports `Try this: [apply] exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`. That is precisely the book's claim. north-mini's "verified" correction is wrong, and its Block-Release condition #3 is based on a false premise.

**3.4 `dbg_trace` examples have no corresponding Lean files (CRITICAL) — VALID.**
`Ch01Basics.lean` is 24 lines covering only Chapter 1 §1-2; no file covers `03-dependent-types.md`/`05-pi-sigma-and-coc.md`, whose `dbg_trace` examples are real (01-basics/03-dependent-types.md:139-140, 272-274). The sub-claim about `#reduce` printing nothing is moot: the book's `dbg_trace` examples use `#eval`, and the `#reduce` caveat is itself discussed (01-basics/05-pi-sigma-and-coc.md:386-398).

**3.5 `Vec.replicate`/`Vec.dot` not in `lean_project` (HIGH) — VALID.**
Confirmed: `Vec`, `Fin`-structures, `pick`, `mySigma` are absent from `LeanProject/`. Signature quoted matches the book (03-dependent-types.md:121).

**3.6 `#print Fin` output unverified (HIGH) — VALID.**
No Lean file executes it; consistent with the missing-file gap.

**3.7 `Nat.succ_add` "doesn't exist in core Lean 4.32.2 / Mathlib-only" (HIGH) — INVALID.**
I ran a Mathlib-free file on this toolchain: `#check Nat.succ_add` succeeds (`Nat.succ_add (n m : Nat) : n.succ + m = (n + m).succ`) and the book's `my_add_comm` proof compiles without any import. It is core Lean. The Block-Release condition #2 is unnecessary.

**3.8 Ch4 `simp` example "works by accident" (HIGH) — INVALID.**
`n + 0 = n` via `simp` relies on the permanent core simp lemma `Nat.add_zero`; this is not an accident. And the book explicitly warns against `simp` in the same passage (04-tactics/04-more-tactics.md:16-21) and defers it to Chapter 12 — the report claims Ch4 doesn't warn when it does.

**3.9 `Mat2.ext` presented as non-working (HIGH) — INVALID.**
The book's comment (08-rings/07-matrices.md:28-32) says exactly that core Lean does not auto-generate `.ext`, and then *supplies* `Mat2.ext` with a complete proof (lines 33-39). No non-working code is presented; the report misreads a transparency note as a defect.

**3.10 Missing `Ch01DependentTypes.lean` and `Ch03Propositions.lean` (HIGH) — PARTIALLY VALID.**
The Chapter 1 dependent-types gap is real (VALID), and there is no Chapter 12 Lean file (VALID). But `LeanProject/Ch03Propositions.lean` **exists** (67 lines, matching Chapter 3 content). The headline claim "Chapter 3 (Propositions) has no lean file" — made twice, in the summary and the drift table — is false.

**3.11 `pick` `if b` vs `if b = true` (MEDIUM) — VALID (severity overstated).**
Verified by running `#check @pick`: it prints `if b = true then Nat else Bool` while the definition says `if b then…`. Real but cosmetic (elaboration pretty-printing); LOW, not MEDIUM.

**3.12 `Vec.dot` type mismatch (MEDIUM) — INVALID.** `Vec Int n` is a correct instantiation of `Vec (α : Type) : Nat → Type`; no contradiction is identified. Vague.

**3.13 Ch12 decision-procedures "gives no decision procedure" (MEDIUM) — INVALID.** The section explains each mechanism in prose (02-decision-procedures.md:12-29). Contradicted by the text.

**3.14 `exact?` env-change warning "no mitigation" (MEDIUM) — INVALID.** The text's mitigation is right there: "inspect what it suggests, and paste in the concrete result" (01-search-tactics.md:22-23).

**3.15 Term-vs-tactic contradicts Ch4 (MEDIUM) — INVALID.** No specific contradiction or file:line for "Ch 4" is given; the Ch12 file's claims are consistent with the book.

**Minors:** "Section 4's untyped-λ-calculus recap" is correct — the recap and the naming of `K` are in Section 4 (`04-terminology.md:82,121-122,160-173`) — INVALID; `noncomm_ring` *is* explained (08-rings/07-matrices.md:340-346) — INVALID; "category theory boxes without glossary" is false — a "Category-theory terms used beyond the baseline" glossary exists (04-terminology.md:235) — INVALID.

---

## Report 4: `deepseek-v4-flash-free-solutions.md`

**4.1 Ch1 Ex 4 solution is "Chapter 11 content, mislabeled and misplaced" (CRITICAL) — INVALID.**
The book's own Chapter 1 exercise 4 *asks for this*: "Chapter 11's `Path Q : V → V → Type` was described… Write down the Π-type expression… matches `Path.append`'s signature…" (01-basics/06-exercises.md:52-58). The appendix solution (01-chapter-1.md:88-107) answers that exercise exactly, citing "Chapter 1, Sections 3/5." It is a deliberate forward-looking exercise, not a copy-paste error. The report's evidence quote ("since it appears as an index into `Path` later") describes the intended content.

**4.2 Solutions overuse unexplained `rfl` (CRITICAL) — INVALID.**
The two cited cases are both explained. `nat_mul_zero` is followed by four lines explaining exactly why `rfl` works ("`Nat.mul` is defined by recursion on its second argument, and `n * 0 = 0` is the base clause" — 03-chapter-4.md:27-30, which I verified is correct in Lean). The `boolXorGroup` fields are followed by "Each field reduces to a finite check… `rfl` closes it" (05-chapter-6.md:45-51). These satisfy the appendix's own rule ("truly definitional and there is nothing left to explain," 00-index.md:8-10).

**4.3 `Bool.xor` should use `decide`/`ZMod 2` instead of `cases` (CRITICAL) — INVALID.**
For a finite type, exhaustive `cases` is the *more* explicit approach the book's style mandates; the report's suggested fix (`decide`) directly contradicts its own finding 4.7 complaining that `decide` appears unexplained. Internally contradictory, and "models the opposite of what the book teaches" is a preference, not a fault.

**4.4 Index numbering mismatch / "02-" for Chapter 3 (HIGH) — PARTIALLY VALID.**
The observation is accurate: the index lists Chapters 1,3,4…11 and file prefixes are `01-chapter-1.md`, `02-chapter-3.md`, etc. But Chapter 2 genuinely has no exercises (its index has only three sections, no Exercises file), so omitting it is correct; only the cosmetic `02-` prefix is at issue. LOW, not HIGH.

**4.5 No solutions for Chapter 12 (HIGH) — INVALID.**
Chapter 12 has no exercises at all (its index has five sections, no exercises file), so there is nothing to solve. The "dbg_trace comments" in the cited `exact?` block are also not present (01-search-tactics.md:30-36 is a plain `exact?` example).

**4.6 Appendix snippets lack `lean_project` modules (HIGH) — VALID.**
Confirmed: no `Ch14Appendix` or per-chapter solution module exists in `LeanProject/`; the appendix code is outside the build. Genuine verification gap (the sharper instance is the Chapter 11 checkpoint, laguna 2.1).

**4.7 Ch1 Ex 3 uses `by decide` unexplained (MEDIUM) — UNVERIFIED/WEAK.**
The observation is accurate (01-chapter-1.md:76), but the book's own Chapter 1 text uses `by decide` in the `mySigma` example (01-basics/05-pi-sigma-and-coc.md:186) without explanation. The appendix merely follows the main text; as an appendix-specific defect the finding is INVALID, as a book-wide note it is LOW. The report's claim that "Chapter 1 hasn't introduced `decide`" is true, but the main text has the same issue.

**4.8 Ch4 Ex 2 "confuses `rfl` with `Nat.mul_zero`" (MEDIUM) — INVALID.** The finding concedes the explanation is "mathematically correct"; my Lean run confirms `n * 0 = 0` closes by `rfl` and `0 * n = 0` does not, exactly as the appendix states. The "confusion" is a demand to add "in Lean's current definition" — a nitpick, self-described as correct.

**4.9 `inv_left`/`inv_right` discussion not demonstrated in code (MEDIUM) — INVALID.** The report calls the prose discussion correct, then faults the code for not duplicating a non-abelian distinction no exercise target supports. Asking for more content is a preference; it also double-counts finding 4.2's complaint about the same code.

**4.10 Ch3 solutions "trivial, don't test understanding" (MEDIUM) — INVALID.** Each solution carries a prose explanation, and Ex 3 even offers two alternative proofs (02-chapter-3.md:38-42). One-line term proofs *are* the explicit style for these exercises.

**4.11 Navigation strips inconsistent (LOW) — VALID.** Confirmed: `01-chapter-1.md:3` has 2 links, `03-chapter-4.md:3` has 3. Cosmetic, correctly graded LOW.

**4.12 `Vec.toList` uses `dbg_trace` "not introduced yet" (LOW) — INVALID.** `dbg_trace` is introduced and used throughout Chapter 1's main text (03-dependent-types.md:133-151).

**4.13 Σ/`Sort` terminology "from Chapter 5" (LOW) — INVALID.** Chapter 1's own key points and exercises use `Sort 0`/`Sort 1` (01-basics/06-exercises.md:26-28); the appendix is consistent with the chapter it belongs to.

---

## Report 5: `mimo-v2.5-free-prose-setup.md`

**5.1 Version mismatch v4.33.0 vs v4.32.2 (CRITICAL) — VALID.**
Confirmed at all four cited spots (lean_book/README.md:40, 00-setup/02-installing-toolchain.md:29, 00-setup/04-mathlib-note.md:45, learning-paths.md:60); `lean_project/lean-toolchain` = `leanprover/lean4:v4.32.2`. Independently documented as a known CRITICAL in AGENT_HANDOFF.md:14,55,69,87 and NEXT_AGENT_TODO.md:24. This is the strongest finding across all five reports.

**5.2 "No programming background" promise broken by setup jargon (CRITICAL) — VALID (severity arguable).**
Quotes check out: README.md:7 ("We assume no programming background"); 02-installing-toolchain.md:10-11 (`uv`, Python); 03-editor.md:7-14 (infoview, jump-to-definition, red squiggles, autocomplete); README.md:27-38 (Pandoc, Mermaid, extensions). A genuine audience-promise tension. I'd grade HIGH rather than CRITICAL (no fact is wrong; the audience is technically literate algebraists), but the finding is evidence-backed.

**5.3 Ch0/Ch13 narratives fail to replace Bloom objectives (HIGH) — VALID (corroborated with north-mini 3.1).**
Confirmed: indexes now carry only "The story of this chapter" (00-setup/00-index.md:8-13; 13-next-steps/00-index.md:8-19), with no measurable outcomes; changelog v1.4.25 confirms removal. The cognitive-level analysis is editorial, but the factual premise is solid and two reviewers agree.

**5.4 "Mathlib-free by design" claim false (HIGH) — INVALID/WEAK.**
The book qualifies the claim precisely where the report cites it: "Mathlib-free by design *through Chapter 11's from-scratch constructions*; Mathlib appears only in the 'Mathlib equivalent' boxes from Chapter 6 onward" (04-mathlib-note.md:24-27), and its own Socratic Q1/Q3 (lines 31-54) disclose that `lean_project` depends on Mathlib. README.md:63's bare wording is loose, but the reader is not misled by the setup chapter the report itself cites. Re-litigates a disclosed design choice.

**5.5 Ch13 "Aside: Church encodings" structurally incoherent (HIGH) — INVALID.**
The block is headed "### Aside:" (03-next-projects.md:181) — no reader "expects a 6th project." And the claim that "it assumes λ-calculus knowledge the book never teaches" is false: Chapter 1 §4 contains the untyped λ-calculus recap (04-terminology.md:82,160-173) and Chapter 1 exercises demand β-reduction. The aside even ends with a concrete check ("encode pairs… and check by hand that projecting… β-reduces correctly," lines 244-245). Placement is a preference.

**5.6 Socratic questions redundant (MEDIUM) — PARTIALLY VALID.**
Q1 and Q3 of 04-mathlib-note.md (lines 31-54) do re-cover points already made at lines 7-27, but Q2 (elan pinning) is new content. The "all three repeat" claim is overbroad; the redundancy that exists is real but LOW-MEDIUM.

**5.7 Navigation strips inconsistent (MEDIUM) — VALID.** Confirmed: 04-mathlib-note.md top has 2 links (line 3), bottom has 4 (line 62). Correctly observed; LOW severity.

**5.8 learning-paths misrepresents path equivalence (MEDIUM) — INVALID.**
The prose accounts for all five paths (two skip outright, two change *how*, plus the default full path) and explicitly explains why non-skipping paths have no edges ("so they have no edge of their own," learning-paths.md:43-44). "See real math fast" *does* have a graph representation — the dashed `C0 → C6` edge labeled "fastest path." The text is self-consistent; the finding misreads it.

**Minors:** #1 (path algebras "simple" unsubstantiated) — subjective, drop; #2 (no direct URL for elan install) — VALID, LOW; #6 ("Chapter 5 appendix's `MyGroup`") — INVALID, the reference resolves to 14-appendix-solutions/04-chapter-5.md, which contains "**2. `MyGroup` as a type class**"; #7/#8 — valid reports of the repo's own documented link failures; #9-#11 — placement/preference.

---

## Cross-Review Corroboration Matrix

| Finding | nemotron | laguna | north-mini | deepseek | mimo | My verification | Verdict |
|---|---|---|---|---|---|---|---|
| Version mismatch v4.33.0 vs v4.32.2 | – | – | – | – | ✅CRIT | AGENT_HANDOFF documents it | **CONFIRMED** |
| Bloom-verbs objectives removed | – | – | ✅CRIT | – | ✅HIGH | changelog v1.4.25; indexes lack objectives | **CONFIRMED** (deliberate, disclosed) |
| Lean code missing from build (Ch1 dep-types, Ch12, Ch11 checkpoint, appendix) | – | ✅CRIT | ✅HIGH | ✅HIGH | – | grep/ls: Ch03Propositions **exists**; Ch01 dep-types, Ch12, checkpoint, appendix **absent** | **CONFIRMED** (Ch3 sub-claim DISMISSED) |
| `exact?` actual output | – | – | ❌"h.symm" | – | – | I ran it: book is right | **DISMISSED** (contradicted by run) |
| `Nat.succ_add` Mathlib-only | – | – | ❌ | – | – | I ran it: core Lean | **DISMISSED** (contradicted by run) |
| Ch3 has no Lean file | – | – | ❌ | – | – | Ch03Propositions.lean exists | **DISMISSED** |
| LaTeX ghost refs / sections removed | – | – | ❌ | – | – | v1.5.0 changelog: markdown unchanged | **DISMISSED** |
| Mat2 `mul_assoc` via `rfl` | – | ❌ | – | – | – | explicit multi-`rw` proof | **DISMISSED** |
| Z-module axioms unverified | – | ❌ | – | – | – | `intZModule` verified (04-submodules.md:51-61) | **DISMISSED** |
| `Submodule` missing `neg_mem` | – | ❌ | – | – | – | derivable; ℕ counterexample incoherent | **DISMISSED** |
| `mul_zero_left` circular ref | – | ❌ | – | – | – | quote not in file | **DISMISSED** |
| Perm3 proof-irrelevance wrong | ❌ | – | – | – | – | book correct; `Perm3.ext` proves it | **DISMISSED** |
| Proof-irrelevance conflation | ❌ | – | – | – | – | quote not in file | **DISMISSED** |
| Ch1 Ex4 is misplaced Ch11 content | – | – | – | ❌CRIT | – | Ch1 exercise 4 asks for it | **DISMISSED** |
| Solutions overuse unexplained `rfl` | – | – | – | ❌CRIT | – | both cases explained | **DISMISSED** |
| No Ch12 solutions | – | – | – | ❌ | – | Ch12 has no exercises | **DISMISSED** |
| Audience-promise jargon (setup) | – | – | – | – | ✅ | quotes verified | **CONFIRMED** (severity debatable) |
| `dbg_trace`/`Vec`/`#print` unverified in lean_project | – | – | ✅ | – | – | files absent | **CONFIRMED** |
| Navigation-strip inconsistency | – | – | – | ✅LOW | ✅ | verified in both files | **CONFIRMED** (LOW) |
| Socratic Q&A redundancy | – | – | – | – | ✅ | Q1/Q3 repeat, Q2 is new | **CONFIRMED** (partial) |
| "Mathlib-free" claim false | – | – | – | – | ❌ | disclosed in-book | **DISMISSED** |
| Ch13 "Aside" incoherent | – | – | – | – | ❌ | labeled Aside; λ-calc taught Ch1 | **DISMISSED** |
| learning-paths misrepresentation | – | – | – | – | ❌ | text self-consistent; "fastest path" edge exists | **DISMISSED** |
| Zero-ring not excluded | – | ❌ | – | – | – | no theorem shown to break | **DISMISSED** (speculative) |

## Bottom line

- **Strongest surviving findings (CONFIRMED):** version mismatch (mimo 5.1), missing/absent Lean verification coverage for Ch1 dependent types + Ch12 + Ch11 checkpoint + appendix (north-mini 3.4/3.5/3.6/3.10, laguna 2.1, deepseek 4.6), Bloom-verb removal (north-mini 3.1, mimo 5.3), and the setup-chapter jargon against the "no programming background" promise (mimo 5.2).
- **Most dangerous reports:** `nemotron` is 7-for-7 invalid (every finding fabricated or misquoted). `north-mini` reaches a "BLOCK RELEASE" verdict on the strength of two empirically false claims (`exact?` output, `Nat.succ_add`) that I disproved by running the code.
- **Pattern:** free-tier reviewers repeatedly invent verbatim quotes to anchor findings (nemotron 1.1/1.2/1.5/1.6, laguna 2.5, north-mini 3.3). Per the skill's Moderator role, only the corroborated items above should reach the author; everything tagged DISMISSED should be dropped before it produces churn.

<<<CRITIQUE_END>>>
