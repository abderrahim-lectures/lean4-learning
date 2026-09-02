## The mathematical definition

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating-into-lean.md)

---

Take any abelian group $(M, +, 0, -(-))$, say $\mathbb{Z}$ itself, or the
group of $2\times 2$ integer matrices under addition from Chapter 9. Multiplying
one of its elements $m$ by a positive integer $n$ needs no new structure
at all, $3 \cdot m$ already means $m + m + m$, computed with nothing but
the group operation already in hand, and $n \cdot m$ for $n \le 0$ extends
this the same way `intSmul`/`natSmul` will in Section 3. This "multiply
by an integer" action satisfies four facts for free, inherited directly
from the group axioms: $n \cdot (m_1 + m_2) = n\cdot m_1 + n \cdot m_2$,
$(n_1+n_2)\cdot m = n_1\cdot m + n_2 \cdot m$, $(n_1 n_2)\cdot m =
n_1\cdot(n_2\cdot m)$, and $1 \cdot m = m$. None of this required
$\mathbb{Z}$ to be a field, only a ring, unlike a vector space, which
needs division to make sense of "scaling." What is the general structure
these four facts describe, once $\mathbb{Z}$ is replaced by an arbitrary
ring $R$ and "integer scaling" by an arbitrary action $R \times M \to M$?

Given a ring $R$ (Chapter 9), a (left) **$R$-module** is an abelian group
$(M, +, 0, -(-))$ together with a scalar action $R \times M \to M$, written
$r \cdot m$, satisfying exactly the four facts just observed for
$\mathbb{Z}$-scaling, now required as axioms for an arbitrary $R$:

$$
\begin{aligned}
\text{(M1)}&\quad r \cdot (m + n) = r\cdot m + r \cdot n \\
\text{(M2)}&\quad (r + s) \cdot m = r \cdot m + s \cdot m \\
\text{(M3)}&\quad (r \cdot s) \cdot m = r \cdot (s \cdot m) \\
\text{(M4)}&\quad 1 \cdot m = m
\end{aligned}
$$

for all $r, s \in R$, $m, n \in M$. This is exactly the vector space
definition, with "field" replaced by "ring". That extra generality is
the whole point: $\mathbb{Z}$-modules are abelian groups, and $k[x]$-modules
(for $k$ a field) are vector spaces equipped with a chosen linear endomorphism.
Most importantly for this book, a representation of a quiver $Q$ is
precisely a module over the path algebra $kQ$; this is why the present
chapter is placed immediately before Chapter 12.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Module.** Given a ring $R$, a left $R$-module is an abelian group
  under addition together with a scalar action of $R$ satisfying the
  left-distributive, right-distributive, and associative-action axioms,
  plus unitality when $R$ has an identity
  ([DummitFoote2003], Ch. 10 "Introduction to Module Theory," §10.1
  "Basic Definitions and Examples"). This is a structural citation to
  the section and its numbered axioms, not a verified word-for-word
  excerpt.
- Weibel ([Weibel1994]) is offered as further reading on modules in the
  broader context of homological algebra, not an independently verified
  factual claim.

[Weibel1994]: ../bibliography.md#weibel1994

---

[← Index](00-index.md) | [Next: Translating into Lean →](02-translating-into-lean.md)
