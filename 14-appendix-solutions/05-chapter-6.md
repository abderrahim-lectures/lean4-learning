## Chapter 6: Groups

[← Chapter 5](04-chapter-5.md) | [Index](00-index.md) | [Next: Chapter 7 →](06-chapter-7.md)

---

**1. `boolXorGroup : Group Bool`**

<p><a href="https://live.lean-lang.org/#code=def%20boolXorGroup%20%3A%20Group%20Bool%20where%0A%20%20op%20%3A%3D%20Bool.xor%0A%20%20id%20%3A%3D%20false%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20boolXorGroup%20%3A%20Group%20Bool%20where%0A%20%20op%20%3A%3D%20Bool.xor%0A%20%20id%20%3A%3D%20false%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20cases%20b%20with%0A%20%20%20%20%20%20%7C%20false%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20%20%20%20%20%7C%20true%20%3D%3E%20cases%20c%20with%20%7C%20false%20%3D%3E%20rfl%20%7C%20true%20%3D%3E%20rfl%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20cases%20a%20with%0A%20%20%20%20%7C%20false%20%3D%3E%20rfl%0A%20%20%20%20%7C%20true%20%3D%3E%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:650px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Each field reduces to a finite check. `Bool.xor` on two or three concrete
booleans always computes, so once every variable is replaced by a concrete
constructor (`false`/`true`) via [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), the resulting equation holds by
definition and [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) closes it. `assoc` needs three nested `cases` since
it quantifies over three booleans ($2^3 = 8$ cases, matching
$(a \oplus b) \oplus c = a \oplus (b \oplus c)$ over $\mathbb{Z}/2$). The
others need only one.

**2. `inv_left`/`inv_right` are genuinely different obligations**

For a general (non-abelian) group, `Grp.op (Grp.inv a) a = Grp.id` and
`Grp.op a (Grp.inv a) = Grp.id` are, in principle, independent statements.
`op` need not be commutative, so nothing forces "inverse on the left" to
equal "inverse on the right" unless both are stated (or proved) separately.
Chapter 7, Theorem 2 (`left_inverse_unique`) establishes something subtler:
given that both axioms hold for the distinguished `Grp.inv`, any other
element that is merely a left inverse of `a` must already equal
`Grp.inv a`. In other words, left inverses are automatically unique once
two-sided inverses are known to exist. This is what lets one-sided
inverse-uniqueness arguments substitute for commutativity in that specific
proof. It does not mean `inv_left` and `inv_right` were redundant as
axioms — only that, once both hold, "a" left inverse coincides with
"the" two-sided one.

---

[← Chapter 5](04-chapter-5.md) | [Index](00-index.md) | [Next: Chapter 7 →](06-chapter-7.md)
