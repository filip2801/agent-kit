# Installing the kit in a project

The kit is a Claude Code marketplace named `agent-kit` holding one plugin, `fk`. A project opts in
to it: nothing is installed at user scope, and no skill files are copied into the project.

## On a new machine

Clone both repos. They need not be siblings — the kit does not have to live anywhere near the
project that uses it:

```bash
git clone git@github-private:filip2801/agent-kit.git
git clone git@github-private:filip2801/<project>.git
```

Then, once per project that should use the kit:

```bash
cd <project>
claude plugin marketplace add <absolute path to agent-kit> --scope local
claude plugin install fk@agent-kit --scope local
```

That writes both entries into the project's `.claude/settings.local.json`:

```json
{
  "extraKnownMarketplaces": {
    "agent-kit": { "source": { "source": "directory", "path": "/path/to/agent-kit" } }
  },
  "enabledPlugins": { "fk@agent-kit": true }
}
```

The skills then load as `fk:spec-review` and `fk:new-session-prompt` — from the *next* session,
since skills are read at startup.

## Why this is redone per machine and per project

`.claude/settings.local.json` is gitignored, and a relative path such as `../agent-kit` is resolved
to an absolute one at the moment the marketplace is added. The declaration is therefore specific to
one machine and cannot be committed and cloned. `--scope project` would write it to the committed
`.claude/settings.json` and bake in a path that exists on one machine only, which is worse than
re-running two commands.

## Day to day

- **Edits to a skill are live.** A directory-sourced plugin loads in place from
  `<agent-kit>/claude`, so a `git pull` or a local edit applies at the next session start, or
  immediately with `/reload-plugins`. Nothing has to be pushed. `claude plugin update` is a no-op
  here: it compares the `version` in `plugin.json` and reports the plugin already current.
- **Check what loaded:** `claude plugin details fk@agent-kit` lists the skills found and their
  token cost; `claude plugin validate <path to agent-kit>` checks the manifests.
- **A newly added plugin** that does not appear: refresh the catalog with
  `claude plugin marketplace update agent-kit`, then install it.
- **More than one Claude install:** plugin state is per config directory (`CLAUDE_CONFIG_DIR`), and
  the two dirs drift. Repeat both commands under each install that should see the kit.
- **Removing it:** `claude plugin marketplace remove agent-kit --scope local`, which uninstalls the
  marketplace's plugins along with it.

## What this does not install

`agents-md/` is not part of the plugin. A project copies the sections it wants into its own
`AGENTS.md`, and diffs its copy against the kit later to see what drifted.
