import LeanProject.Basic
import LeanProject.Ch01Basics
import LeanProject.Ch01DependentTypes
import LeanProject.Ch02TerminologyAndCoC
import LeanProject.Ch03Structures
import LeanProject.Ch04Propositions
import LeanProject.Ch05Tactics
import LeanProject.Ch06RigorCheck
import LeanProject.Ch07Groups
import LeanProject.Ch08GroupTheorems
import LeanProject.Ch09Rings
import LeanProject.Ch10RingTheorems
import LeanProject.Ch11Modules
import LeanProject.Ch12PathAlgebras
import LeanProject.Ch13WorkingEfficiently
import LeanProject.Ch15AppendixSolutions

-- NOTE: the Mathlib-equivalent modules (LeanProjectMathlib.lean) are
-- deliberately *not* imported here. The from-scratch chapters above define
-- their own root-level `Group`/`CommGroup`/`Ring`/`Module`/`Submodule`/
-- `LinearMap`/`Quiver` — names Mathlib also uses at the root namespace —
-- so a single file importing both chains hits genuine name clashes (e.g.
-- `CommGroup.mk` declared twice). Keeping them as separate importing roots
-- (this file vs. `LeanProjectMathlib.lean`) avoids the collision entirely;
-- `lake build` still builds and checks both, per `lakefile.toml`.

-- Coverage note: `LeanProject` (this importing root) now compiles every
-- Lean block from the book's Chapters 1-15. Chapter 14 (Next steps) and
-- the parts of the Appendix that are prose-only or intentional
-- type-errors contribute no compilable code; `Ch13WorkingEfficiently.lean`
-- and `Ch15AppendixSolutions.lean` cover the last two chapters' blocks
-- that earlier editions of the `lean_project` left out.
