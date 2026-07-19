## Dependent types, with examples

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md)

---

Every function seen so far has a *fixed* codomain: `double : Nat → Nat`
returns a `Nat` regardless of the input `n`. Lean's type theory allows
something more general: a type that itself depends on a *value*, and a
function whose return type changes depending on which argument it was
given. This is a **dependent type**. It is the single feature that
separates Lean (and other proof assistants) from an ordinary typed
programming language, so it is worth building up slowly, from the
smallest possible example, before naming the general pattern.

### The problem, in Python first

Before any Lean syntax, here is the actual problem dependent types solve,
in a language with no type checker enforcing anything at all. Suppose a
dot-product function is written over two lists:

```python
def dot(xs, ys):
    return sum(x * y for x, y in zip(xs, ys))

dot([1, 2, 3], [4, 5, 6])   # 32 — correct
dot([1, 2, 3], [4, 5])      # 14 — silently wrong: zip() truncates to the shorter list
```

This is worse than a crash. `dot([1, 2, 3], [4, 5])` does not raise
anything — `zip` just quietly drops the third element of `xs` and hands
back a number that *looks* like a perfectly good answer. The bug (calling
`dot` on two lists of different lengths, which is mathematically
nonsensical) is never caught, not by Python, not by a test that happens
not to cover this call site, not by anything short of a human noticing the
number looks off.

The underlying mistake is that a Python `list` carries no information
about its own length in any way Python's function signatures can see or
enforce. `xs : list` and `ys : list` say nothing about whether the two
lists agree in size — that fact exists only as a comment at best, never
checked by anything. What is actually wanted is a signature saying
"`dot` accepts two lists *of the same length* `n`, for *any* `n`" — a
signature that mentions and constrains a value (`n`), not just a type
(`list`). Ordinary type systems, Python's included even with type hints
added, have no way to say that. This is exactly the gap dependent types
close, and the rest of this section builds the machinery to say it,
starting from the smallest possible example.

### First: a type family, one type per number

Here is the smallest genuine example of a dependent type, and it is
already sitting in Lean's core library. `Fin n` is the type of natural
numbers *strictly less than* `n`:

```lean
#check Fin 3   -- Fin 3 : Type
#check Fin 5   -- Fin 5 : Type
```

`Fin` itself is not one type. It is a **recipe that produces a type once
handed a number**: `Fin 3` and `Fin 5` are both genuine types, but they are
*different* types — `Fin 3` has exactly three inhabitants (the numbers
`0`, `1`, `2`) and `Fin 5` has exactly five. Compare this to something
already known not to be dependent, `List α`: `List Nat` and `List Bool`
are different types too, but only because `Nat` and `Bool` are different
*types* fed in for `α`. `Fin` is a different kind of thing. `Fin 3` and
`Fin 5` differ even though `3` and `5` are both perfectly ordinary terms
of the exact same type, `Nat`. The type `Fin` produces depends on which
*value* it is given, not just which type. That value-dependence is the
entire definition of "dependent type," and `Fin` is the simplest possible
example of one.

The construction of `Fin` can be inspected directly:

```lean
#print Fin
-- structure Fin (n : Nat) : Type
-- fields:
--   Fin.val  : Nat
--   Fin.isLt : val < n
```

So a term of `Fin n` is literally a pair: a `Nat` value, plus a *proof*
that the value is below `n`. The proof's very statement (`val < n`)
mentions `n`, the value supplied. Change `n` and the result is a
genuinely different type, with a genuinely different proof obligation
attached. This bundling — data, plus a proof whose statement depends on
that data — is the second half of the dependent-types story (formalized
later in this section as a **Σ-type**); `Fin` is a real, live example of
it, not a made-up one.

### Second: a function whose *return type* changes with its argument

Now for the companion idea: a **dependent function**, one whose return
type depends on the specific *value* of its argument, not just the
argument's type. Define fixed-length vectors from scratch, the standard
first example in any dependent-type-theory course:

```lean
inductive Vec (α : Type) : Nat → Type where
  | nil  : Vec α 0
  | cons : α → Vec α n → Vec α (n + 1)
```

Read this exactly like `Nat`'s two-constructor definition from the
previous section, with one new ingredient: `Vec α` is not a single type,
it is a **family of types indexed by a `Nat`** — `Vec α 0`, `Vec α 1`,
`Vec α 2`, ... are all different types, one per length, and the length is
tracked *in the type itself*, not just at runtime. `nil` builds the unique
length-`0` vector; `cons` takes an element and a length-`n` vector and
produces a length-`(n+1)` vector — the `n` used on both sides of `cons`'s
arrow is the *same* `n`, so the constructor itself enforces "one longer
than whatever it started with."

Here is a function that *builds* one of these, and its type is the
dependent-function payoff:

```lean
def Vec.replicate (a : α) : (n : Nat) → Vec α n
  | 0     => Vec.nil
  | n + 1 => Vec.cons a (Vec.replicate a n)

#check @Vec.replicate
-- @Vec.replicate : {α : Type} → α → (n : Nat) → Vec α n

#eval (Vec.replicate 7 3 : Vec Nat 3)
-- Vec.cons 7 (Vec.cons 7 (Vec.cons 7 Vec.nil))
```

Look closely at the type `(n : Nat) → Vec α n`. The `n` that appears on
the *left* of the arrow (the argument) reappears inside the type on the
*right* of the arrow (the result). Feed `Vec.replicate a` the number `3`,
and the result has type `Vec α 3`, specifically. Feed it `5`, and the
very same function returns something of type `Vec α 5` instead. This is
categorically different from `double : Nat → Nat`, where the output type
(`Nat`) is fixed in advance and never reads the input value at all. Here,
the *type itself* changes based on which number was passed in. That is
exactly what "the codomain depends on the argument" means, made as
concrete as possible.

### Why bother: invariants become part of the type, not a side promise

The payoff is not just bookkeeping. Because the length lives in the type,
Lean can rule out a whole class of mistakes *before running anything at
all*. Define a function that reads a vector's first element, which only
makes sense for a *non-empty* vector:

```lean
def Vec.head : Vec α (n + 1) → α
  | Vec.cons a _ => a
```

The argument type `Vec α (n + 1)` says, in the type itself, "this only
accepts vectors of length *at least one*" — there is no separate runtime
check for emptiness anywhere in this definition, because none is needed.
Calling it on an empty vector is rejected before the expression ever runs:

```lean
#check Vec.head Vec.nil
```

```
error: Application type mismatch: The argument
  Vec.nil
has type
  Vec ?m 0
but is expected to have type
  Vec ?m (?n + 1)
in the application
  Vec.head Vec.nil
```

Nothing about "index out of range" happens at runtime, because the bad
call is not a well-typed term in the first place — the same "ruled out
before running" guarantee from [§1](01-everything-has-a-type.md), now
enforced by an invariant (non-emptiness) that an ordinary, non-dependent
type could not have expressed at all. `List α` has no way to say "and
this one is non-empty" as part of its type; `Vec α (n+1)` says exactly
that, for free, using only the machinery already on the table.

**Return to the Python example from the start of this section.** Here is
`dot`, rewritten for `Vec` instead of Python's `list`, with both
arguments required to share the *same* length `n`:

```lean
def Vec.dot : Vec Nat n → Vec Nat n → Nat
  | Vec.nil, Vec.nil => 0
  | Vec.cons x xs, Vec.cons y ys => x * y + Vec.dot xs ys
```

The signature `Vec Nat n → Vec Nat n → Nat` uses the *same* `n` for both
arguments — that is not a naming coincidence, it is the whole point. Try
to reproduce Python's silent bug:

```lean
def v3 : Vec Nat 3 := Vec.cons 1 (Vec.cons 2 (Vec.cons 3 Vec.nil))
def v2 : Vec Nat 2 := Vec.cons 4 (Vec.cons 5 Vec.nil)

#check Vec.dot v3 v2
```

```
error: Application type mismatch: The argument
  v2
has type
  Vec Nat 2
but is expected to have type
  Vec Nat 3
in the application
  v3.dot v2
```

Where Python's `dot([1,2,3], [4,5])` silently returned `14` — a wrong
answer with no error at all — Lean's version does not even compile. The
length-mismatch bug is not caught by a clever runtime check *added* to
`Vec.dot`; there is no such check anywhere in its three-line definition.
It is caught because "both arguments have the same length" was stated
once, in the type, and Lean enforces every type it is given,
automatically, for every call site, without exception.

(Lean's actual, built-in `Vector α n` — distinct from the toy `Vec` built
here — is defined differently under the hood, as an `Array α` paired with
a proof that its size equals `n`, for performance reasons, the same way
`Nat`'s *presentation* above as Peano's `zero`/`succ` does not reflect how
Lean actually stores numbers at runtime (as fast arbitrary-precision
integers). The `Vec` built in this section is the traditional textbook
definition — simpler to reason about, and the one every type-theory
reference uses first — while Lean's real `Vector` is engineered for
speed. Both are dependent types in exactly the sense described here.)

### The general pattern: Π-types

Both examples above are instances of one idea. A **dependent function
type**, written with $\Pi$ ("Pi," for "dependent product"), generalizes
the ordinary function-space $A \to B$:

$$
\prod_{x : A} B(x)
$$

read: "a function that, given any $x : A$, returns a term of type
$B(x)$" — a type allowed to mention $x$. When $B(x)$ does not actually
depend on $x$, this collapses exactly to the ordinary function type
$A \to B$. Π-types **strictly generalize** function types; they do not
replace them. `Vec.replicate`'s type above literally *is*
$\prod_{n : \mathtt{Nat}} \mathrm{Vec}\,\alpha\,n$, with Lean's surface
syntax `(n : Nat) → Vec α n` spelling out the same thing without needing
the $\Pi$ symbol.

This is also, not by coincidence, exactly what `∀` has meant since Chapter
3. `∀ n : Nat, n ≥ 0` is a Π-type where $B(n)$ happens to be a
*proposition* (`n ≥ 0 : Prop`) rather than a data type like `Vec α n` —
"for every `n`, produce a proof of the `n`-specific statement `n ≥ 0`."
Every `∀` written since Chapter 3 was already a dependent function,
whether or not the vocabulary was available for it yet; propositions are
just the special case where the family $B$ happens to land in `Prop`
instead of `Type`.

### Looking ahead

Chapter 11 builds a genuinely more elaborate dependent type, `Path Q : V →
V → Type`, a family of types indexed by a *pair* of vertices in a graph
rather than by a single `Nat` — "the type of paths from `u` to `w`," which
differs for each choice of endpoints exactly as `Vec α n` differs for each
length. Its `cons`-like constructor is a dependent function for the same
reason `Vec.replicate` is one here: composing two paths is only accepted
by the type-checker when their endpoints actually match, an invariant
baked into the type rather than checked separately. Nothing new is needed
to understand it once this section's `Fin`/`Vec` examples make sense —
it is the identical idea, with a richer index.

> **Mathematical reading (optional).** For readers who already think
> categorically: an indexed family `B : A → Type` is exactly a functor out
> of the discrete category on `A` — or, thinking of `A × A`-indexed
> families as in the `Path` example above, an assignment of a
> $\mathrm{Hom}$-set to every pair of objects in a category. A Π-type over
> such a family is a **dependent product**; a term of $\sum_{x:A} B(x)$
> (Σ-type, next covered formally in [§5](05-pi-sigma-and-coc.md)) is a
> **dependent sum**. Both are literal categorical limits/colimits in the
> appropriate indexed sense, not merely named after them by analogy.

> Read more: [§5](05-pi-sigma-and-coc.md)
> gives Π-types (and Σ-types) their formal typing rules, with more worked
> examples, rather than only the walkthrough given here.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- *Theorem Proving in Lean 4* ([TPIL4]), "Dependent Types" — the official Lean documentation's own introduction to dependent types, using this same length-indexed-vector example.
- The Lean 4 source / [Mathlib4 API documentation][Mathlib4Docs] for `Fin` and `Vector` — confirmed directly in this section via `#print Fin` against the actual toolchain pinned in this repository's `lean_project/lean-toolchain`.
- Thompson ([Thompson1991]) — a from-scratch treatment of dependent types and Π/Σ, independent of any one proof assistant.
- Chlipala ([Chlipala2013]) — Ch. 2–3 build the same length-indexed-vector idea in Coq, a useful second angle on the identical concept.

[TPIL4]: ../bibliography.md#tpil4
[Mathlib4Docs]: ../bibliography.md#mathlib4docs
[Thompson1991]: ../bibliography.md#thompson1991
[Chlipala2013]: ../bibliography.md#chlipala2013

---

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md) | [Next: Terminology →](04-terminology.md)
