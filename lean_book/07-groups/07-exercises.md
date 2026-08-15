## Exercises

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md)

---

**Key points.** A group is data (`op`, `id`, `inv`) plus proof obligations
(`assoc`, two-sided `id`/`inv` laws), bundled in one `structure`. The
left/right split on `id`/`inv` is not overcaution: `perm3Group` needs both
directions, genuinely different. Any theorem proved once, generically,
against `Grp : Group G` applies to every concrete group built afterward
at no extra cost.

1. `GroupData` (`op`, `id`, `inv`, no axioms) type-checks for any choice
   of the three fields, including nonsense ones. State which fields
   `Group` adds to cut out the genuine groups. Then exhibit a
   `GroupData Bool` whose operation is associative and has a left
   identity, but no right identity, and prove it — showing that
   `id_right` cannot be derived from the other four axioms and must
   remain a field of its own.

2. Build `boolXorGroup : Group Bool` where `op` is boolean XOR
   (`Bool.xor`), `id := false`, and `inv := fun a => a` (every element is
   its own inverse). `by intro a; cases a <;> rfl` proves each field in
   one line; instead use `cases a with | false => rfl | true => rfl` for
   the fields that need a case split, to see which case does what.

3. Prove: if `Grp : Group G` and `Grp.op` is commutative, then `id_left`
   and `id_right` are logically equivalent, and likewise `inv_left` and
   `inv_right`. Then exhibit, using `perm3Group`, why the two directions
   cannot be collapsed into one axiom in general.

4. State the general principle that lets a single computed inequality
   $f(x) \neq g(x)$ at one point $x$ serve as a complete proof that
   $f \neq g$ as functions, and prove it. Apply it to the two `#eval`s in
   Section 4 to conclude `perm3Group` is non-abelian.

Solutions, [Appendix, Chapter 7](../15-appendix-solutions/07-chapter-7.md).

## Next

Continue to [Chapter 8: Group examples and basic theorems](../08-group-theorems/00-index.md),
where we prove facts that hold for *every* group, generically.

---

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 8: Group Theorems →](../08-group-theorems/00-index.md)
