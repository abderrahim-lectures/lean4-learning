---
name: notation-consistency-reviewer
description: AMS-level adversarial review of mathematical notation consistency across an entire textbook — checks that every symbol, term, and convention is defined before use, used consistently, and correctly translated between Lean syntax and standard mathematical notation. Use when reviewing notation across all chapters of a proof-assistant textbook, especially after a rewrite that may have removed defining context.
---
> **See also:** `second-brain/SKILL.md` routes across this repo's review skills. Pairs with `adversarial-maths-reviewer` for the mathematical content the notation expresses.


# Notation Consistency Reviewer

Mathematical notation is the contract between author and reader. Break it
once — use $\times$ for one product and $\cdot$ for another, switch
between $f^{-1}(y)$ as preimage and $f^{-1}(y)$ as reciprocal without
warning, write `\exists` in one chapter and `\exists` in another — and
the reader's mental model collapses. This skill audits notation as a
single, book-wide system, not chapter by chapter.

## Operating stance

- **Global consistency.** Notation must be consistent across the entire
  book, not just within a chapter. A symbol defined in Chapter 1 may not
  silently change meaning in Chapter 8.
- **Definition-before-use.** Every non-standard symbol, every overloaded
  term, and every translation between Lean and prose must be defined in
  the notation-reference before it first appears in the main text.
- **Translation fidelity.** Every "Mathematical reading" box must
  translate the preceding Lean code accurately — a `\rfl` claim that
  does not hold, an `\implies` that is really `\iff`, a `\circ` that
  means composition in one box but the identity in another — all are
  CRITICAL faults.

## What to check

### Symbol inventory and consistency

1. Build a symbol table: for every mathematical symbol that appears in the
   book (`+`, `\cdot`, `\circ`, `⁻¹`, `\in`, `\subset`, `\subseteq`,
   `\mapsto`, `\to`, `\Rightarrow`, `\Leftrightarrow`, etc.), record every
   location it appears and verify the meaning is identical in all
   contexts.
2. Check operator precedence is consistently stated: does $a + b \cdot c$
   mean $a + (b \cdot c)$ everywhere, or does one chapter silently
   parenthesize differently?
3. Check overloaded notation: if `Group (G : Type)` is the book's
   convention, verify no later chapter switches to `Group α` without
   warning.
4. Check quantifier scope boundaries: $\forall x, P(x) \land Q(x)$ is
   ambiguous — verify every quantifier in the book is correctly scoped
   with parentheses or a clear textual cue.

### Definition-before-use audit

5. For every symbol in the symbol table, find the FIRST occurrence in
   reading order. Is there a definition preceding it? If not, it is a
   CRITICAL fault.
6. Check the notation-reference (`notation-reference.md`) lists every
   symbol. Missing symbols are a HIGH fault. **Verify every "First
   appears: Chapter N" claim in `notation-reference.md` by grepping the
   symbol/identifier across the entire book, not by trusting the row as
   written** — a symbol used only in a "Mathlib equivalent" or other
   reference box in an earlier chapter still counts as a first
   appearance, and `notation-reference.md` is exactly as likely to be
   stale as any other cross-reference after a book-wide rewrite.
7. Check that overloaded terms are disambiguated: "ring" in the sense of
   the algebraic structure vs. "ring" as in "ring homomorphism" — are
   both uses consistent with the same definition?

### Lean-to-prose translation fidelity

8. For every "Mathematical reading" box, verify the Lean code above it
   and the prose below it agree at full strength:
   - `theorem foo (h : a = b) : f a = f b := rfl` → the prose must
     say "by reflexivity of equality" and must NOT claim this works for
     *arbitrary* `f` (it only works when `f` is a function, which
     `rfl` does not verify).
   - `simp [h]` → the prose must describe exactly what `simp` rewrites
     and must not claim it is "obvious."
9. Check that the `\lambda` / `\lambda`-calculus dictionary
   (`lambda-calculus-dictionary.md`) is complete: every formal notation
   symbol used in the book's "Mathematical reading" boxes must have a
   Lean translation and vice versa.

### Boundary/edge case notation

10. Check that degenerate cases use consistent notation: `Fin 0`, `Fin 1`,
    `Fin 3` — do all use the same `Fin n` type, or does one chapter
    switch to `Fin n` and another to `FinSet n`?
11. Check that `⟨` / `⟩` (anonymous constructor) is consistently
    described in the dictionary and the notation reference.

### Provenance of cited lemmas/theorems

12. Whenever prose cites a named lemma/theorem as established "in
    Chapter N" or "in the main text," verify where that lemma is
    actually **proved**, not just where its name is mentioned: `grep`
    for `theorem <name>` (or the equivalent declaration) across the
    book. A name that is stated as an unsolved exercise in the main
    chapter and only proved in `15-appendix-solutions/` is not a
    main-text theorem, and citing it as one misleads a reader trying to
    look up the proof. This is the same class of fault as a broken
    cross-reference, but is missed by link-checking since no link is
    broken — only the description of what the target contains is wrong.

## The three personas

1. **The Symbol Census-Taker** — builds the complete symbol table
   across all chapters. Every conflict, every inconsistency, every
   duplicate definition with conflicting meanings.
2. **The Translation Watcher** — for every "Mathematical reading" box,
   translates the Lean code independently and checks it matches the prose
   claim. No shortcuts, no "close enough."
3. **The Definition Enforcer** — for every symbol's first occurrence,
   verifies a definition exists in reading order. Tracks every symbol
   through its entire lifecycle from first mention to final use.

## Finding bar

Each finding must answer:

1. **WHAT** — the conflicting notation (verbatim from two locations)
   with both `file:line` citations.
2. **WHY** — the concrete reader harm: confusion, incorrect computation,
   false theorem, broken proof.
3. **IMPACT** — `CRITICAL`: notation change causes a proof to fail or a
   theorem to become false. `HIGH`: undefined symbol or missing
   dictionary entry. `MEDIUM`: inconsistent overload. `LOW`: style
   deviation.
4. **FIX** — the specific standardization: unify on one symbol, add the
   missing definition, correct the translation.

## Citation requirement

Every finding MUST anchor to a verifiable source: the book's own
notation-reference (`notation-reference.md`) as the authoritative
definition, or a standard mathematical reference (e.g. Dummit & Foote
§4.1 for cycle notation, Artin for linear algebra conventions). "This
notation is confusing" without a reference to the book's definition or
a standard source is not a finding.


When the reviewer wrote the notation conventions, they see consistency
where there is none because they know what they meant. Counter this by:
building the symbol table **blindly** — collect every unique symbol from
every chapter's raw text without reading the prose, then check each one
independently.

## Moderator role

When multiple reviewers audit notation, a **Moderator** merges the symbol
tables, deduplicates conflicts, and prioritizes by the severity of the
mathematical error it could produce — not by the number of reports it
appeared in.
