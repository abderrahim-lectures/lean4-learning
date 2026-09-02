# Chapter 4: Propositions as types, and basic proofs

[← Ch. 3: Functions & Structures](../03-functions-and-structures/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Tactics →](../05-tactics/00-index.md)

---

## Learning objectives

- Read `Prop` as the type of statements and a proof as an ordinary term.
- State the introduction/elimination rules of natural deduction for `∧`/`∨`/`¬`/`→`.
- Write and prove `theorem`/`lemma`s directly as terms.
- Reason about `∀`/`∃` and equality via the anonymous constructor and `rfl`.

## What forces the definitions

Chapters 1 and 3 built terms and types for numbers, points, and
soon-to-be groups, but never said what a *proof* is, as a piece of Lean
data. `Prop`, the type of statements, and the reading of a proof as an
ordinary term of that type, is the Curry–Howard correspondence
([Section 1](01-prop.md)), the same terms-and-types machinery already in
place, turned on statements instead of on numbers. That correspondence
presupposes "propositional logic" and "natural deduction" are already
familiar; [Section 2](02-logic-recap.md) is a self-contained, Lean-free
recap of standard logic, fixing exactly what the "Logic" column of the
table in Section 1 refers to, so the translation into types has
something precise to translate.

Once a proposition is a type, stating and naming a proof needs no new
syntax. `theorem` and `lemma` are identical to `def`
([Section 3](03-theorem-lemma.md)), since a proof is a term like any
other. The most basic rule of natural deduction, $\Rightarrow$-intro, was
already recognizable as `fun (hp : P) => ...`; the resemblance is exact,
not merely suggestive. Implication *is* the function type, and modus
ponens *is* function application, with nothing lost in the translation
([Section 4](04-implication.md)). Implication is one connective; `∧`,
`∨`, `¬` each get their own type former (product, sum,
function-to-`False`), completing the dictionary that Section 1 only
started ([Section 5](05-and-or-not.md)).

Every connective so far concerns *fixed* propositions `P`, `Q`. A
statement varying over every `n`, or asserting that *some* witness
exists, needs quantifiers. `∀` and `∃` are exactly the Π- and Σ-types of
Chapter 1, specialized to a family landing in `Prop` instead of `Type`
([Section 6](06-quantifiers.md)); dependent types were never optional
scaffolding, and here is where they pay off for logic itself. One
relation has been used silently in every section so far, `rfl`, `=`,
without being examined on its own terms; equality reasoning covers
reflexivity, symmetry, transitivity, and substitution, the tools every
later proof in this book leans on without comment
([Section 7](07-equality.md)).

By the last section, "propositions are types, proofs are terms" has gone
from a one-line slogan to a working toolkit. Every connective and
quantifier in ordinary mathematical writing now has a precise Lean
counterpart, ready for the tactics of Chapter 5 to build automatically instead
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

[← Ch. 3: Functions & Structures](../03-functions-and-structures/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Tactics →](../05-tactics/00-index.md)
