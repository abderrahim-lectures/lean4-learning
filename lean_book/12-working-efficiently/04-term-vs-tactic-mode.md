## Term mode vs tactic mode

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)

---

Every tactic-mode proof compiles down to a term (Chapter 3's style). The
choice between them is about which is more *readable* for a given proof,
not a real difference in power:

- **Term mode** is preferable for short proofs that are naturally a single
  expression: `theorem foo := h.symm`, `theorem bar := ⟨x, hx⟩`. Chapter
  6's one-line group-axiom proofs are a good example of where tactic mode
  (`by intro a; exact ...`) is arguably *more* verbose than the term
  `fun a => Int.add_assoc a b c` would have been.
- **Tactic mode** is preferable once a proof involves several steps in a
  row, case splits, or induction — anything where checking an
  intermediate goal state while writing is desirable. Chapters 6 and 8's multi-step
  [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chains would be hard to read (and much harder to *write*) as raw
  terms.
- `have`/`show`/`suffices` inside tactic mode allow naming and restating
  intermediate goals. These should be used freely to keep a long proof's shape clear,
  exactly as Chapters 6 and 8 did throughout.

---

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)
