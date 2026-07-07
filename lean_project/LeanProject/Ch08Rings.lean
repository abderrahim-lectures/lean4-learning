/-
Code from Chapter 8 (Rings) of the book.

The book's `apply Mat2.ext <;> ring` proofs used two things not actually
available: `Mat2.ext` (core Lean 4 does not auto-generate a field-wise
extensionality lemma for a plain `structure` — that's a Mathlib `@[ext]`
convenience) and `ring` (a Mathlib-only decision procedure; this book
never imports Mathlib). Both are supplied by hand below: `Mat2.ext` via
the `mk.injEq` lemma core Lean *does* generate, and each polynomial
identity via an explicit `Int`-algebra rewrite chain, reusing one small
helper lemma (`add4_reorder`) instead of one bespoke chain per proof.
-/
import LeanProject.Ch06Groups

structure CommGroup (G : Type) extends Group G where
  comm : ∀ a b : G, op a b = op b a

structure Ring (R : Type) where
  addGrp : CommGroup R
  mul : R → R → R
  one : R
  mul_assoc : ∀ a b c : R, mul (mul a b) c = mul a (mul b c)
  one_mul : ∀ a : R, mul one a = a
  mul_one : ∀ a : R, mul a one = a
  left_distrib : ∀ a b c : R, mul a (addGrp.op b c) = addGrp.op (mul a b) (mul a c)
  right_distrib : ∀ a b c : R, mul (addGrp.op a b) c = addGrp.op (mul a c) (mul b c)

def intCommGroup : CommGroup Int where
  toGroup := intGroup
  comm := by
    intro a b
    exact Int.add_comm a b

def intRing : Ring Int where
  addGrp := intCommGroup
  mul := fun a b => a * b
  one := 1
  mul_assoc := by
    intro a b c
    exact Int.mul_assoc a b c
  one_mul := by
    intro a
    exact Int.one_mul a
  mul_one := by
    intro a
    exact Int.mul_one a
  left_distrib := by
    intro a b c
    exact Int.mul_add a b c
  right_distrib := by
    intro a b c
    exact Int.add_mul a b c

#eval intRing.addGrp.op 3 4     -- 7
#eval intRing.mul 3 4            -- 12
#eval intRing.one                 -- 1
#eval intRing.addGrp.toGroup.inv 5   -- -5

structure Mat2 where
  a11 : Int
  a12 : Int
  a21 : Int
  a22 : Int

-- NOTE: the book's proofs use `apply Mat2.ext`, expecting an
-- auto-generated field-wise extensionality lemma the way Mathlib's `@[ext]`
-- attribute would produce — but core Lean 4 does not auto-generate `.ext`
-- for a plain `structure`. This is a real gap the compiler caught; supplied
-- by hand here (via the `mk.injEq` lemma core Lean *does* generate), so
-- every `apply Mat2.ext <;> ...` call site below works unchanged.
theorem Mat2.ext {X Y : Mat2} (h1 : X.a11 = Y.a11) (h2 : X.a12 = Y.a12)
    (h3 : X.a21 = Y.a21) (h4 : X.a22 = Y.a22) : X = Y := by
  cases X
  cases Y
  rw [Mat2.mk.injEq]
  exact ⟨h1, h2, h3, h4⟩

def Mat2.add (X Y : Mat2) : Mat2 where
  a11 := X.a11 + Y.a11
  a12 := X.a12 + Y.a12
  a21 := X.a21 + Y.a21
  a22 := X.a22 + Y.a22

def Mat2.neg (X : Mat2) : Mat2 where
  a11 := -X.a11
  a12 := -X.a12
  a21 := -X.a21
  a22 := -X.a22

def Mat2.zero : Mat2 := ⟨0, 0, 0, 0⟩

def Mat2.mul (X Y : Mat2) : Mat2 where
  a11 := X.a11 * Y.a11 + X.a12 * Y.a21
  a12 := X.a11 * Y.a12 + X.a12 * Y.a22
  a21 := X.a21 * Y.a11 + X.a22 * Y.a21
  a22 := X.a21 * Y.a12 + X.a22 * Y.a22

def Mat2.one : Mat2 := ⟨1, 0, 0, 1⟩

def X : Mat2 := ⟨1, 1, 0, 1⟩
def Y : Mat2 := ⟨1, 0, 1, 1⟩

#eval Mat2.mul X Y   -- ⟨2, 1, 1, 1⟩
#eval Mat2.mul Y X    -- ⟨1, 1, 1, 2⟩

def mat2Group : Group Mat2 where
  op := Mat2.add
  id := Mat2.zero
  inv := Mat2.neg
  assoc := by
    intro X Y Z
    apply Mat2.ext <;> exact Int.add_assoc _ _ _
  id_left := by
    intro X
    apply Mat2.ext <;> exact Int.zero_add _
  id_right := by
    intro X
    apply Mat2.ext <;> exact Int.add_zero _
  inv_left := by
    intro X
    apply Mat2.ext <;> exact Int.add_left_neg _
  inv_right := by
    intro X
    apply Mat2.ext <;> exact Int.add_right_neg _

def mat2CommGroup : CommGroup Mat2 where
  toGroup := mat2Group
  comm := by
    intro X Y
    apply Mat2.ext <;> exact Int.add_comm _ _

/-
Each Mat2 entry-equation below is a genuine polynomial identity over `Int`
(up to 12 variables for `mul_assoc`, since each side of `(X*Y)*Z`'s entries
expands to a sum of 4 products of 3 entries). We derive each by hand with
`Int.mul_add`/`Int.add_mul`/`Int.mul_assoc`/`Int.add_assoc`/`Int.add_comm`,
matching the book's own "no automation" philosophy rather than reaching
for Mathlib's `ring` (which the book never imports).
-/

-- A reusable shuffle: rearranges (a+b)+(c+d) into (a+c)+(b+d) — exactly
-- what's needed whenever a "product of sums" expands into four cross
-- terms that must be regrouped to match the other side. Derived once by
-- hand (associativity + one commutation of the middle two terms) rather
-- than repeating an equivalent, easy-to-mistype rewrite chain twelve
-- times below. (An earlier, inline version of these rewrite chains
-- reused the *wrong* pattern at several call sites — a mistake the
-- compiler caught; consolidating into one verified helper avoids
-- repeating that class of error.)
theorem add4_reorder (a b c d : Int) : a + b + (c + d) = a + c + (b + d) := by
  rw [Int.add_assoc a b (c + d)]
  rw [show b + (c + d) = c + (b + d) from by
    rw [← Int.add_assoc, Int.add_comm b c, Int.add_assoc]]
  rw [← Int.add_assoc a c (b + d)]

def mat2Ring : Ring Mat2 where
  addGrp := mat2CommGroup
  mul := Mat2.mul
  one := Mat2.one
  mul_assoc := by
    intro X Y Z
    apply Mat2.ext
    · show (X.a11 * Y.a11 + X.a12 * Y.a21) * Z.a11 + (X.a11 * Y.a12 + X.a12 * Y.a22) * Z.a21
          = X.a11 * (Y.a11 * Z.a11 + Y.a12 * Z.a21) + X.a12 * (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a11 * Y.a11 + X.a12 * Y.a21) * Z.a12 + (X.a11 * Y.a12 + X.a12 * Y.a22) * Z.a22
          = X.a11 * (Y.a11 * Z.a12 + Y.a12 * Z.a22) + X.a12 * (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a21 * Y.a11 + X.a22 * Y.a21) * Z.a11 + (X.a21 * Y.a12 + X.a22 * Y.a22) * Z.a21
          = X.a21 * (Y.a11 * Z.a11 + Y.a12 * Z.a21) + X.a22 * (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
    · show (X.a21 * Y.a11 + X.a22 * Y.a21) * Z.a12 + (X.a21 * Y.a12 + X.a22 * Y.a22) * Z.a22
          = X.a21 * (Y.a11 * Z.a12 + Y.a12 * Z.a22) + X.a22 * (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, Int.mul_add, Int.mul_add,
          Int.mul_assoc, Int.mul_assoc, Int.mul_assoc, Int.mul_assoc,
          add4_reorder]
  one_mul := by
    intro X
    apply Mat2.ext
    · show 1 * X.a11 + 0 * X.a21 = X.a11
      rw [Int.one_mul, Int.zero_mul, Int.add_zero]
    · show 1 * X.a12 + 0 * X.a22 = X.a12
      rw [Int.one_mul, Int.zero_mul, Int.add_zero]
    · show 0 * X.a11 + 1 * X.a21 = X.a21
      rw [Int.zero_mul, Int.one_mul, Int.zero_add]
    · show 0 * X.a12 + 1 * X.a22 = X.a22
      rw [Int.zero_mul, Int.one_mul, Int.zero_add]
  mul_one := by
    intro X
    apply Mat2.ext
    · show X.a11 * 1 + X.a12 * 0 = X.a11
      rw [Int.mul_one, Int.mul_zero, Int.add_zero]
    · show X.a11 * 0 + X.a12 * 1 = X.a12
      rw [Int.mul_zero, Int.mul_one, Int.zero_add]
    · show X.a21 * 1 + X.a22 * 0 = X.a21
      rw [Int.mul_one, Int.mul_zero, Int.add_zero]
    · show X.a21 * 0 + X.a22 * 1 = X.a22
      rw [Int.mul_zero, Int.mul_one, Int.zero_add]
  left_distrib := by
    intro X Y Z
    apply Mat2.ext
    · show X.a11 * (Y.a11 + Z.a11) + X.a12 * (Y.a21 + Z.a21)
          = (X.a11 * Y.a11 + X.a12 * Y.a21) + (X.a11 * Z.a11 + X.a12 * Z.a21)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a11 * (Y.a12 + Z.a12) + X.a12 * (Y.a22 + Z.a22)
          = (X.a11 * Y.a12 + X.a12 * Y.a22) + (X.a11 * Z.a12 + X.a12 * Z.a22)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a21 * (Y.a11 + Z.a11) + X.a22 * (Y.a21 + Z.a21)
          = (X.a21 * Y.a11 + X.a22 * Y.a21) + (X.a21 * Z.a11 + X.a22 * Z.a21)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
    · show X.a21 * (Y.a12 + Z.a12) + X.a22 * (Y.a22 + Z.a22)
          = (X.a21 * Y.a12 + X.a22 * Y.a22) + (X.a21 * Z.a12 + X.a22 * Z.a22)
      rw [Int.mul_add, Int.mul_add, add4_reorder]
  right_distrib := by
    intro X Y Z
    apply Mat2.ext
    · show (X.a11 + Y.a11) * Z.a11 + (X.a12 + Y.a12) * Z.a21
          = (X.a11 * Z.a11 + X.a12 * Z.a21) + (Y.a11 * Z.a11 + Y.a12 * Z.a21)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a11 + Y.a11) * Z.a12 + (X.a12 + Y.a12) * Z.a22
          = (X.a11 * Z.a12 + X.a12 * Z.a22) + (Y.a11 * Z.a12 + Y.a12 * Z.a22)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a21 + Y.a21) * Z.a11 + (X.a22 + Y.a22) * Z.a21
          = (X.a21 * Z.a11 + X.a22 * Z.a21) + (Y.a21 * Z.a11 + Y.a22 * Z.a21)
      rw [Int.add_mul, Int.add_mul, add4_reorder]
    · show (X.a21 + Y.a21) * Z.a12 + (X.a22 + Y.a22) * Z.a22
          = (X.a21 * Z.a12 + X.a22 * Z.a22) + (Y.a21 * Z.a12 + Y.a22 * Z.a22)
      rw [Int.add_mul, Int.add_mul, add4_reorder]

-- Chapter 8 exercise 3
theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X := by
  refine ⟨X, Y, fun h => ?_⟩
  rw [Mat2.mk.injEq] at h
  exact absurd h.1 (by decide)
