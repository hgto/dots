---
name: worktrees
description: Create, synchronize, inspect, or clean up Git worktrees for a development task. Use for branch isolation and worktree management.
---

Read the repository's agent instructions and inspect `git status --short`,
`git worktree list`, the current branch, and configured remotes before changing
anything. The mainline checkout is read-only for task edits, regardless of its
branch name. Preserve existing work and never reset or stash it automatically.

Determine the base from repository instructions, the remote default branch, or
the main checkout's configured upstream. Do not assume a branch named `main`.
Use SSH remotes for GitHub; run the Git operation needed without probing the
SSH agent or invoking `ssh` directly.

Fetch the intended remote. Fast-forward a clean mainline checkout with
`git pull --ff-only`; if it is dirty, preserve it and branch from the fetched
remote base. Stop on divergence rather than resetting it.

Create the task checkout explicitly:

```bash
git worktree add .worktrees/<task> -b <task> <remote>/<base>
```

Do all task edits there. Do not run `setup-worktree.sh` in the_product workspace.
When delegation is authorized, create a separate worktree for each independent
editing task and tell each agent its absolute working directory. Run dependent
work sequentially in one worktree.

Push, publish, and merge only within the user's authorization. After a merge,
remove the clean worktree with `git worktree remove` and delete the merged
branch with `git branch -d`. Never force removal of uncommitted work.
