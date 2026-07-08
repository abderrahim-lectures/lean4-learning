## Terminology you'll meet before it's fully explained

[← Dependent types, categorically](03-dependent-types.md) | [Index](00-index.md)

---

Four words are going to recur constantly from here on, well before this
book gives any of them a full formal treatment (that treatment lives in
[Appendix B](../15-lambda-calculus/00-index.md), which most readers will
want to save for after finishing the main chapters). Rather than leave
them undefined until the very end, here is a working definition of each,
good enough to use immediately, with a pointer to where the precise
version lives.

**Elaborate / elaboration.** The process by which Lean turns the surface
syntax you type into a fully-explicit, fully-typed internal term: filling
in implicit arguments, resolving notation, checking every subterm's type
against what's expected. When this book says an expression "elaborates
to" something, it means "after Lean has finished this filling-in process,
what you actually get is..." — e.g. `identity 5` *elaborates to*
`@identity Nat 5` (Chapter 1), with `α := Nat` filled in silently.
Elaboration is not guessing; it's a deterministic algorithm driven by the
typing rules of Lean's underlying calculus.

> Read more: [Appendix B §5](../15-lambda-calculus/05-lambda-to-lean.md)
> describes elaboration precisely as type inference for the calculus of
> constructions.

**Unify / unification.** The specific step inside elaboration that solves
"what must this placeholder be, given what I already know?" When Lean
sees `identity 5` and knows `identity : {α : Type} → α → α`, it *unifies*
the type of `5` (namely `Nat`) with the placeholder `α`, concluding
`α := Nat`. Unification is what makes implicit-argument inference
(Chapter 1), `apply`'s subgoal-matching (Chapter 4), and typeclass
instance search (Chapter 5) all work — in each case, Lean is solving an
equation between two (possibly partially unknown) terms.

> Read more: [Appendix B §5](../15-lambda-calculus/05-lambda-to-lean.md).

**Reduce / reduction, normal form.** A term **reduces** by repeatedly
applying its computation rules — substituting an abstraction's argument
into its body (β-reduction), unfolding a `def`, or simplifying a `match`
on a known constructor. A term with no more reductions available is in
**normal form**. `#eval` (Chapter 1) computes a term's normal form and
prints it; `rfl` (Chapter 3) succeeds exactly when both sides of an
equation share a normal form. In practice, Lean's kernel usually only
reduces as far as it needs to progress — down to **weak head normal
form** (far enough to see the outermost constructor or function head),
not necessarily all the way down — which is why, e.g., `Nat.add`'s
recursion on its *second* argument (Chapter 4) determines which side of
an equation reduces "for free" and which needs an explicit inductive
argument: Lean only unfolds `a + b` far enough to expose `b`'s shape, so
`a + 0` reduces immediately (the second argument is already the base
case) while `0 + a`, with an unknown `a` in the position `Nat.add`
recurses on, does not reduce at all until `a` itself is known.

> Read more: [Appendix B §1](../15-lambda-calculus/01-untyped-lambda-calculus.md)
> defines β-reduction and normal forms precisely, in the untyped setting
> where the idea is easiest to see in isolation.

**Motive.** The (possibly type-dependent) predicate or type family that a
tactic like `induction` or `rw` is secretly generalizing your goal over
before it operates. When `rw [h]` fails with **"motive is not type
correct,"** it means: to replace one side of `h` with the other
throughout your goal, Lean first abstracts your goal into a function `C`
(the motive) taking the rewritten term as a parameter — and here, that
abstraction produces an ill-typed `C`, typically because the term you're
rewriting appears inside a dependent type's *index* (as in Chapter 11's
`Path`, whose very type depends on specific vertices) rather than in a
position that can vary freely. The fix is almost always to restate the
goal first with `show`, or to generalize the index explicitly, so the
motive Lean builds is well-typed.

> Read more: [Chapter 5 §3](../05-rigor-check/03-defeq-vs-propeq.md)
> revisits "motive is not type correct" alongside definitional equality;
> [Appendix B §4](../15-lambda-calculus/04-dependent-types-coc.md) shows
> the recursor/eliminator (e.g. `Nat.rec`) whose own type is literally
> parameterized by a motive, which is where the name comes from.

---

[← Dependent types, categorically](03-dependent-types.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](../02-functions-and-structures/00-index.md)
