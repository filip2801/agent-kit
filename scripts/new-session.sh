#!/usr/bin/env bash
# Open a new Ghostty tab (in the front window) running an interactive `claude` session in this workspace.
#
#   ./scripts/new-session.sh "<prompt>"
#   ./scripts/new-session.sh -f prompt.md
#
# The prompt travels through a temp file, so quotes, backticks and `$` in it reach
# claude verbatim. When the session ends the tab stays open at a shell here.
set -euo pipefail

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "usage: $0 \"<prompt>\" | -f <prompt-file>" >&2
  exit 1
}

prompt_file="$(mktemp "${TMPDIR:-/tmp}/claude-session-prompt.XXXXXX")"

if [[ "${1:-}" == "-f" ]]; then
  [[ $# -eq 2 && -f "$2" ]] || usage
  cp "$2" "$prompt_file"
else
  [[ $# -ge 1 && -n "$*" ]] || usage
  printf '%s' "$*" > "$prompt_file"
fi

# The new shell reads the prompt, deletes the temp file, runs claude, then stays open.
printf -v launcher 'p="$(cat %q)"; rm -f %q; claude "$p"; exec zsh -l' "$prompt_file" "$prompt_file"
# Interactive as well as login: ~/.zshrc is what puts ~/.local/bin (claude) on PATH.
printf -v command 'zsh -lic %q' "$launcher"

# Ghostty spawns the tab itself, so it gets Ghostty's environment rather than this shell's: a launch
# from inside a claude session does not hand that session's markers on to the new one.
osascript - "$WORKSPACE" "$command" <<'EOF' >/dev/null
on run argv
  tell application "Ghostty"
    set cfg to new surface configuration
    set initial working directory of cfg to item 1 of argv
    set command of cfg to item 2 of argv
    if (count of windows) is 0 then
      new window with configuration cfg
    else
      new tab in front window with configuration cfg
    end if
    activate
  end tell
end run
EOF
