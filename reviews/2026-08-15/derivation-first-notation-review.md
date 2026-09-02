# Notation Consistency Review — Post derivation-first Rewrite

**Reviewer:** notation-consistency-reviewer skill (independent verification pass)
**Scope:** `lean_book/notation-reference.md` as authority; full read of Chapters 01, 03, 05, 07, 09, 11, 13; targeted skim of Chapters 02, 04, 06, 08, 10, 12 for cross-references and terminology; book-wide grep sweeps for symbol/term drift.
**Trigger for this review:** all 16 chapters were rewritten book-wide into a derivation-first prose style — definitions/theorems are now motivated by a question before being formally named. This kind of large-scale reordering is exactly the change most likely to break definition-before-use discipline or leave stale cross-references behind.
**Method:** Three personas — Symbol Census-Taker, Translation Watcher, Definition Enforcer — applied against the sample, then every finding re-verified independently by reading the cited file:line directly (not taken on trust from any single pass).

---

## 1. Summary

The rewrite is largely clean. Definition-before-use discipline holds across all seven fully-read chapters: every named Lean identifier (`Group`, `CommGroup`, `Ring`, `Module`, `Submodule`, `LinearMap`, `DirectSum`) is formally defined before its first substantive (non-forward-pointer) use, and the new motivate-then-name structure does not smuggle in unexplained notation. Cross-references ("Chapter N, Section M") in live chapter content resolve correctly wherever checked.

One **CRITICAL** self-contradiction was found and independently confirmed: the rewrite left two "Mathematical reading" boxes in the same section that directly contradict each other about whether the `ring` tactic is available in this book. One **HIGH** finding concerns an unqualified "First appears" claim in `notation-reference.md` that is contradicted by "Mathlib equivalent" side-boxes using `≃`/`Equiv` two chapters earlier than stated. One **MEDIUM** finding concerns a theorem attribution (`neg_mul`) that points a reader to Chapter 10 main text for something that is actually only proved in the appendix.

**Verdict:** not a rubber stamp — real defects found — but the rewrite did not cause systemic notation drift. The book is publishable after the CRITICAL fix; the HIGH and MEDIUM items should be fixed before the next release but do not block reading comprehension.

---

## 2. Findings

### CRITICAL — Self-contradiction on `ring` tactic availability

**WHAT:** `lean_book/09-rings/07-matrices.md:287-290` states:

> "This book never imports Mathlib, so its `ring` tactic, a decision procedure for commutative-ring identities, is not actually available. An earlier draft of this section reached for it by mistake."

Thirty lines later, in the "Mathematical reading" box for the same construction, `lean_book/09-rings/07-matrices.md:317-320` states:

> "Associativity of $\times$ is the one substantial fact: $((XY)Z)_{i\ell} = \sum_{j,k} X_{ij}Y_{jk}Z_{k\ell} = (X(YZ))_{i\ell}$, whose per-entry form is a polynomial identity over the commutative ring $\mathbb{Z}$, so `ring` can close it."

**WHY:** The second passage repeats, in the reader's mind and within the same section, the exact error the first passage was inserted to correct — that `ring` is available and would close this goal. A reader who reads sequentially hits the correction, then 30 lines later hits the uncorrected claim again, undermining trust in the correction and leaving the actual status of the goal (closed by hand via `add4_reorder`, not by `ring`) ambiguous. This is precisely the kind of defect the rewrite's reordering of exposition would produce: the "Mathematical reading" box was evidently not reconciled with the correction box next to it during the pass that reworked the section.

**IMPACT:** CRITICAL — this is a live self-contradiction about tool availability in the book's own stated constraints (no Mathlib imports), not a subjective style issue.

**FIX:** Reword `07-matrices.md:320` from "so `ring` can close it" to something that does not claim tactic availability, e.g.: "so this is exactly the identity `ring` would close if Mathlib were imported — here it is discharged by hand via `add4_reorder`, as above."

### HIGH — `≃`/`Equiv` used ahead of its stated "First appears: Chapter 11"

**WHAT:** `lean_book/notation-reference.md:50` states, unqualified:

| Meaning | Math notation | Lean syntax | First appears |
|---|---|---|---|
| Isomorphism / equivalence | $A \simeq B$ | `A ≃ B` (`Equiv`) | Chapter 11 |

But `≃`/`Equiv` is used in "Mathlib equivalent" side-boxes well before Chapter 11:
- `lean_book/07-groups/04-permutations-example.md:169-186` — "`Equiv.Perm (Fin 3)`, the type of bijections `Fin 3 ≃ Fin 3`, is already a group..."
- `lean_book/07-groups/06-why-bundle.md:23,27`
- `lean_book/08-group-theorems/04-theorem-3.md:110`

**WHY:** `notation-reference.md` is the book's authoritative symbol dictionary and the skill's designated ground truth. An unqualified "First appears: Chapter 11" is a factual claim about the book's own text; it is false as written, since the symbol appears in Chapters 7 and 8. A reader consulting the reference to locate the symbol's origin, or checking it against the definition-before-use discipline the book advertises, will be misled. This looks like a side-effect of the rewrite spreading "Mathlib equivalent" cross-reference boxes more widely without updating the reference table's scope.

**IMPACT:** HIGH — undefined-by-the-table symbol usage (per the skill's rule 6: missing/inaccurate notation-reference entries are HIGH faults), though contained to clearly-labeled optional side-boxes rather than main narrative, which is a mitigating factor.

**FIX:** Either (a) scope the "First appears" column explicitly, e.g. "Chapter 11 (main narrative); earlier in 'Mathlib equivalent' boxes," or (b) change the Chapter 7/8 boxes to avoid `≃` notation and describe `Equiv.Perm` in prose only until Chapter 11 introduces the symbol formally.

### MEDIUM — `neg_mul` attributed to Chapter 10 main text, but only proved in the appendix

**WHAT:** `lean_book/13-working-efficiently/05-structuring-lemmas.md:11` groups `inv_op`, `neg_one_mul`, and `neg_mul` together as results "from Chapter 10." `inv_op` and `neg_one_mul` are genuine Chapter 10 main-narrative theorems. `neg_mul`, however, appears in Chapter 10 only as an unsolved exercise (`lean_book/10-ring-theorems/04-exercises.md:14`), with its proof appearing only in `lean_book/15-appendix-solutions/10-chapter-10.md:10`.

**WHY:** A reader who has not worked or read the appendix solution will not recognize `neg_mul` as an established fact when Chapter 13 cites it alongside two theorems that genuinely are proved in the main text — the citation implies parity of status that does not exist.

**IMPACT:** MEDIUM — inconsistent theorem-status attribution, not a notation error per se, but affects the same "definition/result before use" contract the skill is checking.

**FIX:** Reword the Chapter 13 citation to "`neg_mul` (Chapter 10 exercises, solved in the appendix)," or move a proof of `neg_mul` into Chapter 10's main narrative if it is meant to be treated as an established lemma from that point forward.

### LOW / Informational — not actionable findings, noted for completeness

- `lean_book/changelog/` contains historical entries with relative links to a pre-renumbering chapter scheme (e.g. `../05-rigor-check/`, `../13-next-steps/`, `../06-groups/`), which no longer match the current numbering. This is changelog history, not live chapter content, and out of scope for a notation-consistency review of the current text, but flagged in case a link-hygiene pass is planned.
- The verification pass did not do an exhaustive third grep sweep of every skimmed (non-full-read) chapter for `ring`/`simp`-availability misstatements beyond the one confirmed instance above; a follow-up targeted grep for `` `ring` `` and `` `simp` `` claims across Chapters 2, 4, 6, 8, 10, 12 would close this gap if a fully exhaustive audit is later required.

---

## 3. Checked and clean (explicitly verified, not just "not investigated")

- **Definition-before-use**, chapters 1, 3, 5, 7, 9, 11, 13 (full read): no violations found. Every named Lean identifier is formally defined before substantive use. Forward mentions are explicitly flagged in the prose as forward pointers (e.g. "Chapter 9 will..."), which is legitimate under the derivation-first motivate-then-name structure and not a definition-before-use fault.
- **Lean syntax vs. `notation-reference.md` table**, in all seven fully-read chapters: every code-block usage matches the table exactly, including deliberate absence of `⊕`/`≃` as infix operators in the book's own (non-Mathlib) code.
- **Cross-references** ("Chapter N, Section M" citations and relative markdown links) in live chapter content and chapter indices: checked via automated link resolution plus manual spot-checks; none found dangling or mis-numbered as a result of the rewrite.
- **Theorem-name cross-references** other than the `neg_mul` case above (`left_inverse_unique`, `inv_op`, `mul_zero`, `mul_zero_left`, `neg_one_mul`, the Huet 1980 / Newman's-lemma citation): all verified genuine and correctly located.

---

## 4. Recommendation

**Conditional accept.** Fix the CRITICAL `ring`-availability contradiction in `09-rings/07-matrices.md` before the next release — it is a direct, checkable falsehood sitting 30 lines from its own correction. Fix the HIGH `notation-reference.md` "First appears" scoping issue and the MEDIUM `neg_mul` attribution when convenient. No evidence of systemic notation drift from the derivation-first rewrite: the definition-before-use discipline the book advertises held up under an adversarial, independently-verified check across a broad chapter sample.
