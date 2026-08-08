## Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)

---

The previous section asked why this book delays the `class` mechanism in Lean
in favor of plain `structure`. This section asks the second of the three
questions the chapter introduction raised. Chapter 1 said `Type` is
itself a term, of some type. A careful reader
should immediately ask *of what type?* If the answer were "`Type` is a
term of type `Type`," the logic of Lean would be inconsistent. This is exactly
the Russell paradox in type-theoretic form. The type of "all types," if it
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
`Point`/`Pair` structures from Chapter 3.

### Why this matters for `Group`

Recall `structure Group (G : Type) where ...` from Chapter 7. This
signature commits to `G : Type`, meaning `G` lives in the universe `Type 0`.
The natural question is whether `Group` itself has a `Group`-structure. Is `Group Int` an
element of some `Group (Group Int)`? Setting aside whether that would even
be meaningful, a more basic obstruction is evident. `Group Int` is a `Type`
(`#check (Group Int : Type)` type-checks, since a `structure`
applied to its parameters is itself a type), but `Group`, the type
*constructor* itself (before applying it to a carrier `G`), is not a
`Type` at all. It is a function `Type → Type`, that is, a term of type
`Type → Type`.

*Why* does `Type → Type` live in `Type 1` rather than back in `Type 0`?
This is not merely a bookkeeping choice. It follows from the specific
typing rule Lean uses for building function (Π-)types out of universes.
Forming `A → B` when `A : Type i` and `B : Type j` produces a term of type
`Type (max i j)`. Concretely here, `A := Type` (living in `Type 1`, since
`Type : Type 1`) and `B := Type` again, so `Type → Type` itself lands in
`Type (max 1 1) = Type 1`.
[Chapter 6, Section 3](03-typing-rules-and-safety.md) states this rule precisely
as one line of the calculus of constructions, including the one case not
covered by `max`, namely when `B` is a proposition. The short version
is that `Group` is not even a candidate carrier type for its own
construction. It sits one universe level too high, exactly because it is a
function *out of* `Type` itself, not out of some ordinary `Type 0` type
like `Nat`.

### Universe polymorphism (a brief note)

A definition is occasionally written with an explicit universe
variable, e.g. `structure Group.{u} (G : Type u) where ...`. This makes
the definition **universe polymorphic**, usable the same way whether `G`
lives in `Type 0`, `Type 1`, or any level, rather than pinned to `Type 0`
specifically. This book fixes everything at `Type` (that is, `Type 0`) for
simplicity, since none of the groups, rings, or modules built here need
anything larger. The actual definitions in Mathlib are universe polymorphic
throughout, exactly because they must accommodate constructions (such as
"the group of automorphisms of a large category") that genuinely do not fit
in `Type 0`.

> Read more. [Chapter 6, Section 3](03-typing-rules-and-safety.md) states the
> universe-formation rules precisely, as part of the calculus of
> constructions. Externally, the "Dependent Type Theory" chapter of
> the *Theorem Proving in Lean 4* manual ([TPIL4]) covers universes at a
> similar level of detail with more Lean-specific examples.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Universe hierarchy.** "Think of `Type 0` as a universe of 'small'
  or 'ordinary' types. `Type 1` is then a larger universe of types,
  which contains `Type 0` as an element, and `Type 2` is an even
  larger universe of types, which contains `Type 1` as an element.
  The list is infinite, there is a `Type n` for every natural number
  `n`. `Type` is an abbreviation for `Type 0`" ([TPIL4], §2.2 "Types
  as objects").
- **Universe polymorphism.** "Some operations ... need to be
  polymorphic over type universes. For example, `List α` should make
  sense for any type `α`, no matter which type universe `α` lives in
  ... Lean allows you to declare universe variables explicitly using
  the `universe` command" ([TPIL4], §2.2).
- Girard, *"Interprétation fonctionnelle et élimination des coupures dans l'arithmétique d'ordre supérieure,"* Thèse d'État, Université Paris VII, 1972 (not yet in the bibliography of this book), is the actual source of the `Type : Type` inconsistency, the proof that a calculus with the rule `⊢ * : *` loses the normalization property. [Girard1971] (the 1971/1970 "Une extension de l'interprétation de Gödel à l'analyse" paper, already in the bibliography of this book) is a different, earlier paper and is not that source. The 1986 paper by Thierry Coquand, "An analysis of Girard's paradox," LICS 1986, is the standard modern exposition, also not yet cited here.

[TPIL4]: ../bibliography.md#tpil4
[Girard1971]: ../bibliography.md#girard1971

---

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)
