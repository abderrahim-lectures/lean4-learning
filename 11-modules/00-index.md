# Chapter 11: Modules over a ring

[← Ch. 10: Ring Theorems](../10-ring-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 12: Path Algebras →](../12-path-algebras/00-index.md)

---

## Learning objectives

- Translate the module axioms into a Lean `structure` parameterized by an explicit ring.
- Build a `Submodule` as a membership predicate with closure proofs.
- Define a `LinearMap` and check its two defining properties.
- Assemble a direct sum of modules field by field via `congr 1`.

## The story of this chapter

Each section below answers the question the previous one forces.

1. **A `Ring`, from Chapter 9, already generalizes a field by dropping
   division. What happens to a *vector space* under the same move?**
   ([Section 1](01-definition.md)) The vector-space axioms make sense
   verbatim over an arbitrary ring, not just a field. An abelian group
   $M$ equipped with a scalar action $R \times M \to M$ satisfying the
   same four distributivity/associativity/unit laws. This is the
   **module**, and it is the subject of the whole chapter.
2. **Stated on paper, this definition is not yet something Lean can check
   proofs against. How is it written down as a `structure`?**
   ([Section 2](02-translating-into-lean.md)) Exactly the same "data,
   then axioms" translation already used for `Group` and `Ring`,
   with one difference, the ring $R$ a module is defined *over* enters as
   an explicit argument to `Module`, not as bundled data, because a module
   is always a module over some already-fixed ring.
3. **Is this definition merely formally sound, or does something already
   familiar satisfy it?** ([Section 3](03-z-module-example.md)) Every
   abelian group is a $\mathbb{Z}$-module, and moreover the scalar action is
   *forced*, not chosen. The initiality of $\mathbb{Z}$ itself as a ring pins down
   $n \cdot m$ uniquely by induction. "Abelian group" and
   "$\mathbb{Z}$-module" turn out to be the same notion, seen from two
   directions.
4. **Given one module, which of its subsets inherit the same
   structure?** ([Section 4](04-submodules.md)) A **submodule**, the
   module analogue of a subgroup, a subset closed under addition,
   containing $0$, and closed under the scalar action, encoded in Lean the
   same way every "subobject of $X$" has been encoded since Chapter 3: a
   membership predicate bundled with closure proofs, rather than a
   `Set X` wrapped separately.
5. **Given a module, what are the structure-preserving maps *between* two
   of them?** ([Section 5](05-linear-maps.md)) A **linear map**, additive,
   and compatible with the scalar action on both sides. This supplies the
   morphisms of the category $R\text{-}\mathbf{Mod}$, completing the
   objects-and-morphisms picture Chapter 1 first set up for `Type` itself.
6. **With objects and morphisms both available, how are new modules built
   out of old ones?** ([Section 6](06-direct-sums.md)) The **direct
   sum** $M \oplus N$, componentwise structure on the product $M \times N$,
   verified field by field with `congr 1`, and equipped with projection
   maps that are themselves instances of the `LinearMap` of Section 5,
   nothing new is needed to state them, only what is already on the table.

By the last section, "module" has gone from a paper generalization of
"vector space" to a working Lean `structure`, complete with a canonical
example, its subobjects, its morphisms, and one way to build new modules
from old. Chapter 12 puts this machinery to its intended use, a
representation of a quiver is exactly a module over its path algebra,
which is why this chapter comes immediately before it.

## Sections

1. [The mathematical definition](01-definition.md)
2. [Translating into Lean](02-translating-into-lean.md)
3. [Example: every abelian group is a $\mathbb{Z}$-module](03-z-module-example.md)
4. [Submodules](04-submodules.md)
5. [Linear maps](05-linear-maps.md)
6. [Direct sums of modules](06-direct-sums.md)
7. [Exercises](07-exercises.md)

---

[← Ch. 10: Ring Theorems](../10-ring-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 12: Path Algebras →](../12-path-algebras/00-index.md)
