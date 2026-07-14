## Equality reasoning

[← Quantifiers](05-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

The three properties below are the standard ones making $=$ an equivalence
relation together with substitutivity.

```lean
theorem symm_example {a b : Nat} (h : a = b) : b = a :=
  h.symm
```

`symm` gives symmetry $a = b \Rightarrow b = a$.

```lean
theorem trans_example {a b c : Nat} (h1 : a = b) (h2 : b = c) : a = c :=
  h1.trans h2
```

`trans` gives transitivity $a = b,\ b = c \Rightarrow a = c$. Combined with
reflexivity ($\mathrm{rfl}$) and symmetry above, this says $=$ is an
equivalence.

```lean
theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

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

[← Quantifiers](05-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)
