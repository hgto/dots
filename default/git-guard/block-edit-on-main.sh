#!/usr/bin/env bash
# block-edit-on-main.sh
# Deny Write/Edit to a file that lives in the primary checkout (mainline).
# Companion to block-commit-on-main.sh: that stops commits on main, this stops
# task-work edits from landing in the main checkout instead of a worktree.
#
# Stdin: JSON with { "tool_input": { "file_path": "..." }, "cwd": "..." }.
# Codex apply_patch calls don't expose a single file_path, so cwd is used.
# Exit 0: allow  |  Exit 2: block (stderr is shown back to the model)
#
# Break-glass: ALLOW_MAIN_EDIT=1
#
# Git worktrees share the main repo's config, so enabling the opt-in once covers
# the main checkout and every worktree; worktrees sit on feature branches and
# pass, only the main checkout (on main/master) is blocked.
set -euo pipefail

[ "${ALLOW_MAIN_EDIT:-}" = "1" ] && exit 0

input="$(cat)"
fp="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"

if [ -n "$fp" ]; then
  # For a new file the path may not exist yet; walk up to the nearest real dir.
  dir="$(dirname "$fp")"
  while [ ! -d "$dir" ] && [ "$dir" != "/" ] && [ "$dir" != "." ]; do
    dir="$(dirname "$dir")"
  done
  target="$fp"
elif [ -n "$cwd" ]; then
  dir="$cwd"
  target="$cwd"
else
  exit 0
fi

# Guard is opt-in per repo: `git config guard.blockMainEdit true`
[ "$(git -C "$dir" config --get guard.blockMainEdit 2>/dev/null)" = "true" ] || exit 0

git_dir="$(git -C "$dir" rev-parse --absolute-git-dir 2>/dev/null || true)"
common_dir="$(git -C "$dir" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"

[ -n "$git_dir" ] && [ "$git_dir" = "$common_dir" ] || exit 0

printf 'Blocked: %q is in the mainline checkout.\n' "$target" >&2
printf 'Task work belongs in a worktree, not the main checkout.\n' >&2
printf 'Edit the file under its worktree path instead (e.g. .worktrees/<name>/ or\n' >&2
printf '.claude/worktrees/agent-*/), or set ALLOW_MAIN_EDIT=1 to override.\n' >&2
exit 2
