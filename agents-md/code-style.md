## Code style

- **Avoid the ternary operator** unless the expression is short and obviously clearer than an
  `if`/`else`. Nested or long ternaries always lose.
- **When both branches of a decision return a value, write `if`/`else`** —
  `if (cond) { return a; } else { return b; }`, not `if (cond) { return a; } return b;`. The
  symmetry shows the two outcomes are equal alternatives rather than a rule and an afterthought.
  This is not an argument against guard clauses: an early return that bails out on invalid input
  or an unmet precondition is a different shape, and there it is the right one.
