## Chapter 3: Functions, definitions, and structures

[← Chapter 2](02-chapter-2.md) | [Index](00-index.md) | [Next: Chapter 4 →](04-chapter-4.md)

---

**1. `Rectangle` and `area`**

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

**2. `Box α` and `unwrap`**

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

**3. `ColoredRectangle` and the forgetful projection**

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
