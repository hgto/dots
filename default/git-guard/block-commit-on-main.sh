#!/usr/bin/env bash
# block-commit-on-main.sh
# Deny `git commit` in the primary checkout (mainline).
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

git_dir="$(git -C "${cwd:-.}" rev-parse --absolute-git-dir 2>/dev/null || true)"
common_dir="$(git -C "${cwd:-.}" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"

[ -n "$git_dir" ] && [ "$git_dir" = "$common_dir" ] || exit 0

printf 'Blocked: commits in the mainline checkout are not allowed.\n' >&2
printf 'Create a feature branch in a worktree:\n' >&2
printf '  git worktree add .worktrees/<name> -b <name> HEAD\n' >&2
printf 'Then work there. Or set ALLOW_MAIN_COMMIT=1 to override.\n' >&2
exit 2
