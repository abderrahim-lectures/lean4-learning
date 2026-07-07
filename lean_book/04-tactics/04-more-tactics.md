## More tactics: `simp`, `constructor`, `cases`, `induction`, `unfold`

[← Reading failures](03-reading-failures.md) | [Index](00-index.md) | [Next: Worked example →](05-worked-example.md)

---

### `simp`: simplify using known simplification lemmas

```lean
theorem simp_example (n : Nat) : n + 0 = n := by
  simp
```

`simp` automatically searches for known "simplification" lemmas and applies
them, possibly many at once. This is convenient, but it hides *which* facts
were used and *why* the proof works — bad for learning. **In this book we
avoid `simp` and `rfl`-as-a-shortcut wherever the point is to understand the
proof.** We'll instead use explicit `rw` steps naming exactly which equality
justifies each step, and `induction` with a fully spelled-out base case and
inductive step. Treat `simp` as a tool for your *own* later proofs once you
already understand what it would have done by hand.

> Read more: [Chapter 12, "`simp`, now that you understand what it
> replaces"](../12-working-efficiently/03-simp.md) covers when it's the
> *right* efficient choice, once you no longer need every step spelled out.

### `constructor`: build a structure/And/Iff by its constructor

```lean
theorem and_example (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp
  · exact hq
```

The `·` (focus dot) lets you address each remaining goal one at a time.

**Mathematical reading.** `constructor` invokes the introduction rule of the
goal's type. For a product/conjunction $P \wedge Q$ it splits the task into
proving each factor separately — reflecting the universal property of the
product, "a map into $P \times Q$ is a pair of maps," so proving $P$ and
proving $Q$ suffices. More generally for any `structure` it reduces the goal
to one subgoal per field. Dually, `cases` on $h : P \vee Q$ below invokes
the *elimination* rule of a coproduct: to prove anything from $P \sqcup Q$
it suffices to prove it from each summand, the case analysis $\iota_1$/
$\iota_2$.

### `cases`: case-split on an inductive value or hypothesis

```lean
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq
```

### `induction`: proof by induction on a `Nat` (or other inductive type)

```lean
theorem add_zero_left (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 0 + (k + 1) = k + 1
    rw [Nat.add_succ, ih]
```

This mirrors the mathematical principle of induction:

$$
P(0) \;\land\; \big(\forall k,\ P(k) \to P(k+1)\big) \;\implies\; \forall n,\ P(n)
$$

`ih` (induction hypothesis) is exactly $P(k)$, available to prove $P(k+1)$.

### `unfold`: unfold a definition

```lean
def isZero (n : Nat) : Prop := n = 0

theorem isZero_zero : isZero 0 := by
  unfold isZero
```

**Mathematical reading.** `unfold isZero` replaces the defined name by its
definiens, exposing $\mathrm{isZero}(0) = (0 = 0)$. This is the use of a
*definitional* equality: $\mathrm{isZero} := (n \mapsto n = 0)$ means the
two are interchangeable by definition (like unwinding "$n$ is even" to
"$\exists k,\ n = 2k$" in a proof), so the goal becomes the tautology
$0 = 0$, closed by reflexivity.

[← Reading failures](03-reading-failures.md) | [Index](00-index.md) | [Next: Worked example →](05-worked-example.md)
