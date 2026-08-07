## Dependent types, with examples

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md)

---

Every function seen so far has a *fixed* codomain. `double : Nat → Nat`
returns a `Nat` regardless of the input `n`. The Lean type theory allows
something more general, a type that itself depends on a *value*, and a
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

dot([17, -3, 42], [99, 8, 6])   # 1911 — correct
dot([17, -3, 42], [99, 8])      # 1659 — silently wrong: zip() truncates to the shorter list
```

This is worse than a crash. `dot([17, -3, 42], [99, 8])` does not raise
anything. `zip` just quietly drops the third element of `xs` and hands
back a number that *looks* like a perfectly good answer. The bug (calling
`dot` on two lists of different lengths, which is mathematically
nonsensical) is never caught, not by Python, not by a test that happens
not to cover this call site, not by anything short of a human noticing the
number looks off.

The underlying mistake is that a Python `list` carries no information
about its own length in any way the function signatures of Python can see or
enforce. `xs : list` and `ys : list` say nothing about whether the two
lists agree in size. That fact exists only as a comment at best, never
checked by anything. What is actually wanted is a signature saying
"`dot` accepts two lists *of the same length* `n`, for *any* `n`," a
signature that mentions and constrains a value (`n`), not just a type
(`list`). Ordinary type systems, including that of Python, even with type hints
added, have no way to say that. This is exactly the gap dependent types
close, and the rest of this section builds the machinery to say it,
starting from the smallest possible example.

### First: a type family, one type per number

Here is the smallest genuine example of a dependent type, and it is
already sitting in the core library of Lean. [`Fin n`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Fin)
is the type of natural numbers *strictly less than* `n`:

```lean
#check Fin 3   -- Fin 3 : Type
#check Fin 5   -- Fin 5 : Type
```

`Fin` itself is not one type. It is a **recipe that produces a type once
handed a number**. `Fin 3` and `Fin 5` are both genuine types, but they are
*different* types. `Fin 3` has exactly three inhabitants (the numbers
`0`, `1`, `2`) and `Fin 5` has exactly five. Compare this to something
already known not to be dependent, `List α`. `List Nat` and `List Bool`
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
--   Fin.isLt : ↑self < n
```

So a term of `Fin n` is literally a pair, a `Nat` value, plus a *proof*
that the value is below `n`. The very statement of the proof (`↑self < n`,
i.e. the wrapped `val` compared against `n`) mentions `n`, the value
supplied. Change `n` and the result is a
genuinely different type, with a genuinely different proof obligation
attached. This bundling of data, plus a proof whose statement depends on
that data, is the second half of the dependent-types story (formalized
later in this section as a **Σ-type**). `Fin` is a real, live example of
it, not a made-up one.

### Second: a function whose *return type* changes with its argument

Now for the companion idea, a **dependent function**, one whose return
type depends on the specific *value* of its argument, not just
the type of the argument. Define fixed-length vectors from scratch, the standard
first example in any dependent-type-theory course:

```lean
inductive Vec (α : Type) : Nat → Type where
  | nil  : Vec α 0
  | cons : α → Vec α n → Vec α (n + 1)
```

Read this exactly like `Nat`'s two-constructor definition from the
previous section, with one new ingredient. `Vec α` is not a single type,
it is a **family of types indexed by a `Nat`**. `Vec α 0`, `Vec α 1`,
`Vec α 2`, and so on, are all different types, one per length, and the length is
tracked *in the type itself*, not just at runtime. `nil` builds the unique
length-`0` vector, and `cons` takes an element and a length-`n` vector and
produces a length-`(n+1)` vector. The `n` used on both sides of the arrow in `cons` is the *same* `n`, so the constructor itself enforces "one longer
than whatever it started with."

One detail that the careful treatment in Section 2 of `{α : Type}` does not
account for is that `n` is never bound anywhere in the `cons` line above, and yet
the declaration elaborates. That is the **`autoImplicit`** setting of Lean, on by
default, which turns an unbound lowercase identifier in the type of a declaration
into an implicit argument automatically, here inserting `{n : Nat}` for you.
The same thing happens with `α` in the definitions below, which is why
`#check @Vec.replicate` prints a `{α : Type}` binder that nothing in the
source wrote. Mathlib and most substantial projects set
`autoImplicit := false`, precisely so that a typo cannot silently become a
new implicit argument. In such a project, write the binders out:

```lean
inductive Vec (α : Type) : Nat → Type where
  | nil  : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)
```

That version binds `n` explicitly rather than relying on the setting, which is
what the Mathlib-style projects in Chapter 13 expect.

Here is a function that *builds* one of these, and its type is the
dependent-function payoff:

```lean
def Vec.replicate (a : α) : (n : Nat) → Vec α n
  | 0     => Vec.nil
  | n + 1 => Vec.cons a (Vec.replicate a n)

#check @Vec.replicate
-- @Vec.replicate : {α : Type} → α → (n : Nat) → Vec α n

#eval (Vec.replicate (-42 : Int) 3 : Vec Int 3)
-- Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))
```

**A third style of writing a `def` body, and why the signature ends in a
bare `→`.** Every `def` up to this point (`double`, `average`, `identity`)
named every argument inside `(...)` and gave one term after `:=`.
`Vec.replicate` above does something visibly different for its last
argument: `(n : Nat)` never appears to the left of `:=`, the signature
itself ends in a plain `→` the way the statement of a `theorem` does, and the
body is a list of `| pattern => term` equations instead of one term. This
is not a new arrow meaning on top of the two flagged in
[Section 2](02-def-let-implicit.md), and it is not a different kind of
function. It is a third *writing style* for the exact same thing, worth
seeing side by side on a smaller example before trusting it in
`Vec.replicate`:

```lean
def vecLen {α : Type} {n : Nat} (_ : Vec α n) : Nat := n

def vecLen' {α : Type} {n : Nat} : Vec α n → Nat
  | _ => n
```

- `vecLen` is the familiar style. The `Vec α n` argument is bound by name
  (as `_`, since the body never actually uses it, only its index `n`)
  inside `(...)`, and the body is one term, `n`, exactly like the body of
  `double` was one term, `n * 2`.
- `vecLen'` binds nothing after the colon. Its signature is
  `Vec α n → Nat`, a bare arrow, precisely as if it were the *statement* of
  a theorem rather than the header of a function. The argument is instead
  supplied by the single equation `| _ => n` below, matching against
  whatever term of `Vec α n` is eventually passed in. Lean's **equation
  compiler** is what turns this `| pattern => term` block into an ordinary
  function, internally no different from writing `fun v => match v with
  | _ => n` inside a `:=` body. `vecLen` and `vecLen'` are, after
  elaboration, the same function under two different pieces of surface
  syntax, not two functions that happen to agree on every input.
- The two styles are not interchangeable in every situation, only
  equally valid where they overlap. Equation-style earns its keep exactly
  when the whole purpose of a definition is to case on the *shape* of an
  inductive argument, one equation per constructor, which is why
  `Vec.replicate` above (and `Vec.head`, `Vec.dot` shortly) are written
  that way. Each genuinely has one case for `0`/`nil` and one for
  `n + 1`/`cons`. The named-binder `:=` style stays the natural choice
  once the argument is used as an ordinary value rather than taken apart,
  exactly as `vecLen` above never inspects *which* vector it received,
  only its already-known length `n`.

**Mathematical reading.** Equation-style `def` is the Lean transcription
of ordinary definition by cases,
$$
f(n) = \begin{cases} c_0 & n = 0 \\ c(k, f(k)) & n = k + 1, \end{cases}
$$
the exact shape a mathematician already writes for a recursively defined
sequence or function. Nothing new is being learned here beyond the Lean
spelling of a pattern already familiar from ordinary practice, which is
also exactly why it shows up unannounced the moment this book starts
defining functions over an inductive type like `Vec`.

`Vec.replicate` recurses exactly once per unit of length, so it is worth
watching the recursion unwind one call at a time. Adding a `dbg_trace`
line to each branch (harmless, since it only prints, and changes nothing about
what the function returns) makes every step visible:

```lean
def Vec.replicate' (a : α) : (n : Nat) → Vec α n
  | 0     => dbg_trace s!"replicate: n=0, base case, returning Vec.nil"; Vec.nil
  | n + 1 => dbg_trace s!"replicate: n={n+1}, prepending one copy of a, recursing with n={n}";
             Vec.cons a (Vec.replicate' a n)

#eval (Vec.replicate' (-42 : Int) 3 : Vec Int 3)
-- replicate: n=3, prepending one copy of a, recursing with n=2
-- replicate: n=2, prepending one copy of a, recursing with n=1
-- replicate: n=1, prepending one copy of a, recursing with n=0
-- replicate: n=0, base case, returning Vec.nil
-- Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))
```

Read the trace bottom-to-top against top-to-bottom. The four `dbg_trace`
lines print in the order each recursive call is *entered* (`n=3`, then
`n=2`, then `n=1`, then the base case `n=0`), and only once the base case
returns does the final `#eval` line print the fully-built `Vec`. This is
the general shape every structurally-recursive function over `Vec`/`Nat`
in this book has. One line prints per recursive call, in call order, with
the line for the base case printed last before the result appears. The value of `a` itself cannot be printed generically inside the trace. `α` is an
arbitrary type here, and nothing says a `Repr α` instance (the typeclass
that lets a value be turned into displayable text) exists for whichever
type `α` turns out to be at a given call site. This is why the message
names the *step* (which branch fired, what `n` is) rather than the data,
the same reason `dbg_trace` traces later in this book stick to naming
steps and concrete, already-known values, never a still-generic argument.

This example deliberately stores `Int` values, not `Nat` values. With a
`Vec Nat n` holding `Nat` elements, the length `n` and the stored numbers
would both be `Nat`, and it becomes easy to lose track of which `Nat` is
playing which role. `Int` keeps the elements visibly numeric, unlike,
say, `Bool`, while still being unmistakably a *different* type from `Nat`,
the type of the length. A stored element such as `-42` can be large and negative,
which a length can never be, so no reader could mistake it for the length
`3`.

Real or complex numbers would make the distinction just as clear, but are
not an option this early. `ℝ`/`ℂ` are Mathlib types, and this book stays
Mathlib-free through Chapter 11. The reals in Lean in particular are
`noncomputable` (built from Cauchy sequences with no decidable equality),
so `#eval` cannot evaluate one at all, not even in principle. `Int` is the
closest numeric type that is both core Lean and actually computable. The
next example, `Vec.dot`, uses `Vec Int n` for the same reason.

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
all*. Define a function that reads the first element of a vector, which only
makes sense for a *non-empty* vector:

```lean
def Vec.head : Vec α (n + 1) → α
  | Vec.cons a _ => a
```

The argument type `Vec α (n + 1)` says, in the type itself, "this only
accepts vectors of length *at least one*." There is no separate runtime
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
  Vec.nil.head
```

The pretty-printer in Lean renders the failed application in field-notation
form, `Vec.nil.head`, rather than echoing back `Vec.head Vec.nil` verbatim.
This is cosmetic, but worth not being surprised by when reproducing this error
directly.

Nothing about "index out of range" happens at runtime, because the bad
call is not a well-typed term in the first place. This is the same "ruled out
before running" guarantee from [Chapter 1, Section 1](01-everything-has-a-type.md), now
enforced by an invariant (non-emptiness) that an ordinary, non-dependent
type could not have expressed at all. `List α` has no way to say "and
this one is non-empty" as part of its type. `Vec α (n+1)` says exactly
that, for free, using only the machinery already on the table.

**Return to the Python example from the start of this section.** Here is
`dot`, rewritten for `Vec` instead of the `list` type of Python, with both
arguments required to share the *same* length `n`:

```lean
def Vec.dot : Vec Int n → Vec Int n → Int
  | Vec.nil, Vec.nil => 0
  | Vec.cons x xs, Vec.cons y ys => x * y + Vec.dot xs ys
```

The signature `Vec Int n → Vec Int n → Int` uses the *same* `n`, a
`Nat`, the length, for both arguments. That is not a naming
coincidence, it is the whole point. Elements are `Int`, not `Nat`, on
purpose. This keeps the length (`n`, a `Nat`) and the stored numbers
(`Int`) as visibly different types throughout, with no `Nat`/`Nat`
overlap left to lose track of. The vectors below are also named
`vecA`/`vecB`, not after their own lengths, to avoid yet another
coincidence layered on top. Try to reproduce the silent bug from Python:

```lean
def vecA : Vec Int 3 := Vec.cons 17 (Vec.cons (-3) (Vec.cons 42 Vec.nil))
def vecB : Vec Int 2 := Vec.cons 99 (Vec.cons 8 Vec.nil)

#check Vec.dot vecA vecB
```

`Vec.dot` recurses on *both* arguments at once, consuming one element from
each per call, and accumulates a running total on the way back up. Before
seeing why the mismatched-length call above fails, watch a same-length
call succeed, with a `dbg_trace` line added to each branch. Unlike
the trace for `Vec.replicate`, this one can also print the actual numbers, since
`Int` (unlike a fully generic `α`) does have a `Repr` instance:

```lean
def Vec.dot' : Vec Int n → Vec Int n → Int
  | Vec.nil, Vec.nil => dbg_trace s!"dot: both nil, base case, returning 0"; 0
  | Vec.cons x xs, Vec.cons y ys =>
      dbg_trace s!"dot: heads x={x}, y={y}, recursing on the rest";
      x * y + Vec.dot' xs ys

def vecC : Vec Int 3 := Vec.cons 2 (Vec.cons 5 (Vec.cons 1 Vec.nil))

#eval Vec.dot' vecA vecC
-- dot: heads x=17, y=2, recursing on the rest
-- dot: heads x=-3, y=5, recursing on the rest
-- dot: heads x=42, y=1, recursing on the rest
-- dot: both nil, base case, returning 0
-- 61
```

Each traced line names the pair of heads being multiplied *before* the
recursive call is made, so the four lines above are exactly
$17 \times 2$, $-3 \times 5$, $42 \times 1$, and the $0$ of the base case, in
that order. These are the same four terms the recursion in the definition adds
together, made visible one at a time instead of only appearing as the
final sum $34 + (-15) + 42 + 0 = 61$. `vecA` and `vecB` have different
lengths on purpose, to set up the type-mismatch check next. `vecC` above
is a third vector, the same length as `vecA`, used only to give
`Vec.dot'` a legal pair to run on.

```
error: Application type mismatch: The argument
  vecB
has type
  Vec Int 2
but is expected to have type
  Vec Int 3
in the application
  vecA.dot vecB
```

the version of Python, `dot([17,-3,42], [99,8])`, silently returned `1659`, a wrong
answer with no error at all. The Lean version does not even compile. The
length-mismatch bug is not caught by a clever runtime check *added* to
`Vec.dot`. There is no such check anywhere in its three-line definition.
It is caught because "both arguments have the same length" was stated
once, in the type, and Lean enforces every type it is given,
automatically, for every call site, without exception.

The actual, built-in `Vector α n` in Lean is distinct from the toy `Vec` built
here. It is defined differently under the hood, as an `Array α` paired
with a proof that its size equals `n`, for performance reasons, the same
way the *presentation* of `Nat` above as `zero`/`succ`, due to Peano, does not reflect
how Lean actually stores numbers at runtime (as fast arbitrary-precision
integers). The `Vec` built in this section is the traditional textbook
definition, simpler to reason about and the one every type-theory
reference uses first, while the real `Vector` in Lean is engineered for speed.
Both are dependent types in exactly the sense described here.

### The general pattern: Π-types

Both examples above are instances of one idea. A **dependent function
type**, written with $\Pi$ ("Pi," for "dependent product"), generalizes
the ordinary function-space $A \to B$:

$$
\prod_{x : A} B(x)
$$

Here $B$ is not itself a type. $B$ is a **family of types indexed by
$A$**, formally a function $B : A \to \mathrm{Type}$ (or into `Prop`, the
type of propositions, a distinct universe of its own, formally named
`Sort 0` in [Chapter 1, Section 5](05-pi-sigma-and-coc.md), as below). For
each $x : A$, $B(x)$ is the specific type that family
produces at $x$, and different values of $x$ may give genuinely different
types. Read the whole expression as "a function that, given any
$x : A$, returns a term of type $B(x)$," a type allowed to mention
$x$, because $B$ itself is allowed to vary with $x$. When $B(x)$ does
not actually depend on $x$ (i.e. $B$ is a *constant* family), this
collapses exactly to the ordinary function type $A \to B$. Π-types
**strictly generalize** function types. They do not replace them.
The type of `Vec.replicate` above literally *is*
$\prod_{n : \mathtt{Nat}} \mathrm{Vec}\,\alpha\,n$, with the surface
syntax of Lean `(n : Nat) → Vec α n` spelling out the same thing without needing
the $\Pi$ symbol.

This is also, not by coincidence, exactly what `∀` means. `∀ n : Nat, n ≥
0` is a Π-type where $B(n)$ happens to be a *proposition* (`n ≥ 0 :
Prop`) rather than a data type like `Vec α n`. It reads as "for every `n`, produce a
proof of the `n`-specific statement `n ≥ 0`." Chapter 3 introduces `∀`
and propositional logic properly. Once it does, every `∀` written from
that point on is already a dependent function in exactly this sense,
whether or not this vocabulary is available yet when it is first met.
Propositions are just the special case where the family $B$ happens to
land in `Prop` instead of `Type`.

### Looking ahead

Chapter 11 builds a genuinely more elaborate dependent type, `Path Q : V →
V → Type`, a family of types indexed by a *pair* of vertices in a graph
rather than by a single `Nat`. It is "the type of paths from `u` to `w`," which
differs for each choice of endpoints exactly as `Vec α n` differs for each
length. Its `cons`-like constructor is a dependent function for the same
reason `Vec.replicate` is one here. Composing two paths is only accepted
by the type-checker when their endpoints actually match, an invariant
baked into the type rather than checked separately. Nothing new is needed
to understand it once the `Fin`/`Vec` examples in this section make sense.
It is the identical idea, with a richer index.

> **Mathematical reading (optional).** For readers who already think
> categorically, an indexed family `B : A → Type` is exactly a functor out
> of the discrete category on `A`, or, thinking of `A × A`-indexed
> families as in the `Path` example above, an assignment of a
> $\mathrm{Hom}$-set to every pair of objects in a category. A Π-type over
> such a family is a **dependent product**. A term of $\sum_{x:A} B(x)$
> (Σ-type, next covered formally in [Chapter 1, Section 5](05-pi-sigma-and-coc.md)) is a
> **dependent sum**. Both are literal categorical limits/colimits in the
> appropriate indexed sense, not merely named after them by analogy.

> Read more. [Chapter 1, Section 5](05-pi-sigma-and-coc.md)
> gives Π-types (and Σ-types) their formal typing rules, with more worked
> examples, rather than only the walkthrough given here.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Dependent type.** "The short explanation is that types can depend
  on parameters" ([TPIL4], §2.8 "What makes dependent type theory
  dependent?"). Picture it like this. A cake sized to the guest count. "The
  cake for 12" and "the cake for 3" aren't the same cake made smaller,
  they're genuinely different objects, one per number of guests. `Fin
  n` is that idea turned into a type. `Fin 12` and `Fin 3` are
  different types, one per `n`, the same way cake sizes differ per
  guest count.
- **Dependent function type ($\Pi$-type).** "The type
  `(a : α) → β a` denotes the type of functions `f` with the property
  that, for each `a : α`, `f a` is an element of `β a`" ([TPIL4],
  §2.8). Picture it like this. A vending machine whose dispensing slot changes
  shape depending which button is pressed. A soda comes out one
  opening, a bag of chips another. Written here as $\prod_{x:A} B(x)$
  (standard mathematical notation for the same construct; TPIL4
  itself uses "dependent function type"/"dependent arrow type," not
  the $\Pi$ symbol), an ordinary function type $A \to B$ is just the
  boring special case where every slot happens to be the same shape.
- The Lean 4 source / [Mathlib4 API documentation][Mathlib4Docs] for `Fin` and `Vector`, confirmed directly in this section via `#print Fin` against the actual toolchain pinned in `lean_project/lean-toolchain` in this repository.
- Thompson ([Thompson1991]), §4.6 "Quantifiers," §6.3 "Dependent types and quantifiers" develop the same dependent-product/dependent-sum content, verified verbatim against the source. The primary notation used by Thompson is $\forall$/$\exists$, not Π/Σ. He calls the Σ-type-equivalent an "(infinitary) sum type" or "dependent sum type," and the literal term "Sigma-type" never appears in his main text, only once, in a bibliography entry citing a paper by a different author. Explicit Π-notation does appear later, in the meta-theory chapters of that book (§8.3, §9.1.5), applied to dependent function spaces in a typed λ-calculus meta-language.
- Chlipala ([Chlipala2013]), §8.1 "Length-Indexed Lists" and §9.1 "More Length-Indexed Lists". The length-indexed-vector idea in this book (`ilist : nat → Set`) is built and revisited there, not in Ch. 2–3 as an earlier draft of this section stated, verified verbatim (`Inductive ilist : nat → Set := | Nil : ilist O | Cons : ∀ n, A → ilist n → ilist (S n)`). This is a useful second angle on the identical concept, in Coq rather than Lean.

[TPIL4]: ../bibliography.md#tpil4
[Mathlib4Docs]: ../bibliography.md#mathlib4docs
[Thompson1991]: ../bibliography.md#thompson1991
[Chlipala2013]: ../bibliography.md#chlipala2013

---

[← `def`, `let`, implicit arguments](02-def-let-implicit.md) | [Index](00-index.md) | [Next: Terminology →](04-terminology.md)
