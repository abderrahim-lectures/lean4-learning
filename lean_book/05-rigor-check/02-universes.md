## Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](03-defeq-vs-propeq.md)

---

Chapter 1 said `Type` is itself a term, of some type. A careful reader
should immediately ask: *of what type?* If the answer were "`Type` is a
term of type `Type`," Lean's logic would be inconsistent — this is exactly
Russell's paradox in type-theoretic dress (the type of "all types," if it
contained itself, would let you reconstruct the set-of-all-sets-that-don't-
contain-themselves paradox inside the type theory). Lean avoids this with
a **hierarchy of universes**.

### The hierarchy

```lean
#check (Nat : Type)        -- Nat itself lives in Type
#check (Type : Type 1)      -- Type lives one level up, in Type 1
#check (Type 1 : Type 2)    -- and so on, forever
```

$$
\mathtt{Nat} : \mathtt{Type} : \mathtt{Type}\ 1 : \mathtt{Type}\ 2 : \cdots
$$

Each `Type u` is itself a term of `Type (u+1)`, never of itself — exactly
enough stratification to block the paradox, while still letting you say
"for every type" (quantifying over some fixed `Type u`) as often as you
like. `Type` on its own (with no numeral) is notation for `Type 0`, the
universe containing "ordinary" types like `Nat`, `Bool`, `Int`, and the
`Point`/`Pair` structures from Chapter 2.

### Why this matters for `Group`

Recall `structure Group (G : Type) where ...` from Chapter 6. This
signature commits to `G : Type`, i.e. `G` lives in the universe `Type 0`.
Now ask: does `Group` itself have a `Group`-structure — is `Group Int` an
element of some `Group (Group Int)`? Setting aside whether that would even
be meaningful, notice a more basic obstruction: `Group Int` is a `Type`
(check `#check (Group Int : Type)` — it type-checks, since a `structure`
applied to its parameters is itself a type), but `Group`, the type
*constructor* itself (before applying it to a carrier `G`), is not a
`Type` at all — it's a function `Type → Type`, i.e. a term of type
`Type → Type`.

*Why* does `Type → Type` live in `Type 1` rather than back in `Type 0`?
This isn't just plausible bookkeeping — it follows from the specific
typing rule Lean uses for building function (Π-)types out of universes:
forming `A → B` when `A : Type i` and `B : Type j` produces a term of type
`Type (max i j)`, *unless* `B`'s universe already needs to be at least one
higher to safely contain "the collection of all functions out of `A`" —
concretely here, `A := Type` (living in `Type 1`, since `Type : Type 1`)
and `B := Type` again, so `Type → Type` itself lands in `Type 1`. [Appendix
B §4](../15-lambda-calculus/04-dependent-types-coc.md) states this rule
precisely as one line of the calculus of constructions; the short version
for now is that `Group` isn't even a candidate carrier type for its own
construction — it's one universe level too high, exactly because it is a
function *out of* `Type` itself, not out of some ordinary `Type 0` type
like `Nat`.

This is not merely a technicality to wave away — it is the precise
type-theoretic reason a naive "category of all groups, where the
collection of groups is itself considered as an object" runs into
size issues, mirroring exactly the set-theoretic caution familiar from
category theory: the collection of all groups is a **proper class**, not a
set, and $\mathbf{Grp}$ is accordingly a *large* category (one whose
objects don't form a set/small type) rather than a small one. Lean's
universe hierarchy is the mechanized version of the same size discipline
category theorists already carry around informally when they distinguish
small categories from large ones, or worry about whether a construction
like "the category of all categories" needs a further Grothendieck
universe to make sense.

### Universe polymorphism (a brief note)

You will occasionally see a definition written with an explicit universe
variable, e.g. `structure Group.{u} (G : Type u) where ...`. This makes
the definition **universe polymorphic** — usable uniformly whether `G`
lives in `Type 0`, `Type 1`, or any level — rather than pinned to `Type 0`
specifically. This book fixes everything at `Type` (i.e. `Type 0`) for
simplicity, since none of the groups, rings, or modules we build need
anything larger; Mathlib's actual definitions are universe polymorphic
throughout, precisely because they must accommodate constructions (like
"the group of automorphisms of a large category") that genuinely don't fit
in `Type 0`.

> Read more: [Appendix B §4](../15-lambda-calculus/04-dependent-types-coc.md)
> states the universe-formation rules precisely, as part of the calculus
> of constructions. Externally, the "Dependent Type Theory" chapter of
> the *Theorem Proving in Lean 4* manual covers universes at a similar
> level of detail with more Lean-specific examples.

---

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Definitional vs propositional equality →](03-defeq-vs-propeq.md)
