## Direct sums of modules

[← Linear maps](05-linear-maps.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

Given two $R$-modules $M$, $N$, their direct sum $M \oplus N$ has carrier
$M \times N$, componentwise addition, and componentwise scalar action:

<p><a href="https://live.lean-lang.org/#code=structure%20DirectSum%20%28M%20N%20%3A%20Type%29%20where%0A%20%20fst%20%3A%20M%0A%20%20snd%20%3A%20N%0A%0Adef%20directSumModule%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20%3A%20Type%7D%0A%20%20%20%20%28ModM%20%3A%20Module%20R%20Rg%20M%29%20%28ModN%20%3A%20Module%20R%20Rg%20N%29%20%3A%0A%20%20%20%20Module%20R%20Rg%20%28DirectSum%20M%20N%29%20where%0A%20%20addGrp%20%3A%3D%20%7B%0A%20%20%20%20toGroup%20%3A%3D%20%7B%0A%20%20%20%20%20%20op%20%3A%3D%20fun%20x%20y%20%3D%3E%20%E2%9F%A8ModM.addGrp.op%20x.fst%20y.fst%2C%20ModN.addGrp.op%20x.snd%20y.snd%E2%9F%A9%0A%20%20%20%20%20%20id%20%3A%3D%20%E2%9F%A8ModM.addGrp.toGroup.id%2C%20ModN.addGrp.toGroup.id%E2%9F%A9%0A%20%20%20%20%20%20inv%20%3A%3D%20fun%20x%20%3D%3E%20%E2%9F%A8ModM.addGrp.toGroup.inv%20x.fst%2C%20ModN.addGrp.toGroup.inv%20x.snd%E2%9F%A9%0A%20%20%20%20%20%20assoc%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%20y%20z%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.assoc%20x.fst%20y.fst%20z.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.assoc%20x.snd%20y.snd%20z.snd%0A%20%20%20%20%20%20id_left%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.id_left%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.id_left%20x.snd%0A%20%20%20%20%20%20id_right%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.id_right%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.id_right%20x.snd%0A%20%20%20%20%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.inv_left%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.inv_left%20x.snd%0A%20%20%20%20%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.inv_right%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.inv_right%20x.snd%0A%20%20%20%20%7D%0A%20%20%20%20comm%20%3A%3D%20by%0A%20%20%20%20%20%20intro%20x%20y%0A%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.comm%20x.fst%20y.fst%0A%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.comm%20x.snd%20y.snd%0A%20%20%7D%0A%20%20smul%20%3A%3D%20fun%20r%20x%20%3D%3E%20%E2%9F%A8ModM.smul%20r%20x.fst%2C%20ModN.smul%20r%20x.snd%E2%9F%A9%0A%20%20smul_add%20%3A%3D%20by%0A%20%20%20%20intro%20r%20x%20y%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.smul_add%20r%20x.fst%20y.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.smul_add%20r%20x.snd%20y.snd%0A%20%20add_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.add_smul%20r%20s%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.add_smul%20r%20s%20x.snd%0A%20%20smul_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.smul_smul%20r%20s%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.smul_smul%20r%20s%20x.snd%0A%20%20one_smul%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.one_smul%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.one_smul%20x.snd" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20DirectSum%20%28M%20N%20%3A%20Type%29%20where%0A%20%20fst%20%3A%20M%0A%20%20snd%20%3A%20N%0A%0Adef%20directSumModule%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20%3A%20Type%7D%0A%20%20%20%20%28ModM%20%3A%20Module%20R%20Rg%20M%29%20%28ModN%20%3A%20Module%20R%20Rg%20N%29%20%3A%0A%20%20%20%20Module%20R%20Rg%20%28DirectSum%20M%20N%29%20where%0A%20%20addGrp%20%3A%3D%20%7B%0A%20%20%20%20toGroup%20%3A%3D%20%7B%0A%20%20%20%20%20%20op%20%3A%3D%20fun%20x%20y%20%3D%3E%20%E2%9F%A8ModM.addGrp.op%20x.fst%20y.fst%2C%20ModN.addGrp.op%20x.snd%20y.snd%E2%9F%A9%0A%20%20%20%20%20%20id%20%3A%3D%20%E2%9F%A8ModM.addGrp.toGroup.id%2C%20ModN.addGrp.toGroup.id%E2%9F%A9%0A%20%20%20%20%20%20inv%20%3A%3D%20fun%20x%20%3D%3E%20%E2%9F%A8ModM.addGrp.toGroup.inv%20x.fst%2C%20ModN.addGrp.toGroup.inv%20x.snd%E2%9F%A9%0A%20%20%20%20%20%20assoc%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%20y%20z%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.assoc%20x.fst%20y.fst%20z.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.assoc%20x.snd%20y.snd%20z.snd%0A%20%20%20%20%20%20id_left%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.id_left%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.id_left%20x.snd%0A%20%20%20%20%20%20id_right%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.id_right%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.id_right%20x.snd%0A%20%20%20%20%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.inv_left%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.inv_left%20x.snd%0A%20%20%20%20%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20%20%20%20%20intro%20x%0A%20%20%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.toGroup.inv_right%20x.fst%0A%20%20%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.toGroup.inv_right%20x.snd%0A%20%20%20%20%7D%0A%20%20%20%20comm%20%3A%3D%20by%0A%20%20%20%20%20%20intro%20x%20y%0A%20%20%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20%20%20congr%201%0A%20%20%20%20%20%20%C2%B7%20exact%20ModM.addGrp.comm%20x.fst%20y.fst%0A%20%20%20%20%20%20%C2%B7%20exact%20ModN.addGrp.comm%20x.snd%20y.snd%0A%20%20%7D%0A%20%20smul%20%3A%3D%20fun%20r%20x%20%3D%3E%20%E2%9F%A8ModM.smul%20r%20x.fst%2C%20ModN.smul%20r%20x.snd%E2%9F%A9%0A%20%20smul_add%20%3A%3D%20by%0A%20%20%20%20intro%20r%20x%20y%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.smul_add%20r%20x.fst%20y.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.smul_add%20r%20x.snd%20y.snd%0A%20%20add_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.add_smul%20r%20s%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.add_smul%20r%20s%20x.snd%0A%20%20smul_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.smul_smul%20r%20s%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.smul_smul%20r%20s%20x.snd%0A%20%20one_smul%20%3A%3D%20by%0A%20%20%20%20intro%20x%0A%20%20%20%20show%20DirectSum.mk%20_%20_%20%3D%20DirectSum.mk%20_%20_%0A%20%20%20%20congr%201%0A%20%20%20%20%C2%B7%20exact%20ModM.one_smul%20x.fst%0A%20%20%20%20%C2%B7%20exact%20ModN.one_smul%20x.snd" title="Lean playground" loading="lazy" style="width:100%;height:650px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`congr 1` is a tactic worth noting, as this is its first
appearance. Given a goal `f a1 a2 = f b1 b2` (here `f` is `DirectSum.mk`),
`congr 1` reduces it to the componentwise goals `a1 = b1` and `a2 = b2`.
This is the categorical fact that a product's equality is checked
pairwise, turned into a one-line tactic instead of a hand-unfolded
`Prod.ext`-style lemma. Every proof obligation above genuinely *is* two
independent facts, one from `M` and one from `N`, glued together by the
direct-sum's product structure. `congr 1` is the right tool exactly
because it exposes that independence directly, instead of hiding it
inside a single opaque equality on pairs. Note the
`show DirectSum.mk _ _ = DirectSum.mk _ _` line before each `congr 1`:
without it, the goal is stated in terms of the anonymous-constructor
lambda (`op := fun x y => ⟨...⟩`) rather than the visible `DirectSum.mk`
application. `congr 1` cannot reliably split a goal it does not recognize
as "one constructor applied to arguments on both sides" — a real gap that
the compiler catches immediately if the `show` line is left out.

**Mathematical reading.** This builds the **direct sum** $M \oplus N$: its
carrier is the product $M \times N$, with all structure defined
componentwise — $(m,n) + (m',n') = (m+m',\, n+n')$, $0 = (0,0)$, $-(m,n) =
(-m,-n)$, and $r\cdot(m,n) = (r\cdot m,\, r\cdot n)$. Every axiom holds
because it holds in each coordinate independently, which is exactly what
`congr 1` exposes: an equation of pairs splits into one equation in $M$ and
one in $N$. For finitely many summands the direct sum $M \oplus N$ is both
a product and a coproduct at once in $R\text{-}\mathbf{Mod}$: the
projections $\pi_M, \pi_N$ and inclusions $\iota_M, \iota_N$ satisfy
$\pi_M\iota_M = \mathrm{id}$, $\pi_N\iota_N = \mathrm{id}$, $\pi_M\iota_N =
0$, and $\iota_M\pi_M + \iota_N\pi_N = \mathrm{id}$.

### A concrete instance: $\mathbb{Z} \oplus \mathbb{Z}$

Instantiating the generic construction requires nothing beyond supplying two
modules — here, `intZModule` twice.

<p><a href="https://live.lean-lang.org/#code=def%20zSquaredModule%20%3A%3D%20directSumModule%20intRing%20intZModule%20intZModule%0A%0A%23eval%20%28zSquaredModule.addGrp.op%20%E2%9F%A82%2C%203%E2%9F%A9%20%E2%9F%A810%2C%2020%E2%9F%A9%20%3A%20DirectSum%20Int%20Int%29%0A--%20%7B%20fst%20%3A%3D%2012%2C%20snd%20%3A%3D%2023%20%7D%2C%20i.e.%20%282%2C3%29%20%2B%20%2810%2C20%29%20%3D%20%2812%2C23%29%0A%0A%23eval%20%28zSquaredModule.smul%205%20%E2%9F%A82%2C%203%E2%9F%A9%20%3A%20DirectSum%20Int%20Int%29%0A--%20%7B%20fst%20%3A%3D%2010%2C%20snd%20%3A%3D%2015%20%7D%2C%20i.e.%205%20%C2%B7%20%282%2C3%29%20%3D%20%2810%2C15%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20zSquaredModule%20%3A%3D%20directSumModule%20intRing%20intZModule%20intZModule%0A%0A%23eval%20%28zSquaredModule.addGrp.op%20%E2%9F%A82%2C%203%E2%9F%A9%20%E2%9F%A810%2C%2020%E2%9F%A9%20%3A%20DirectSum%20Int%20Int%29%0A--%20%7B%20fst%20%3A%3D%2012%2C%20snd%20%3A%3D%2023%20%7D%2C%20i.e.%20%282%2C3%29%20%2B%20%2810%2C20%29%20%3D%20%2812%2C23%29%0A%0A%23eval%20%28zSquaredModule.smul%205%20%E2%9F%A82%2C%203%E2%9F%A9%20%3A%20DirectSum%20Int%20Int%29%0A--%20%7B%20fst%20%3A%3D%2010%2C%20snd%20%3A%3D%2015%20%7D%2C%20i.e.%205%20%C2%B7%20%282%2C3%29%20%3D%20%2810%2C15%29" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both outputs are exactly the componentwise formulas from the mathematical
reading above, computed rather than merely asserted.

**Mathlib equivalent.** The book builds `DirectSum`/`directSumModule`
field by field (five group axioms, four module axioms, each split
componentwise via `congr 1`). Mathlib already gives the ordinary product
type `M × N` a `Module R` instance directly. There is no `DirectSum`
wrapper to define at all:

<p><a href="https://live.lean-lang.org/#code=example%20%7BM%20N%20%3A%20Type%2A%7D%20%5BAddCommGroup%20M%5D%20%5BAddCommGroup%20N%5D%0A%20%20%20%20%5BModule%20Int%20M%5D%20%5BModule%20Int%20N%5D%20%3A%20Module%20Int%20%28M%20%C3%97%20N%29%20%3A%3D%20inferInstance%0A%0A%23eval%20%28%282%2C%203%29%20%2B%20%2810%2C%2020%29%20%3A%20Int%20%C3%97%20Int%29%20%20%20%20%20--%20%2812%2C%2023%29%0A%23eval%20%28%285%20%3A%20Int%29%20%E2%80%A2%20%28%282%2C%203%29%20%3A%20Int%20%C3%97%20Int%29%29%20%20%20--%20%2810%2C%2015%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BM%20N%20%3A%20Type%2A%7D%20%5BAddCommGroup%20M%5D%20%5BAddCommGroup%20N%5D%0A%20%20%20%20%5BModule%20Int%20M%5D%20%5BModule%20Int%20N%5D%20%3A%20Module%20Int%20%28M%20%C3%97%20N%29%20%3A%3D%20inferInstance%0A%0A%23eval%20%28%282%2C%203%29%20%2B%20%2810%2C%2020%29%20%3A%20Int%20%C3%97%20Int%29%20%20%20%20%20--%20%2812%2C%2023%29%0A%23eval%20%28%285%20%3A%20Int%29%20%E2%80%A2%20%28%282%2C%203%29%20%3A%20Int%20%C3%97%20Int%29%29%20%20%20--%20%2810%2C%2015%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

These are the same componentwise formulas as `zSquaredModule`'s `#eval`s
above. But `Prod`'s `AddCommGroup`/[`Module`](https://loogle.lean-lang.org/?q=Module) instances (and the
componentwise `+`/`•` they provide) are already in the library, built once
for *any* two additive groups or modules, instead of assembled here for
`Int` and `Int` specifically.

The first projection $\pi_1 : \mathbb{Z}\oplus\mathbb{Z} \to \mathbb{Z}$,
one of the defining maps from the product/coproduct structure above, is
itself a `LinearMap` (previous section), built directly from
`DirectSum`'s own field accessor:

<p><a href="https://live.lean-lang.org/#code=def%20proj1%20%3A%20LinearMap%20intRing%20zSquaredModule%20intZModule%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20x.fst%0A%20%20map_add%20%3A%3D%20by%20intro%20x%20y%3B%20rfl%0A%20%20map_smul%20%3A%3D%20by%20intro%20r%20x%3B%20rfl%0A%0A%23eval%20proj1.toFun%20%E2%9F%A87%2C%20100%E2%9F%A9%20%20%20--%207" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20proj1%20%3A%20LinearMap%20intRing%20zSquaredModule%20intZModule%20where%0A%20%20toFun%20%3A%3D%20fun%20x%20%3D%3E%20x.fst%0A%20%20map_add%20%3A%3D%20by%20intro%20x%20y%3B%20rfl%0A%20%20map_smul%20%3A%3D%20by%20intro%20r%20x%3B%20rfl%0A%0A%23eval%20proj1.toFun%20%E2%9F%A87%2C%20100%E2%9F%A9%20%20%20--%207" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both proof obligations are `rfl` directly: `zSquaredModule.addGrp.op`
unfolds to componentwise addition (by the construction two sections
back), so taking `.fst` of a sum is definitionally the same as summing the
`.fst`s. No arithmetic argument is needed, only unfolding.

**Mathlib equivalent, continued.** The projection `proj1` is, again, not
something that needs to be built. Mathlib's [`LinearMap.fst`](https://loogle.lean-lang.org/?q=LinearMap.fst) already is $\pi_1$,
generic over any two modules over any ring:

<p><a href="https://live.lean-lang.org/#code=def%20proj1%27%20%3A%20%28Int%20%C3%97%20Int%29%20%E2%86%92%E2%82%97%5BInt%5D%20Int%20%3A%3D%20LinearMap.fst%20Int%20Int%20Int%0A%0A%23eval%20proj1%27%20%287%2C%20100%29%20%20%20--%207" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20proj1%27%20%3A%20%28Int%20%C3%97%20Int%29%20%E2%86%92%E2%82%97%5BInt%5D%20Int%20%3A%3D%20LinearMap.fst%20Int%20Int%20Int%0A%0A%23eval%20proj1%27%20%287%2C%20100%29%20%20%20--%207" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard classical (non-Lean) reference for direct sums of modules and their universal property.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Linear maps](05-linear-maps.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)
