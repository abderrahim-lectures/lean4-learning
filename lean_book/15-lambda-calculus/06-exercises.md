## Exercises

[← From λ-calculus to Lean, term by term](05-lambda-to-lean.md) | [Index](00-index.md)

---

1. β-reduce $(\lambda x.\lambda y.\, y\, x)\, a\, b$ to normal
   form by hand, writing out each step. Which of the two named combinators from
   Section 1 (recall $K = \lambda x.\lambda y. x$) does
   $\lambda x.\lambda y.\, y\, x$ resemble, and how does it differ?
2. Using the Church-numeral definitions from Section 2, β-reduce
   $\mathrm{plus}\;\underline{1}\;\underline{2}$ down to (an
   α-equivalent form of) $\underline{3} = \lambda f.\lambda x.\,
   f(f(f\,x))$. Show every step.
3. Write the Church-encoded pair constructor
   $\mathrm{pair} := \lambda a.\lambda b.\lambda f.\, f\, a\, b$ and its
   two projections $\mathrm{fst} := \lambda p.\, p\, (\lambda a.\lambda
   b.\, a)$, $\mathrm{snd} := \lambda p.\, p\, (\lambda a.\lambda b.\, b)$.
   Verify by β-reduction that $\mathrm{fst}\,(\mathrm{pair}\, a\, b)
   \longrightarrow_\beta a$. (This is the untyped-calculus ancestor of
   Chapter 2's `structure Pair (α β : Type) where fst : α; snd : β` — the
   same idea, before types or a `structure` keyword existed to name it.)
4. In a few sentences, explain why
   `identity {α : Type} (x : α) : α := x` from Chapter 1 cannot be typed
   in the simply typed λ-calculus of Section 3, but can be typed once
   Π-types (Section 4) are available. Identify exactly which typing rule
   from Section 4 licenses it.
5. Chapter 11's `Path Q : V → V → Type` was described as "a family of
   types indexed by a pair of vertices." Write down the Π-type expression
   $\prod_{x:A} B(x)$ instantiated so that it matches
   `Path.append`'s signature
   `{u v w : V} → Path Q u v → Path Q v w → Path Q u w`
   (treat the implicit `{u v w : V}` as outer Π-binders). Identify $A$ and
   $B$ explicitly at each nesting level.
6. (Optional, harder) Look up how `Nat.rec` (Lean's automatically
   generated recursion principle for the `inductive Nat`) is stated, and
   compare its shape to a Church numeral's type
   $\prod_{X : \mathtt{Type}} X \to (X \to X) \to X$. What role does each
   argument play in both presentations?

---

[← From λ-calculus to Lean, term by term](05-lambda-to-lean.md) | [Index](00-index.md) | [Table of contents](../README.md)
