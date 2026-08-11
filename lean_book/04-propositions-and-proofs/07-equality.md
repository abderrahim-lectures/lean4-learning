## Equality reasoning

[← Quantifiers](06-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)

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
from here on. Nearly every proof from Chapter 5 onward reaches for it
whenever an equality hypothesis needs to be used inside a larger goal.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Equality as an equivalence relation.** "A fundamental property of
  equality is that it is an equivalence relation, holding reflexivity,
  symmetry, [and] transitivity" ([TPIL4], §4.2 "Equality"). Picture it
  like this. `symm_example` and `trans_example` above are exactly the
  symmetry and transitivity halves of that triple; reflexivity is `rfl`,
  used freely everywhere else in this book.
- **Substitution and congruence.** "Equality is much more than an
  equivalence relation, however. It has the important property that every
  assertion respects the equivalence, in the sense that we can substitute
  equal expressions without changing the truth value. [...] Given `h1 : a
  = b` and `h2 : p a`, we can construct a proof for `p b` using
  substitution: `Eq.subst h1 h2`" ([TPIL4], §4.2 "Equality"). Picture it
  like this. `congr_example` is a `rw`-mechanized instance of exactly this
  substitution property, `rw [h]` finds `a` and replaces it with `b`
  wherever the goal mentions it, which is substitution applied to the
  specific assertion `_ + 1 = b + 1`.

---

[← Quantifiers](06-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](08-exercises.md)
