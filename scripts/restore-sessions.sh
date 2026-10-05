#!/bin/zsh
# Reopen the sessions saved by save-sessions.sh as tabs of one new Ghostty
# window, each running `claude --resume <id>` in its original directory.
# Usage: restore-sessions.sh [file]   (default: the latest snapshot)
set -euo pipefail

file=${1:-~/.claude-saved-sessions/latest.tsv}
[[ -s $file ]] || { echo "Nothing to restore in $file"; exit 1; }

script='on run argv
  tell application "Ghostty"
    activate
    set w to missing value
    repeat with i from 1 to (count of argv) by 2
      set cfg to new surface configuration
      set initial working directory of cfg to item i of argv
      set initial input of cfg to "claude --resume " & item (i + 1) of argv & linefeed
      if w is missing value then
        set w to new window with configuration cfg
      else
        new tab in w with configuration cfg
      end if
    end repeat
  end tell
end run'

args=()
while IFS=$'\t' read -r id cwd state name; do
  if [[ ! -d $cwd ]]; then
    echo "Skipping $name ($id): $cwd no longer exists"
    continue
  fi
  echo "Resuming $name ($id) in $cwd"
  args+=($cwd $id)
done < $file

osascript -e $script -- $args
