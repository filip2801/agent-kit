---
name: spec-review
description: Use when an OpenSpec change (proposal, design, specs, tasks) should be reviewed before it is implemented - right after a propose, after the artifacts were revised, or when asked to "review the spec/change/proposal". Args: optionally the change name.
---

Review an OpenSpec change and report ranked, actionable findings. Review only: never edit the
change's artifacts or the code from this skill.

**Input**: optionally the change name. With none, select it in step 1.

**Steps**

1. **Select the change.**
   - Use the name if one was given, or the change the conversation is about.
   - Otherwise run `openspec list --json`. One active change: take it. Several: ask the user which,
     offering the names found.

   Announce `Reviewing change: <name>`.

2. **Gather the inputs.**
   - `openspec status --change "<name>" --json`: which artifacts exist and are complete. If a
     required one is missing, say which and stop; there is little to review. Suggest finishing the
     propose first.
   - `openspec validate "<name>" --type change --strict --json`: the validator's errors and
     warnings.
   - The artifacts under the change directory: `proposal.md`, `design.md`, `specs/**/spec.md`,
     `tasks.md`.
   - The current spec under `openspec/specs/` for each capability the change modifies, so deltas
     can be compared with what is there now.
   - The project's conventions the change must honour: its `AGENTS.md` / `CLAUDE.md`, and the
     target repo's own one if the change is scoped to a single repo.

3. **Review with fresh eyes.**

   If your agent can dispatch a subagent, hand the review to one: it gets a clean context, free of
   the reasoning that produced the change. Give it everything inline (the validator output, the
   full artifact text, the conventions, the rubric below, the output shape from step 4) and tell it:
   - it is a rigorous staff-level reviewer, and read-only: report, don't edit;
   - it may read and grep the code the change touches, and should spot-check the risky claims
     rather than re-read everything;
   - which things matter most for this change: behaviour-parity claims, cross-repo coordination,
     error handling, caching — whatever applies.

   Use the strongest model available for it. Without subagents, review inline against the same
   rubric, and say that the reviewer is the same session that may have written the change.

4. **Report.** A subagent's output is not shown to the user, so present it yourself:
   - A one-line verdict: *ready to apply*, *needs changes* or *blocking gaps*.
   - Findings grouped by severity (Blocker / Major / Minor / Nit), each naming the artifact and
     section it lives in, with a concrete suggested fix.
   - The validator's errors and warnings, if any, noting that validation is structural only.
   - A short "got right — don't lose" list.

   Then offer to fold the fixes in, or to start implementing.

**Review rubric**

- **Completeness**: the proposal has Why / What Changes / Impact; every capability it names has a
  `specs/<capability>/spec.md`; every requirement has at least one scenario; scenarios use
  WHEN/THEN under the `####` heading OpenSpec requires.
- **Cross-artifact consistency**: every "What Changes" bullet is covered by tasks; every task
  traces to a requirement or a design decision; the design addresses the proposal's risks;
  modified capabilities carry ADDED / MODIFIED / REMOVED delta headers, REMOVED with a Reason and
  a Migration.
- **Correctness and feasibility**: technically sound; honours the project's conventions (build,
  test, branch, PR and code-comment rules); cross-repo coordination and build ordering are
  captured; **behaviour-parity claims hold against the real code** — error paths, null and
  not-found handling, caching, edge cases — not only the happy path.
- **Clarity and testability**: requirements are normative (SHALL / MUST, not should / may); each
  scenario is a concrete, testable case.
- **Gaps and risks**: missing edge cases, rollback, migration, concurrency, error handling,
  security and performance concerns.

**Acting on the findings**

Treat each finding as a question about the design, not an order. When a fix does not drop in
cleanly, don't bend the design until it fits: the friction usually means an assumption underneath
is wrong, or that another implementation would make the finding go away. Say which, name the
alternatives, and let the user decide. A finding that does not hold up against the code gets
pushed back on, with the evidence.

If acting on the findings changes the artifacts materially (a reworked or added requirement, a
changed decision, new or dropped tasks), review again with a fresh reviewer, which sees the
revision rather than the original. Skip that for cosmetic fixes, and say you skipped. Stop at two
reviews per change; if a third still seems needed, say why and ask.
