#!/bin/zsh
# Snapshot every running interactive Claude Code session (cwd + session id) so
# restore-sessions.sh can reopen them after a reboot. Each running claude
# registers itself in ~/.claude/sessions/<pid>.json.
set -euo pipefail

dir=~/.claude-saved-sessions
mkdir -p $dir
out=$dir/$(date +%Y%m%d-%H%M%S).tsv

for f in ~/.claude/sessions/*.json(N); do
  pid=${${f:t}%.json}
  kill -0 $pid 2>/dev/null || continue
  jq -r 'select(.kind == "interactive") | [.sessionId, .cwd, .status, .name] | @tsv' $f
done > $out

ln -sf $out $dir/latest.tsv

count=$(wc -l < $out | tr -d ' ')
echo "Saved $count session(s) to $out"
echo
column -t -s $'\t' $out

if grep -q $'\tbusy\t' $out; then
  echo
  echo "Some sessions are busy (mid-turn) - let them finish before rebooting, or the turn is cut off."
fi
