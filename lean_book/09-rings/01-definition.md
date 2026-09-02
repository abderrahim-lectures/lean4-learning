## The mathematical definition

[← Index](00-index.md) | [Next: CommGroup →](02-comm-group.md)

---

A `Group` (Chapter 7) has one operation. Arithmetic on $\mathbb{Z}$ has
more structure than that: multiplication sits alongside addition, and
$a(b+c) = ab+ac$ ties the two together. What is the minimal set of
axioms capturing "two operations, one of them a group, the second
compatible with the first via distributivity"? Every familiar instance,
integers, polynomials, matrices under entrywise addition, has
commutative addition; Chapter 7's `Group` alone does not require it, so
the additive part is strengthened to a *commutative* group. The second
operation, multiplication, is required to be associative with a
two-sided identity, an ordinary monoid structure, but not to commute or
have inverses: neither holds for $2 \times 2$ matrices, which must still
count as a ring. Distributivity, stated on both sides since
multiplication is not assumed commutative, ties the two operations
together. These three ingredients give the definition.

A **ring** is a set $R$ with *two* binary operations, addition and
multiplication, such that:

$$
\begin{aligned}
\text{(R1)}&\quad (R, +, 0, -(-)) \text{ is a commutative group} \\
\text{(R2)}&\quad (a \cdot b) \cdot c = a \cdot (b \cdot c) \quad \text{(multiplication is associative)} \\
\text{(R3)}&\quad \exists\, 1 \in R,\ 1 \cdot a = a \text{ and } a \cdot 1 = a \quad \text{(multiplicative identity)} \\
\text{(R4)}&\quad a \cdot (b + c) = a \cdot b + a \cdot c, \quad (a + b) \cdot c = a \cdot c + b \cdot c \quad \text{(distributivity)}
\end{aligned}
$$

Some textbooks do not require a multiplicative identity. Such a structure
is called a *rng*. The missing "i" stands for the missing identity. This
book includes the identity, since that is the more common convention.

(R1) is exactly the strengthening argued for above: `Group` in Chapter 7
did not require commutativity, so before `Ring` can be translated into
Lean, "commutative" must first be defined as an extension of `Group`.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Ring.** A set with two binary operations, addition and
  multiplication, such that the set is an abelian group under addition,
  multiplication is associative and distributes over addition, and
  (in the convention this book follows) a multiplicative identity exists
  ([DummitFoote2003], Ch. 7 "Introduction to Rings," §7.1 "Basic
  Definitions and Examples"). Dummit and Foote's own base definition
  does *not* require a multiplicative identity, calling that weaker
  structure a ring "not necessarily with 1" and reserving "ring" by
  default for the identity-including case in most of the later chapters
  of this book, the same choice (R3) above makes explicit. This is a
  structural citation to the section and its numbered axioms, not a
  verified word-for-word excerpt.

---

[← Index](00-index.md) | [Next: CommGroup →](02-comm-group.md)
