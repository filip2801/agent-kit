## Tests

- **Name a test after the behaviour it expects**, not the method it calls:
  `should_retry_a_failed_export_three_times()`, or `it("treats a missing timestamp as stale")`. A
  failing test should read as a sentence about what broke, so the report is useful before anyone
  opens the file.
- **Structure each test as given / when / then**, with those words as lowercase comments marking
  the blocks. Omit a block only when it is genuinely empty. Where older tests predate the
  convention, follow it for new and changed tests rather than converting everything at once.
- **Pick one assertion library per language and use it throughout**, instead of mixing a fluent
  library with the runner's built-in assertions in the same suite.
- **Test at both levels.** Focused unit tests, plus integration tests that wire the **real**
  components together with **no mocked services**, so the full flow proves the parts actually fit.
  Reach for a test double only where the real thing cannot be used: a third-party service, the
  clock, a source of randomness.
- **Only unit-test real logic.** Calculations, parsing, formatting and similar pure functions earn
  tests. UI components, rendering and plumbing with no logic of their own do not — those tests
  mostly restate the markup and break on every redesign, which teaches the team to ignore them.
  That comes with a layout obligation: keep the logic in its own module, so there is something to
  test without mounting a component.
- **Keep tests with the code they cover** — colocated where the language allows it, mirroring the
  source layout where it does not.
- **Gate coverage in the build**, so the check runs on every build and a drop fails it. Treat the
  number as a floor that stops silent erosion, never as a target to optimise: a gate says nothing
  about whether the tests assert anything worth asserting.
