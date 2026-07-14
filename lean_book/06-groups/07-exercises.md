## Exercises

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md)

---

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

Solutions: [Appendix, Chapter 6](../14-appendix-solutions/04-chapter-6.md).

## Next

Continue to [Chapter 7: Group examples and basic theorems](../07-group-theorems/00-index.md),
where we prove facts that hold for *every* group, generically.

---

[← Why bundle proofs with data?](06-why-bundle.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 7: Group Theorems →](../07-group-theorems/00-index.md)
