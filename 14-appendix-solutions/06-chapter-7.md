## Chapter 7: Group examples and basic theorems

[← Chapter 6](05-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](07-chapter-8.md)

---

**1. `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`**

<p><a href="https://live.lean-lang.org/#code=theorem%20inv_inv%20%28a%20%3A%20G%29%20%3A%20Grp.inv%20%28Grp.inv%20a%29%20%3D%20a%20%3A%3D%20by%0A%20%20apply%20Eq.symm%0A%20%20apply%20left_inverse_unique%20Grp%20%28Grp.inv%20a%29%20a%0A%20%20--%20Goal%3A%20op%20a%20%28inv%20a%29%20%3D%20id%0A%20%20exact%20Grp.inv_right%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20inv_inv%20%28a%20%3A%20G%29%20%3A%20Grp.inv%20%28Grp.inv%20a%29%20%3D%20a%20%3A%3D%20by%0A%20%20apply%20Eq.symm%0A%20%20apply%20left_inverse_unique%20Grp%20%28Grp.inv%20a%29%20a%0A%20%20--%20Goal%3A%20op%20a%20%28inv%20a%29%20%3D%20id%0A%20%20exact%20Grp.inv_right%20a" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

By `left_inverse_unique` (Chapter 7, Theorem 2), to show
`a = Grp.inv (Grp.inv a)` it suffices to show `a` is a left inverse of
`Grp.inv a`, i.e. `Grp.op a (Grp.inv a) = Grp.id` — exactly `Grp.inv_right a`.

**2. `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`**

<p><a href="https://live.lean-lang.org/#code=theorem%20cancel_left%20%28a%20b%20c%20%3A%20G%29%20%28h%20%3A%20Grp.op%20a%20b%20%3D%20Grp.op%20a%20c%29%20%3A%20b%20%3D%20c%20%3A%3D%20by%0A%20%20have%20h1%20%3A%20Grp.op%20%28Grp.inv%20a%29%20%28Grp.op%20a%20b%29%20%3D%20Grp.op%20%28Grp.inv%20a%29%20%28Grp.op%20a%20c%29%20%3A%3D%20by%0A%20%20%20%20rw%20%5Bh%5D%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20b%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20op%20%28inv%20a%29%20%28op%20a%20c%29%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20c%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20op%20%28op%20%28inv%20a%29%20a%29%20c%0A%20%20rw%20%5BGrp.inv_left%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20id%20b%20%3D%20op%20id%20c%0A%20%20rw%20%5BGrp.id_left%2C%20Grp.id_left%5D%20at%20h1%0A%20%20--%20h1%20%3A%20b%20%3D%20c%0A%20%20exact%20h1" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20cancel_left%20%28a%20b%20c%20%3A%20G%29%20%28h%20%3A%20Grp.op%20a%20b%20%3D%20Grp.op%20a%20c%29%20%3A%20b%20%3D%20c%20%3A%3D%20by%0A%20%20have%20h1%20%3A%20Grp.op%20%28Grp.inv%20a%29%20%28Grp.op%20a%20b%29%20%3D%20Grp.op%20%28Grp.inv%20a%29%20%28Grp.op%20a%20c%29%20%3A%3D%20by%0A%20%20%20%20rw%20%5Bh%5D%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20b%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20op%20%28inv%20a%29%20%28op%20a%20c%29%0A%20%20rw%20%5B%E2%86%90%20Grp.assoc%20%28Grp.inv%20a%29%20a%20c%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20op%20%28op%20%28inv%20a%29%20a%29%20c%0A%20%20rw%20%5BGrp.inv_left%5D%20at%20h1%0A%20%20--%20h1%20%3A%20op%20id%20b%20%3D%20op%20id%20c%0A%20%20rw%20%5BGrp.id_left%2C%20Grp.id_left%5D%20at%20h1%0A%20%20--%20h1%20%3A%20b%20%3D%20c%0A%20%20exact%20h1" title="Lean playground" loading="lazy" style="width:100%;height:288px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both sides of `h` are left-multiplied by `Grp.inv a` (step `h1`), then regrouped
with associativity so that `Grp.inv a` meets `a` on both sides. That
pair cancels to `Grp.id` via `inv_left`, and `Grp.id` is then stripped via `id_left`, which
leaves `b = c` directly.

---

[← Chapter 6](05-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](07-chapter-8.md)
