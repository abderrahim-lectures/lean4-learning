## Exercises

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md)

---

**Key points.** A group is data (`op`, `id`, `inv`) plus proof obligations
(`assoc`, two-sided `id`/`inv` laws), bundled in one `structure`. The
left/right split on `id`/`inv` is not overcaution — a genuinely
non-abelian example (`perm3Group`) needs both. Any theorem proved once,
generically, against `Grp : Group G` applies to every concrete group
built afterward at no extra cost.

**Socratic questions.**

1. *`intGroup` never tests the difference between `id_left`/`id_right`
   or `inv_left`/`inv_right`, since `Int` addition is commutative. Does
   that mean the split is only there for generality's sake, with no
   concrete example that actually needs it?* No — `perm3Group` needs it
   for real: composing permutations is genuinely non-commutative, so
   `id_left` and `id_right` are two separate proof obligations there,
   not a single fact proved twice.
2. *`GroupData` (op, id, inv, no axioms) type-checks for any choice of
   the three fields, including nonsense ones. What is the smallest change
   that turns "any `GroupData`" into "only genuine groups"?* Nothing
   about the *data* fields changes at all — five more fields are added,
   each a proof obligation. `Group` is exactly `GroupData` plus those
   five proofs; the type of a term goes from "some operation and two
   elements" to "an operation and two elements *together with evidence*
   they behave correctly."
3. *`perm3Group`'s three-line `#eval` computation showed
   `swap01 ∘ cycle012 ≠ cycle012 ∘ swap01`. Why is that a complete proof
   of non-commutativity, rather than just suggestive evidence?* Because
   disproving a universal claim (`∀ f g, f ∘ g = g ∘ f`) needs only one
   counterexample, and the two sides of that one inequality were
   computed, not estimated — `#eval` is exact here, not approximate,
   since `Perm3` composition is finite and decidable.

1. Build `boolXorGroup : Group Bool` where `op` is boolean XOR (`Bool.xor`),
   `id := false`, and `inv := fun a => a` (every element is its own
   inverse). Prove each field using `by intro a; cases a <;> rfl` is
   tempting — instead, for practice, use `cases a with | false => rfl | true => rfl`
   for the fields that need a case split, to see exactly which case does
   what.
2. Verify on paper that `inv_left` and `inv_right` are genuinely
   different obligations. They coincide automatically only once the group has
   been *proved* commutative — this is exactly the content of
   Chapter 7's first theorem.

Solutions: [Appendix, Chapter 6](../14-appendix-solutions/05-chapter-6.md).

## Next

Continue to [Chapter 7: Group examples and basic theorems](../07-group-theorems/00-index.md),
where we prove facts that hold for *every* group, generically.

---

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 7: Group Theorems →](../07-group-theorems/00-index.md)
