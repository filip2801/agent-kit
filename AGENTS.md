# agent-kit

Reusable skills, instruction sections and workflows for coding agents (Claude Code, Codex). This
file is about working **on** the kit; the material itself is meant for other projects. The layout
and what goes where are in `README.md`.

## Keep it generic

- Nothing tied to one employer, product or codebase: no company names, hosts, ticket prefixes,
  internal repos or local paths. Examples use made-up names (`PROJ-123`, `retry-failed-exports`).
- A skill or section that only makes sense with a project's internals stays in that project.

## Skills (`skills/`)

- One directory per skill holding a `SKILL.md`, with frontmatter `name` (equal to the directory
  name) and `description`.
- The `description` decides when an agent picks the skill, so it starts with "Use when…" and names
  the situations and phrasings that should trigger it, not what the skill does internally.
- Shared skills must work in every agent. Describe the action ("ask the user", "dispatch a
  subagent if your agent can, otherwise…"), never a tool only one agent has. A skill that cannot
  be written that way is agent-specific, and `README.md` says where it goes.

## Instruction sections (`agents-md/`)

- One topic per file, starting with a `##` heading, so a project can paste it whole into its own
  `AGENTS.md` or `CLAUDE.md`.
- Each file stands alone: no references to other sections, to this repo, or to the README.
- A rule lives in one place. If a skill already carries it, the section only says when to use the
  skill.

## Git

- Single branch, `master`; no pull requests.
- Commit messages say what changed for the kit's user, not which files moved.
