---
name: new-session-prompt
description: Use when a session is ending or context is running out and the work will continue in a fresh session. Also use when asked for a handoff, a continuation prompt, or "how do I start next time". Args: optionally what the next session should do, e.g. "implement the change" or "finish the cleanup".
---

Produce a prompt the user can paste to start the next session.

**Input**: optionally what the next session should do. With no args, work it out from the state.

**Steps**

1. **Gather state** for every repo this session touched, not only the one the session runs in:

   ```bash
   git -C <repo> branch --show-current
   git -C <repo> status --short
   git -C <repo> rev-parse --verify --quiet origin/<branch> >/dev/null \
     && git -C <repo> rev-list --count origin/<branch>..HEAD \
     || echo "branch is not on the remote"
   ```

   Check the remote ref by name. `@{u}` and `origin/HEAD` both fail silently on a branch with no
   upstream, and report zero unpushed commits for a branch that was never pushed at all.

   Also check whatever tracks the work (an OpenSpec change, a ticket, a plan file, a todo list),
   any background task still running, and any check known to be failing.

2. **Decide the task.** Use the args, or what the user has already said this session. Otherwise
   infer the single next step from the state.

3. **Ask when it is not obvious**, with one question whose options come from the real state:
   - more than one plausible next step exists;
   - work is pending in more than one repo;
   - something is half-done and it is unclear whether to continue or restart it;
   - the args are too vague to act on.

   Don't guess, and don't ask when the state gives one obvious answer.

4. **Emit the output below.** Nothing before it, nothing after it.

**Output**

Exactly these parts, in this order:

- **Blockers**: one line each, anything that would stop the next session cold — uncommitted or
  unpushed work, a failing check, a stale input, a decision the user still owes. Omit the section
  when there are none.
- **Next session**: one to three sentences on what it will do. Name the directory to start in
  whenever it is not the one the user is in now.
- **Start**: the launch command on its own line, naming the session when the agent supports it
  (`claude --name <name>`), so the session can be found again by name. Omit it when the agent
  cannot name a session.
- **Prompt**: a single fenced block, ready to paste.

**The session name**

The ticket key, if the work has one, plus a 2–4 word slug of the work, lowercase and hyphenated:
`PROJ-123-retry-failed-exports`. A continuation keeps the current session's name and appends the
phase it starts, so it sorts next to its predecessor: `PROJ-123-retry-failed-exports-apply`. With
an OpenSpec change, the change name is the slug. With no ticket, the slug alone.

**What goes in the prompt**

The block holds only what gets pasted into a running session: no `cd`, no launch command, no shell.

- Any slash command or skill to run, on its own line.
- One task, written as an instruction.
- Paths to the committed files that carry the context: findings, a plan, a spec.
- The ticket key, when the work has one and you know it; the agreed scope often lives there
  rather than in a file. Don't invent one, and don't go looking if none came up.
- Decisions already settled that the next session must not reopen.

Point at files rather than repeating them. The repo is the context; the prompt is the pointer.

**Common mistakes**

| Mistake | Instead |
|---|---|
| Summarising findings the repo already records | Give the path |
| Several tasks in one prompt | One task; the next session re-runs this skill |
| Shell commands in the block (`cd`, `claude`) | The block is pasted into a session, not a terminal |
| Silence about a sibling repo's directory | Name it in **Next session**: a wrong cwd derails everything |
| Writing a status report | Write an instruction |

**Example**

**Start**: `claude --name PROJ-123-retry-failed-exports-apply`

```
/opsx:apply retry-failed-exports

Start with the backend half: add the retry queue and the backoff policy, then wire the scheduler.
Scope and the rollout order are in PROJ-123. Keep the existing export table; no schema changes.
```
