## Chapter 8: Rings

[← Chapter 7](06-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](08-chapter-9.md)

---

**1. `boolAndOrRing` (the ring $\mathbb{Z}/2\mathbb{Z}$ on `Bool`)**

```lean
def bool2CommGroup : CommGroup Bool where
  toGroup := boolXorGroup
  comm := by
    intro a b
    cases a with
    | false => cases b with | false => rfl | true => rfl
    | true => cases b with | false => rfl | true => rfl

def bool2Ring : Ring Bool where
  addGrp := bool2CommGroup
  mul := Bool.and
  one := true
  mul_assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  one_mul := by
    intro a
    cases a with | false => rfl | true => rfl
  mul_one := by
    intro a
    cases a with | false => rfl | true => rfl
  left_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  right_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
```

We reuse `boolXorGroup` from Chapter 6's exercise as the additive group
(`+` = XOR, `0` = `false`), and add `∧` (Boolean and) as multiplication with
`1 = true`. As with `assoc` in Chapter 6, every axiom is a finite check over
$2$ or $2^3$ cases, each closed by [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) since `Bool.and`/`Bool.xor` compute
on concrete constructors. This is exactly $\mathbb{Z}/2\mathbb{Z}$: XOR is
addition mod 2, and AND is multiplication mod 2.

**2. Why both `left_distrib` and `right_distrib` are needed**

Distributivity as usually stated, $a(b+c) = ab+ac$, only lets you expand a
product with the *sum on the right*. Its mirror, $(a+b)c = ac+bc$, expands
a product with the *sum on the left*. If `mul` were known to be
commutative, these two would be interchangeable — just apply `comm` and use
the other one. But a general `Ring` (unlike a `CommRing`) makes no such
assumption. In fact, Chapter 9's proof of `mul_zero` uses `left_distrib`,
while `mul_zero_left` (its mirror, an exercise) needs `right_distrib`
instead, precisely because there is no `mul_comm` field to convert one
into the other.

**3. `theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X`**

```lean
theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X := by
  refine ⟨X, Y, fun h => ?_⟩
  rw [Mat2.mk.injEq] at h
  exact absurd h.1 (by decide)
```

`X` and `Y` are the witness pair already computed in the chapter (`Mat2.mul
X Y` evaluates to `⟨2, 1, 1, 1⟩`, `Mat2.mul Y X` to `⟨1, 1, 1, 2⟩`), so
`refine ⟨X, Y, fun h => ?_⟩` only needs to derive `False` from an assumed
equality `h : Mat2.mul X Y = Mat2.mul Y X`. As the exercise's hint notes,
`by decide` cannot attack `h` directly — `Mat2` has no `DecidableEq`
instance — so `Mat2.mk.injEq` first turns `h` into a conjunction of four
`Int` equalities, one per field. `h.1`, the first conjunct, states
`2 = 1` (the two matrices' `a11` entries). `Int` *does* have decidable
equality for this, so `by decide` refutes it directly. `absurd` then
combines the false hypothesis with its refutation to close the goal.

---

[← Chapter 7](06-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](08-chapter-9.md)
