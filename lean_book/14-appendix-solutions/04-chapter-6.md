## Chapter 6: Groups

[← Chapter 5](03-chapter-5.md) | [Index](00-index.md) | [Next: Chapter 7 →](05-chapter-7.md)

---

**1. `boolXorGroup : Group Bool`**

```lean
def boolXorGroup : Group Bool where
  op := Bool.xor
  id := false
  inv := fun a => a
  assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  id_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  id_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
```

Each field reduces to a finite check: `Bool.xor` on two or three concrete
booleans always computes, so once every variable is replaced by a concrete
constructor (`false`/`true`) via `cases`, the resulting equation is
definitional and `rfl` closes it. `assoc` needs three nested `cases` since
it quantifies over three booleans ($2^3 = 8$ cases, matching
$(a \oplus b) \oplus c = a \oplus (b \oplus c)$ over $\mathbb{Z}/2$); the
others need only one.

**2. `inv_left`/`inv_right` are genuinely different obligations**

For a general (non-abelian) group, `Grp.op (Grp.inv a) a = Grp.id` and
`Grp.op a (Grp.inv a) = Grp.id` are a priori independent statements — `op`
need not be commutative, so nothing forces "inverse on the left" to equal
"inverse on the right" without separately postulating (or proving) both.
Chapter 7, Theorem 2 (`left_inverse_unique`) shows something subtler:
*given* both axioms hold for the *distinguished* `Grp.inv`, any *other*
element that is merely a left inverse of `a` must already equal
`Grp.inv a` — i.e. left inverses are automatically unique once two-sided
inverses are known to exist, which is what lets one-sided inverse-uniqueness
arguments substitute for commutativity in that specific proof. It does not
mean `inv_left` and `inv_right` were redundant as *axioms*; only that, once
both hold, "a" left inverse coincides with "the" two-sided one.

---

[← Chapter 5](03-chapter-5.md) | [Index](00-index.md) | [Next: Chapter 7 →](05-chapter-7.md)
