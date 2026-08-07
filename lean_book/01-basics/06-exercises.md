## Exercises

[← Π/Σ-types and the calculus of constructions](05-pi-sigma-and-coc.md) | [Index](00-index.md)

---

**Key points.** `#check` reports a type without running anything. `#eval`
runs. A type is *dependent* when a later type mentions an earlier
*value* (`Vec α n`, `Fin n`), not merely an earlier type. `Prop` is
proof-irrelevant, which is exactly why `∃` (landing in `Prop`) cannot
extract its witness the way `Sigma` (landing in `Type`) can. Both Π- and
Σ-types, plus `Prop`, assemble into the calculus of constructions
underlying every Lean declaration seen so far.

**Socratic questions.**

1. *The return type of `Vec.replicate` mentions the value of its `Nat` argument. A
   plain function like `Nat.succ` does not. Is the type of `Nat.succ`,
   `Nat → Nat`, therefore *not* a Π-type?* It still is. `∀ n : Nat, Nat`
   is a Π-type whose body happens not to mention the bound variable. Every
   ordinary function type is a Π-type in the degenerate case. "Dependent"
   describes the *interesting* instances, not a separate kind of arrow.
2. *`Σ n : Nat, Fin n` type-checks, but `Σ n : Nat, n > 0` does not, even
   though `n > 0` is a perfectly good proposition about `n`. What is the
   one-sentence reason, stated as a rule rather than an example?*
   The second component of `Sigma` must be `Type`-valued, and `Prop` is a
   different universe (`Sort 0`) from `Type` (`Sort 1` and up). No
   proposition, however true, is itself a `Type`.
3. *`∃ x, P x` and `Σ x, P x` have exactly the same shape, a witness plus
   a proof. What is lost by writing the existential instead of the
   Sigma?* Extractability. `Exists` lives in `Prop`, and proof
   irrelevance means two proofs of the same proposition are
   indistinguishable to the kernel, so there is no way to pull the
   witness back out computationally, only to use it inside another proof.
   The witness of `Sigma`, landing in `Type`, has no such restriction.

1. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ to normal form by
   hand, writing out each step. The untyped-λ-calculus recap in Section 4 named
   $K = \lambda x.\lambda y.\, x$ ("take two arguments, return the
   first"). Which existing named term does $\lambda x.\lambda y.\, y\, x$
   resemble, and how does it differ?
2. Write `Vec.toList : Vec α n → List α`, converting a length-indexed
   vector to an ordinary list by forgetting its length. Contrast its type
   with the type of `Vec.replicate` from Section 3. Which one is a genuinely *dependent*
   function (its return type mentions the value of the argument), and which
   one is an ordinary function that merely happens to take a value of a
   dependent type as input?
3. Construct a term of type `Σ n : Nat, Fin n` other than the
   `⟨3, ⟨2, by decide⟩⟩` example given in the text. Then, in a sentence or two, explain why
   `Σ n : Nat, n > 0` fails to type-check in Lean at all (hint: check what
   *sort* `n > 0` lives in, and compare to the signature of `Sigma` itself).
4. The `Path Q : V → V → Type` of Chapter 11 was described as "a family of
   types indexed by a pair of vertices." Write down the Π-type expression
   $\prod_{x:A} B(x)$ instantiated so that it matches the signature of
   `Path.append`,
   `{u v w : V} → Path Q u v → Path Q v w → Path Q u w`
   (treat the implicit `{u v w : V}` as outer Π-binders). Identify $A$ and
   $B$ explicitly at each nesting level.

Solutions: [Appendix, Chapter 1](../14-appendix-solutions/01-chapter-1.md).

---

[← Π/Σ-types and the calculus of constructions](05-pi-sigma-and-coc.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](../02-functions-and-structures/00-index.md)
