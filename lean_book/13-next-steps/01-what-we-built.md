## What we built

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)

---

Starting from `#eval` and `def`, we built up, entirely from first
principles (no external library):

- a general `Group` structure, with theorems proved for an arbitrary group
  (uniqueness of identity, uniqueness of inverses, $(ab)^{-1} = b^{-1}a^{-1}$),
- a `CommGroup` extending `Group`,
- a `Ring` structure built on top of `CommGroup`, with theorems for an
  arbitrary ring ($a \cdot 0 = 0$, $(-1)\cdot a = -a$), plus a genuinely
  noncommutative example ($2\times 2$ matrices),
- a `Module` over a ring, with submodules, linear maps, and direct sums,
- a `Quiver` and an indexed inductive `Path` type, with path composition,
  as the combinatorial skeleton underlying a path algebra.

Every proof in this book was written with explicit `rw`/`have`/`intro`
steps, each one marked with the axiom or prior theorem that justified it.
There is no [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), and no unexplained [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/). This is exactly the
discipline you need to carry into reading (or writing) a real Lean
library: when something goes wrong, you should be able to point at the
exact lemma responsible.

---

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)
