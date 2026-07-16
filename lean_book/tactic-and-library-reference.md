# Tactic and library reference

[Table of contents](README.md)

---

A quick index of every tactic used in this book, and every Mathlib name
used in the "Mathlib equivalent" boxes (Chapters 6-11), each with a link
to look it up yourself. This page is a lookup table, not something to
read start to finish — the tactics chapter ([Chapter 4](04-tactics/00-index.md))
and the working-efficiently chapter ([Chapter 12](12-working-efficiently/00-index.md))
are where each one is actually explained.

Two general links used throughout this page:

- **[Lean 4 Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)**
  — the official, current documentation for every built-in tactic.
- **[Loogle](https://loogle.lean-lang.org/)** — the Mathlib declaration
  search engine; `https://loogle.lean-lang.org/?q=NAME` jumps straight to
  a name. Also see the browsable **[Mathlib4 docs](https://leanprover-community.github.io/mathlib4_docs/)**.

## Tactics

| Tactic | First used | Reference |
| --- | --- | --- |
| `rfl` | Ch. 1 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `rw` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `exact` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `apply` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `intro` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `constructor` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `cases` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `induction` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `simp` | Ch. 4, Ch. 12 §3 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `unfold` | Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `decide` | Ch. 8, Ch. 12 §2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `show` | Ch. 6 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `have` | Ch. 7 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `refine` | Ch. 10 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `ext` / `funext` | Ch. 6, Ch. 10 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `congr` | Ch. 10 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `left` / `right` | Ch. 3, Ch. 4 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `use` | Ch. 3, Ch. 10 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `exact?` / `apply?` | Ch. 12 §1 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `omega` | Ch. 12 §2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `norm_num` | Ch. 12 §2 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |
| `noncomm_ring` | Ch. 8 (Mathlib equivalent) | [Loogle](https://loogle.lean-lang.org/?q=noncomm_ring) |
| `sorry` | Ch. 4 §3 | [Tactic Reference](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) |

## Mathlib names (Chapters 6-11's "Mathlib equivalent" boxes)

| Name | What it is | Reference |
| --- | --- | --- |
| `Group`, `AddCommGroup`, `CommGroup` | The real group/abelian-group classes | [Loogle: Group](https://loogle.lean-lang.org/?q=Group) |
| `Ring`, `CommRing` | The real ring classes | [Loogle: Ring](https://loogle.lean-lang.org/?q=Ring) |
| `Module`, `Submodule` | The real module/submodule classes | [Loogle: Module](https://loogle.lean-lang.org/?q=Module) |
| `LinearMap` (`→ₗ[R]`) | Module homomorphisms | [Loogle: LinearMap](https://loogle.lean-lang.org/?q=LinearMap) |
| `Quiver`, `Quiver.Path` | Mathlib's own quiver/path classes | [Loogle: Quiver](https://loogle.lean-lang.org/?q=Quiver) |
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
