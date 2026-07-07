# Chapter 1: First steps — terms, types, `#eval`

[← Setup](00-setup.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](02-functions-and-structures.md)

---

## Everything has a type

In Lean 4, every expression (a **term**) has a **type**, and types are
themselves terms of type `Type` (or `Prop` for propositions — Chapter 3).
It's fruitful to think of `Type` as (the objects of) a category: a term
`x : α` is an element of `α`, a function `f : α → β` is a morphism
$\alpha \to \beta$, `fun x => x` is the identity, and `∘` is genuine
categorical composition — associativity and the identity laws hold
*definitionally*, so Lean checks them for you. A `structure` bundling data
and axioms (Chapter 2 onward) is an object of the evident category of
"structures of that shape," exactly as in any algebra course that presents
groups or rings as objects of a category.

```lean
#check 3          -- 3 : Nat
#check -3         -- -3 : Int
#check Nat        -- Nat : Type
#eval 2 ^ 10        -- 1024 (evaluates; #check only elaborates)
```

`Nat` is the inductive type $\texttt{Nat} ::= \texttt{zero} \mid
\texttt{succ}\,(n : \texttt{Nat})$ — Peano's definition, verbatim. This
inductive presentation is what licenses proof by induction later, and is
worth keeping in mind: unlike most languages, Lean's numerals are not a
primitive but a defined inductive family, definitionally the free monoid
on one generator under successor.

## `def`, `let`, implicit arguments

```lean
def double (n : Nat) : Nat := n * 2

def average (a b : Nat) : Nat :=
  let sum := a + b
  sum / 2

def identity {α : Type} (x : α) : α := x
```

`{α : Type}` is an implicit argument, elaborated by unification rather than
supplied at call sites — the usual "let Lean infer the universe-polymorphic
parameter" pattern you'd expect from any dependently-typed setting.

## Next

Continue to [Chapter 2: Functions and structures](02-functions-and-structures.md).

---

[← Setup](00-setup.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](02-functions-and-structures.md)
