## Example: every abelian group is a $\mathbb{Z}$-module

[← Translating into Lean](02-translating-into-lean.md) | [Index](00-index.md) | [Next: Submodules →](04-submodules.md)

---

This is the standard first example, and a good one to build by hand,
since the scalar action is not given as data: it must be *defined*, by
repeated addition, from the group structure alone.

<p><a href="https://live.lean-lang.org/#code=--%20n%20%E2%80%A2%20m%20for%20n%20%3A%20Nat%2C%20by%20iterating%20%60op%60.%0Adef%20natSmul%20%7BM%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20M%29%20%28n%20%3A%20Nat%29%20%28m%20%3A%20M%29%20%3A%20M%20%3A%3D%0A%20%20match%20n%20with%0A%20%20%7C%20Nat.zero%20%3D%3E%20Grp.id%0A%20%20%7C%20Nat.succ%20k%20%3D%3E%20Grp.op%20m%20%28natSmul%20Grp%20k%20m%29%0A%0A--%20extend%20to%20n%20%3A%20Int%20by%20using%20%60inv%60%20on%20negative%20n.%0Adef%20intSmul%20%7BM%20%3A%20Type%7D%20%28CG%20%3A%20CommGroup%20M%29%20%28n%20%3A%20Int%29%20%28m%20%3A%20M%29%20%3A%20M%20%3A%3D%0A%20%20match%20n%20with%0A%20%20%7C%20Int.ofNat%20k%20%3D%3E%20natSmul%20CG.toGroup%20k%20m%0A%20%20%7C%20Int.negSucc%20k%20%3D%3E%20CG.toGroup.inv%20%28natSmul%20CG.toGroup%20%28k%20%2B%201%29%20m%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20n%20%E2%80%A2%20m%20for%20n%20%3A%20Nat%2C%20by%20iterating%20%60op%60.%0Adef%20natSmul%20%7BM%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20M%29%20%28n%20%3A%20Nat%29%20%28m%20%3A%20M%29%20%3A%20M%20%3A%3D%0A%20%20match%20n%20with%0A%20%20%7C%20Nat.zero%20%3D%3E%20Grp.id%0A%20%20%7C%20Nat.succ%20k%20%3D%3E%20Grp.op%20m%20%28natSmul%20Grp%20k%20m%29%0A%0A--%20extend%20to%20n%20%3A%20Int%20by%20using%20%60inv%60%20on%20negative%20n.%0Adef%20intSmul%20%7BM%20%3A%20Type%7D%20%28CG%20%3A%20CommGroup%20M%29%20%28n%20%3A%20Int%29%20%28m%20%3A%20M%29%20%3A%20M%20%3A%3D%0A%20%20match%20n%20with%0A%20%20%7C%20Int.ofNat%20k%20%3D%3E%20natSmul%20CG.toGroup%20k%20m%0A%20%20%7C%20Int.negSucc%20k%20%3D%3E%20CG.toGroup.inv%20%28natSmul%20CG.toGroup%20%28k%20%2B%201%29%20m%29" title="Lean playground" loading="lazy" style="width:100%;height:269px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`natSmul Grp n m` is literally $m + m + \cdots + m$ ($n$ times). It is
defined by recursion on `n`, in exactly the way `Nat.add` itself was
defined (Chapter 4). `intSmul` extends it to negative integers using the
group inverse. Given any `CG : CommGroup M`, one can then check that
`intSmul CG` satisfies (M1)–(M4) against `intRing` (Chapter 8). This is a
genuine, if somewhat long, proof by induction on the integer scalar, in the
same spirit as Chapter 4's `my_add_comm`. The full verification is left as
an extended exercise, since carrying it out directly is the best way to see *why*
modules over $\mathbb{Z}$ are forced, not chosen: `intSmul` is the *unique*
action that turns any abelian group into a $\mathbb{Z}$-module, because
(M4) plus (M1)/(M2) pin down $n \cdot m$ for every integer $n$ by
induction, leaving no freedom.

**Mathematical reading.** This constructs the canonical $\mathbb{Z}$-action
on any abelian group. `natSmul` is the
$\mathbb{N}$-action $n\cdot m = \underbrace{m + \cdots + m}_{n}$ (the
$n$-fold sum, with $0\cdot m = 0$), and `intSmul` extends it to $\mathbb{Z}$
by $(-n)\cdot m = -(n\cdot m)$. This is forced: since $\mathbb{Z}$ is the
[initial](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
ring, there is a unique ring map $\mathbb{Z} \to
\mathrm{End}(M)$ for any abelian group $M$ (it must send $1 \mapsto
\mathrm{id}_M$, hence $n \mapsto n\cdot\mathrm{id}_M$). So the $\mathbb{Z}$-
module structure is unique. "Abelian group" and "$\mathbb{Z}$-module" are
literally the same notion. The recursion mirrors the definition of
multiplication-as-iterated-addition.

**Mathlib equivalent.** Mathlib does not leave "every abelian group is
(uniquely) a $\mathbb{Z}$-module" as an exercise. It is registered as an
instance, available for *any* `AddCommGroup` at all, with no
`natSmul`/`intSmul` to define or verify by hand:

<p><a href="https://live.lean-lang.org/#code=example%20%7BM%20%3A%20Type%2A%7D%20%5BAddCommGroup%20M%5D%20%3A%20Module%20Int%20M%20%3A%3D%20inferInstance" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%7BM%20%3A%20Type%2A%7D%20%5BAddCommGroup%20M%5D%20%3A%20Module%20Int%20M%20%3A%3D%20inferInstance" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

The book builds the action from nothing (`natSmul` by recursion, then
`intSmul` by extending to negative integers via `inv`) and leaves the
four-axiom verification as an extended exercise. Mathlib's instance already
carries that proof, following exactly the uniqueness argument in
the mathematical reading above, established once in the library instead of once
per abelian group encountered.

---

[← Translating into Lean](02-translating-into-lean.md) | [Index](00-index.md) | [Next: Submodules →](04-submodules.md)
