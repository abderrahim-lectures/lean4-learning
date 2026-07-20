## Everything has a type

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)

---

In Lean 4, every expression (a **term**) has a **type**. A type answers the
question "what *kind* of thing is this?" — a number, a boolean, a proof, a
function from numbers to numbers. Lean checks this question *before*
running anything, and it never lets a term of the wrong type slip through.

```lean
#check 3          -- 3 : Nat
#check -3         -- -3 : Int
#check Nat        -- Nat : Type
#eval 2 ^ 10        -- 1024 (evaluates; #check only elaborates)
```

**Mathematical reading.** Type theory's basic unit of assertion is the
**judgment**: a statement made *about* an underlying formal system, called
the **calculus**, from the outside — not a proposition proved *inside* it.
(For Lean, this calculus is made concrete a few sentences below as the
$\lambda$-calculus, and named precisely as the **calculus of
constructions** in [Chapter 1 §5](05-pi-sigma-and-coc.md). Nothing here
depends on that name yet.) Following Martin-Löf ([MartinLof1984],
"Explanations of the forms of judgement" — the source is organized into
unnumbered sections, not a numbered "Ch. 1"), the judgment used here has
the form $e : \tau$, read "$e$ is a term of type $\tau$" — adapted to
Lean's colon notation; Martin-Löf's own text writes the same judgment as
$a \in A$ ("$a$ is an element of the set $A$"), set-membership notation
rather than a colon, though the judgment being made is the same one. For
example,
$3 : \mathtt{Nat}$ is one such judgment: it asserts, from outside the
calculus, that the term $3$ has type $\mathtt{Nat}$ — not a fact proved
*by* the calculus, but a fact established *about* it, the same way a
type-checking algorithm's output is a claim about a program, not a
theorem proved inside the program. `#check e` asks Lean to establish
exactly this kind of judgment for a given `e`, and it is literally the
same typing judgment used in a lecture on the simply-typed (or
dependently-typed) $\lambda$-calculus:
$3 : \mathtt{Nat}$, ${-3} : \mathtt{Int}$, $\mathtt{Nat} : \mathtt{Type}$.
`#eval e` instead asks Lean to reduce $e$ to a normal form. This is the
computational content of $\beta$-reduction: Lean follows the definitional
equalities until nothing more can fire, exactly as one would normalize a
term in $\lambda$-calculus by hand. (Both "normal form" and
"$\beta$-reduction" receive a full treatment in
[Chapter 1 §4](04-terminology.md) for readers meeting them for the first
time; briefly, each denotes the value obtained after fully
simplifying/running the expression, nothing more exotic.)

Read `#check 3` as "Lean answers the question `3 : ?` with `Nat`." Read
`#check Nat` as "even `Nat` itself — the type of natural numbers — is a
term, and *its* type is `Type`." This is the first surprising fact worth
sitting with: types are not a separate kind of thing bolted onto a
programming language. In Lean, a type is itself a term, and it has a type
of its own (`Type`), the same way `3` has a type (`Nat`). This is what
"everything has a type" means literally, not just for ordinary values.

`#check e` answers the question "what type does `e` have?" without running
`e`. `#eval e` actually runs `e` and prints the result. These are
deliberately two different commands, since they answer two different
questions:

- `#check` is a **static** guarantee — it holds before any particular
  input is supplied, for every possible run.
- `#eval` is a **one-off fact** — the result of running this *particular*
  expression, right now.

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
Python's `int` has no genuine analogue of `Nat`: `int` is signed and never
checked against a "must be non-negative" rule, except by an explicit
runtime `if` statement. `Nat`, by contrast, bakes non-negativity into the
type itself, checked once, statically, for every use site. This is closer
to a language with a genuine `unsigned` type (C, Rust) than to Python.

### Why this matters: types rule things out in advance

Here is the entire point of a type system, made concrete — starting in
Python, where the failure can actually be watched happening, before seeing
how Lean rules it out instead.

```python
# Python: this line is perfectly legal to *write*.
def add_them(a, b):
    return a + b

add_them(3, True)    # 4 — Python silently treats True as 1, no error at all
add_them(3, "oops")  # TypeError: unsupported operand type(s), but only once this exact line runs
```

Nothing stops Python from *writing* `add_them(3, "oops")`. The mistake is
only discovered the moment that specific line executes — if it sits on a
rarely-hit branch, it can ship for months undetected. And in the `True`
case, Python does not even complain: it quietly coerces the boolean to `1`
and moves on, whether or not that was the intended meaning.

Now the same shape of mistake in Lean:

```lean
#check 3 + true   -- error: failed to synthesize Add Nat Bool
```

Lean refuses to even *elaborate* this expression. It never runs it, never
silently coerces `true` to `1`, never crashes five function calls later
once the bad value finally reaches code that cannot handle it — it simply
never accepts the term in the first place, because `+`'s left argument is
a `Nat` and its right argument is a `Bool`, and no rule connects the two.
The check happens once, by reading the expression, without running it on
any input. Lean's guarantee is stronger than Python's: once a term
type-checks, this entire class of runtime error is impossible for that
term, on *every* input, not just the ones a test suite happened to run.

### `Nat`, concretely

`Nat` is not a built-in primitive the way `int` is in most languages. It is
defined, in full, as an **inductive type**:

$$
\mathtt{Nat} ::= \mathtt{zero} \mid \mathtt{succ}\,(n : \mathtt{Nat})
$$

Read this as: "a `Nat` is built in exactly one of two ways — it is `zero`,
or it is `succ n` for some already-built `Nat` called `n`." This is Peano's
definition, written out exactly. So `3` is not a primitive digit; it is
shorthand for `succ (succ (succ zero))`. Confirm it directly:

```lean
#eval Nat.succ (Nat.succ (Nat.succ Nat.zero))  -- 3
```

Lean prints numerals for readability, but underneath, every `Nat` really is
built from nothing but `zero` and `succ`, the same way every natural number
in a first course in logic is built from Peano's axioms. This inductive
shape is exactly what licenses proof by induction later (Chapter 4): to
prove something about *every* `Nat`, it suffices to prove it for `zero` and
show it is preserved by `succ` — because those are, provably, the only two
ways a `Nat` can ever have been built.

> **Mathematical reading (optional, for readers who already know some
> category theory).** Regard `Type` as a category: its **objects** are
> types — `α`, `β`, ... (this book's convention throughout, spelled out
> fully in [§2](02-def-let-implicit.md)) — and its **morphisms** are
> functions. A function `f : α → β` is a morphism from `α` to `β`, *not*
> a functor (a functor maps *between* categories; `Type` is the only
> category in sight here, and `α` and `β` are two of its objects, not
> categories in their own right). A term `x : α` is an element of the
> object `α`. `fun x => x` is the identity morphism, and `∘` is genuine
> categorical composition — associativity and the identity laws hold
> *definitionally*, checked by Lean at no extra cost.
>
> **Statement of the result.** `Nat` is generated by a base case
> (`zero`) and a step (`succ`), and by nothing else. Category theory
> gives a precise sense in which `Nat` is the smallest structure with
> this shape, and this precision is what justifies proof by induction.
> The argument below is given first in general terms, for an arbitrary
> type $X$, and only afterward specialized to `Nat` itself — the two
> notations are kept separate on purpose, to avoid mixing the general
> statement with its particular instance.
>
> **1. The general statement, for an arbitrary type $X$.** Let
> $F(X) = 1 + X$, an **endofunctor** on `Type` (here $1$ denotes a
> one-element type and $+$ denotes *disjoint sum* — these correspond to
> Lean's
> [`Unit`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Unit)
> and
> [`Sum`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#Sum),
> and this $+$ is distinct from the numeric $+$ introduced later in this
> box, notation notwithstanding). For an arbitrary endofunctor $F$, an
> **$F$-algebra** ([Jacobs1999], §2.6, p. 161) is a type $X$
> equipped with a map $F(X) \to X$. By the universal property of $+$, a
> map $(1 + X) \to X$ is equivalent to a pair consisting of an element
> $z : X$ and a self-map $s : X \to X$ — $z$ for "zero component," to
> avoid confusion with the identity element of a monoid, denoted $e$,
> which appears later in this box for an unrelated structure; an
> $F$-algebra is therefore equivalent to a triple $(X, z, s)$. A
> **morphism** of $F$-algebras from $(X, z, s)$ to $(Y, z', s')$ is a
> function $f : X \to Y$ satisfying $f(z) = z'$ and $f(s(x)) = s'(f(x))$
> for every $x$, i.e. a function compatible with both components of the
> algebra structure. Among all $F$-algebras there is an
> **initial object** ([MacLane1998], Ch. I §5): an algebra
> $(X_0, z_0, s_0)$ such that, for every algebra $(X, z, s)$, there
> exists exactly one algebra morphism from $(X_0, z_0, s_0)$ to
> $(X, z, s)$.
>
> **2. Specializing to `Nat`.** Set $X_0 := \mathtt{Nat}$,
> $z_0 := \mathtt{zero}$, $s_0 := \mathtt{succ}$. This triple is an
> $F$-algebra, and it is in fact the initial one: for every algebra
> $(X, z, s)$, there exists exactly one algebra morphism from `Nat`,
> determined uniquely by sending `zero` to $z$ and `succ n` to $s$
> applied to the image of `n`. From here on the discussion stays with
> `Nat`, `zero`, and `succ` — the general letters $X$, $z$, $s$ have done
> their job and will not reappear.
>
> **3. Consequence for induction.** The uniqueness established in Step 2
> is precisely the universal property that justifies structural
> induction: to define a function, or establish a statement, for every
> `Nat`, it suffices to specify the base case at `zero` and the inductive
> step at `succ`, since this data already determines the unique algebra
> morphism from `Nat`, and defining a function on `Nat` (or proving a
> statement about it) amounts to specifying such a morphism. This
> construction is known in the literature under two equivalent names:
> **initial algebra** and **natural numbers object** ([Jacobs1999],
> §2.6; [MacLane1998], Appendix "Foundations") of `Type`.
>
> **A second, different fact — worth not conflating with the above.**
> None of this is required to use `Nat`. It is offered only because,
> once ordinary numeric `+` and `0` are *defined* on `Nat` (Chapter 4) —
> an entirely different operation from the disjoint-sum $+$ used to
> build $F$ above, despite sharing a symbol — a second and different
> fact becomes provable (not merely definitional): `Nat`, with this
> numeric `+` and `0`, is the free commutative monoid on one generator.
> This is a genuinely different universal property from the
> initial-algebra one above — the two are easy to conflate, since both
> attach the word "universal" to `Nat`, but one concerns $F$-algebras and
> the other concerns monoids. [Chapter 1 §4](04-terminology.md) fixes the
> vocabulary ("universal property," "initial object") used here, for any
> reader meeting it for the first time.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Lean 4 documentation, "Basic Types," and *Theorem Proving in Lean 4*, §2.1 "Simple Type Theory" ([LeanDocs], [TPIL4]) — the `#check`/`#eval` distinction verified verbatim ("The `#check` command asks Lean to report their types... The `#eval` command asks Lean to evaluate the given expression") and `Nat` as an inductive type, straight from the source.
- Martin-Löf ([MartinLof1984]), Ch. 1, "Judgements and their explanations" — the formal definition of "judgment" used above.
- Pierce ([Pierce2002]), §1.1 "Types in Computer Science," §1.2 "What Type Systems Are Good For" — on what a static type system buys (ruling out whole classes of runtime failure before execution), verified verbatim: "A type system is a tractable syntactic method for proving the absence of certain program behaviors..."; independent of any particular language.
- Mac Lane ([MacLane1998]), Ch. I §5, p. 20 — the universal-property reading of `Nat` used in the optional box above, verified verbatim: "An object $s$ is initial in $C$ if to each object $a$ there is exactly one arrow $s \to a$."
- Jacobs ([Jacobs1999]), §2.6, p. 161 — the general definition of an algebra for an endofunctor used in the optional box's Step 1, verified verbatim: "For an arbitrary endofunctor $T : \mathbb{B} \to \mathbb{B}$ an algebra (or $T$-algebra) consists of a 'carrier' object $Y \in \mathbb{B}$ together with a morphism $\varphi : T(Y) \to Y$" (this book writes $F$ for Jacobs's $T$).
- Jacobs ([Jacobs1999]), §2.6, pp. 159–162 — the precise categorical framing used in the optional box's second paragraph: `Nat` as the initial algebra for $F(X) = 1 + X$, verified verbatim: "Notice that an initial algebra of the functor $X \mapsto 1 + X$ is a natural numbers object."
- Jacobs ([Jacobs1999]), §2.6, p. 159, and Mac Lane ([MacLane1998]), Appendix "Foundations," p. 292 — the standard name (NNO) for the same construction, equivalent to the initial-algebra framing above.

[LeanDocs]: ../bibliography.md#leandocs
[TPIL4]: ../bibliography.md#tpil4
[MartinLof1984]: ../bibliography.md#martinlof1984
[Pierce2002]: ../bibliography.md#pierce2002
[MacLane1998]: ../bibliography.md#maclane1998
[Jacobs1999]: ../bibliography.md#jacobs1999

---

[← Index](00-index.md) | [Next: `def`, `let`, implicit arguments →](02-def-let-implicit.md)
