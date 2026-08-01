# Chapter 3: Propositions as types, and basic proofs

[← Ch. 2: Functions & Structures](../02-functions-and-structures/00-index.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](../04-tactics/00-index.md)

---

**Learning objectives.** By the end of this chapter, read `Prop` as the
type of statements and a proof as an ordinary term, state natural
deduction's introduction/elimination rules for `∧`/`∨`/`¬`/`→`, write and
prove `theorem`/`lemma`s directly as terms, and reason about `∀`/`∃` and
equality via the anonymous constructor and `rfl`.

## The story of this chapter

Each section again answers the question the previous one forces:

1. **Chapters 1 and 2 built terms and types for numbers, points, and
   soon-to-be groups — but what is a *proof*, as a piece of Lean data?**
   ([Section 1](01-prop.md)) The Curry–Howard correspondence: a
   proposition is a type, `Prop`, and a proof is simply a term of that
   type — the same terms-and-types machinery already in place, turned on
   statements instead of on numbers.
2. **That correspondence assumes "propositional logic" and "natural
   deduction" are already familiar — are they?** ([Section 2](02-logic-recap.md))
   A self-contained, Lean-free recap of standard logic, fixing exactly
   what the "Logic" column of Section 1's table refers to, so the
   translation into types has something precise to translate.
3. **Now that a proposition is a type, how does one actually *state* and
   *name* a proof, the way ordinary mathematics names a theorem?**
   ([Section 3](03-theorem-lemma.md)) `theorem` and `lemma` — syntactically
   identical to `def`, since a proof is a term like any other.
4. **Natural deduction's most basic rule, $\Rightarrow$-intro, was
   already recognizable as `fun (hp : P) => ...` — is that resemblance
   exact, or only suggestive?** ([Section 4](04-implication.md)) Exact:
   implication *is* the function type, and modus ponens *is* function
   application, with nothing lost in the translation.
5. **Implication is one connective. What about the rest — `∧`, `∨`,
   `¬`?** ([Section 5](05-and-or-not.md)) Each gets its own type former
   (product, sum, function-to-`False`), completing the dictionary
   Section 1 only started.
6. **Every connective so far has been about *fixed* propositions `P`,
   `Q`. What about a statement varying over every `n`, or asserting that
   *some* witness exists?** ([Section 6](06-quantifiers.md)) `∀` and `∃`
   are exactly Chapter 1's Π- and Σ-types, specialized to a family
   landing in `Prop` instead of `Type` — dependent types were never
   optional scaffolding, and here is where they pay off for logic
   itself.
7. **One relation has been used silently in every section so far —
   `rfl`, `=` — without ever being examined on its own terms. What
   *is* it, precisely, and what can be done with it?**
   ([Section 7](07-equality.md)) Equality reasoning: reflexivity,
   symmetry, transitivity, and substitution, the tools every later proof
   in this book leans on without comment.

By the last section, "propositions are types, proofs are terms" has gone
from a one-line slogan to a working toolkit: every connective and
quantifier in ordinary mathematical writing now has a precise Lean
counterpart, ready for Chapter 4's tactics to build automatically instead
of by hand.

## Sections

1. [`Prop`: the type of statements](01-prop.md)
2. [A recap of standard logic and logical calculus](02-logic-recap.md)
3. [`theorem` and `lemma`](03-theorem-lemma.md)
4. [Implication is a function type](04-implication.md)
5. [And, Or, Not](05-and-or-not.md)
6. [Universal and existential quantifiers](06-quantifiers.md)
7. [Equality reasoning](07-equality.md)
8. [Exercises](08-exercises.md)

---

[← Ch. 2: Functions & Structures](../02-functions-and-structures/00-index.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](../04-tactics/00-index.md)
