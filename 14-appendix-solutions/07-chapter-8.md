## Chapter 8: Rings

[← Chapter 7](06-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](08-chapter-9.md)

---

**1. `boolAndOrRing` (the ring $\mathbb{Z}/2\mathbb{Z}$ on `Bool`)**

<p><a href="https://live.lean-lang.org/#code=def%20bool2CommGroup%20%3A%20CommGroup%20Bool%20where%0A%20%20toGroup%20%3A%3D%20boolXorGroup%0A%20%20comm%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%0Adef%20bool2Ring%20%3A%20Ring%20Bool%20where%0A%20%20addGrp%20%3A%3D%20bool2CommGroup%0A%20%20mul%20%3A%3D%20Bool.and%0A%20%20one%20%3A%3D%20true%0A%20%20mul_assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20one_mul%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20mul_one%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20left_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20right_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20bool2CommGroup%20%3A%20CommGroup%20Bool%20where%0A%20%20toGroup%20%3A%3D%20boolXorGroup%0A%20%20comm%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%0Adef%20bool2Ring%20%3A%20Ring%20Bool%20where%0A%20%20addGrp%20%3A%3D%20bool2CommGroup%0A%20%20mul%20%3A%3D%20Bool.and%0A%20%20one%20%3A%3D%20true%0A%20%20mul_assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20one_mul%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20mul_one%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20left_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20right_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:650px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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

<p><a href="https://live.lean-lang.org/#code=theorem%20mat2_not_comm%20%3A%20%E2%88%83%20X%20Y%20%3A%20Mat2%2C%20Mat2.mul%20X%20Y%20%E2%89%A0%20Mat2.mul%20Y%20X%20%3A%3D%20by%0A%20%20refine%20%E2%9F%A8X%2C%20Y%2C%20fun%20h%20%3D%3E%20%3F_%E2%9F%A9%0A%20%20rw%20%5BMat2.mk.injEq%5D%20at%20h%0A%20%20exact%20absurd%20h.1%20%28by%20decide%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20mat2_not_comm%20%3A%20%E2%88%83%20X%20Y%20%3A%20Mat2%2C%20Mat2.mul%20X%20Y%20%E2%89%A0%20Mat2.mul%20Y%20X%20%3A%3D%20by%0A%20%20refine%20%E2%9F%A8X%2C%20Y%2C%20fun%20h%20%3D%3E%20%3F_%E2%9F%A9%0A%20%20rw%20%5BMat2.mk.injEq%5D%20at%20h%0A%20%20exact%20absurd%20h.1%20%28by%20decide%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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
