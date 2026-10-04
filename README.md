# agent-kit

Personal skills, instructions and workflows for coding agents (Claude Code, Codex), kept apart from any
single project so they can be reused in the next one. Nothing here is specific to a company or a
codebase: project knowledge (deployments, ticket conventions, internal APIs) stays in that project's
own repo.

## Layout

```
agent-kit/
  INSTALL.md                 # how a project opts into the kit, incl. on a new machine
  .claude-plugin/
    marketplace.json         # marketplace "agent-kit", listing the plugins below
  skills/                    # shared: plain SKILL.md skills both agents can load
    new-session-prompt/      # handoff prompt for continuing work in a fresh session
      SKILL.md
    spec-review/             # review an OpenSpec change before implementing it
      SKILL.md
  agents-md/                 # shared: AGENTS.md / CLAUDE.md sections, one file per section
    tests.md
    code-comments.md
    code-style.md
    git-and-prs.md
    diagrams.md
    openspec.md              # review after propose, generated files, committing artifacts
  claude/                    # Claude Code only
    .claude-plugin/
      plugin.json            # plugin "fk" -> skills load as fk:<skill>
    skills/                  # symlinks into ../../skills for the shared ones
    commands/
    workflows/               # Workflow tool scripts
    agents/
    hooks/
  codex/                     # Codex only
    prompts/
```

## What goes where

- **`skills/`** holds a skill only if it works in both agents. It describes what to do ("ask the
  user", "run these in parallel if you can"), never a tool that one agent alone has. A skill that
  needs a Claude-only tool (subagents, `AskUserQuestion`, the Workflow tool) goes under `claude/`.
- **`agents-md/`** holds the project instructions worth repeating across projects, one topic per
  file. A new project takes the sections it wants by copying files into its own `AGENTS.md` or
  `CLAUDE.md`. One file per section means a section can be copied whole, and diffed against a project's
  copy later to see what drifted.
- **`claude/`** is the Claude Code plugin root: commands, workflows, agents and hooks. A plugin
  loads skills from its own `skills/`, so the shared ones reach Claude Code as relative symlinks
  from `claude/skills/` into `skills/`. Both ends stay inside the repo, so a clone keeps working.
  A Claude-only skill lives in `claude/skills/` as a real directory.
- **`codex/`** is the Codex-only counterpart.

## Installing in a project

The kit is a marketplace (`agent-kit`) holding one plugin (`fk`), registered from its path and
installed per project, so nothing lands at user scope:

```bash
cd <project>
claude plugin marketplace add <absolute path to agent-kit> --scope local
claude plugin install fk@agent-kit --scope local
```

Skills then load as `fk:<skill>` from the next session. The wiring lives in the project's gitignored
`.claude/settings.local.json`, so it is re-done per machine and per project — see
[INSTALL.md](INSTALL.md) for the new-machine walkthrough, the one-Claude-install-per-config-dir
caveat, and how edits to a skill reach a running project.

## Not here

- Anything tied to one employer or codebase: stage deployment, Jira ticket creation, internal API
  clients, log search over a company's indices.
- Files a tool generates per project, such as the `openspec-*` skills and `/opsx:*` commands; these
  come from `openspec init` / `openspec update`.
