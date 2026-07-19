## Moving to Mathlib

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

---

Everything here was reinvented on purpose instead of imported, so that
every moving part would be visible. Mathlib, Lean's community mathematics
library, already has much more general and well-tested versions of all of
this:

- `Mathlib.Algebra.Group.Defs` — [`Group`](https://loogle.lean-lang.org/?q=Group), `CommGroup`, built with Lean's
  **type class** mechanism (`class ... extends ...`) instead of a plain
  `structure`. This lets notation like `a * b`, `a⁻¹`, `1` work the same
  way across every group, without threading a `Grp :` argument through
  every definition by hand, and lets Lean find instances automatically
  through typeclass search.
- `Mathlib.Algebra.Ring.Defs` — [`Ring`](https://loogle.lean-lang.org/?q=Ring), `CommRing`, `Field`, and the whole
  hierarchy in between (`Semiring`, `NonUnitalRing`, ...).
- `Mathlib.Algebra.Module.Defs` — [`Module`](https://loogle.lean-lang.org/?q=Module), much more general than
  Chapter 10's hand-built version, with the entire linear-algebra library
  (`Mathlib.LinearAlgebra.*`: bases, dimension, tensor products, exact
  sequences) built on top.
- `Mathlib.Combinatorics.Quiver.Basic` and `Mathlib.Algebra.Category.*` —
  quivers as the underlying data of a category (a category is "a quiver
  plus identities and composition satisfying associativity," the same
  free-category construction from Chapter 11), and `Mathlib.CategoryTheory`
  more broadly.
- Path algebras specifically show up in representation-theory-oriented
  corners of Mathlib and in dedicated Lean projects on quiver
  representations. Searching Mathlib's docs for "quiver" and "path" is a
  good starting point once the type-class style is familiar.

The jump from this book's `structure`-based definitions to Mathlib's
`class`-based ones is mostly about **ergonomics**: automatic instance
resolution, shared notation, and inheritance diamonds (the ambiguity that
arises when a structure extends two parents with a common ancestor)
already resolved. It is not really about mathematical content —
the axioms already learned are the same axioms, merely packaged so
Lean's elaborator can find them without a `Grp` argument named in
every theorem.

### Two theorems for free

Everything above is a promise that Mathlib is *more general*. Here are
two concrete payoffs — things this book explicitly could not state,
using exactly the examples already built.

**`ZMod 3` is a field, not just a ring.** Chapter 8 §5 built `fin3Ring`
and said in so many words that a `Field` would need every nonzero
element to be invertible, "true for $\mathbb{Z}/3$ precisely because $3$
is prime, but not part of `Ring`'s axioms and not checked here." Mathlib
already has this instance, for real:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20Field%20%28ZMod%203%29%20%3A%3D%20inferInstance%0A%0A--%20A%20fact%20%60fin3Ring%60%20%28a%20mere%20%60Ring%60%29%20genuinely%20cannot%20state%3A%20every%0A--%20nonzero%20element%20has%20a%20multiplicative%20inverse.%0Aexample%20%3A%20%E2%88%80%20a%20%3A%20ZMod%203%2C%20a%20%E2%89%A0%200%20%E2%86%92%20%E2%88%83%20b%2C%20a%20%2A%20b%20%3D%201%20%3A%3D%20by%20decide" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20Field%20%28ZMod%203%29%20%3A%3D%20inferInstance%0A%0A--%20A%20fact%20%60fin3Ring%60%20%28a%20mere%20%60Ring%60%29%20genuinely%20cannot%20state%3A%20every%0A--%20nonzero%20element%20has%20a%20multiplicative%20inverse.%0Aexample%20%3A%20%E2%88%80%20a%20%3A%20ZMod%203%2C%20a%20%E2%89%A0%200%20%E2%86%92%20%E2%88%83%20b%2C%20a%20%2A%20b%20%3D%201%20%3A%3D%20by%20decide" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

**Lagrange's theorem, applied to the non-abelian example from Chapters
6-7.** `Equiv.Perm (Fin 3)` (Chapter 6 §4's Mathlib analogue of
`perm3Group`) never had subgroups defined for it — the book built one
group, not the lattice of its subgroups. Mathlib's `Subgroup` type
already comes with Lagrange's theorem attached, so applying it to a real
subgroup costs nothing beyond naming the subgroup:

<p><a href="https://live.lean-lang.org/#code=--%20Lagrange%27s%20theorem%2C%20fully%20generic%3A%20a%20subgroup%27s%20size%20divides%20the%0A--%20ambient%20group%27s%20size.%0Aexample%20%28s%20%3A%20Subgroup%20%28Equiv.Perm%20%28Fin%203%29%29%29%20%3A%0A%20%20%20%20Nat.card%20s%20%E2%88%A3%20Nat.card%20%28Equiv.Perm%20%28Fin%203%29%29%20%3A%3D%0A%20%20Subgroup.card_subgroup_dvd_card%20s%0A%0A--%20Concretely%3A%20%7CS_3%7C%20%3D%203%21%20%3D%206...%0Aexample%20%3A%20Nat.card%20%28Equiv.Perm%20%28Fin%203%29%29%20%3D%206%20%3A%3D%20by%0A%20%20rw%20%5BNat.card_eq_fintype_card%2C%20Fintype.card_perm%2C%20Fintype.card_fin%5D%0A%20%20rfl%0A%0A--%20...and%20the%20cyclic%20subgroup%20generated%20by%20the%203-cycle%20finRotate%203%20has%0A--%20order%203%2C%20since%20%28finRotate%203%29%5E3%20%3D%201%20and%20finRotate%203%20%E2%89%A0%201%20with%203%20prime.%0Aexample%20%3A%20Nat.card%20%28Subgroup.zpowers%20%28finRotate%203%29%29%20%3D%203%20%3A%3D%20by%0A%20%20rw%20%5BNat.card_zpowers%5D%0A%20%20apply%20orderOf_eq_prime%0A%20%20%C2%B7%20decide%0A%20%20%C2%B7%20decide" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20Lagrange%27s%20theorem%2C%20fully%20generic%3A%20a%20subgroup%27s%20size%20divides%20the%0A--%20ambient%20group%27s%20size.%0Aexample%20%28s%20%3A%20Subgroup%20%28Equiv.Perm%20%28Fin%203%29%29%29%20%3A%0A%20%20%20%20Nat.card%20s%20%E2%88%A3%20Nat.card%20%28Equiv.Perm%20%28Fin%203%29%29%20%3A%3D%0A%20%20Subgroup.card_subgroup_dvd_card%20s%0A%0A--%20Concretely%3A%20%7CS_3%7C%20%3D%203%21%20%3D%206...%0Aexample%20%3A%20Nat.card%20%28Equiv.Perm%20%28Fin%203%29%29%20%3D%206%20%3A%3D%20by%0A%20%20rw%20%5BNat.card_eq_fintype_card%2C%20Fintype.card_perm%2C%20Fintype.card_fin%5D%0A%20%20rfl%0A%0A--%20...and%20the%20cyclic%20subgroup%20generated%20by%20the%203-cycle%20finRotate%203%20has%0A--%20order%203%2C%20since%20%28finRotate%203%29%5E3%20%3D%201%20and%20finRotate%203%20%E2%89%A0%201%20with%203%20prime.%0Aexample%20%3A%20Nat.card%20%28Subgroup.zpowers%20%28finRotate%203%29%29%20%3D%203%20%3A%3D%20by%0A%20%20rw%20%5BNat.card_zpowers%5D%0A%20%20apply%20orderOf_eq_prime%0A%20%20%C2%B7%20decide%0A%20%20%C2%B7%20decide" title="Lean playground" loading="lazy" style="width:100%;height:402px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Thus $3 \mid 6$ — not asserted, but *derived*, by instantiating a theorem
Mathlib already proved once, generically, for every group. Neither of
these two facts required a single new definition: both reuse objects
this book already built, and both are facts this book's own from-scratch
`Ring`/`Group` genuinely could not have stated, since it never built
the surrounding machinery (invertibility, subgroups) that Mathlib
already has. This is the concrete shape of "moving to Mathlib": not
different mathematics, merely a much larger stock of already-proved
consequences to draw on.

---

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)
