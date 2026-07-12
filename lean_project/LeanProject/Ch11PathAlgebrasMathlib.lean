/-
Mathlib-equivalent code for Chapter 11 (Quivers and path algebras).

Mathlib's `Quiver` class encodes arrows differently from the book's
from-scratch `Quiver`: instead of one flat arrow type `A` plus separate
`source`/`target : A → V` functions, Mathlib bakes the endpoints into the
arrow's *type* directly, `Hom : V → V → Sort*` (notation `a ⟶ b`), so an
arrow from `i` to `j` simply *has type* `i ⟶ j` — there is no `source`/
`target` to state or prove separately, and an attempt to compose two
non-matching arrows is rejected by the type checker before you'd even get
to a proof obligation.
-/
import Mathlib

-- Our example quiver: 0 → 1 → 2, an arrow family indexed by its own
-- endpoints. `MyArrow 0 1` has exactly the one constructor `alpha`;
-- `MyArrow i j` for any other `(i, j)` has none at all, so "there is no
-- arrow 2 → 0" is not a side-condition to check, it's simply an empty type.
inductive MyArrow : Fin 3 → Fin 3 → Type
  | alpha : MyArrow 0 1
  | beta : MyArrow 1 2

instance : Quiver (Fin 3) := ⟨MyArrow⟩

-- NOTE: deliberately *not* `open Quiver` here — Mathlib also has a root-level
-- `Path` (a continuous path between two points of a topological space,
-- `Mathlib.Topology.Path`), so an opened `Quiver.Path` would be ambiguous
-- with it. Spelling out `Quiver.Path` throughout avoids the clash.

-- The book's `pathAlpha`/`pathBetaAlpha`, built with Mathlib's own
-- `Quiver.Path.nil`/`Quiver.Path.cons` (`cons` takes the shorter path
-- *first*, then the new arrow — the mirror image of the book's argument
-- order, which takes the arrow first).
def pathAlpha' : Quiver.Path (0 : Fin 3) 1 := Quiver.Path.cons Quiver.Path.nil MyArrow.alpha
def pathBetaAlpha' : Quiver.Path (0 : Fin 3) 2 := Quiver.Path.cons pathAlpha' MyArrow.beta

-- The book's `Path.append`, already in Mathlib as `Quiver.Path.comp` —
-- same recursion (on the *second* path), same "nil does nothing, cons
-- re-attaches its trailing arrow" shape.
def pathBetaOnly' : Quiver.Path (1 : Fin 3) 2 := Quiver.Path.cons Quiver.Path.nil MyArrow.beta
def pathBetaAlphaViaComp' : Quiver.Path (0 : Fin 3) 2 := Quiver.Path.comp pathAlpha' pathBetaOnly'

-- Same "two different constructions of the same path agree definitionally"
-- check as the book's closing `rfl`.
example : pathBetaAlphaViaComp' = pathBetaAlpha' := rfl
