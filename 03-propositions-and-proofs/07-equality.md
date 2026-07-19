## Equality reasoning

[← Quantifiers](06-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)

---

The three properties below are the standard ones making $=$ an equivalence
relation together with substitutivity.

<p><a href="https://live.lean-lang.org/#code=theorem%20symm_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20b%20%3D%20a%20%3A%3D%0A%20%20h.symm" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20symm_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20b%20%3D%20a%20%3A%3D%0A%20%20h.symm" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`symm` gives symmetry $a = b \Rightarrow b = a$.

<p><a href="https://live.lean-lang.org/#code=theorem%20trans_example%20%7Ba%20b%20c%20%3A%20Nat%7D%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20b%20%3D%20c%29%20%3A%20a%20%3D%20c%20%3A%3D%0A%20%20h1.trans%20h2" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20trans_example%20%7Ba%20b%20c%20%3A%20Nat%7D%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20b%20%3D%20c%29%20%3A%20a%20%3D%20c%20%3A%3D%0A%20%20h1.trans%20h2" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`trans` gives transitivity $a = b,\ b = c \Rightarrow a = c$. Combined with
reflexivity ($\mathrm{rfl}$) and symmetry above, this says $=$ is an
equivalence.

<p><a href="https://live.lean-lang.org/#code=theorem%20congr_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20congr_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

[`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) ("rewrite") rewrites the goal using an equality proof. `rw [h]` with
`h : a = b` finds every occurrence of `a` in the goal and replaces it with
`b`. Here the goal starts as `a + 1 = b + 1`. After rewriting `a` to `b`, it
becomes `b + 1 = b + 1`, which `rw` then closes automatically by trying
`rfl` as its last step; that final `rfl` need not be written explicitly.

The congruence `congr_example` is the Leibniz principle: $a = b \Rightarrow
f(a) = f(b)$ for any function $f$ (here $f(x) = x + 1$). This is
"substitute equals for equals," mechanized. `rw` is the workhorse for this
from here on: nearly every proof from Chapter 4 onward reaches for it
whenever an equality hypothesis needs to be used inside a larger goal.

---

[← Quantifiers](06-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)
