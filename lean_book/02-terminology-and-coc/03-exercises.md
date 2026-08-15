## Exercises

[← Π/Σ-types and the calculus of constructions](02-pi-sigma-and-coc.md) | [Index](00-index.md)

---

**Key points.** `Prop` is proof-irrelevant, which is exactly why `∃`
(landing in `Prop`) cannot extract its witness the way `Sigma` (landing
in `Type`) can. Both Π- and Σ-types, plus `Prop`, assemble into the
calculus of constructions underlying every Lean declaration seen so far.
β-reduction is the computational engine underneath `rfl`/`#eval`, one
substitution step at a time.

1. State, as a general rule rather than by example, why `Σ n : Nat, Fin
   n` type-checks but `Σ n : Nat, n > 0` does not, even though `n > 0` is
   a perfectly good proposition about `n`. Prove the rule from the
   signature of `Sigma`.
2. `∃ x, P x` and `Σ x, P x` have exactly the same shape, a witness plus
   a proof. Prove that a witness cannot be extracted computationally from
   a proof of `∃ x, P x`, and identify exactly which fact about `Prop`
   the proof depends on.
3. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ to normal form by
   hand, writing out each step. The untyped-λ-calculus recap in Section 1 named
   $K = \lambda x.\lambda y.\, x$ ("take two arguments, return the
   first"). Which existing named term does $\lambda x.\lambda y.\, y\, x$
   resemble, and how does it differ?
4. Construct a term of type `Σ n : Nat, Fin n` other than the
   `⟨3, ⟨2, by decide⟩⟩` example given in the text. Then, in a sentence or two, explain why
   `Σ n : Nat, n > 0` fails to type-check in Lean at all (hint, check what
   *sort* `n > 0` lives in, and compare to the signature of `Sigma` itself).
5. The `Path Q : V → V → Type` of Chapter 12 was described as "a family of
   types indexed by a pair of vertices." Write down the Π-type expression
   $\prod_{x:A} B(x)$ instantiated so that it matches the signature of
   `Path.append`,
   `{u v w : V} → Path Q u v → Path Q v w → Path Q u w`
   (treat the implicit `{u v w : V}` as outer Π-binders). Identify $A$ and
   $B$ explicitly at each nesting level.

Solutions, [Appendix, Chapter 2](../15-appendix-solutions/02-chapter-2.md).

---

[← Π/Σ-types and the calculus of constructions](02-pi-sigma-and-coc.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 3: Functions & Structures →](../03-functions-and-structures/00-index.md)
