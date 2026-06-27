# Git worktree workflow

This file is the shared source of guidance for the worktree-first git workflow. It is referenced from `~/.claude/CLAUDE.md` (Claude Code) and `~/.config/opencode/AGENTS.md` (opencode).

---

## Core rules

- **Never commit on `main` or `master`.** The guard (`block-commit-on-main.sh`) enforces this when enabled. Override with `ALLOW_MAIN_COMMIT=1` only for exceptional cases.
- **`main` is read-only.** Keep it synced with origin, nothing else.
- **All work lives in a worktree**, branched off fresh `main`.

---

## Starting work

```bash
# 1. Sync main
git fetch origin
git switch main
git pull --ff-only          # never reset --hard; if this fails, investigate

# 2. Create a worktree for your work
git worktree add .worktrees/<name> -b <name> origin/main

# 3. Work there
cd .worktrees/<name>
# ... make changes, commit, push as normal ...
```

`.worktrees/` is gitignored globally, so the directory never appears in `git status` on main.

---

## Orchestrating parallel work

### Claude Code (native isolation)

Spawn each independent subagent with `isolation: "worktree"`. The harness creates a fresh `.claude/worktrees/<auto-name>` checkout automatically and removes it if the agent leaves no changes.

```python
Agent(
    description="Implement feature X",
    isolation="worktree",
    prompt="..."
)
```

Non-parallelizable work: omit `isolation` and run agents sequentially in a single worktree.

### opencode (manual isolation)

opencode has no native worktree isolation. Create one explicitly per parallel agent task:

```bash
git worktree add .worktrees/task-a -b task-a origin/main
git worktree add .worktrees/task-b -b task-b origin/main
# run agents pointing at each worktree; merge afterwards
```

---

## Merging and cleanup

```bash
# From main:
git merge --ff-only .worktrees/<name>   # or open a PR

# Remove the worktree once merged:
git worktree remove .worktrees/<name>
git branch -d <name>
```

---

## The guard: `block-commit-on-main.sh`

Located at `~/Projects/dots/default/git-guard/block-commit-on-main.sh`.

The guard is a **PreToolUse hook** registered globally in `~/.claude/settings.json`. It intercepts every Bash tool call and blocks `git commit` when the current branch is `main` or `master`. It is **opt-in per repo** — it does nothing unless the repo has the flag set.

### Enable in a repo

```bash
git config guard.blockMainCommit true
```

This writes to the repo's local `.git/config` — not committed, not shared. To disable:

```bash
git config --unset guard.blockMainCommit
```

### How it works

1. Claude Code fires the hook before running any Bash command.
2. The script reads the command and `cwd` from the hook's JSON input.
3. If `git config guard.blockMainCommit` is not `true` in that repo, it exits 0 (allow) immediately.
4. If it is enabled, it checks whether the command matches a `git commit` pattern.
5. If on `main` or `master`, it exits 2 (block) and prints instructions to use a worktree instead.

### Wiring (Claude Code)

```json
// ~/.claude/settings.json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [{ "type": "command",
                  "command": "$HOME/Projects/dots/default/git-guard/block-commit-on-main.sh" }]
    }
  ]
}
```

---

## Break-glass

If you genuinely need to commit on main (rare — e.g. initial commit in a new repo):

```bash
ALLOW_MAIN_COMMIT=1 git commit -m "initial commit"
```

This bypasses the hook for that single invocation only.
