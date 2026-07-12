## `structure` versus `class`: why this book delays type classes

[← Index](00-index.md) | [Next: Universes →](02-universes.md)

---

Every algebraic definition in this book — `Group`, `Ring`, `Module` — is
written as a plain `structure`. Mathlib, the real Lean library, defines
all of these using `class` instead:

```lean
-- this book's style
structure Group (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  -- ...

-- Mathlib's style (schematically — not the literal Mathlib source)
class Group (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  -- ...
```

Syntactically these look almost identical. `class` is very nearly a
shorthand for `structure` plus one extra mechanism. Understanding exactly what that
mechanism is, and why this book avoids it until you've built the
intuition `class` would otherwise hide, is the point of this section.

### What `class` actually adds: instance search

A `class` is a `structure` whose *inhabitants* Lean is willing to search
for automatically, through a process called **typeclass resolution** (or
"instance search"). When you write `class Group (G : Type)`, and then
register a particular group structure with the keyword `instance` instead
of `def`:

```lean
instance : Group Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  -- ...
```

Lean remembers `Int`'s group structure in a global table. From then on,
any function that takes an *implicit* `[Group G]` argument (square
brackets, not curly braces — this is a third kind of argument, an **instance
argument**) gets it filled in automatically whenever `G` is unified with
`Int`, with no explicit term needed at the call site:

```lean
def opTwice [Group G] (x : G) : G :=
  Group.op x x   -- the `Group G` instance is found automatically

#eval opTwice (3 : Int)   -- Lean infers the `Group Int` instance silently
```

Compare this to the style used throughout this book, where every theorem
about groups takes an *explicit* term `Grp : Group G` as a genuine
function argument:

```lean
def opTwice (Grp : Group G) (x : G) : G :=
  Grp.op x x

#eval opTwice intGroup 3   -- you must name the specific Group term
```

Mathematically, the difference is this: `class` + `instance` implements the
same convention as ordinary mathematical prose, where you write "let $G$
be a group" once and then simply write $a \cdot b$, $e$, $a^{-1}$
after that. The *specific* group structure is left implicit, tracked by
context, and never re-named at each use. Lean's typeclass mechanism
automates exactly that convention. A `structure`-only approach (this
book's style) is the more careful alternative where you *always* carry
the structure around explicitly, the way you would if a referee demanded
that you never leave out which group operation you mean.

### Why this book deliberately avoids `class`, for now

`class`'s automation is exactly what would make it harder to see, the
first time through, what is actually happening. Every `Grp.op`, every
`Grp.assoc` in this book's proofs is a visible, traceable term. You can
always ask "where did this fact come from?" and point at the specific
argument it's a field of. With `class`, that same information is present
but resolved silently by the elaborator. That's wonderful once you trust
it, but painful to debug the first time instance resolution picks the
"wrong" (or an unexpected) instance, or fails to find one at all. Learning
to read the *explicit* version first, this book's approach, builds the
mental model that makes debugging *silent* instance-resolution failures
manageable later, because you already know what data is being
threaded through even when it's no longer visible in the source text.

### The bridge to Mathlib

Nothing about the *mathematical content* changes between the two styles.
`Group`'s axioms are the axioms, in either encoding. The type-class version
also usually bundles in the group's `*`, `⁻¹`, `1` as genuine
*notation* (through further, separate mechanisms — `Mul`, `Inv`, `One` type
classes that `Group` extends), so that Mathlib code reads as `a * b`
instead of `Grp.op a b`. Chapter 13's suggested projects include redoing
this book's `Group`/`Ring` as type classes once you're comfortable. At
that point, everything in this section is the vocabulary you'll need.

### A note on `.toGroup`, `.toPoint`, and coercion

Whenever a `structure` extends another (Chapter 2's `Point3D extends Point`,
this book's `CommGroup extends Group`), Lean generates a field named
`.toX` that projects back to the parent structure. `cg.toGroup` recovers the
underlying `Group` from a `CommGroup cg`. Lean also lets you *drop* the
`.toGroup` and write `cg.op` directly, silently inserting the projection
for you. This automatic insertion of a "translate from one type to
another" function is an instance of **coercion**, the general mechanism by
which Lean lets a term of one type stand in for a term of a related type
without you writing the conversion explicitly. It is the same general idea,
though a much simpler case, as coercing `Nat` values into `Int`. The
literal projection differs, but "insert a conversion function
automatically so notation reads naturally" is the shared mechanism.

> Read more: TPiL's chapters on "Structures and Records" and "Type
> Classes" cover both topics in this section directly, including
> coercions, in more depth and with additional worked examples than this
> book provides.

---

[← Index](00-index.md) | [Next: Universes →](02-universes.md)
