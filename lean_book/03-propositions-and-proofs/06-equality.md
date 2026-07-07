## Equality reasoning

[← Quantifiers](05-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

```lean
theorem symm_example {a b : Nat} (h : a = b) : b = a :=
  h.symm

theorem trans_example {a b c : Nat} (h1 : a = b) (h2 : b = c) : a = c :=
  h1.trans h2

theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 :=
  h ▸ rfl
```

`▸` ("substitution") rewrites the goal using an equality proof. You will use
its tactic form, `rw`, constantly starting in the next chapter.

**Mathematical reading.** These are the standard properties making $=$ an
equivalence relation together with substitutivity. `symm` and `trans` give
symmetry $a = b \Rightarrow b = a$ and transitivity $a = b,\ b = c
\Rightarrow a = c$; combined with reflexivity ($\mathrm{rfl}$) they say $=$
is an equivalence. The congruence `congr_example` is the Leibniz principle:
$a = b \Rightarrow f(a) = f(b)$ for any function $f$ (here $f(x) = x + 1$).
Type-theoretically, `h ▸ e` is *transport* along the equality $h : a = b$ —
given a proof of a statement about $a$, it produces the corresponding proof
about $b$, the operation that makes the identity type $\mathrm{Id}_\alpha(a,
b)$ behave like genuine equality. In categorical language, transport is the
action of the path $a \to b$ on the fibers of a dependent family.

---

[← Quantifiers](05-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)
