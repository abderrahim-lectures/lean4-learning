## Exercises

[← Dependent types, with examples](03-dependent-types.md) | [Index](00-index.md)

---

**Key points.** `#check` reports a type without running anything. `#eval`
runs. A type is *dependent* when a later type mentions an earlier
*value* (`Vec α n`, `Fin n`), not merely an earlier type.

**Exercises.**

1. The return type of `Vec.replicate` mentions the value of its `Nat`
   argument. A plain function like `Nat.succ` does not. Is the type of
   `Nat.succ`, `Nat → Nat`, therefore *not* a Π-type? (The general
   Π-type pattern this question turns on gets its full formal treatment
   in [Chapter 2](../02-terminology-and-coc/00-index.md).)

2. Write `Vec.toList : Vec α n → List α`, converting a length-indexed
   vector to an ordinary list by forgetting its length. Contrast its type
   with the type of `Vec.replicate` from Section 3. Which one is a genuinely *dependent*
   function (its return type mentions the value of the argument), and which
   one is an ordinary function that merely happens to take a value of a
   dependent type as input?

Solutions, [Appendix, Chapter 1](../15-appendix-solutions/01-chapter-1.md).

---

[← Dependent types, with examples](03-dependent-types.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 2: Terminology & CoC →](../02-terminology-and-coc/00-index.md)
