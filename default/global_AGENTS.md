# Global opencode rules


## Git
Mainline inhereinafter to the locally checked-out branch, not in a worktree, or
any branch named like main, master, or mainline.

Never run `git push` (or any variant) to a remote branch without approval from the user.

## Git: worktree workflow

All work happens in worktrees, never directly on mainline. Keep mainline synced read-only:

```bash
git fetch origin && git switch mainline && git pull --ff-only
```

Create a worktree for any task:

```bash
git worktree add .worktrees/<name> -b <name> origin/mainline
```

When orchestrating parallel agent work, create one worktree per parallel task explicitly with `git worktree add`. Non-parallelizable work runs sequentially in a single worktree.


Clean up after merging: `git worktree remove .worktrees/<name>`.

Full procedure: `~/Projects/dots/default/git-guard/git-worktree-workflow.md`
