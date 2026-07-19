## Submodules

[← Z-module example](03-z-module-example.md) | [Index](00-index.md) | [Next: Linear maps →](05-linear-maps.md)

---

A **submodule** of $M$ is a subset closed under $+$, containing $0$, and
closed under the scalar action. In Lean, "a subset closed under some
operations" is naturally a `structure` bundling a *predicate* on `M`
together with closure proofs. This is the same "data + proofs" idea as
`Group`, just with the "data" being a property instead of an operation:

<p><a href="https://live.lean-lang.org/#code=structure%20Submodule%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20%3A%20Type%7D%20%28Mod%20%3A%20Module%20R%20Rg%20M%29%20where%0A%20%20carrier%20%3A%20M%20%E2%86%92%20Prop%0A%20%20zero_mem%20%3A%20carrier%20Mod.addGrp.toGroup.id%0A%20%20add_mem%20%3A%20%E2%88%80%20%7Bm%20n%20%3A%20M%7D%2C%20carrier%20m%20%E2%86%92%20carrier%20n%20%E2%86%92%20carrier%20%28Mod.addGrp.op%20m%20n%29%0A%20%20smul_mem%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%7Bm%20%3A%20M%7D%2C%20carrier%20m%20%E2%86%92%20carrier%20%28Mod.smul%20r%20m%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Submodule%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20%3A%20Type%7D%20%28Mod%20%3A%20Module%20R%20Rg%20M%29%20where%0A%20%20carrier%20%3A%20M%20%E2%86%92%20Prop%0A%20%20zero_mem%20%3A%20carrier%20Mod.addGrp.toGroup.id%0A%20%20add_mem%20%3A%20%E2%88%80%20%7Bm%20n%20%3A%20M%7D%2C%20carrier%20m%20%E2%86%92%20carrier%20n%20%E2%86%92%20carrier%20%28Mod.addGrp.op%20m%20n%29%0A%20%20smul_mem%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%7Bm%20%3A%20M%7D%2C%20carrier%20m%20%E2%86%92%20carrier%20%28Mod.smul%20r%20m%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`carrier : M → Prop` is the subset, viewed as its membership predicate
(`carrier m` reads "`m` is in the submodule"). This is the standard Lean
idiom for "subobject of `X`": not a `Set X` wrapped separately, but a
predicate directly, since `carrier m` *is* a proposition usable directly as a
hypothesis.

**Mathematical reading.** `Submodule Rg Mod` is a submodule $N \le M$,
presented by its membership predicate $\chi_N : M \to \mathrm{Prop}$ (a
subset $N = \{\,m \in M \mid \chi_N(m)\,\}$) together with closure proofs:
$0 \in N$, $m,n \in N \Rightarrow m+n \in N$, and $r\in R,\, m\in N
\Rightarrow r\cdot m \in N$. These are exactly the conditions for $N$ to be
an $R$-submodule: closed under the abelian-group operations and stable
under scalars. So $N$ inherits an $R$-module structure and the
inclusion $N \hookrightarrow M$ is $R$-linear. Categorically this is a
[subobject](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
of $M$ in $R\text{-}\mathbf{Mod}$.

### Example: the submodule of even integers, as a $\mathbb{Z}$-submodule of $\mathbb{Z}$

The $\mathbb{Z}$-module structure on $\mathbb{Z}$ itself, described only in
passing so far, is required first:

<p><a href="https://live.lean-lang.org/#code=def%20intZModule%20%3A%20Module%20Int%20intRing%20Int%20where%0A%20%20addGrp%20%3A%3D%20intCommGroup%0A%20%20smul%20%3A%3D%20fun%20r%20m%20%3D%3E%20r%20%2A%20m%0A%20%20smul_add%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20n%0A%20%20%20%20exact%20Int.mul_add%20r%20m%20n%0A%20%20add_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20m%0A%20%20%20%20exact%20Int.add_mul%20r%20s%20m%0A%20%20smul_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20m%0A%20%20%20%20exact%20Int.mul_assoc%20r%20s%20m%0A%20%20one_smul%20%3A%3D%20by%0A%20%20%20%20intro%20m%0A%20%20%20%20exact%20Int.one_mul%20m" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20intZModule%20%3A%20Module%20Int%20intRing%20Int%20where%0A%20%20addGrp%20%3A%3D%20intCommGroup%0A%20%20smul%20%3A%3D%20fun%20r%20m%20%3D%3E%20r%20%2A%20m%0A%20%20smul_add%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20n%0A%20%20%20%20exact%20Int.mul_add%20r%20m%20n%0A%20%20add_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20m%0A%20%20%20%20exact%20Int.add_mul%20r%20s%20m%0A%20%20smul_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20s%20m%0A%20%20%20%20exact%20Int.mul_assoc%20r%20s%20m%0A%20%20one_smul%20%3A%3D%20by%0A%20%20%20%20intro%20m%0A%20%20%20%20exact%20Int.one_mul%20m" title="Lean playground" loading="lazy" style="width:100%;height:345px;border:1px solid #ccc;border-radius:8px;">
</iframe>

<p><a href="https://live.lean-lang.org/#code=--%20NOTE%3A%20%60intZModule.addGrp.op%60%2F%60.id%60%2F%60.smul%60%20are%20definitionally%20%28but%20not%0A--%20syntactically%29%20equal%20to%20plain%20%60%2B%60%2F%600%60%2F%60%2A%60%20on%20%60Int%60%20%E2%80%94%20true%20by%20%60rfl%60%2C%20but%0A--%20%60rw%60%20only%20fires%20on%20syntactic%20matches%2C%20so%20a%20bare%20%60rw%20%5B...%5D%60%20%28or%20%60ring%60%2C%0A--%20which%20this%20book%20doesn%27t%20import%20from%20Mathlib%20anyway%29%20would%20leave%0A--%20an%20unsolved%20goal%20even%20though%20the%20underlying%20statement%20is%20true.%20%60show%60%0A--%20restates%20the%20goal%20in%20its%20reduced%20%28defeq%29%20form%20explicitly%20first.%0Adef%20evenSubmodule%20%3A%20Submodule%20intRing%20intZModule%20where%0A%20%20carrier%20%3A%3D%20fun%20m%20%3D%3E%20%E2%88%83%20k%20%3A%20Int%2C%20m%20%3D%202%20%2A%20k%0A%20%20zero_mem%20%3A%3D%20%E2%9F%A80%2C%20rfl%E2%9F%A9%0A%20%20add_mem%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%20%E2%9F%A8k%2C%20hk%E2%9F%A9%20%E2%9F%A8j%2C%20hj%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8k%20%2B%20j%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20m%20%2B%20n%20%3D%202%20%2A%20%28k%20%2B%20j%29%0A%20%20%20%20rw%20%5Bhk%2C%20hj%2C%20Int.mul_add%5D%0A%20%20smul_mem%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20%E2%9F%A8k%2C%20hk%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8r%20%2A%20k%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20r%20%2A%20m%20%3D%202%20%2A%20%28r%20%2A%20k%29%0A%20%20%20%20rw%20%5Bhk%2C%20%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20r%202%2C%20Int.mul_assoc%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20NOTE%3A%20%60intZModule.addGrp.op%60%2F%60.id%60%2F%60.smul%60%20are%20definitionally%20%28but%20not%0A--%20syntactically%29%20equal%20to%20plain%20%60%2B%60%2F%600%60%2F%60%2A%60%20on%20%60Int%60%20%E2%80%94%20true%20by%20%60rfl%60%2C%20but%0A--%20%60rw%60%20only%20fires%20on%20syntactic%20matches%2C%20so%20a%20bare%20%60rw%20%5B...%5D%60%20%28or%20%60ring%60%2C%0A--%20which%20this%20book%20doesn%27t%20import%20from%20Mathlib%20anyway%29%20would%20leave%0A--%20an%20unsolved%20goal%20even%20though%20the%20underlying%20statement%20is%20true.%20%60show%60%0A--%20restates%20the%20goal%20in%20its%20reduced%20%28defeq%29%20form%20explicitly%20first.%0Adef%20evenSubmodule%20%3A%20Submodule%20intRing%20intZModule%20where%0A%20%20carrier%20%3A%3D%20fun%20m%20%3D%3E%20%E2%88%83%20k%20%3A%20Int%2C%20m%20%3D%202%20%2A%20k%0A%20%20zero_mem%20%3A%3D%20%E2%9F%A80%2C%20rfl%E2%9F%A9%0A%20%20add_mem%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%20%E2%9F%A8k%2C%20hk%E2%9F%A9%20%E2%9F%A8j%2C%20hj%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8k%20%2B%20j%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20m%20%2B%20n%20%3D%202%20%2A%20%28k%20%2B%20j%29%0A%20%20%20%20rw%20%5Bhk%2C%20hj%2C%20Int.mul_add%5D%0A%20%20smul_mem%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%20%E2%9F%A8k%2C%20hk%E2%9F%A9%0A%20%20%20%20refine%20%E2%9F%A8r%20%2A%20k%2C%20%3F_%E2%9F%A9%0A%20%20%20%20show%20r%20%2A%20m%20%3D%202%20%2A%20%28r%20%2A%20k%29%0A%20%20%20%20rw%20%5Bhk%2C%20%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20r%202%2C%20Int.mul_assoc%5D" title="Lean playground" loading="lazy" style="width:100%;height:421px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Each closure proof follows the same shape: destructure the hypothesis to
expose its witness (`⟨k, hk⟩` denotes "`m` is even, with witness `k` and proof
`hk : m = 2 * k`"), then supply a new witness and discharge the resulting
`Int` equation. `zero_mem`'s witness `0` makes the goal `id = 2 * 0`, true
by `rfl` directly (both sides compute to `0`). `add_mem` and `smul_mem`
require `show` first to reveal the goal's `+`/`*`-form before `rw` can find
anything to rewrite, since `Mod.addGrp.op`/`Mod.smul` do not display as
plain `+`/`*`, even though they compute to exactly that here.

**Mathematical reading.** This is the submodule $2\mathbb{Z} \le \mathbb{Z}$
of even integers, $2\mathbb{Z} = \{\, m \mid \exists k,\ m = 2k \,\}$. It's
the image of multiplication-by-$2$, and equivalently the principal ideal
$(2)\trianglelefteq \mathbb{Z}$ (submodules of the $\mathbb{Z}$-module
$\mathbb{Z}$ are exactly its ideals). The closure checks are the elementary
facts $0 = 2\cdot 0$, $2k + 2j = 2(k+j)$, and $r\cdot(2k) = 2(rk)$, each an
identity in the commutative ring $\mathbb{Z}$. The existential witnesses
$0,\ k+j,\ rk$ are precisely the elements that show closure.

**Mathlib equivalent.** Mathlib builds the submodule generated by a set
*generically*, using [`Submodule.span`](https://loogle.lean-lang.org/?q=Submodule.span). Thus `evenSubmodule`'s three
hand-written closure proofs (`zero_mem`/`add_mem`/`smul_mem`) become a
single call, applicable to any generating set at all, not just `{2}`:

<p><a href="https://live.lean-lang.org/#code=def%20evenSubmodule%27%20%3A%20Submodule%20Int%20Int%20%3A%3D%20Submodule.span%20Int%20%7B%282%20%3A%20Int%29%7D%0A%0Aexample%20%3A%20%282%20%3A%20Int%29%20%E2%88%88%20evenSubmodule%27%20%3A%3D%20Submodule.subset_span%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20evenSubmodule%27%20%3A%20Submodule%20Int%20Int%20%3A%3D%20Submodule.span%20Int%20%7B%282%20%3A%20Int%29%7D%0A%0Aexample%20%3A%20%282%20%3A%20Int%29%20%E2%88%88%20evenSubmodule%27%20%3A%3D%20Submodule.subset_span%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Submodule.span R s` is, by construction, the smallest submodule
containing `s`. [`Submodule.subset_span`](https://loogle.lean-lang.org/?q=Submodule.subset_span) is the one fact that does all the
work here: "the generators are always members", proved once, generically,
instead of the book's custom `zero_mem`/`add_mem`/`smul_mem` triple for
this specific subset.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard classical (non-Lean) reference for submodules and their axioms.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Z-module example](03-z-module-example.md) | [Index](00-index.md) | [Next: Linear maps →](05-linear-maps.md)
