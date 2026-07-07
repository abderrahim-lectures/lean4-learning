/-
Code from Chapter 11 (Quivers and path algebras) of the book.
-/

structure Quiver (V : Type) (A : Type) where
  source : A → V
  target : A → V

inductive ExampleArrow where
  | alpha : ExampleArrow   -- 0 → 1
  | beta : ExampleArrow     -- 1 → 2

def exampleQuiver : Quiver (Fin 3) ExampleArrow where
  source := fun a => match a with
    | ExampleArrow.alpha => 0
    | ExampleArrow.beta => 1
  target := fun a => match a with
    | ExampleArrow.alpha => 1
    | ExampleArrow.beta => 2

inductive Path {V A : Type} (Q : Quiver V A) : V → V → Type where
  | nil (v : V) : Path Q v v
  | cons {u v w : V} (a : A) (h : Q.source a = v) (h' : Q.target a = w)
      (p : Path Q u v) : Path Q u w

def pathAlpha : Path exampleQuiver 0 1 :=
  Path.cons ExampleArrow.alpha rfl rfl (Path.nil 0)

def pathBetaAlpha : Path exampleQuiver 0 2 :=
  Path.cons ExampleArrow.beta rfl rfl pathAlpha

def Path.append {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) : Path Q u w :=
  match q with
  | Path.nil _ => p
  | Path.cons a h h' q' => Path.cons a h h' (Path.append p q')

-- Chapter 11 exercises
inductive CyclicArrow where
  | alpha : CyclicArrow   -- 0 → 1
  | beta : CyclicArrow     -- 1 → 2
  | gamma : CyclicArrow    -- 2 → 0

def cyclicQuiver : Quiver (Fin 3) CyclicArrow where
  source := fun a => match a with
    | CyclicArrow.alpha => 0
    | CyclicArrow.beta => 1
    | CyclicArrow.gamma => 2
  target := fun a => match a with
    | CyclicArrow.alpha => 1
    | CyclicArrow.beta => 2
    | CyclicArrow.gamma => 0

def cPathAlpha : Path cyclicQuiver 0 1 :=
  Path.cons CyclicArrow.alpha rfl rfl (Path.nil 0)

def cPathBetaAlpha : Path cyclicQuiver 0 2 :=
  Path.cons CyclicArrow.beta rfl rfl cPathAlpha

def cPathGammaBetaAlpha : Path cyclicQuiver 0 0 :=
  Path.cons CyclicArrow.gamma rfl rfl cPathBetaAlpha

-- NOTE: the book's `| nil v => ...` does not type-check as written — at
-- this point `v` is already fixed by `p`'s own type, so `nil`'s case has
-- no fresh variable left to bind; a real bug found by the compiler.
-- Fixed by dropping the (nonexistent) binder.
theorem append_nil_left {V A : Type} {Q : Quiver V A} {u v : V} (p : Path Q u v) :
    Path.append (Path.nil u) p = p := by
  induction p with
  | nil =>
    rfl
  | cons a h h' q' ih =>
    show Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'
    rw [ih]
