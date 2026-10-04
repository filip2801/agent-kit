## Instruction files

`AGENTS.md` is the single source of truth for this project's conventions. `CLAUDE.md` is one line
that imports it:

```
@AGENTS.md
```

- **Write a convention once, in `AGENTS.md`.** Never copy prose between the two files. Two copies
  drift, and a stale copy is indistinguishable from a current one until it misleads someone — the
  failure is silent and arrives months later.
- **A subdirectory with conventions of its own gets its own pair** — `<dir>/AGENTS.md` holding the
  rules and `<dir>/CLAUDE.md` importing it — covering only what differs there, never restating the
  root.
- **Keep it short enough to stay true.** Every line is read on every session and every line is
  something to maintain. Prefer pointing at the file that holds a detail over summarising it here,
  because the summary is what goes stale.
