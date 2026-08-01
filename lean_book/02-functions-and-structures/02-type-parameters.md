## Structures with type parameters

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)

---

The previous section built `Point`, a structure with two fixed `Nat`
fields. That works only because `Point` never needed to hold anything
but numbers. A structure that should bundle a value of *any* type — a
pair of two arbitrary things, say — cannot be written once per type
without repeating the same three lines endlessly. What is needed instead
is a structure parameterized by the types themselves, the same
implicit-argument idea from Chapter 1's `identity`, now applied to a
`structure` rather than a `def`.

```lean
structure Pair (α β : Type) where
  fst : α
  snd : β

def p : Pair Nat String := { fst := 1, snd := "one" }

#eval p.fst    -- 1
#eval p.snd     -- "one"
```

This generalizes directly to how we will write, e.g., `structure Group (G : Type)`.

**Mathematical reading.** `Pair α β` is the ordinary binary Cartesian
product, but taken *uniformly*, as a functor of two arguments at once.
Rather than fixing $\alpha$ and $\beta$ once, `structure Pair (α β : Type)
where ...` defines the *whole family* of products $\alpha \times \beta$ at
once, one for every choice of the two type arguments. `Pair Nat String`
is then just this construction evaluated at the pair $(\mathbb{N},
\mathrm{String})$, giving $\mathbb{N} \times \mathrm{String}$. This is the
same "definition parameterized by objects of the category" idea that lets
us later write `Group (G : Type)`: not one group, but the functor sending
a carrier type $G$ to the type of group-structures on $G$.

**Programmer's corner (Python).** Python code like `def identity(x): return
x` or `class Pair: def __init__(self, fst, snd): ...` is also "generic," in
the sense that it does not mention any particular type. But nothing checks
that genericity until the code actually runs. Writing `identity(3) +
"oops"` causes Python to happily run `identity`, hand back `3`, and only
then break on `3 + "oops"` at runtime. Constructing a `Pair` and placing a
`Group (Fin 3)` into its `fst` draws no complaint from Python either.

The closer Python analogue is `typing.TypeVar`: `def identity(x: T) -> T:
return x` documents the same universally quantified type that `identity`
has in Lean. But that documentation is optional and erased at runtime. It
is enforced only if a checker such as `mypy` is separately run, and a
stray `# type: ignore` comment silences it entirely.

Lean's `{α : Type} → α → α` is not documentation. It is *proved*, once,
that `identity` works for every type `α`, and that proof is checked before
`identity` is ever called — not merely approximated by a linter that might
never run.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Type-parameterized structure.** This book's working statement:
  `structure Pair (α β : Type)` does not define one structure. It defines
  one structure *per choice* of `α` and `β`, all at once. Categorically,
  this is a functor of the type parameters, not a single fixed structure.
- **Parametric polymorphism.** Milner's theoretical account of type
  polymorphism ([Milner1978]). Brief: genericity that is *proved* once for
  every type, and checked before the generic code is ever called — unlike
  an optional, erased type annotation. Python's `TypeVar` and Lean's
  `{α : Type} → ...` both implement this idea, to different degrees, as
  the Programmer's corner box below explains.
- Python `typing` module documentation and mypy documentation ([PythonTyping], [MypyDocs]) — for the Python-side comparison used in this section's box.

[PythonTyping]: ../bibliography.md#pythontyping
[MypyDocs]: ../bibliography.md#mypydocs
[Milner1978]: ../bibliography.md#milner1978

---

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)
