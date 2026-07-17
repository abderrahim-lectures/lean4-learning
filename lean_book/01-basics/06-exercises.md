## Exercises

[← Π/Σ-types and the calculus of constructions](05-pi-sigma-and-coc.md) | [Index](00-index.md)

---

**Key points.** `#check` reports a type without running anything; `#eval`
runs. A type is *dependent* when a later type mentions an earlier
*value* (`Vec α n`, `Fin n`), not merely an earlier type. `Prop` is
proof-irrelevant, which is exactly why `∃` (landing in `Prop`) cannot
extract its witness the way `Sigma` (landing in `Type`) can. Both Π- and
Σ-types, plus `Prop`, assemble into the calculus of constructions
underlying every Lean declaration seen so far.

1. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ to normal form by
   hand, writing out each step. §4's untyped-λ-calculus recap named
   $K = \lambda x.\lambda y.\, x$ ("take two arguments, return the
   first"). Which existing named term does $\lambda x.\lambda y.\, y\, x$
   resemble, and how does it differ?
2. Write `Vec.toList : Vec α n → List α`, converting a length-indexed
   vector to an ordinary list by forgetting its length. Contrast its type
   with `Vec.replicate`'s from §3: which one is a genuinely *dependent*
   function (its return type mentions the argument's value), and which
   one is an ordinary function that merely happens to take a value of a
   dependent type as input?
3. Construct a term of type `Σ n : Nat, Fin n` other than the text's
   `⟨3, ⟨2, by decide⟩⟩` example. Then, in a sentence or two, explain why
   `Σ n : Nat, n > 0` fails to type-check in Lean at all (hint: check what
   *sort* `n > 0` lives in, and compare to `Sigma`'s own signature).
4. Chapter 11's `Path Q : V → V → Type` was described as "a family of
   types indexed by a pair of vertices." Write down the Π-type expression
   $\prod_{x:A} B(x)$ instantiated so that it matches
   `Path.append`'s signature
   `{u v w : V} → Path Q u v → Path Q v w → Path Q u w`
   (treat the implicit `{u v w : V}` as outer Π-binders). Identify $A$ and
   $B$ explicitly at each nesting level.

Solutions: [Appendix, Chapter 1](../14-appendix-solutions/01-chapter-1.md).

---

[← Π/Σ-types and the calculus of constructions](05-pi-sigma-and-coc.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](../02-functions-and-structures/00-index.md)
