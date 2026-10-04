## Development workflow

- **Get something working first, then deepen.** Build the simplest end-to-end slice that works on
  the happy path, then layer on validation and edge cases. Prefer a thin working skeleton through
  every layer over one fully-built layer with nothing to call it: the skeleton proves the parts fit
  together, which is where the surprises live.
- **Before a task is done, run the checks that cover it** — the build, the test command, the
  linter — and confirm they pass. Never report work finished on the strength of a check you did
  not run.
- **Commit each task separately**, with a focused message saying what changed for someone using
  the code rather than which files moved.
