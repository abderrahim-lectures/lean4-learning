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

`trans` gives transitivity $a = b,\ b = c \Rightarrow a = c$; combined with
reflexivity ($\mathrm{rfl}$) and symmetry above, this says $=$ is an
equivalence.

```lean
theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 :=
  h ▸ rfl
```

`▸` ("substitution") rewrites the goal using an equality proof. You will use
its tactic form, `rw`, constantly starting in the next chapter.

The congruence `congr_example` is the Leibniz principle: $a = b \Rightarrow
f(a) = f(b)$ for any function $f$ (here $f(x) = x + 1$).
Type-theoretically, `h ▸ e` performs what's usually called **transport**:
given a proof `e` of some statement about `a`, and an equality `h : a = b`,
it produces the corresponding proof of that same statement about `b`, by
substituting `b` for `a` wherever `a` appeared. In `congr_example`, `rfl`
first proves the (trivial) statement "$a + 1 = a + 1$," and `h ▸` carries
that proof across $h : a = b$ to land on the stated goal "$a + 1 = b + 1$."
This is the mechanical form of "substitute equals for equals" — exactly
what the `rw` tactic (starting next chapter) automates for you.

---

[← Quantifiers](05-quantifiers.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)
