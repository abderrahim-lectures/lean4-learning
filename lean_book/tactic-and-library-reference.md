# Tactic and library reference

[Table of contents](README.md)

---

A quick index of every tactic used in this book, and every Mathlib name
used in the "Mathlib equivalent" boxes (Chapters 7-12), each with a link
to look it up yourself. This page is a lookup table, not something to
read start to finish. The tactics chapter ([Chapter 5](05-tactics/00-index.md))
and the working-efficiently chapter ([Chapter 13](13-working-efficiently/00-index.md))
are where each one is actually explained.

Two general links used throughout this page:

- **[Lean 4 Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)**,
  the official, current documentation for every built-in tactic.
- **[Loogle](https://loogle.lean-lang.org/)**, the Mathlib declaration
  search engine; `https://loogle.lean-lang.org/?q=NAME` jumps straight to
  a name. Also see the browsable **[Mathlib4 docs](https://leanprover-community.github.io/mathlib4_docs/)**.

## Tactics

| Tactic | First used | Reference |
| --- | --- | --- |
| `rfl` | Ch. 1 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `rw` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `subst` | Ch. 2, Section 1 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `exact` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `apply` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `intro` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `constructor` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `cases` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `induction` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `simp` | Ch. 5, Ch. 13, Section 3 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `unfold` | Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `decide` | Ch. 9, Ch. 13, Section 2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `show` | Ch. 7 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `have` | Ch. 8 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `refine` | Ch. 11 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `ext` / `funext` | Ch. 7, Ch. 11 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `congr` | Ch. 11 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `left` / `right` | Ch. 4, Ch. 5 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `use` | Ch. 4, Ch. 11 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `exact?` / `apply?` | Ch. 13, Section 1 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `omega` | Ch. 13, Section 2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `norm_num` | Ch. 13, Section 2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `noncomm_ring` | Ch. 9 (Mathlib equivalent) | [Loogle](https://loogle.lean-lang.org/?q=noncomm_ring) |
| `sorry` | Ch. 5, Section 3 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |

## Binder & definition styles

Every way Lean has of binding an argument or introducing a definition, and
where each is actually explained end to end (not just first mentioned).

| Syntax | What it is | First explained |
| --- | --- | --- |
| `(x : α)` | Explicit argument, supplied positionally | Ch. 1, Section 2 |
| `{x : α}` | Implicit argument, solved by unification | Ch. 1, Section 2 |
| `[x : C]` | Instance-implicit argument, solved by typeclass search | Ch. 1, Section 2 (named) / Ch. 6, Section 1 (in use) |
| `{{x : α}}` | Strict-implicit argument, deferred until an explicit argument follows; not used in the own code of this book | Ch. 1, Section 2 |
| `def` | Semi-reducible definition; unfolds only when told to (`unfold`) | Ch. 1, Section 2 (named) / Ch. 5 (transparency) |
| `let` | Local, definitionally transparent definition | Ch. 1, Section 2 |
| `abbrev` | Reducible definition, auto `@[reducible, inline]`, seen through automatically | Ch. 1, Section 2 (named) / Ch. 5 (in depth) |
| `opaque` | Never unfolds, even explicitly; hides an implementation entirely | Ch. 1, Section 2 (named) / Ch. 5 (in depth) |
| `@[reducible]` | Attribute form of the transparency `abbrev` gets automatically, applied to an existing `def` | Ch. 4, Section 6 (in use) / Ch. 5 (explained) |
| `def f : A → B` (equation-style body) | Pattern-matches the last argument(s) directly, one equation per case, instead of naming them in `(...)` | Ch. 1, Section 3 |

## Mathlib names (the "Mathlib equivalent" boxes of Chapters 7-12)

| Name | What it is | Reference |
| --- | --- | --- |
| `Group`, `AddCommGroup`, `CommGroup` | The real group/abelian-group classes | [Loogle: Group](https://loogle.lean-lang.org/?q=Group) |
| `Ring`, `CommRing` | The real ring classes | [Loogle: Ring](https://loogle.lean-lang.org/?q=Ring) |
| `Module`, `Submodule` | The real module/submodule classes | [Loogle: Module](https://loogle.lean-lang.org/?q=Module) |
| `LinearMap` (`→ₗ[R]`) | Module homomorphisms | [Loogle: LinearMap](https://loogle.lean-lang.org/?q=LinearMap) |
| `Quiver`, `Quiver.Path` | The real quiver/path classes of Mathlib | [Loogle: Quiver](https://loogle.lean-lang.org/?q=Quiver) |
| `ZMod` | $\mathbb{Z}/n\mathbb{Z}$ | [Loogle: ZMod](https://loogle.lean-lang.org/?q=ZMod) |
| `Matrix` | Matrices over a ring | [Loogle: Matrix](https://loogle.lean-lang.org/?q=Matrix) |
| `Equiv.Perm`, `Equiv.swap`, `finRotate` | Permutation group of a type | [Loogle: Equiv.Perm](https://loogle.lean-lang.org/?q=Equiv.Perm) |
| `mul_assoc`, `add_assoc` | Associativity | [Loogle: mul_assoc](https://loogle.lean-lang.org/?q=mul_assoc) |
| `one_mul`, `mul_one`, `zero_add`, `add_zero` | Identity laws | [Loogle: one_mul](https://loogle.lean-lang.org/?q=one_mul) |
| `neg_add_cancel`, `add_neg_cancel`, `mul_inv_cancel` | Inverse laws | [Loogle: mul_inv_cancel](https://loogle.lean-lang.org/?q=mul_inv_cancel) |
| `mul_inv_rev` | $(ab)^{-1}=b^{-1}a^{-1}$ | [Loogle: mul_inv_rev](https://loogle.lean-lang.org/?q=mul_inv_rev) |
| `neg_one_mul`, `mul_zero`, `zero_mul` | Ring absorbing/sign laws | [Loogle: neg_one_mul](https://loogle.lean-lang.org/?q=neg_one_mul) |
| `mul_add`, `add_mul` | Distributivity | [Loogle: mul_add](https://loogle.lean-lang.org/?q=mul_add) |
| `Submodule.span`, `Submodule.subset_span` | Generated submodules | [Loogle: Submodule.span](https://loogle.lean-lang.org/?q=Submodule.span) |
| `LinearMap.fst` | Product-module projection | [Loogle: LinearMap.fst](https://loogle.lean-lang.org/?q=LinearMap.fst) |
| `inferInstance` | Typeclass-resolution term | [Loogle: inferInstance](https://loogle.lean-lang.org/?q=inferInstance) |

---

[Table of contents](README.md)
