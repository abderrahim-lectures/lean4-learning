-- Mathlib-equivalent modules (see each book chapter's "Mathlib equivalent"
-- boxes, Chapters 6-11). Kept as a separate importing root from
-- `LeanProject.lean` because the from-scratch chapters there define their
-- own root-level `Group`/`CommGroup`/`Ring`/`Module`/`Submodule`/
-- `LinearMap`/`Quiver` — names Mathlib also declares at the root namespace
-- — so one file cannot import both chains without a name clash.
import LeanProject.Ch07GroupsMathlib
import LeanProject.Ch08GroupTheoremsMathlib
import LeanProject.Ch09RingsMathlib
import LeanProject.Ch10RingTheoremsMathlib
import LeanProject.Ch11ModulesMathlib
import LeanProject.Ch12PathAlgebrasMathlib
import LeanProject.Ch14CapstoneMathlib
