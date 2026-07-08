## Everything has a type

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)

---

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

**Mathematical reading.** `#check e` is the judgment $e : \tau$ from type
theory — literally the same turnstile-free typing judgment you'd write in a
lecture on the simply-typed (or dependently-typed) $\lambda$-calculus:
$3 : \mathtt{Nat}$, ${-3} : \mathtt{Int}$, $\mathtt{Nat} : \mathtt{Type}$.
`#eval e` instead asks Lean to reduce $e$ to a normal form — the
computational content of $\beta$-reduction, i.e. following the definitional
equalities until nothing more can fire, exactly as you'd normalize a term
in $\lambda$-calculus by hand.

`Nat` is the inductive type

$$
\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}\,(n : \mathtt{Nat})
$$

— Peano's definition, verbatim; in more set-theoretic language, `Nat` is
the **initial object** in the category of "sets equipped with a
distinguished element and an endomorphism" (a $\mathrm{zero} \in X$ and a
map $s : X \to X$) — this initiality is exactly the universal property
that makes structural induction valid: a map out of `Nat` is uniquely
determined by where it sends `zero` and how it commutes with `succ`. This
inductive presentation is what licenses proof by induction later, and is
worth keeping in mind: unlike most languages, Lean's numerals are not a
primitive but a defined inductive family, built exactly this way.

Separately — and this is a *theorem*, not a definitional fact, worth not
conflating with the initiality above — once `+` and `0` are *defined* on
`Nat` by recursion (Chapter 4), one can *prove* $(\mathbb{N}, +, 0)$ is the
free commutative monoid on one generator: $\mathrm{Nat} \cong \langle 1
\rangle$, with every natural number $n$ literally being $1 + 1 + \cdots +
1$ ($n$ times). This is a genuinely different (if closely related)
universal property from the $(\mathrm{zero}, \mathrm{succ})$-initiality
above — the first concerns `Nat`'s *inductive structure* directly, the
second concerns *the monoid built on top of it*, and the "free" claim
requires an actual argument (by induction, unsurprisingly), not mere
inspection of definitions.

---

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)
