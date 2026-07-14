## `def`, `let`, implicit arguments

[← Everything has a type](01-everything-has-a-type.md) | [Index](00-index.md)

---

Consider three short definitions. Every token in them is doing something
specific; each is examined in full below.

```lean
def double (n : Nat) : Nat := n * 2
```

**`def double (n : Nat) : Nat := n * 2`**

- `def` — the keyword that introduces a new global definition into the
  environment: a name, permanently available afterward, standing for a
  fixed term. This is different from a hypothesis or a local variable.
  Once elaborated, `double` is a completely ordinary constant, referable
  anywhere later in the file (or, once the file is imported, anywhere
  else). Compare this with `example` from Chapter 3, which elaborates a
  term but does *not* bind it to a name. `def` is for the case where the
  definition is meant to be reused.
- `double` — the name being bound. Lean enforces no special naming
  convention, but lowerCamelCase for `def`s and UpperCamelCase for types is
  the near-universal community style, which this book follows.
- `(n : Nat)` — an explicit argument named `n`, of type `Nat`. "Explicit"
  means a caller must supply it positionally: `double 5` provides `5` for
  `n` directly. This is what makes `double` a function rather than a plain
  value. Everything after `def double` up to the first bare `:=` (if there
  are argument binders) is the function's parameter list, and `double`'s
  *actual* type ends up being `Nat → Nat`, exactly as if it had been
  written `def double : Nat → Nat := fun n => n * 2` instead. The two forms
  elaborate to the same term. The `(n : Nat)` binder form is simply the
  standard, more readable surface syntax for "a function with named
  parameters."
- `: Nat` (the second one, right before `:=`) — the declared return type.
  This is not optional filler. Lean uses it to *check* the body against a
  known expected type while elaborating, rather than only inferring a type
  afterward. If the body's type did not match, an error would occur at
  this point, not somewhere downstream.
- `:=` — separates the declaration's signature (name, arguments, return
  type) from its definition (the actual term). Read it as "is defined to
  be."
- `n * 2` — the body. At this point in elaboration, `n` is in scope with
  type `Nat` (introduced by the `(n : Nat)` binder above), so `n * 2` is
  `Nat` multiplication applied to `n` and the numeral `2`. That numeral
  itself elaborates to a `Nat`, because that is what `Nat.mul`'s second
  argument's type forces it to be. Numeral elaboration is guided by the
  expected type — another case of Lean checking against context instead of
  guessing.

**Mathematical reading.** `def double (n : Nat) : Nat := n * 2` is nothing
more than the ordinary mathematical definition

$$
\mathrm{double} : \mathbb{N} \to \mathbb{N}, \qquad \mathrm{double}(n) = 2n,
$$

with the signature $\mathrm{double} : \mathbb{N} \to \mathbb{N}$ split
across `def double (n : Nat) : Nat` (domain and codomain, spelled out
argument-by-argument rather than as a single arrow), and the equation
$\mathrm{double}(n) = 2n$ becomes `:= n * 2`. There is no real difference
between writing the domain as one arrow `Nat → Nat` or as a named binder
`(n : Nat) : Nat`, exactly as $f : A \to B,\ f(a) = \ldots$ and
$f = (a \mapsto \ldots) : A \to B$ describe the same function.


```lean
def average (a b : Nat) : Nat :=
  let sum := a + b
  sum / 2
```

**`def average (a b : Nat) : Nat := let sum := a + b; sum / 2`**

- `(a b : Nat)` — two explicit arguments, both of type `Nat`, written with
  a single shared type annotation. This is pure surface-syntax sugar for
  `(a : Nat) (b : Nat)`; Lean expands it identically either way. This
  shorthand is standard style whenever several consecutive parameters
  share a type, and costs nothing.
- `let sum := a + b` — introduces a *local* definition, visible only in the
  rest of this particular body, as opposed to `def`'s *global* one. `let`
  does not need (though it can take) a type annotation, since the type of
  `a + b` is already fully determined by `a` and `b`'s types, so Lean
  infers it. Operationally, `let sum := a + b; sum / 2` means exactly the
  same thing as substituting `a + b` for every occurrence of `sum` in
  `sum / 2`. A `let` is definitionally transparent, so `average a b` and
  `(a + b) / 2` elaborate to the same normal form. The reason to write it
  as a `let` anyway, rather than inlining `(a + b) / 2` directly, is purely
  for the human reader: naming an intermediate quantity documents what it
  means, and in a longer proof or definition, it prevents repeating a
  nontrivial subexpression (and therefore repeating a mistake in it) in
  several places.
- The line break between `let sum := a + b` and `sum / 2` is whitespace,
  not two separate statements needing a semicolon. Lean's parser uses
  indentation-sensitive layout for `let`-chains, the same way it does for
  `by`-blocks in tactic mode. `sum / 2` is the `let`'s body: the whole
  two-line construct `let sum := a + b; sum / 2` is itself one term, which
  is then what `average`'s `:=` binds to.
- `sum / 2` — `Nat` division, which in Lean is *truncating*. `average 4 10`
  computes `sum = 14`, then `14 / 2 = 7` exactly. But `average 1 2` would
  compute `sum = 3`, then `3 / 2 = 1` (rounded down, since `Nat` has no
  fractions). This should be noted before relying on this `average` for
  anything where the rounding matters.

**Mathematical reading.** The `let` is exactly a "let $s := a + b$ in
$\ldots$" clause of the kind used constantly in written proofs to name an
intermediate quantity:

$$
\mathrm{average}(a,b) = \big\lfloor \tfrac{s}{2} \big\rfloor
\text{ where } s := a + b,
$$

One caveat: this `average` computes $\lfloor s/2 \rfloor$ (floor division)
rather than the true rational average $s/2$, since `Nat`'s division is
truncating. This gap is easy to overlook in ordinary mathematical prose,
but Lean forces it to be confronted explicitly: there is no coercion to
$\mathbb{Q}$ happening for free.

```lean
def identity {α : Type} (x : α) : α := x
```

**`def identity {α : Type} (x : α) : α := x`**

- `{α : Type}` — an **implicit** argument, marked by curly braces instead
  of parentheses. The name `α` (conventionally a Greek letter for a type
  variable — again pure convention, `T` or `A` would work just as well) has
  type `Type`, meaning this argument is itself a *type*, not a value of
  some fixed type. `identity` is thus **polymorphic**: it works uniformly
  for every choice of `α`.
- The crucial difference from `(n : Nat)` above: `{α : Type}` is not
  supplied positionally at call sites. Writing `identity 5` does *not*
  mean "pass `5` as `α`". Lean instead **elaborates** (infers) `α` by
  unification, working backward from the type of the explicit argument
  actually supplied. In `identity 5`, Lean sees that `5 : Nat` is being
  passed where an `x : α` is expected, unifies `α := Nat`, and only then
  checks the rest. An implicit argument can still be supplied explicitly
  when overriding inference is necessary, with `@identity Nat 5`. The `@`
  prefix means "no more auto-inference; every argument, implicit or not,
  is given by hand." This escape hatch matters mainly for debugging
  elaboration failures, not everyday use.
- Why implicit rather than explicit here at all: `α` is determined by
  `x`'s type at every call site, so requiring the caller to type it out
  (as in `identity Nat 5`) would be pure noise. Lean already has enough
  information without being told. The general rule of thumb, used
  throughout Mathlib and this book: mark an argument implicit exactly when
  its value is always recoverable from the *other* arguments or from the
  expected return type; keep it explicit when it genuinely varies
  independently, and a reader benefits from seeing it written at the call
  site.
- `: α := x` — the return type is `α` itself (the same type variable bound
  above, now in scope for the rest of the signature and body), and the
  body is simply `x`, the argument unchanged. This is the identity
  function at every type simultaneously: one `def`, rather than one
  per type, which is exactly what the `{α : Type}` parameter provides.

**Mathematical reading.** `identity {α : Type} (x : α) : α := x` is the
family $\{\,\mathrm{id}_A : A \to A\,\}_{A \in \mathbf{Type}}$ indexed over
*every* type $A$ at once. It is precisely the assignment sending each
object $A$ of the category to its identity morphism $\mathrm{id}_A$,
packaged as a single polymorphic definition rather than one definition per
$A$. The implicit argument `{α : Type}` is what makes this a *statement
about all $A$ simultaneously* rather than a single fixed function. In
category theory one would never write "$\mathrm{id}_{\mathbb{Z}}$,
$\mathrm{id}_{\mathbb{R}}$, ..." one at a time either, but would instead
say "for every object $A$, there is an identity morphism $\mathrm{id}_A$," which is
exactly what the universally-quantified, implicitly-inferred `{α : Type}`
expresses.

---

[← Everything has a type](01-everything-has-a-type.md) | [Index](00-index.md) | [Next: Dependent types, categorically →](03-dependent-types.md)
