## Code comments

- **Comments explain the code as it is — never the edit history.** When changing existing code, do
  not leave comments that justify or narrate the change ("now uses X instead of Y", "simplified
  to…", "no longer needs the custom decoder"). Write every comment as if the code had always
  looked this way: explain the logic or the tricky part only, exactly as you would for freshly
  written code. A reader should not be able to tell the code was ever different — the diff and the
  commit message already record that, and they stay accurate as the code moves on.
- **Doc comments only when they earn their place.** Add one where it genuinely explains
  non-obvious logic, a contract a caller cannot see from the signature, or a thread-safety
  assumption. Do not document self-explanatory getters, constructors or obvious methods: a comment
  that restates its own signature adds a second thing to keep in sync and says nothing.
