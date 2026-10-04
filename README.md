# agent-kit

Personal skills, instructions and workflows for coding agents (Claude Code, Codex), kept apart from any
single project so they can be reused in the next one. Nothing here is specific to a company or a
codebase: project knowledge (deployments, ticket conventions, internal APIs) stays in that project's
own repo.

## Layout

```
agent-kit/
  AGENTS.md                  # working rules for the kit itself, not material to reuse
  INSTALL.md                 # how a project opts into the kit, incl. on a new machine
  TOOLING.md                 # libraries, CLIs and plugins worth setting up, with their setup
  .claude-plugin/
    marketplace.json         # marketplace "agent-kit", listing the plugins below
  skills/                    # shared: plain SKILL.md skills both agents can load
    new-session-prompt/      # handoff prompt for continuing work in a fresh session
      SKILL.md
    spec-review/             # review an OpenSpec change before implementing it
      SKILL.md
  agents-md/                 # shared: AGENTS.md / CLAUDE.md sections, one file per section
    instruction-files.md     # AGENTS.md is the source of truth, CLAUDE.md imports it
    workflow.md              # vertical slices, checks before done, a commit per task
    code-style.md
    code-comments.md
    code-review-checklist.md
    tests.md                 # naming, given/when/then, both levels, what not to test
    tests-spring.md          # @SpringBootTest over @DataJpaTest, repository-level queries
    database.md              # migrations only, who owns enum values
    openspec.md              # review after propose, generated files, committing artifacts
  claude/                    # Claude Code only
    .claude-plugin/
      plugin.json            # plugin "fk" -> skills load as fk:<skill>
    skills/                  # symlinks into ../../skills for the shared ones
    commands/
    workflows/               # Workflow tool scripts
    agents/
    hooks/
  codex/                     # Codex only (not populated yet)
    prompts/
```

## What goes where

- **`skills/`** holds a skill only if it works in both agents. A skill that cannot avoid a tool
  only one agent has (`AskUserQuestion`, `Agent`, the Workflow tool) goes under `claude/` or
  `codex/` instead; how to write one so it stays portable is in `AGENTS.md`.
- **`agents-md/`** holds the project instructions worth repeating across projects, one topic per
  file. A new project takes the sections it wants by copying files into its own `AGENTS.md` or
  `CLAUDE.md`. One file per section means a section can be copied whole, and diffed against a project's
  copy later to see what drifted.
- **`TOOLING.md`** is for the human setting a project up, not for the agent: what to install, and
  the snippet that actually enables it. A rule the agent must follow goes in `agents-md/` instead.
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
