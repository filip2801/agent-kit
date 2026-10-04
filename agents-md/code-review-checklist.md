## Code review checklist

Before calling work done, and when reviewing a diff:

- **Security and thread-safety.** Validate and authorize at the boundary; never trust client
  input. Watch shared mutable state — singletons, caches, static fields: confirm it is actually
  safe under concurrency, and where it is only safe under a condition, write that condition down
  next to it (for example, that there is a single instance).
- **One job per unit.** A class or method doing two things gets split. Depend on an abstraction
  where the dependency is genuinely likely to vary, not reflexively. Keep interfaces narrow enough
  that no implementer has to stub out methods it does not need.
- **Prefer the simplest thing that works.** No speculative abstraction, no premature
  generalization, no configuration nobody asked for. Flexibility costs now and pays only if the
  guess was right.
- **Where a seam is needed anyway, shape it so behaviour arrives as an addition, not a rewire.**
  This is a tie-breaker between designs you were already choosing between — never a reason to
  introduce a seam that is not needed yet.
- **Let the framework do it.** Before hand-rolling a bean, filter, decoder or config class, check
  whether a starter, plugin or a few properties already cover it — usually better, with lazy
  initialization and sensible defaults. Write custom wiring only where the framework genuinely
  cannot express what is needed.
