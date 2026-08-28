## What we built

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)

---

Starting from `#eval` and `def`, this book built up, entirely from first
principles (no external library), the following.

- A general `Group` structure, with theorems proved for an arbitrary group
  (uniqueness of identity, uniqueness of inverses, $(ab)^{-1} = b^{-1}a^{-1}$).
- A `CommGroup` extending `Group`.
- A `Ring` structure built on top of `CommGroup`, with theorems for an
  arbitrary ring ($a \cdot 0 = 0$, $(-1)\cdot a = -a$), plus a genuinely
  noncommutative example ($2\times 2$ matrices).
- A `Module` over a ring, with submodules, linear maps, and direct sums.
- A `Quiver` and an indexed inductive `Path` type, with path composition,
  as the combinatorial skeleton underlying a path algebra.

Nearly every proof in this book was written with explicit
`rw`/`have`/`intro` steps, each one marked with the axiom or prior theorem
that justified it, and no unexplained [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/). [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) itself is
used sparingly outside the discussion of it in Chapter 13, and only when a
genuine technical obstacle makes the explicit alternative not worth the
detour. `Perm3.ext` in Chapter 7 reaches for `simp only [mk.injEq]` because
core Lean generates no field-wise extensionality lemma for a plain
`structure`, and the checkpoint project of Chapter 12 reaches for
`simp only [Path.append, Path.length]` because a match on an *indexed*
inductive type like `Path` reduces only through its equation lemmas, not
plain `rfl`, once an abstract path is involved. Both name only the exact
definitions being unfolded, standing in for a specific, known step rather
than an unknown pile of lemmas. Every other proof avoids `simp` entirely,
precisely to keep the discipline required for reading (or writing) a real
Lean library, when something goes wrong, the exact lemma responsible
should be identifiable.

**Programmer note (Python).** Every Programmer note in this book
made the same comparison, once per chapter, against one concrete
Python failure mode, a `KeyError` from an untyped `dict`, an `assert`
that only ever ran the inputs it happened to see, a `float` silently
breaking associativity, a hand-checked graph invariant nobody remembered
to enforce everywhere. None of those bugs are exotic. Each is a bug a
working Python programmer has hit, or will hit. The pattern behind all
of them is the same one, some invariant is true "by convention," known
to the author, documented in a comment or a docstring at best, and
checked, if at all, only at the specific call sites someone thought to
guard. `Group`, `Ring`, `Module`, and `Path` in this book took the
opposite approach at every step, each invariant, associativity, the
identity laws, connectivity of a path, was written as a *type*, so that
building a value of that type is the same act as proving the invariant
holds. The habitual question a Python programmer has to ask, "did I
remember to check this everywhere it matters," simply does not arise
for anything proved this way. It was checked once, by the type checker, at the one
place the value was constructed, and every later use of it inherits
that guarantee for free. This is the actual case for functional,
statically typed languages like Lean, not that they make correct
programs easier to write in the small, but that they make entire
categories of bug, the ones coming from an invariant nobody remembered
to check, structurally unable to compile in the first place.

---

[← Index](00-index.md) | [Next: Moving to Mathlib →](02-moving-to-mathlib.md)
