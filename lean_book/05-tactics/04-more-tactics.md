## More tactics: [`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`unfold`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)

[← Reading failures](03-reading-failures.md) | [Index](00-index.md) | [Next: Worked example →](05-worked-example.md)

---

None of `intro`/`exact`/`apply`/`rw` from the previous section says anything
about a goal with two independent parts to prove at once, like $P \wedge Q$:
proving it needs a proof of $P$ *and* a proof of $Q$, two separate
obligations from one goal.

```lean
theorem and_example (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp
  · exact hq
```

[`constructor`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is exactly the tactic for this: it invokes the
introduction rule of the goal's type, splitting $P \wedge Q$ into the two
goals $P$ and $Q$ (the `·` focus dot addresses each one in turn), and more
generally, for any `structure`, into one goal per field. This reflects the
[universal
property](../02-terminology-and-coc/01-terminology.md#category-theory-terms-used-beyond-the-baseline)
of the product, "a map into $P \times Q$ is a pair of maps," so proving $P$
and proving $Q$ is enough.

> Read more. [Chapter 4, Section 2](../04-propositions-and-proofs/02-logic-recap.md)
> states the introduction/elimination rules for every connective by name,
> if "introduction rule"/"elimination rule" as general terms are new.

`constructor` builds a conjunction; the dual problem is *consuming* a
disjunction already in hand. A hypothesis $h : P \vee Q$ gives no term
directly usable by `exact`, since which of $P$, $Q$ actually holds is not
known, only that one of them does.

```lean
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq
```

[`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) splits the proof into one branch per way $h$ could have
been built, `inl hp : P` or `inr hq : Q`, and each branch supplies its own
proof of the goal. This is the *elimination* rule of a coproduct (the
reading of $\vee$ as a coproduct in
[Chapter 4, Section 5](../04-propositions-and-proofs/05-and-or-not.md)):
to prove anything from $P \sqcup Q$, it suffices to prove it from each
summand, the case analysis $\iota_1$/$\iota_2$. `cases` works the same way
on any inductive value, not only a disjunction hypothesis, splitting into
one goal per constructor.

`cases` handles a value built by *one* of finitely many constructors, but
`Nat` has a constructor, `succ`, that refers back to a smaller `Nat`.
Splitting on `succ k` alone leaves a goal about `k` with nothing yet known
about it, unlike the finitely many closed cases `cases` produces elsewhere.

```lean
theorem add_zero_left (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 0 + (k + 1) = k + 1
    rw [Nat.add_succ, ih]
```

[`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is `cases` strengthened for exactly this: the `succ k`
branch additionally supplies `ih`, a proof of the goal *for `k`*, the
mathematical principle of induction made available as a hypothesis.

$$
P(0) \;\land\; \big(\forall k,\ P(k) \to P(k+1)\big) \;\implies\; \forall n,\ P(n)
$$

`ih` is exactly $P(k)$, available to prove $P(k+1)$.

None of the tactics so far can see through a name like `isZero` to what it
actually means; `rw` needs an equation to rewrite with, and `isZero 0` is
not stated as one.

```lean
def isZero (n : Nat) : Prop := n = 0

theorem isZero_zero : isZero 0 := by
  unfold isZero
  -- Goal after unfold: 0 = 0
  rfl
```

[`unfold`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) replaces the defined name with its definiens, exposing
$\mathrm{isZero}(0) = (0 = 0)$. This uses a *definitional* equality:
$\mathrm{isZero} := (n \mapsto n = 0)$ means the two are interchangeable by
definition (like unwinding "$n$ is even" to "$\exists k,\ n = 2k$" in a
proof). So the goal becomes the tautology $0 = 0$, closed by reflexivity.

### An aside on transparency: `def` vs. `abbrev` vs. `opaque`

`unfold isZero` above had to name `isZero` explicitly, the same way
`rw` names an equation explicitly, because that is exactly what `unfold`
is for. This is a good moment to name the promise from
[Chapter 1, Section 2](../01-basics/02-def-let-implicit.md). `def` is not
the only way to introduce a definition, and the alternatives differ
precisely in how much they need to be *told about* like this, versus being
seen through automatically.

- **`def` (semi-reducible, the default).** Requires an explicit instruction
  to unfold, `unfold` by name in a tactic proof, exactly as above. This
  matches the traceability this book has been deliberately practicing
  throughout this chapter, nothing unfolds silently, and every step names
  what justified it.
- **`abbrev` (reducible, automatically `@[reducible, inline]`).** Declares
  the definition *notational*, not merely equal, so the elaborator of Lean and
  automated machinery treat every occurrence as if the body had been
  written out directly, with no `unfold` step to ask for. The clean
  demonstration of this has to wait for tools that actually *search*
  through definitions automatically. Typeclass resolution
  ([Chapter 6](../06-rigor-check/01-structure-vs-class.md)) searches at
  reducible transparency by default, so an `abbrev` (or a `def` tagged
  `@[reducible]`, as `isPrime` was in
  [Chapter 4](../04-propositions-and-proofs/06-quantifiers.md)) is visible
  to that search without being unfolded by hand first, while a
  plain `def` generally is not.
- **`opaque`.** The opposite extreme, not unfoldable at all, by `unfold`
  or anything else, even though it still has a definition somewhere. Useful
  for genuinely hiding an implementation and exposing only the properties
  proved about it, the Lean equivalent of citing a chosen but unspecified
  witness ("let $c$ be *some* element of the nonempty set $S$") and
  reasoning only from what is known about it, never from how it was built.

**Mathematical reading.** This maps onto a distinction already made
informally, if rarely by name, in ordinary mathematical writing. A `def`
is a definition cited by name in a proof, "by definition of $f$, ...", an
explicit, visible step. An `abbrev` is pure notation, the kind silently
unfolded without comment, writing $2n$ in place of ever having introduced
a name $f(n) := 2n$ at all. An `opaque` value is an axiomatized or
black-boxed object, reasoned about only through its stated properties,
never its construction. The three transparency levels of Lean are exactly
these three mathematical habits, made explicit and machine-checked instead
of left to convention.

Every proof in this chapter so far has named, by hand, exactly which lemma
or equation justifies each step: `Nat.add_succ`, `ih`, an `unfold`d
definition. Once the same handful of rewrites recur across many similar
goals, naming each one individually stops teaching anything new and
becomes pure repetition.

```lean
theorem simp_example (n : Nat) : n + 0 = n := by
  simp
```

[`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) automates exactly this: it searches a library of known
"simplification" lemmas and applies as many as fire, in one step. The cost
is exactly the traceability just built up by hand: `simp` hides *which*
facts were used and *why* the proof works, which is bad for learning
something for the first time. **This book therefore avoids `simp` and
`rfl`-as-a-shortcut wherever the point is to understand the proof**, using
explicit `rw` and `induction` with a fully spelled-out base case and
inductive step instead. `simp` is a tool for *later*, once what it would
have done by hand is already understood, not a substitute for doing it by
hand the first time.

> Read more. [Chapter 13, "`simp`, now that you understand what it
> replaces"](../13-working-efficiently/03-simp.md) covers when it is the
> *right* efficient choice, once every step no longer needs to be spelled out.

[← Reading failures](03-reading-failures.md) | [Index](00-index.md) | [Next: Worked example →](05-worked-example.md)
