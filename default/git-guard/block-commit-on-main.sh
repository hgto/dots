#!/usr/bin/env bash
# block-commit-on-main.sh
# Deny `git commit` on main/master branches.
# Shared by Claude Code (PreToolUse hook) and opencode (tool.execute.before plugin).
#
# Stdin: JSON with { "tool_input": { "command": "..." }, "cwd": "..." }
# Exit 0: allow  |  Exit 2: block (stderr is shown back to the model)
#
# Break-glass: ALLOW_MAIN_COMMIT=1 git commit ...
#
# Known limitation: `cd /other/repo && git commit` is evaluated against the
# hook's cwd (the session dir), not /other/repo. Acceptable as a guardrail.
set -euo pipefail

[ "${ALLOW_MAIN_COMMIT:-}" = "1" ] && exit 0

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"

# Nothing to check if command is empty.
[ -z "$cmd" ] && exit 0

# Guard is opt-in per repo: `git config guard.blockMainCommit true`
[ "$(git -C "${cwd:-.}" config --get guard.blockMainCommit 2>/dev/null)" = "true" ] || exit 0

# Match `git commit` variants: plain, `git -C <dir> commit`, `commit --amend`, etc.
# Does NOT match `git log --grep=commit`, `git show`, etc.
printf '%s' "$cmd" | grep -Eq \
  '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+|[[:space:]]+-C[[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)' \
  || exit 0

branch="$(git -C "${cwd:-.}" branch --show-current 2>/dev/null || true)"

case "$branch" in
  main|master)
    printf 'Blocked: commits on %q are not allowed.\n' "$branch" >&2
    printf 'Create a worktree on a feature branch:\n' >&2
    printf '  git worktree add .worktrees/<name> -b <name> origin/%s\n' "$branch" >&2
    printf 'Then work there. Or set ALLOW_MAIN_COMMIT=1 to override.\n' >&2
    exit 2
    ;;
esac

exit 0
