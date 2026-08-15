# Chapter 8: Group examples and basic theorems

[← Ch. 7: Groups](../07-groups/00-index.md) | [Table of contents](../README.md) | [Ch. 9: Rings →](../09-rings/00-index.md)

---

## Learning objectives

- Prove a fact about *every* group at once by reasoning only from the fields of `Group`.
- Recognize the "relate both sides to a common third expression" and "pad with the identity, then cancel" patterns.
- Reuse a proved lemma (`left_inverse_unique`) to shortcut a later one (`inv_op`) instead of re-deriving it.

This chapter proves theorems about an *arbitrary* group. We are given some
`Grp : Group G` for an unknown `G`, and we use only the fields from
Chapter 7. Chapter 7 named a payoff it had not yet cashed in, that a
theorem proved once, generically, is inherited for free by every group
built afterward. This chapter cashes it in, and the point of the chapter
lies less in the three theorems themselves (they are standard) than in
**the search process** for finding each proof, given a goal, what to
examine, what to attempt, and how to recognize being stuck versus one step
away. Each theorem below is presented as that search, not merely its
answer.

Stating a theorem about "every group," rather than about one specific
group like `intGroup`, means fixing an arbitrary `Grp : Group G` with
`variable`, the same way a written proof opens with "let $G$ be a group"
([Section 1](01-setup.md)). The first fact worth proving this way is that
the identity is unique ([Section 2](02-theorem-1.md)), chosen first
because its proof introduces the central technique of the chapter, when
two opaque things must be shown equal, find a third expression both sides
equal on their own. The same "relate to a common expression" idea stretches
to a harder claim, uniqueness of inverses ([Section 3](03-theorem-2.md)),
though this time no single axiom hands over the needed third expression
directly; it must be built by padding an element with the identity and
then swapping the identity for something cancelable. Having just proved
that a left inverse is unique, that fact is then reused rather than
re-derived: proving $(ab)^{-1} = b^{-1}a^{-1}$
([Section 4](04-theorem-3.md)) reduces to checking that $b^{-1}a^{-1}$
satisfies the characterizing equation of Theorem 2, a "compute this" goal
turned into a cheaper "verify this" goal, and the result is then applied,
with no new proof, to the concrete permutation group of Chapter 7,
delivering the "proved once, free everywhere" promise for real.

Chapter 9 needs exactly this pattern again, one level up, a second
operation added to the structure of a group, with its own theorems to prove
generically before any concrete ring is built.

## Sections

1. [Setup](01-setup.md)
2. [Theorem 1: the identity is unique](02-theorem-1.md)
3. [Theorem 2: left inverses equal right inverses](03-theorem-2.md)
4. [Theorem 3: inverse of a product](04-theorem-3.md)
5. [Exercises](05-exercises.md)

---

[← Ch. 7: Groups](../07-groups/00-index.md) | [Table of contents](../README.md) | [Ch. 9: Rings →](../09-rings/00-index.md)
