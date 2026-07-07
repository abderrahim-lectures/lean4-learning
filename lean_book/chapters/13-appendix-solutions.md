# Appendix: Solutions to exercises

[← Ch. 12: Next Steps](12-next-steps.md) | [Table of contents](../README.md)

---

Solutions are written in the same explicit style as the main text: every
`rw`/`have`/`intro` is one step, and shortcuts (`simp`, unexplained `rfl`)
are avoided except where a step is genuinely definitional and there is
nothing to explain.

## Chapter 3: Propositions and proofs

**1. `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

```lean
theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P :=
  ⟨h.right, h.left⟩
```

`h : P ∧ Q` has fields `h.left : P` and `h.right : Q`. A proof of `Q ∧ P` is
the pair with those two components in the opposite order.

**2. `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P`**

```lean
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq
```

`Or` has two constructors, so any proof `h : P ∨ Q` was built by one of
them; `match` recovers which one and the witness it carried. In the
`Or.inl hp` case we have `hp : P`, and `Or.inr hp : Q ∨ P` uses it as the
right disjunct; symmetrically for `Or.inr hq`.

**3. `theorem exists_gt_zero : ∃ n : Nat, n > 0`**

```lean
theorem exists_gt_zero : ∃ n : Nat, n > 0 :=
  ⟨1, by decide⟩
```

An `∃`-proof is a witness (`1`) paired with a proof that it satisfies the
predicate (`1 > 0`), here discharged by `decide` since `1 > 0` on `Nat` is a
decidable, closed proposition. Equivalently `⟨1, Nat.one_pos⟩` or `⟨1, rfl⟩`
(as `1 > 0` unfolds to `0 < 1`, i.e. `Nat.succ 0 ≤ 1`, definitionally true).

## Chapter 4: Tactics

**1. `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P`**

```lean
theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left
```

`constructor` reduces the goal `Q ∧ P` to two subgoals, `Q` and `P`, one for
each field of `And`. `h.right : Q` and `h.left : P` close them respectively.

**2. `theorem nat_mul_zero (n : Nat) : n * 0 = 0`**

```lean
theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl
```

`rfl` *does* work here: `Nat.mul` is defined by recursion on its second
argument with `n * 0 = 0` as the base clause, so this holds definitionally,
with no induction needed (contrast with `0 * n = 0`, which is not a base
clause and does need induction on `n`).

**3. `modus_ponens` in tactic mode**

```lean
theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

`apply hpq` matches the goal `Q` against the conclusion of `hpq : P → Q`,
leaving a new goal `P`, closed by `exact hp`.

## Chapter 5: Groups

**1. `boolXorGroup : Group Bool`**

```lean
def boolXorGroup : Group Bool where
  op := Bool.xor
  id := false
  inv := fun a => a
  assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  id_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  id_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
```

Each field reduces to a finite check: `Bool.xor` on two or three concrete
booleans always computes, so once every variable is replaced by a concrete
constructor (`false`/`true`) via `cases`, the resulting equation is
definitional and `rfl` closes it. `assoc` needs three nested `cases` since
it quantifies over three booleans ($2^3 = 8$ cases, matching
$(a \oplus b) \oplus c = a \oplus (b \oplus c)$ over $\mathbb{Z}/2$); the
others need only one.

**2. `inv_left`/`inv_right` are genuinely different obligations**

For a general (non-abelian) group, `Grp.op (Grp.inv a) a = Grp.id` and
`Grp.op a (Grp.inv a) = Grp.id` are a priori independent statements — `op`
need not be commutative, so nothing forces "inverse on the left" to equal
"inverse on the right" without separately postulating (or proving) both.
Chapter 6, Theorem 2 (`left_inverse_unique`) shows something subtler:
*given* both axioms hold for the *distinguished* `Grp.inv`, any *other*
element that is merely a left inverse of `a` must already equal
`Grp.inv a` — i.e. left inverses are automatically unique once two-sided
inverses are known to exist, which is what lets one-sided inverse-uniqueness
arguments substitute for commutativity in that specific proof. It does not
mean `inv_left` and `inv_right` were redundant as *axioms*; only that, once
both hold, "a" left inverse coincides with "the" two-sided one.

## Chapter 6: Group examples and basic theorems

**1. `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`**

```lean
theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a := by
  apply Eq.symm
  apply left_inverse_unique Grp (Grp.inv a) a
  -- Goal: op a (inv a) = id
  exact Grp.inv_right a
```

By `left_inverse_unique` (Chapter 6, Theorem 2), to show
`a = Grp.inv (Grp.inv a)` it suffices to show `a` is a left inverse of
`Grp.inv a`, i.e. `Grp.op a (Grp.inv a) = Grp.id` — exactly `Grp.inv_right a`.

**2. `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`**

```lean
theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c := by
  have h1 : Grp.op (Grp.inv a) (Grp.op a b) = Grp.op (Grp.inv a) (Grp.op a c) := by
    rw [h]
  rw [← Grp.assoc (Grp.inv a) a b] at h1
  -- h1 : op (op (inv a) a) b = op (inv a) (op a c)
  rw [← Grp.assoc (Grp.inv a) a c] at h1
  -- h1 : op (op (inv a) a) b = op (op (inv a) a) c
  rw [Grp.inv_left] at h1
  -- h1 : op id b = op id c
  rw [Grp.id_left, Grp.id_left] at h1
  -- h1 : b = c
  exact h1
```

We left-multiply both sides of `h` by `Grp.inv a` (step `h1`), regroup with
associativity so `Grp.inv a` meets `a` on both sides, cancel that pair via
`inv_left` to `Grp.id`, then strip `Grp.id` via `id_left`, leaving `b = c`
directly.

## Chapter 7: Rings

**1. `boolAndOrRing` (the ring $\mathbb{Z}/2\mathbb{Z}$ on `Bool`)**

```lean
def bool2CommGroup : CommGroup Bool where
  toGroup := boolXorGroup
  comm := by
    intro a b
    cases a with
    | false => cases b with | false => rfl | true => rfl
    | true => cases b with | false => rfl | true => rfl

def bool2Ring : Ring Bool where
  addGrp := bool2CommGroup
  mul := Bool.and
  one := true
  mul_assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  one_mul := by
    intro a
    cases a with | false => rfl | true => rfl
  mul_one := by
    intro a
    cases a with | false => rfl | true => rfl
  left_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  right_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
```

Reusing `boolXorGroup` from Chapter 5's exercise as the additive group
(`+` = XOR, `0` = `false`), we add `∧` (Boolean and) as multiplication with
`1 = true`. As with `assoc` in Chapter 5, every axiom is a finite check over
$2$ or $2^3$ cases, each closed by `rfl` since `Bool.and`/`Bool.xor` compute
on concrete constructors. This is exactly $\mathbb{Z}/2\mathbb{Z}$: XOR is
addition mod 2, AND is multiplication mod 2.

**2. Why both `left_distrib` and `right_distrib` are needed**

Distributivity as usually stated, $a(b+c) = ab+ac$, only lets you expand a
product with the *sum on the right* factor. Its mirror,
$(a+b)c = ac+bc$, expands a product with the *sum on the left* factor. If
`mul` were known to be commutative these would be interchangeable (apply
`comm` and use the other one), but a general `Ring` (as opposed to a
`CommRing`) makes no such assumption — indeed Chapter 8's proof of
`mul_zero` uses `left_distrib`, while `mul_zero_left` (its mirror, an
exercise) needs `right_distrib` instead, precisely because there is no
`mul_comm` field available to convert one into the other.

## Chapter 8: Ring examples and basic theorems

**1. `theorem mul_zero_left (Rg : Ring R) (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id`**

```lean
theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) a =
      Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a) :=
    Rg.right_distrib Rg.addGrp.id Rg.addGrp.id a
  rw [h0] at h1
  -- h1 : Rg.mul Rg.addGrp.id a = op (mul 0 a) (mul 0 a)
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a)) (Rg.mul Rg.addGrp.id a) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))
        (Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a)) := by
    rw [h1]
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm
```

Line for line the mirror of Chapter 8's Theorem 1 (`mul_zero`): instead of
distributing `a * (0 + 0)` on the left, we distribute `(0 + 0) * a` on the
right (`right_distrib`), giving `mul 0 a = op (mul 0 a) (mul 0 a)`, and the
same "add the inverse of `mul 0 a` to both sides" trick isolates
`Rg.addGrp.id = Rg.mul Rg.addGrp.id a`.

**2. `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`**

```lean
theorem neg_mul (a b : R) :
    Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b) := by
  apply left_inverse_unique Rg.addGrp.toGroup (Rg.mul a b) (Rg.mul (Rg.addGrp.toGroup.inv a) b)
  -- Goal: op (mul (inv a) b) (mul a b) = id
  rw [← Rg.right_distrib]
  -- justified by right_distrib, read backwards: combines the two products
  -- mul (inv a) b and mul a b into mul (op (inv a) a) b.
  -- Goal: mul (op (inv a) a) b = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- justified by inv_left of the additive group: op (inv a) a = id.
  -- Goal: mul Rg.addGrp.id b = id
  exact mul_zero_left Rg b
```

By `left_inverse_unique` (Chapter 6, Theorem 2, applied to the additive
group `Rg.addGrp.toGroup`), it suffices to show
`Rg.mul (Rg.addGrp.toGroup.inv a) b` is a left additive-inverse of
`Rg.mul a b`. `right_distrib` (used backwards) merges the two products into
`Rg.mul (Rg.addGrp.op (Rg.addGrp.toGroup.inv a) a) b`; `inv_left` collapses
the inner sum to `Rg.addGrp.id`; and `mul_zero_left` (the previous exercise)
finishes.

## Chapter 9: Quivers and path algebras

**1. Adding a cycle**

```lean
inductive CyclicArrow where
  | alpha : CyclicArrow   -- 0 → 1
  | beta : CyclicArrow     -- 1 → 2
  | gamma : CyclicArrow    -- 2 → 0

def cyclicQuiver : Quiver (Fin 3) CyclicArrow where
  source := fun a => match a with
    | CyclicArrow.alpha => 0
    | CyclicArrow.beta => 1
    | CyclicArrow.gamma => 2
  target := fun a => match a with
    | CyclicArrow.alpha => 1
    | CyclicArrow.beta => 2
    | CyclicArrow.gamma => 0

def cPathAlpha : Path cyclicQuiver 0 1 :=
  Path.cons CyclicArrow.alpha rfl rfl (Path.nil 0)

def cPathBetaAlpha : Path cyclicQuiver 0 2 :=
  Path.cons CyclicArrow.beta rfl rfl cPathAlpha

def cPathGammaBetaAlpha : Path cyclicQuiver 0 0 :=
  Path.cons CyclicArrow.gamma rfl rfl cPathBetaAlpha
```

Each `rfl` again discharges a source/target proof obligation that reduces
definitionally from the `match` in `cyclicQuiver`. Note
`cPathGammaBetaAlpha` is a nontrivial *loop* at vertex `0` — the path
algebra of a quiver with cycles has elements of arbitrarily high "length,"
which is exactly why such algebras are typically infinite-dimensional
unless one imposes relations (an "admissible ideal") on the path algebra.

**2. `theorem append_nil_left`**

```lean
theorem append_nil_left {V A : Type} {Q : Quiver V A} {u v : V} (p : Path Q u v) :
    Path.append (Path.nil u) p = p := by
  induction p with
  | nil v =>
    -- Goal: Path.append (Path.nil u) (Path.nil v) = Path.nil v
    -- Here u and v are the same vertex (both goals collapse since nil's
    -- source and target indices coincide); Path.append unfolds on its
    -- second argument being `nil`, giving `Path.nil u` on the nose.
    rfl
  | cons a h h' q' ih =>
    -- ih : Path.append (Path.nil u) q' = q'
    -- Goal: Path.append (Path.nil u) (Path.cons a h h' q') = Path.cons a h h' q'
    show Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'
    rw [ih]
```

This mirrors `Path.append`'s own recursion, case for case: `Path.append`
was *defined* by matching on its second argument, so `induction p` (which
case-splits on exactly that argument, generating the matching induction
hypothesis `ih` in the `cons` case) unfolds the definition directly. In the
`nil` case both sides are definitionally `Path.nil u`. In the `cons` case,
unfolding `Path.append`'s defining equation turns the goal into
`Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'`
(the `show` line makes this explicit rather than leaving it to
elaboration), and `rw [ih]` finishes by the induction hypothesis.

**3. Sketch of `PathAlgebra`**

```lean
-- A k-linear combination of paths from u to v, as a finitely-supported
-- function from paths to coefficients. `Finsupp`-style support tracking is
-- the honest way to do this; a simplified sketch:
structure PathAlgebraElem (V A : Type) (Q : Quiver V A) (k : Type) where
  -- coeff p = the coefficient of path p, for finitely many nonzero p
  coeff : {u v : V} → Path Q u v → k
  -- (a finiteness/support condition would be required here in a full
  -- development, e.g. via Mathlib's `Finsupp`)

-- To satisfy `Ring` (Chapter 7), `PathAlgebraElem` would need:
--   addGrp : CommGroup (PathAlgebraElem V A Q k)   -- pointwise addition of coefficients
--   mul    : concatenate paths, multiplying and summing coefficients over
--            all ways two paths compose (zero when endpoints don't match)
--   one    : the sum, over all vertices v, of 1 · (trivial path at v)
--            (an idempotent identity, since Q may have infinitely many
--            vertices this "one" is only literally an element when Q0 is
--            finite — for infinite Q the path algebra is typically only
--            a "ring with local units," a subtlety Mathlib's category-
--            theoretic treatment handles more gracefully than a bare Ring)
```

The honest finiteness/support bookkeeping (which paths have nonzero
coefficient) is exactly what makes a full formalization a genuine project
rather than a one-page exercise — this sketch identifies the three `Ring`
fields that need it (`addGrp`, `mul`, `one`) and why `one` is the subtle
one when $Q_0$ is infinite.

---

[← Ch. 12: Next Steps](12-next-steps.md) | [Table of contents](../README.md)
