## Chapter 3: Functions, definitions, and structures

[← Chapter 2](02-chapter-2.md) | [Index](00-index.md) | [Next: Chapter 4 →](04-chapter-4.md)

---

**1. Why `⟨0, 0⟩` is unambiguous**

`def origin : Point := ⟨0, 0⟩` type-checks unambiguously because the
*expected type* `Point` is already fixed by the `def`'s signature before
the right-hand side is elaborated. Lean reads off `Point`'s constructor
and field order from that expected type alone, so `⟨0, 0⟩` needs no
further information to know it means `Point.mk 0 0` rather than, say,
`Pair.mk 0 0`.

This property fails whenever no expected type is available, or several
structures with the same field arity are simultaneously in scope with
nothing to disambiguate them: `#check (⟨0, 0⟩ : _)` with the placeholder
left fully open. Lean cannot choose a constructor from field values
alone, and reports an "expected type" error rather than a fabricated
guess. The named form `{ x := ..., y := ... }` sidesteps this, since the
field names themselves pin down the constructor regardless of context.

**2. Writing out `.toPoint` by hand**

Without `extends`, the projection `extends Point` generates would have to
be written explicitly, as
`def Point3D.toPoint (p : Point3D) : Point := { x := p.x, y := p.y }`.

This is precisely a **forgetful functor**
([Chapter 2, Section 1](../02-terminology-and-coc/01-terminology.md), and
the Mathematical reading box of
[Section 3](../03-functions-and-structures/03-extending-structures.md)):
a map that keeps some of the data of a structure (here, `x` and `y`) and
discards the rest (`z`). `extends` generates exactly this projection
automatically, under the name `.toPoint`, rather than requiring it to be
written by hand for every extension.

**3. Proof fields change nothing about type-checking**

Claim: a `structure` field whose declared type is a proposition `P` is
checked by exactly the same mechanism as a field whose declared type is
`Nat` or any other `Type`.

*Proof.* Field checking in a `structure` constructor is uniform across
all fields: given `{ f₁ := e₁, ..., fₙ := eₙ }`, Lean elaborates each `eᵢ`
against the declared type of `fᵢ` and accepts the term exactly when that
type-check succeeds, regardless of which universe (`Type` or `Prop`) the
declared type inhabits. Supplying a proof field is the ordinary case of
this rule with `fᵢ : P` for some `P : Prop`; the term `eᵢ` supplied must
be a proof of `P`, checked once, at construction time, the same way `eᵢ`
supplied for a `Nat`-typed field must genuinely have type `Nat`. $\blacksquare$

This is exactly what makes `Group` (Chapter 7) impossible to build
carelessly. Its axiom fields (`assoc`, `id_left`, ...) are `Prop`-valued
fields like any other, so a `Group` value cannot be assembled without
supplying an actual proof of each axiom, checked by the same constructor
mechanism that checks `op`, `id`, and `inv`.

**4. `Rectangle` and `area`**

```lean
structure Rectangle where
  width : Nat
  height : Nat

def area (r : Rectangle) : Nat := r.width * r.height

#eval area ⟨3, 4⟩   -- 12
```

`⟨3, 4⟩` is the anonymous constructor, filling `width` and `height` in
field-declaration order. `area` reads both fields back out via `.width`
and `.height` projection and multiplies them. Nothing here differs from
`Point`/`shift` in Section 1, only the field names and the arithmetic
change.

**5. `Box α` and `unwrap`**

```lean
structure Box (α : Type) where
  value : α

def unwrap {α : Type} (b : Box α) : α := b.value

def natBox : Box Nat := ⟨7⟩
def strBox : Box String := ⟨"seven"⟩

#eval unwrap natBox   -- 7
#eval unwrap strBox   -- "seven"
```

`Box` is `Pair` with one slot instead of two, the same
"parameterize by the type itself" idea from Section 2, at its simplest
possible size. `Box Nat` and `Box String` are two different types,
generated from the one `structure Box (α : Type)` declaration, the way
`Pair Nat String` and `Pair String Nat` are two different instantiations
of `Pair`. `unwrap` is implicit in `α`, exactly like `identity` in
Chapter 1, since the type of `b.value` already determines it.

**6. `ColoredRectangle` and the forgetful projection**

```lean
structure ColoredRectangle extends Rectangle where
  color : String

def redSquare : ColoredRectangle :=
  { width := 5, height := 5, color := "red" }

#check redSquare.toRectangle      -- redSquare.toRectangle : Rectangle
#eval area redSquare.toRectangle  -- 25
```

`redSquare.toRectangle` has type `Rectangle`, generated automatically by
`extends`, discarding only the `color` field and keeping `width`/`height`
untouched. `area` was written once, against `Rectangle`, with no
knowledge that `ColoredRectangle` would ever exist. Calling it on
`redSquare.toRectangle` reuses that same function unchanged, computing
`25` from the inherited `width`/`height` fields alone. This is exactly
the forgetful-functor pattern from the Mathematical reading box of
Section 3, not a coincidence of naming. `.toRectangle` is the map
$U : \mathrm{ColoredRectangle} \to \mathrm{Rectangle}$ that strips away
the extra structure (the `color` field) and keeps everything else, and
`area` factoring through it is exactly what it means for `area` to be a
function defined on the *underlying* `Rectangle`, indifferent to whatever
extra data the specific extension of a caller happens to add on top.

---

[← Chapter 2](02-chapter-2.md) | [Index](00-index.md) | [Next: Chapter 4 →](04-chapter-4.md)
