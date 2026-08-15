## Chapter 7: Groups

[← Chapter 6](06-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](08-chapter-8.md)

---

**1. Which fields cut `Group` out of `GroupData`, and a witness for `id_right`**

Nothing about the three data fields (`op`, `id`, `inv`) changes. Five
proof-obligation fields are added: `assoc`, `id_left`, `id_right`,
`inv_left`, `inv_right`. `Group` is exactly `GroupData` plus these five
proofs — the type of a term goes from "some operation and two elements"
to "an operation and two elements *together with evidence* they behave
correctly."

Claim: `op : Bool → Bool → Bool := fun a b => b` (return the second
argument) is associative, `id := false` is a left identity for `op`, but
`false` is not a right identity.

*Proof.* Associativity: `op (op a b) c = op b c = c` and
`op a (op b c) = op a c = c`, equal for all `a b c`. Left identity: `op e
a = a` holds for every `a` and, in fact, for *any* `e`, since `op`
ignores its first argument entirely and returns the second. Not a right
identity: `op a e = e` for every `a`, so `op a e = a` holds only when `a
= e`; taking `a := true`, `e := false` gives `op true false = false ≠
true`. $\blacksquare$

Hence a `GroupData Bool` built from this `op`, together with `id :=
false` and any `inv`, satisfies `assoc` and `id_left` but not
`id_right`. If the `id_right` field were removed from the definition of
`Group`, this data would type-check as a "group" while manifestly
lacking a two-sided identity — `id_right` is not implied by the other
four axioms and must remain a field of its own. The same style of
argument (a witness satisfying every axiom but one) applies to each of
the other four fields; deleting any of them admits a corresponding class
of non-group data.

**2. `boolXorGroup : Group Bool`**

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

Each field reduces to a finite check. `Bool.xor` on two or three concrete
booleans always computes, so once every variable is replaced by a concrete
constructor (`false`/`true`) via [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), the resulting equation holds by
definition and [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) closes it. `assoc` needs three nested `cases` since
it quantifies over three booleans ($2^3 = 8$ cases, matching
$(a \oplus b) \oplus c = a \oplus (b \oplus c)$ over $\mathbb{Z}/2$). The
others need only one.

**3. `id_left`/`id_right` and `inv_left`/`inv_right` under commutativity**

Claim: if `Grp.op` is commutative, `Grp.op id a = a` and `Grp.op a id = a`
are logically equivalent, and likewise for `inv_left`/`inv_right`.

*Proof.* Suppose `Grp.op id a = a` holds for all `a`. By commutativity,
`Grp.op a id = Grp.op id a = a`, which is exactly `id_right`. The
converse argument is identical with the roles exchanged. The same
substitution proves `inv_left ↔ inv_right` under commutativity: `Grp.op
(Grp.inv a) a = Grp.op a (Grp.inv a)` by commutativity, so one law holds
for all `a` iff the other does. $\blacksquare$

This is exactly why `intGroup` never distinguishes the two directions:
`Int` addition is commutative, so the equivalence above collapses
`id_left`/`id_right` into one fact proved twice.

In `perm3Group`, `Perm3.comp` is not commutative (`swap01 ∘ cycle012 ≠
cycle012 ∘ swap01`, computed in Section 4), so the hypothesis of the
claim fails, and no argument like the one above can derive `id_right`
from `id_left` alone, or `inv_right` from `inv_left` alone — both must be
supplied and proved independently, which is exactly what `perm3Group`'s
definition does.

**4. A single computed inequality proves function inequality**

Claim: for $f, g : X \to Y$, if there exists one $x_0 \in X$ with
$f(x_0) \neq g(x_0)$, then $f \neq g$.

*Proof.* Suppose toward contradiction $f = g$. Then $f(x_0) = g(x_0)$ for
every $x_0$, including the witness above, contradicting $f(x_0) \neq
g(x_0)$. Hence $f \neq g$. $\blacksquare$

This is the contrapositive of function extensionality: $f = g$ implies
agreement everywhere, so disagreement at even one point refutes equality.
No estimate or approximation is involved; a single point suffices because
$f = g$ is a *universal* claim ($\forall x, f(x) = g(x)$), and refuting a
universal claim needs only one counterexample.

Applying this to Section 4's `#eval`s: `(Perm3.comp swap01
cycle012).toFun 0` evaluates to `0` and `(Perm3.comp cycle012
swap01).toFun 0` evaluates to `2`, computed exactly (finite, decidable
data, not approximated). Taking $x_0 = 0$, $f = $ `(Perm3.comp swap01
cycle012).toFun`, $g = $ `(Perm3.comp cycle012 swap01).toFun` in the
claim above gives `(Perm3.comp swap01 cycle012).toFun ≠
(Perm3.comp cycle012 swap01).toFun`. If two `Perm3` records were equal,
their `toFun` fields would be equal by projection; contrapositively,
unequal `toFun` fields force the records themselves apart, giving
`Perm3.comp swap01 cycle012 ≠ Perm3.comp cycle012 swap01`: `perm3Group`
is non-abelian.

---

[← Chapter 6](06-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](08-chapter-8.md)
