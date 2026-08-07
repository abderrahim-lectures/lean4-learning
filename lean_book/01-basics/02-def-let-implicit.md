## `def`, `let`, implicit arguments

[← Everything has a type](01-everything-has-a-type.md) | [Index](00-index.md)

---

Section 1 established that every term has a type, and that Lean checks
this before running anything. That fact is useless without a way to
*name* terms so they can be reused, and a way to write one definition
that works for many types at once rather than one copy per type. Those
are exactly the two gaps this section closes. `def`/`let` handle naming
(global and local, respectively), and implicit arguments allow writing a
single definition, like an identity function, that is correct for
every type simultaneously, instead of retyped per type.

Consider three short definitions, each introducing one of these pieces in
turn. Every token in them is doing something specific; each is examined
in full below.

```lean
def double (n : Nat) : Nat := n * 2
```

**`def double (n : Nat) : Nat := n * 2`**

- `def` is the keyword that introduces a new global definition into the
  environment, a name, permanently available afterward, standing for a
  fixed term. This is different from a hypothesis or a local variable.
  Once elaborated, `double` is a completely ordinary constant, referable
  anywhere later in the file (or, once the file is imported, anywhere
  else). Compare this with `example` from Chapter 4, which elaborates a
  term but does *not* bind it to a name. `def` is for the case where the
  definition is meant to be reused.
- `double` is the name being bound. Lean enforces no special naming
  convention, but lowerCamelCase for `def`s and UpperCamelCase for types is
  the near-universal community style, which this book follows.
- `(n : Nat)` is an explicit argument named `n`, of type `Nat`. "Explicit"
  means a caller must supply it positionally. `double 5` provides `5` for
  `n` directly. This is what makes `double` a function rather than a plain
  value. Everything after `def double` up to the first bare `:=` (if there
  are argument binders) is the function parameter list, and the actual type of `double`
  ends up being `Nat → Nat`, exactly as if it had been
  written `def double : Nat → Nat := fun n => n * 2` instead. The two forms
  elaborate to the same term. The `(n : Nat)` binder form is simply the
  standard, more readable surface syntax for "a function with named
  parameters."
- `: Nat` (the second one, right before `:=`) is the declared return type.
  This is not optional filler. Lean uses it to *check* the body against a
  known expected type while elaborating, rather than only inferring a type
  afterward. If the type of the body did not match, an error would occur at
  this point, not somewhere downstream.
- `:=` separates the declaration signature (name, arguments, return
  type) from the definition (the actual term). Read it as "is defined to
  be."
- `n * 2` is the body. At this point in elaboration, `n` is in scope with
  type `Nat` (introduced by the `(n : Nat)` binder above), so `n * 2` is
  `Nat` multiplication applied to `n` and the numeral `2`. That numeral
  itself elaborates to a `Nat`, because that is what the type of the second
  argument of `Nat.mul` forces it to be. Numeral elaboration is guided by the
  expected type, another case of Lean checking against context instead of
  guessing.

A word of warning about the `→` that appeared two bullets up
(`Nat → Nat`, the type of `double`). This same arrow reappears twice more
later in this book, meaning something that looks different each time. Once
`Prop` exists ([Chapter 4](../04-propositions-and-proofs/04-implication.md)),
`P → Q` for propositions `P`, `Q` reads as logical implication, not "takes a
`P`-value, returns a `Q`-value." And later this section
([Section 5](../02-terminology-and-coc/02-pi-sigma-and-coc.md)) names the fully general pattern `→` is
secretly always an instance of, the Π-type, where the *codomain* is allowed
to depend on which argument was given, `Nat → Nat` being only the special
case where it happens not to. Nothing about `double` above needs any of
this yet. It is flagged only so the same symbol showing up wearing two more
meanings later does not read as three unrelated coincidences.

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

- `(a b : Nat)` is two explicit arguments, both of type `Nat`, written with
  a single shared type annotation. This is pure surface-syntax sugar for
  `(a : Nat) (b : Nat)`. Lean expands it identically either way. This
  shorthand is standard style whenever several consecutive parameters
  share a type, and costs nothing.
- `let sum := a + b` introduces a *local* definition, visible only in the
  rest of this particular body, as opposed to the *global* kind introduced by `def`. `let`
  does not need (though it can take) a type annotation, since the type of
  `a + b` is already fully determined by the types of `a` and `b`, so Lean
  infers it. Operationally, `let sum := a + b; sum / 2` means exactly the
  same thing as substituting `a + b` for every occurrence of `sum` in
  `sum / 2`. A `let` is definitionally transparent, so `average a b` and
  `(a + b) / 2` elaborate to the same normal form. The reason to write it
  as a `let` anyway, rather than inlining `(a + b) / 2` directly, is purely
  for the human reader. Naming an intermediate quantity documents what it
  means, and in a longer proof or definition, it prevents repeating a
  nontrivial subexpression (and therefore repeating a mistake in it) in
  several places.
- The line break between `let sum := a + b` and `sum / 2` is whitespace,
  not two separate statements needing a semicolon. The parser used by Lean uses
  indentation-sensitive layout for `let`-chains, the same way it does for
  `by`-blocks in tactic mode. `sum / 2` is the body of the `let`. The whole
  two-line construct `let sum := a + b; sum / 2` is itself one term, which
  is then what the `:=` of `average` binds to.
- `sum / 2` is `Nat` division, which in Lean is *truncating*. `average 4 10`
  computes `sum = 14`, then `14 / 2 = 7` exactly. But `average 1 2` would
  compute `sum = 3`, then `3 / 2 = 1` (rounded down, since `Nat` has no
  fractions). This should be noted before relying on this `average` for
  anything where the rounding matters.

**Mathematical reading.** The `let` is exactly a "let $s := a + b$ in
$\ldots$" clause of the kind used constantly in written proofs to name an
intermediate quantity.

$$
\mathrm{average}(a,b) = \big\lfloor \tfrac{s}{2} \big\rfloor
\text{ where } s := a + b,
$$

One caveat is that this `average` computes $\lfloor s/2 \rfloor$ (floor division)
rather than the true rational average $s/2$, since division on `Nat` is
truncating. This gap is easy to overlook in ordinary mathematical prose,
but Lean forces it to be confronted explicitly. There is no coercion to
$\mathbb{Q}$ happening for free.

```lean
def identity {α : Type} (x : α) : α := x
```

**`def identity {α : Type} (x : α) : α := x`**

- `{α : Type}` is an **implicit** argument, marked by curly braces instead
  of parentheses. The name `α` (conventionally a Greek letter for a type
  variable; again pure convention, `T` or `A` would work just as well) has
  type `Type`, meaning this argument is itself a *type*, not a value of
  some fixed type. `identity` is thus **polymorphic**. It works uniformly
  for every choice of `α`.
- The crucial difference from `(n : Nat)` above is that `{α : Type}` is not
  supplied positionally at call sites. Writing `identity 5` does *not*
  mean "pass `5` as `α`." Lean instead **elaborates** (infers) `α` by
  unification, working backward from the type of the explicit argument
  actually supplied. In `identity 5`, Lean sees that `5 : Nat` is being
  passed where an `x : α` is expected, unifies `α := Nat`, and only then
  checks the rest. An implicit argument can still be supplied explicitly
  when overriding inference is necessary, with `@identity Nat 5`. The `@`
  prefix means "no more auto-inference; every argument, implicit or not,
  is given by hand." This escape hatch matters mainly for debugging
  elaboration failures, not everyday use.
- The reason to make `α` implicit rather than explicit here is that the value of `α` is determined by
  the type of `x` at every call site, so requiring the caller to type it out
  (as in `identity Nat 5`) would be pure noise. Lean already has enough
  information without being told. The general rule of thumb, used
  throughout Mathlib and this book, is to mark an argument implicit exactly when
  its value is always recoverable from the *other* arguments or from the
  expected return type, and to keep it explicit when it genuinely varies
  independently, and a reader benefits from seeing it written at the call
  site.
- `: α := x` gives the return type `α` itself (the same type variable bound
  above, now in scope for the rest of the signature and body), and the
  body is simply `x`, the argument unchanged. This is the identity
  function at every type simultaneously, one `def`, rather than one
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

**Two more binder styles, and one more kind of `def`, not needed yet.**
`()` and `{}` are not the whole story, only the two pieces needed so far.
Briefly, so meeting these elsewhere later is not a surprise:

- A **third** kind of argument, written with square brackets, `[x : C]`,
  is solved neither positionally like `()` nor by unification like `{}`,
  but by a search through registered instances of `C`, called
  **typeclass resolution**. This book delays it deliberately, until
  [Chapter 6](../06-rigor-check/01-structure-vs-class.md), where the
  `Group`/`class`/`instance` machinery that makes it useful is built up
  from `structure` first, so the automation is understood rather than
  taken on faith.
- A **fourth**, rarer kind, **strict implicit**, written `{{x : α}}` (Lean
  also accepts a Unicode spelling of the same double-brace pair, seen
  occasionally in Mathlib source), behaves like `{}` except that Lean
  defers solving it until an *explicit* argument after it is actually
  supplied. It is a Mathlib idiom for keeping partially applied functions
  well behaved, and does not appear anywhere in this book's own code. It
  is named here only so it is recognizable, not mysterious, if
  encountered while reading Mathlib source directly.
- `def` is not the only way to introduce a definition either. `abbrev` and
  `opaque` exist alongside it, and differ not in what they let you write,
  but in how transparent the result is to Lean's own equality checker,
  whether `unfold`ing it is ever needed, or ever even possible.
  [Chapter 5](../05-tactics/04-more-tactics.md), once `unfold` itself is on
  the table, is where this is worth actually seeing rather than taking on
  faith.

None of this needs remembering yet. Only `()` and `{}` are needed for
everything through the end of this chapter.

The implicit `{α : Type}` argument of `identity` is polymorphic *over which type is
plugged in*, but its return type, `α`, never changes shape once `α` is
fixed. An `identity` for `Nat` returns a `Nat`, full stop, no matter
which `Nat` was given. The next section asks the sharper question this
naturally raises. Can the *type itself* depend not just on which type
was chosen, but on the specific *value* of an argument, changing from one
call to the next even at a single fixed type? That is a strictly new
capability, not a variation on implicit arguments, and it is what makes
Lean a genuine proof assistant rather than an ordinary typed language.

---

[← Everything has a type](01-everything-has-a-type.md) | [Index](00-index.md) | [Next: Dependent types, with examples →](03-dependent-types.md)
