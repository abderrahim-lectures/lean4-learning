import LeanProject.Basic
import LeanProject.Ch01Basics
import LeanProject.Ch01DependentTypes
import LeanProject.Ch02Structures
import LeanProject.Ch03Propositions
import LeanProject.Ch04Tactics
import LeanProject.Ch05RigorCheck
import LeanProject.Ch06Groups
import LeanProject.Ch07GroupTheorems
import LeanProject.Ch08Rings
import LeanProject.Ch09RingTheorems
import LeanProject.Ch10Modules
import LeanProject.Ch11PathAlgebras
import LeanProject.Ch12WorkingEfficiently
import LeanProject.Ch14AppendixSolutions

-- NOTE: the Mathlib-equivalent modules (LeanProjectMathlib.lean) are
-- deliberately *not* imported here. The from-scratch chapters above define
-- their own root-level `Group`/`CommGroup`/`Ring`/`Module`/`Submodule`/
-- `LinearMap`/`Quiver` — names Mathlib also uses at the root namespace —
-- so a single file importing both chains hits genuine name clashes (e.g.
-- `CommGroup.mk` declared twice). Keeping them as separate importing roots
-- (this file vs. `LeanProjectMathlib.lean`) avoids the collision entirely;
-- `lake build` still builds and checks both, per `lakefile.toml`.

-- Coverage note: `LeanProject` (this importing root) now compiles every
-- Lean block from the book's Chapters 1-14. Chapter 13 (Next steps) and
-- the parts of the Appendix that are prose-only or intentional
-- type-errors contribute no compilable code; `Ch12WorkingEfficiently.lean`
-- and `Ch14AppendixSolutions.lean` cover the last two chapters' blocks
-- that earlier editions of the `lean_project` left out.
