## Structures with type parameters

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)

---

```lean
structure Pair (α β : Type) where
  fst : α
  snd : β

def p : Pair Nat String := { fst := 1, snd := "one" }

#eval p.fst    -- 1
#eval p.snd     -- "one"
```

This generalizes directly to how we will write, e.g., `structure Group (α : Type)`.

**Mathematical reading.** `Pair α β` is the ordinary binary Cartesian
product **as a bifunctor** $(-) \times (-) : \mathbf{Type} \times
\mathbf{Type} \to \mathbf{Type}$: rather than fixing $\alpha$ and $\beta$
once, `structure Pair (α β : Type) where ...` defines the *whole family* of
products $\alpha \times \beta$ at once, one for every choice of the two
type arguments — `Pair Nat String` is then just this bifunctor evaluated at
the pair $(\mathbb{N}, \mathrm{String})$, giving $\mathbb{N} \times
\mathrm{String}$. This is the same "definition parameterized by objects of
the category" idea that lets us later write `Group (G : Type)` — not one
group, but the functor sending a carrier type $G$ to the type of
group-structures on $G$.

---

[← `structure` basics](01-structure-basics.md) | [Index](00-index.md) | [Next: Extending structures →](03-extending-structures.md)
