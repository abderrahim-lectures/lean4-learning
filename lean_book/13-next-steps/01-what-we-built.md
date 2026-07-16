## What we built

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)

---

Starting from `#eval` and `def`, this book built up, entirely from first
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

Nearly every proof in this book was written with explicit
`rw`/`have`/`intro` steps, each one marked with the axiom or prior theorem
that justified it, and no unexplained [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/). [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) itself is
used sparingly outside Chapter 12's own discussion of it, and only when a
genuine technical obstacle makes the explicit alternative not worth the
detour: Chapter 6's `Perm3.ext` reaches for `simp only [mk.injEq]` because
core Lean generates no field-wise extensionality lemma for a plain
`structure`, and Chapter 11's checkpoint project reaches for
`simp only [Path.append, Path.length]` because a match on an *indexed*
inductive type like `Path` reduces only through its equation lemmas, not
plain `rfl`, once an abstract path is involved. Both name only the exact
definitions being unfolded, standing in for a specific, known step rather
than an unknown pile of lemmas. Every other proof avoids `simp` entirely,
precisely to keep the discipline required for reading (or writing) a real
Lean library: when something goes wrong, the exact lemma responsible
should be identifiable.

---

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)
