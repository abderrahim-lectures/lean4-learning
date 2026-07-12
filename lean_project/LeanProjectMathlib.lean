-- Mathlib-equivalent modules (see each book chapter's "Mathlib equivalent"
-- boxes, Chapters 6-11). Kept as a separate importing root from
-- `LeanProject.lean` because the from-scratch chapters there define their
-- own root-level `Group`/`CommGroup`/`Ring`/`Module`/`Submodule`/
-- `LinearMap`/`Quiver` — names Mathlib also declares at the root namespace
-- — so one file cannot import both chains without a name clash.
import LeanProject.Ch06GroupsMathlib
import LeanProject.Ch07GroupTheoremsMathlib
import LeanProject.Ch08RingsMathlib
import LeanProject.Ch09RingTheoremsMathlib
import LeanProject.Ch10ModulesMathlib
import LeanProject.Ch11PathAlgebrasMathlib
import LeanProject.Ch13CapstoneMathlib
