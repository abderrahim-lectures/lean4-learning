## Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)

---

Chapter 1 said `Type` is itself a term, of some type. A careful reader
should immediately ask: *of what type?* If the answer were "`Type` is a
term of type `Type`," Lean's logic would be inconsistent. This is exactly
Russell's paradox in type-theoretic form: the type of "all types," if it
contained itself, would permit rebuilding the set-of-all-sets-that-do-not-
contain-themselves paradox inside the type theory. Lean avoids this with
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

Each `Type u` is itself a term of `Type (u+1)`, never of itself. This gives
just enough structure to block the paradox, while still permitting "for
every type" (quantifying over some fixed `Type u`) to be said as often as
needed. `Type` on its own (with no numeral) is notation for `Type 0`, the
universe containing "ordinary" types like `Nat`, `Bool`, `Int`, and the
`Point`/`Pair` structures from Chapter 2.

### Why this matters for `Group`

Recall `structure Group (G : Type) where ...` from Chapter 6. This
signature commits to `G : Type`, meaning `G` lives in the universe `Type 0`.
The natural question: does `Group` itself have a `Group`-structure? Is `Group Int` an
element of some `Group (Group Int)`? Setting aside whether that would even
be meaningful, a more basic obstruction is evident. `Group Int` is a `Type`
(`#check (Group Int : Type)` type-checks, since a `structure`
applied to its parameters is itself a type), but `Group`, the type
*constructor* itself (before applying it to a carrier `G`), is not a
`Type` at all. It is a function `Type → Type`, that is, a term of type
`Type → Type`.

*Why* does `Type → Type` live in `Type 1` rather than back in `Type 0`?
This is not merely a bookkeeping choice. It follows from the specific
typing rule Lean uses for building function (Π-)types out of universes:
forming `A → B` when `A : Type i` and `B : Type j` produces a term of type
`Type (max i j)`, *unless* `B`'s universe already needs to be at least one
level higher to safely contain "the collection of all functions out of `A`".
Concretely here, `A := Type` (living in `Type 1`, since `Type : Type 1`)
and `B := Type` again, so `Type → Type` itself lands in `Type 1`.
[Chapter 5 §3](03-typing-rules-and-safety.md) states this rule precisely
as one line of the calculus of constructions. The short version
is that `Group` is not even a candidate carrier type for its own
construction. It sits one universe level too high, exactly because it is a
function *out of* `Type` itself, not out of some ordinary `Type 0` type
like `Nat`.

### Universe polymorphism (a brief note)

A definition is occasionally written with an explicit universe
variable, e.g. `structure Group.{u} (G : Type u) where ...`. This makes
the definition **universe polymorphic**: usable the same way whether `G`
lives in `Type 0`, `Type 1`, or any level, rather than pinned to `Type 0`
specifically. This book fixes everything at `Type` (that is, `Type 0`) for
simplicity, since none of the groups, rings, or modules built here need
anything larger. Mathlib's actual definitions are universe polymorphic
throughout, exactly because they must accommodate constructions (such as
"the group of automorphisms of a large category") that genuinely do not fit
in `Type 0`.

> Read more: [Chapter 5 §3](03-typing-rules-and-safety.md) states the
> universe-formation rules precisely, as part of the calculus of
> constructions. Externally, the "Dependent Type Theory" chapter of
> the *Theorem Proving in Lean 4* manual covers universes at a similar
> level of detail with more Lean-specific examples.

---

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)
