## Everything has a type

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)

---

In Lean 4, every expression (a **term**) has a **type**. Types are
themselves terms of type `Type` (or `Prop` for propositions — Chapter 3).
It is useful to regard `Type` as (the objects of) a category: a term
`x : α` is an element of `α`, a function `f : α → β` is a morphism
$\alpha \to \beta$, `fun x => x` is the identity, and `∘` is genuine
categorical composition. Associativity and the identity laws hold
*definitionally*, so Lean checks them automatically. A `structure` bundling
data and axioms (Chapter 2 onward) is an object of the evident category of
"structures of that shape," exactly as in any algebra course that presents
groups or rings as objects of a category.

```lean
#check 3          -- 3 : Nat
#check -3         -- -3 : Int
#check Nat        -- Nat : Type
#eval 2 ^ 10        -- 1024 (evaluates; #check only elaborates)
```

**Mathematical reading.** `#check e` is the judgment $e : \tau$ from type
theory. It is literally the same typing judgment used in a lecture on the
simply-typed (or dependently-typed) $\lambda$-calculus:
$3 : \mathtt{Nat}$, ${-3} : \mathtt{Int}$, $\mathtt{Nat} : \mathtt{Type}$.
`#eval e` instead asks Lean to reduce $e$ to a normal form. This is the
computational content of $\beta$-reduction: Lean follows the definitional
equalities until nothing more can fire, exactly as one would normalize a
term in $\lambda$-calculus by hand. (Both "normal form" and
"$\beta$-reduction" receive a full treatment in
[Chapter 1 §4](04-terminology.md) for readers meeting them for the first
time; briefly, each denotes the value obtained after fully
simplifying/running the expression, nothing more exotic.)

**Programmer's corner (Python).** For readers who have written Python but
not Lean: `#check e` is *not* `type(e)`. Python's `type()` asks a running
value what class it happens to belong to, after the fact. Lean's `#check`
is closer to what a static type checker like `mypy` does with an
annotation such as `x: int = 3`: it verifies, *before* anything runs, that
the expression could only ever produce a value of the stated type. `#eval
e`, on the other hand, *is* just `print(e)`: run it, show the result. Lean
separates these two commands for the same reason `mypy` exists at all:
type-checking is a static guarantee that holds for every possible input,
while evaluating is a one-off fact about this particular expression.
Python's `int` has no genuine analogue of `Nat`: it is signed and never
checked against a "must be non-negative" rule, except by an explicit
runtime `if` statement. `Nat`, by contrast, bakes non-negativity into the
type itself, checked once, statically, for every use site. This is closer
to a language with a genuine `unsigned` type (C, Rust) than to Python.

`Nat` is the inductive type

$$
\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}\,(n : \mathtt{Nat})
$$

This is Peano's definition, written out exactly. In more set-theoretic
language, `Nat` is the **initial object** in the category of "sets
equipped with a distinguished element and an endomorphism" (a
$\mathrm{zero} \in X$ and a map $s : X \to X$). This initiality is exactly
the universal property that makes structural induction valid: a map out of
`Nat` is uniquely determined by where it sends `zero` and how it commutes
with `succ`. This inductive presentation is what licenses proof by
induction later; note that, unlike most languages, Lean's numerals are not
a primitive but a defined inductive family, built exactly this way.

Separately, once `+` and `0` are *defined* on `Nat` by recursion
(Chapter 4), one can *prove* $(\mathbb{N}, +, 0)$ is the free commutative
monoid on one generator: $\mathrm{Nat} \cong \langle 1 \rangle$, with every
natural number $n$ literally being $1 + 1 + \cdots + 1$ ($n$ times). This
is a *theorem*, not a definitional fact, and must not be confused with the
initiality above: it is a genuinely different (though closely related)
universal property from the $(\mathrm{zero}, \mathrm{succ})$-initiality
above. The first concerns `Nat`'s *inductive structure* directly. The
second concerns *the monoid built on top of it*, and the "free" claim
requires an actual argument (by induction, unsurprisingly), not merely
inspection of the definitions.

---

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)
