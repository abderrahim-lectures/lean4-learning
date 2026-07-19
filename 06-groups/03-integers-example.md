## A first example: the integers under addition

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Permutations example →](04-permutations-example.md)

---

Consider packaging $(\mathbb{Z}, +, 0, -(-))$ as a `Group Int`. The construction
proceeds field by field, proving each obligation with a short, explicit tactic proof.

<p><a href="https://live.lean-lang.org/#code=def%20intGroup%20%3A%20Group%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20--%20Goal%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%0A%20%20%20%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%200%20%2B%20a%20%3D%20a%0A%20%20%20%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%20a%0A%20%20%20%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20%28-a%29%20%2B%20a%20%3D%200%0A%20%20%20%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20%28-a%29%20%3D%200%0A%20%20%20%20exact%20Int.add_right_neg%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20intGroup%20%3A%20Group%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20--%20Goal%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%0A%20%20%20%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%200%20%2B%20a%20%3D%20a%0A%20%20%20%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%20a%0A%20%20%20%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20%28-a%29%20%2B%20a%20%3D%200%0A%20%20%20%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20%28-a%29%20%3D%200%0A%20%20%20%20exact%20Int.add_right_neg%20a" title="Lean playground" loading="lazy" style="width:100%;height:516px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Each field is proved separately. Each proof is a single `intro` (to name
the universally quantified variables) followed by `exact` naming the exact
core-library lemma that already states this fact about `Int`. No step is
hidden: `Int.add_assoc`, `Int.zero_add`, and the rest are
themselves proved (elsewhere, in Lean's core library) by induction on the
same `Nat`/`Int` representation introduced in Chapter 4. These lemmas are
reused here rather than re-deriving integer arithmetic from scratch.

**Mathematical reading.** This shows $(\mathbb{Z}, +, 0, -)$ as an object
of the category $\mathbf{Grp}$. The term `intGroup` is a *proof that
$\mathbb{Z}$ is a group*, built by giving the data $(+, 0, -)$ and
verifying each axiom. The verification is not re-proved here but *cited*:
associativity is $\mathrm{Int.add\_assoc}$, the identity laws are $0 + a = a
= a + 0$, and the inverse laws are $(-a) + a = 0 = a + (-a)$. In textbook
terms this is the one-line remark "$\mathbb{Z}$ under addition is an abelian
group," with the underlying lemmas about $\mathbb{Z}$ (themselves ultimately
inductions on the integers) written out in full instead of just assumed.

**Mathlib equivalent.** Mathlib requires no `intGroup`-style bundle at
all: `Int` is *already* registered as an [`AddCommGroup`](https://loogle.lean-lang.org/?q=AddCommGroup) instance, and the
five axioms above are available as free-standing lemmas that apply to
every additive group, not just `Int`:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20AddCommGroup%20Int%20%3A%3D%20inferInstance%0A%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%20%3A%3D%20add_assoc%20a%20b%20c%0Aexample%20%28a%20%3A%20Int%29%20%3A%200%20%2B%20a%20%3D%20a%20%3A%3D%20zero_add%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2B%200%20%3D%20a%20%3A%3D%20add_zero%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20-a%20%2B%20a%20%3D%200%20%3A%3D%20neg_add_cancel%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2B%20-a%20%3D%200%20%3A%3D%20add_neg_cancel%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20AddCommGroup%20Int%20%3A%3D%20inferInstance%0A%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%20%3A%3D%20add_assoc%20a%20b%20c%0Aexample%20%28a%20%3A%20Int%29%20%3A%200%20%2B%20a%20%3D%20a%20%3A%3D%20zero_add%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2B%200%20%3D%20a%20%3A%3D%20add_zero%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20-a%20%2B%20a%20%3D%200%20%3A%3D%20neg_add_cancel%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2B%20-a%20%3D%200%20%3A%3D%20add_neg_cancel%20a" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the same content as `intGroup`, the same five facts about
$\mathbb{Z}$. But where the book *assembles* a `Group Int` term by hand,
Mathlib's version has nothing to assemble: the instance already exists,
found automatically by [`inferInstance`](https://loogle.lean-lang.org/?q=inferInstance). And [`add_assoc`](https://loogle.lean-lang.org/?q=add_assoc)/[`zero_add`](https://loogle.lean-lang.org/?q=zero_add)/etc.
are generic lemmas about *any* `AddCommGroup`, so they read somewhat
differently from `Int.add_assoc`: they apply equally well to Chapter 6's
`perm3Group`-style examples once those are phrased in Mathlib's
`Group`/`AddCommGroup` classes (Chapter 6 §4 does exactly that next).

---

[← Translating into Lean](02-translating.md) | [Index](00-index.md) | [Next: Permutations example →](04-permutations-example.md)
