## Chapter 8: Rings

[← Chapter 7](05-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](07-chapter-9.md)

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

Reusing `boolXorGroup` from Chapter 6's exercise as the additive group
(`+` = XOR, `0` = `false`), we add `∧` (Boolean and) as multiplication with
`1 = true`. As with `assoc` in Chapter 6, every axiom is a finite check over
$2$ or $2^3$ cases, each closed by `rfl` since `Bool.and`/`Bool.xor` compute
on concrete constructors. This is exactly $\mathbb{Z}/2\mathbb{Z}$: XOR is
addition mod 2, AND is multiplication mod 2.

**2. Why both `left_distrib` and `right_distrib` are needed**

Distributivity as usually stated, $a(b+c) = ab+ac$, only lets you expand a
product with the *sum on the right* factor. Its mirror,
$(a+b)c = ac+bc$, expands a product with the *sum on the left* factor. If
`mul` were known to be commutative these would be interchangeable (apply
`comm` and use the other one), but a general `Ring` (as opposed to a
`CommRing`) makes no such assumption — indeed Chapter 9's proof of
`mul_zero` uses `left_distrib`, while `mul_zero_left` (its mirror, an
exercise) needs `right_distrib` instead, precisely because there is no
`mul_comm` field available to convert one into the other.

---

[← Chapter 7](05-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](07-chapter-9.md)
