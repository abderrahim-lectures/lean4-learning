## Chapter 10: Modules over a ring

[← Chapter 9](08-chapter-9.md) | [Index](00-index.md) | [Next: Chapter 11 →](10-chapter-11.md)

---

**1. The identity function is a linear map**

<p><a href="https://live.lean-lang.org/#code=def%20idLinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20%3A%20Type%7D%20%28Mod%20%3A%20Module%20R%20Rg%20M%29%20%3A%0A%20%20%20%20LinearMap%20Rg%20Mod%20Mod%20where%0A%20%20toFun%20%3A%3D%20id%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20rfl%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20idLinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20%3A%20Type%7D%20%28Mod%20%3A%20Module%20R%20Rg%20M%29%20%3A%0A%20%20%20%20LinearMap%20Rg%20Mod%20Mod%20where%0A%20%20toFun%20%3A%3D%20id%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20rfl%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:231px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`id : M → M` is `fun x => x`. Both fields reduce to [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) because
`id (Mod.addGrp.op m n)` and `Mod.addGrp.op (id m) (id n)` unfold to the
same term (`id` changes nothing). The same holds for
`map_smul`. The only content in `LinearMap`'s two fields is the
compatibility of `toFun` with `+`/`smul`, and `id` trivially preserves
everything, since it changes nothing.

**2. Linear maps compose**

<p><a href="https://live.lean-lang.org/#code=def%20composeLinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20P%20%3A%20Type%7D%0A%20%20%20%20%7BModM%20%3A%20Module%20R%20Rg%20M%7D%20%7BModN%20%3A%20Module%20R%20Rg%20N%7D%20%7BModP%20%3A%20Module%20R%20Rg%20P%7D%0A%20%20%20%20%28f%20%3A%20LinearMap%20Rg%20ModM%20ModN%29%20%28g%20%3A%20LinearMap%20Rg%20ModN%20ModP%29%20%3A%0A%20%20%20%20LinearMap%20Rg%20ModM%20ModP%20where%0A%20%20toFun%20%3A%3D%20g.toFun%20%E2%88%98%20f.toFun%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20show%20g.toFun%20%28f.toFun%20%28ModM.addGrp.op%20m%20n%29%29%20%3D%0A%20%20%20%20%20%20ModP.addGrp.op%20%28g.toFun%20%28f.toFun%20m%29%29%20%28g.toFun%20%28f.toFun%20n%29%29%0A%20%20%20%20rw%20%5Bf.map_add%5D%0A%20%20%20%20--%20Goal%3A%20g.toFun%20%28op%20%28f.toFun%20m%29%20%28f.toFun%20n%29%29%20%3D%20op%20%28g.toFun%20%28f.toFun%20m%29%29%20%28g.toFun%20%28f.toFun%20n%29%29%0A%20%20%20%20exact%20g.map_add%20%28f.toFun%20m%29%20%28f.toFun%20n%29%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20show%20g.toFun%20%28f.toFun%20%28ModM.smul%20r%20m%29%29%20%3D%20ModP.smul%20r%20%28g.toFun%20%28f.toFun%20m%29%29%0A%20%20%20%20rw%20%5Bf.map_smul%5D%0A%20%20%20%20--%20Goal%3A%20g.toFun%20%28ModN.smul%20r%20%28f.toFun%20m%29%29%20%3D%20ModP.smul%20r%20%28g.toFun%20%28f.toFun%20m%29%29%0A%20%20%20%20exact%20g.map_smul%20r%20%28f.toFun%20m%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20composeLinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20P%20%3A%20Type%7D%0A%20%20%20%20%7BModM%20%3A%20Module%20R%20Rg%20M%7D%20%7BModN%20%3A%20Module%20R%20Rg%20N%7D%20%7BModP%20%3A%20Module%20R%20Rg%20P%7D%0A%20%20%20%20%28f%20%3A%20LinearMap%20Rg%20ModM%20ModN%29%20%28g%20%3A%20LinearMap%20Rg%20ModN%20ModP%29%20%3A%0A%20%20%20%20LinearMap%20Rg%20ModM%20ModP%20where%0A%20%20toFun%20%3A%3D%20g.toFun%20%E2%88%98%20f.toFun%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20show%20g.toFun%20%28f.toFun%20%28ModM.addGrp.op%20m%20n%29%29%20%3D%0A%20%20%20%20%20%20ModP.addGrp.op%20%28g.toFun%20%28f.toFun%20m%29%29%20%28g.toFun%20%28f.toFun%20n%29%29%0A%20%20%20%20rw%20%5Bf.map_add%5D%0A%20%20%20%20--%20Goal%3A%20g.toFun%20%28op%20%28f.toFun%20m%29%20%28f.toFun%20n%29%29%20%3D%20op%20%28g.toFun%20%28f.toFun%20m%29%29%20%28g.toFun%20%28f.toFun%20n%29%29%0A%20%20%20%20exact%20g.map_add%20%28f.toFun%20m%29%20%28f.toFun%20n%29%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20show%20g.toFun%20%28f.toFun%20%28ModM.smul%20r%20m%29%29%20%3D%20ModP.smul%20r%20%28g.toFun%20%28f.toFun%20m%29%29%0A%20%20%20%20rw%20%5Bf.map_smul%5D%0A%20%20%20%20--%20Goal%3A%20g.toFun%20%28ModN.smul%20r%20%28f.toFun%20m%29%29%20%3D%20ModP.smul%20r%20%28g.toFun%20%28f.toFun%20m%29%29%0A%20%20%20%20exact%20g.map_smul%20r%20%28f.toFun%20m%29" title="Lean playground" loading="lazy" style="width:100%;height:402px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`g.toFun ∘ f.toFun` is ordinary function composition. Each field's proof
first uses `f`'s own compatibility fact (`f.map_add`/`f.map_smul`) to push
the additive-group operation or scalar action *through* `f`. This leaves a
goal that is now exactly `g`'s compatibility fact, applied to the
already-transformed points `f.toFun m`, `f.toFun n`. This, plus Exercise 1
and the associativity of `∘` (both free from ordinary function
composition), is exactly the data that makes $R$-modules and $R$-linear
maps a category, as promised in the chapter text.

**3. Verifying `intSmul` satisfies `Module`'s axioms (partial: `one_smul`, `smul_add`)**

<p><a href="https://live.lean-lang.org/#code=--%20one_smul%3A%20intSmul%20CG%201%20m%20%3D%20m%0Atheorem%20intSmul_one_smul%20%7BM%20%3A%20Type%7D%20%28CG%20%3A%20CommGroup%20M%29%20%28m%20%3A%20M%29%20%3A%0A%20%20%20%20intSmul%20CG%201%20m%20%3D%20m%20%3A%3D%20by%0A%20%20show%20natSmul%20CG.toGroup%201%20m%20%3D%20m%0A%20%20show%20CG.toGroup.op%20m%20%28natSmul%20CG.toGroup%200%20m%29%20%3D%20m%0A%20%20show%20CG.toGroup.op%20m%20CG.toGroup.id%20%3D%20m%0A%20%20exact%20CG.toGroup.id_right%20m" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20one_smul%3A%20intSmul%20CG%201%20m%20%3D%20m%0Atheorem%20intSmul_one_smul%20%7BM%20%3A%20Type%7D%20%28CG%20%3A%20CommGroup%20M%29%20%28m%20%3A%20M%29%20%3A%0A%20%20%20%20intSmul%20CG%201%20m%20%3D%20m%20%3A%3D%20by%0A%20%20show%20natSmul%20CG.toGroup%201%20m%20%3D%20m%0A%20%20show%20CG.toGroup.op%20m%20%28natSmul%20CG.toGroup%200%20m%29%20%3D%20m%0A%20%20show%20CG.toGroup.op%20m%20CG.toGroup.id%20%3D%20m%0A%20%20exact%20CG.toGroup.id_right%20m" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`intSmul CG 1 m` unfolds (since `1 = Int.ofNat 1`) to `natSmul CG.toGroup 1 m`,
which unfolds (since `1 = Nat.succ Nat.zero`) to
`CG.toGroup.op m (natSmul CG.toGroup 0 m)`. This unfolds again (the `zero`
case of `natSmul`) to `CG.toGroup.op m CG.toGroup.id`, which is exactly the
`id_right` axiom.

<p><a href="https://live.lean-lang.org/#code=--%20smul_add%2C%20restricted%20to%20natural-number%20scalars%2C%20by%20induction%20on%20n%0Atheorem%20natSmul_add%20%7BM%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20M%29%20%28n%20%3A%20Nat%29%20%28m1%20m2%20%3A%20M%29%0A%20%20%20%20%28comm%20%3A%20%E2%88%80%20a%20b%20%3A%20M%2C%20Grp.op%20a%20b%20%3D%20Grp.op%20b%20a%29%20%3A%0A%20%20%20%20natSmul%20Grp%20n%20%28Grp.op%20m1%20m2%29%20%3D%20Grp.op%20%28natSmul%20Grp%20n%20m1%29%20%28natSmul%20Grp%20n%20m2%29%20%3A%3D%20by%0A%20%20induction%20n%20with%0A%20%20%7C%20zero%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20natSmul%20Grp%200%20%28op%20m1%20m2%29%20%3D%20op%20%28natSmul%20Grp%200%20m1%29%20%28natSmul%20Grp%200%20m2%29%0A%20%20%20%20show%20Grp.id%20%3D%20Grp.op%20Grp.id%20Grp.id%0A%20%20%20%20exact%20%28Grp.id_left%20Grp.id%29.symm%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20natSmul%20Grp%20k%20%28op%20m1%20m2%29%20%3D%20op%20%28natSmul%20Grp%20k%20m1%29%20%28natSmul%20Grp%20k%20m2%29%0A%20%20%20%20show%20Grp.op%20%28Grp.op%20m1%20m2%29%20%28natSmul%20Grp%20k%20%28Grp.op%20m1%20m2%29%29%20%3D%0A%20%20%20%20%20%20Grp.op%20%28Grp.op%20m1%20%28natSmul%20Grp%20k%20m1%29%29%20%28Grp.op%20m2%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20rw%20%5Bih%5D%0A%20%20%20%20--%20Goal%3A%20op%20%28op%20m1%20m2%29%20%28op%20%28natSmul%20Grp%20k%20m1%29%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20--%20%20%20%20%20%3D%20op%20%28op%20m1%20%28natSmul%20Grp%20k%20m1%29%29%20%28op%20m2%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20--%20Both%20sides%20are%20the%20same%20four%20elements%20combined%20via%20%60op%60%2C%20just%20grouped%0A%20%20%20%20--%20and%20ordered%20differently%3B%20regroup%20with%20%60assoc%60%20and%20swap%20the%20middle%20two%0A%20%20%20%20--%20terms%20using%20%60comm%60%2C%20exactly%20the%20%22regroup%2C%20then%20rearrange%22%20pattern%0A%20%20%20%20--%20from%20Chapter%207.%0A%20%20%20%20rw%20%5B%E2%86%90%20Grp.assoc%2C%20Grp.assoc%20m1%20m2%2C%20comm%20m2%20%28natSmul%20Grp%20k%20m1%29%2C%20%E2%86%90%20Grp.assoc%20m1%2C%0A%20%20%20%20%20%20%20%20Grp.assoc%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20smul_add%2C%20restricted%20to%20natural-number%20scalars%2C%20by%20induction%20on%20n%0Atheorem%20natSmul_add%20%7BM%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20M%29%20%28n%20%3A%20Nat%29%20%28m1%20m2%20%3A%20M%29%0A%20%20%20%20%28comm%20%3A%20%E2%88%80%20a%20b%20%3A%20M%2C%20Grp.op%20a%20b%20%3D%20Grp.op%20b%20a%29%20%3A%0A%20%20%20%20natSmul%20Grp%20n%20%28Grp.op%20m1%20m2%29%20%3D%20Grp.op%20%28natSmul%20Grp%20n%20m1%29%20%28natSmul%20Grp%20n%20m2%29%20%3A%3D%20by%0A%20%20induction%20n%20with%0A%20%20%7C%20zero%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20natSmul%20Grp%200%20%28op%20m1%20m2%29%20%3D%20op%20%28natSmul%20Grp%200%20m1%29%20%28natSmul%20Grp%200%20m2%29%0A%20%20%20%20show%20Grp.id%20%3D%20Grp.op%20Grp.id%20Grp.id%0A%20%20%20%20exact%20%28Grp.id_left%20Grp.id%29.symm%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20natSmul%20Grp%20k%20%28op%20m1%20m2%29%20%3D%20op%20%28natSmul%20Grp%20k%20m1%29%20%28natSmul%20Grp%20k%20m2%29%0A%20%20%20%20show%20Grp.op%20%28Grp.op%20m1%20m2%29%20%28natSmul%20Grp%20k%20%28Grp.op%20m1%20m2%29%29%20%3D%0A%20%20%20%20%20%20Grp.op%20%28Grp.op%20m1%20%28natSmul%20Grp%20k%20m1%29%29%20%28Grp.op%20m2%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20rw%20%5Bih%5D%0A%20%20%20%20--%20Goal%3A%20op%20%28op%20m1%20m2%29%20%28op%20%28natSmul%20Grp%20k%20m1%29%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20--%20%20%20%20%20%3D%20op%20%28op%20m1%20%28natSmul%20Grp%20k%20m1%29%29%20%28op%20m2%20%28natSmul%20Grp%20k%20m2%29%29%0A%20%20%20%20--%20Both%20sides%20are%20the%20same%20four%20elements%20combined%20via%20%60op%60%2C%20just%20grouped%0A%20%20%20%20--%20and%20ordered%20differently%3B%20regroup%20with%20%60assoc%60%20and%20swap%20the%20middle%20two%0A%20%20%20%20--%20terms%20using%20%60comm%60%2C%20exactly%20the%20%22regroup%2C%20then%20rearrange%22%20pattern%0A%20%20%20%20--%20from%20Chapter%207.%0A%20%20%20%20rw%20%5B%E2%86%90%20Grp.assoc%2C%20Grp.assoc%20m1%20m2%2C%20comm%20m2%20%28natSmul%20Grp%20k%20m1%29%2C%20%E2%86%90%20Grp.assoc%20m1%2C%0A%20%20%20%20%20%20%20%20Grp.assoc%5D" title="Lean playground" loading="lazy" style="width:100%;height:478px;border:1px solid #ccc;border-radius:8px;">
</iframe>

The base case is `id = id + id` (an identity is its own double). This
mirrors the "element equal to its own double is zero" fact used in
Chapter 9's `mul_zero`. The inductive step requires commutativity (`comm`,
available since the group is a `CommGroup`) to slide `m2` and
`natSmul Grp k m1` past each other. This is exactly why `intSmul`
distributing over `+` requires an abelian group, rather than a general one:
without `comm`, there is no way to reorder the four terms into a matching
shape. Full verification of `add_smul` and `smul_smul` follows the same
induction-on-the-scalar pattern, and makes a good longer exercise for
further practice.

**4. Submodule of multiples of `d`**

<p><a href="https://live.lean-lang.org/#code=def%20multiplesSubmodule%20%28d%20%3A%20Int%29%20%3A%20Submodule%20intRing%20intZModule%20where%0A%20%20carrier%20%3A%3D%20fun%20m%20%3D%3E%20%E2%88%83%20k%20%3A%20Int%2C%20m%20%3D%20d%20%2A%20k%0A%20%20zero_mem%20%3A%3D%20%E2%9F%A80%2C%20by%20show%20%280%20%3A%20Int%29%20%3D%20d%20%2A%200%3B%20rw%20%5BInt.mul_zero%5D%E2%9F%A9%0A%20%20add_mem%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%20%E2%9F%A8k%2C%20hk%E2%9F%A9%20%E2%9F%A8j%2C%20hj%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8k%20%2B%20j%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20m%20%2B%20n%20%3D%20d%20%2A%20%28k%20%2B%20j%29%0A%20%20%20%20rw%20%5Bhk%2C%20hj%2C%20Int.mul_add%5D%0A%20%20smul_mem%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20%E2%9F%A8k%2C%20hk%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8r%20%2A%20k%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20r%20%2A%20m%20%3D%20d%20%2A%20%28r%20%2A%20k%29%0A%20%20%20%20rw%20%5Bhk%2C%20%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20r%20d%2C%20Int.mul_assoc%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20multiplesSubmodule%20%28d%20%3A%20Int%29%20%3A%20Submodule%20intRing%20intZModule%20where%0A%20%20carrier%20%3A%3D%20fun%20m%20%3D%3E%20%E2%88%83%20k%20%3A%20Int%2C%20m%20%3D%20d%20%2A%20k%0A%20%20zero_mem%20%3A%3D%20%E2%9F%A80%2C%20by%20show%20%280%20%3A%20Int%29%20%3D%20d%20%2A%200%3B%20rw%20%5BInt.mul_zero%5D%E2%9F%A9%0A%20%20add_mem%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%20%E2%9F%A8k%2C%20hk%E2%9F%A9%20%E2%9F%A8j%2C%20hj%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8k%20%2B%20j%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20m%20%2B%20n%20%3D%20d%20%2A%20%28k%20%2B%20j%29%0A%20%20%20%20rw%20%5Bhk%2C%20hj%2C%20Int.mul_add%5D%0A%20%20smul_mem%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20%E2%9F%A8k%2C%20hk%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8r%20%2A%20k%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20r%20%2A%20m%20%3D%20d%20%2A%20%28r%20%2A%20k%29%0A%20%20%20%20rw%20%5Bhk%2C%20%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20r%20d%2C%20Int.mul_assoc%5D" title="Lean playground" loading="lazy" style="width:100%;height:307px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This has the same shape as `evenSubmodule` (the case `d = 2`). Every `2` in
that proof is simply replaced by the parameter `d`, and each closure proof
still reduces to an `Int` equation, handled the same way ([`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) to
reveal the goal's `+`/`*`-form, then [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)), rather than with `ring` (which
this book does not import from Mathlib).

---

[← Chapter 9](08-chapter-9.md) | [Index](00-index.md) | [Next: Chapter 11 →](10-chapter-11.md)
