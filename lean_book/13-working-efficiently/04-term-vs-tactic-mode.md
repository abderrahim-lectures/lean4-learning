## Term mode vs tactic mode

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)

---

Every tactic-mode proof compiles down to a term (the style of Chapter 4). The
choice between them is about which is more *readable* for a given proof,
not a real difference in power.

- **Term mode** is preferable for short proofs that are naturally a single
  expression: `theorem foo := h.symm`, `theorem bar := ⟨x, hx⟩`. The
  one-line group-axiom proofs of Chapter 7 are a good example of where tactic mode
  (`by intro a; exact ...`) is arguably *more* verbose than the term
  `fun a => Int.add_assoc a b c` would have been.
- **Tactic mode** is preferable once a proof involves several steps in a
  row, case splits, or induction, anything where checking an
  intermediate goal state while writing is desirable. The multi-step
  [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chains of Chapters 8 and 10 would be hard to read (and much harder to *write*) as raw
  terms.
- `have`/`show`/`suffices` inside tactic mode allow naming and restating
  intermediate goals. These should be used freely to keep the shape of a long proof clear,
  exactly as Chapters 8 and 10 did throughout.

---

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)
