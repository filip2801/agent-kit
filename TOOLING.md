# Tooling

Libraries, CLIs and plugins worth setting up in a new project, with the setup that actually turns
each one on. Versions are what the recommendation was last checked against, not pins.

## OpenSpec — spec-driven changes

`@fission-ai/openspec` (checked at 1.14.0) keeps a project's capabilities in `openspec/specs/` and
every in-flight change in `openspec/changes/<name>/` as a proposal, a design, spec deltas and a
task list.

```bash
npm install -g @fission-ai/openspec
openspec init        # in the repo root
openspec update      # after a CLI upgrade, to refresh the generated files
```

`init` generates per-agent entry points — `.claude/skills/openspec-*`, `.claude/commands/opsx/*`,
`.codex/skills/openspec-*` — and `openspec update` overwrites them, so never hand-edit a file
carrying `generatedBy` in its frontmatter. Workflow conventions belong in `AGENTS.md` instead.

`openspec/config.yaml` is the one file you do own. It holds a `context` block shown to the agent
whenever it shapes an artifact, plus optional per-artifact `rules`. Keep the context lean: it is
orientation for writing specs and tasks, not a style guide. Point at `AGENTS.md` for the full
conventions rather than restating them, or the two drift.

The flow is propose → review → apply → archive. These are the commands worth knowing, all
machine-readable with `--json`:

```bash
openspec list                                           # active changes
openspec status --change "<name>"                       # which artifacts exist and are complete
openspec validate "<name>" --type change --strict       # structural check only
openspec show "<name>"
openspec archive "<name>"                               # folds deltas into openspec/specs/
```

## Superpowers — process skills for Claude Code

A plugin of process skills: brainstorming, writing and executing plans, systematic debugging,
verification before completion, requesting and receiving code review, git worktrees, parallel
agents. From the official marketplace, so `/plugin` in Claude Code finds it; MIT, by Jesse
Vincent, at <https://github.com/obra/superpowers> (checked at 6.4.1).

It writes its artifacts into the repo — `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` and
`docs/superpowers/plans/` — and expects them committed.

**It overlaps with OpenSpec.** Both own "design and plan before writing code", and both leave a
document trail. Pick one as the system of record per project: either let brainstorming hand off
into an OpenSpec proposal and keep the artifacts under `openspec/`, or keep the superpowers spec
and plan files and skip OpenSpec. Running both trails for the same change produces two documents
that disagree, and nobody can tell which one was implemented.

## context7 MCP — current library docs

Pulls up-to-date documentation for a library or framework at the version in use, instead of
whatever the model remembers.

```json
// .mcp.json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {}
    }
  }
}
```

A repo-level `.mcp.json` is only an offer; Claude Code still asks before trusting it. Accept it
once, or pre-approve it:

```json
// .claude/settings.local.json
{ "enabledMcpjsonServers": ["context7"] }
```

Codex registers MCP servers through its own global config (`codex mcp ...`), not through a file in
the repo — so a project using both agents needs the server added in both places.

## Playwright MCP — driving a real browser

For verifying a flow end to end as a user, and for reading the console when something fails
silently. It drops console logs and screenshots into `.playwright-mcp/`, which belongs in
`.gitignore`.

## Dependency docs beat training data

Some libraries ship their own documentation inside the installed package, and a major version can
invalidate most of what a model knows about them. Where that is true, say so in the project's
instructions and name the path, for example:

> This version has breaking changes — APIs, conventions and file structure may all differ from
> your training data. Read the relevant guide in `node_modules/<pkg>/dist/docs/` before writing
> any code. Heed deprecation notices.

Pair it with context7 for libraries that do not ship docs locally.

## Permission allowlists

Approving the same safe command every session is pure friction. Allowlist the repetitive ones:

```json
// .claude/settings.local.json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(./gradlew test:*)",
      "Bash(npm run test:*)"
    ]
  }
}
```

`settings.local.json` is personal and untracked; `settings.json` is committed and shared, and is
also where a project enables a plugin for everyone:

```json
// .claude/settings.json
{ "enabledPlugins": { "frontend-design@claude-plugins-official": true } }
```

Keep destructive commands off both lists — a wildcard on `git push` or a migration command is the
one that eventually surprises you.
