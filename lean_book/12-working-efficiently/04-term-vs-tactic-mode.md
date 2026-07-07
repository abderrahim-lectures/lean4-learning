## Term mode vs tactic mode

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)

---

Every tactic-mode proof compiles down to a term (Chapter 3's style); the
choice between them is about which is more *readable* for the given proof,
not a fundamental difference in power:

- Prefer **term mode** for short proofs that are naturally a single
  expression: `theorem foo := h.symm`, `theorem bar := ⟨x, hx⟩`. Chapter 6's
  one-line group-axiom proofs are a good example of where tactic mode
  (`by intro a; exact ...`) is arguably *more* verbose than the term
  `fun a => Int.add_assoc a b c` would have been.
- Prefer **tactic mode** once a proof involves several sequential
  steps, case splits, or induction — anything where you'd want to inspect
  an intermediate goal state while writing it. Chapters 6 and 8's
  multi-step `rw` chains would be unreadable (and much harder to *write*)
  as raw terms.
- `have`/`show`/`suffices` inside tactic mode let you name and restate
  intermediate goals — use them liberally to keep a long proof's shape
  legible, exactly as Chapters 6 and 8 did throughout.

---

[← simp](03-simp.md) | [Index](00-index.md) | [Next: Structuring lemmas for reuse →](05-structuring-lemmas.md)
