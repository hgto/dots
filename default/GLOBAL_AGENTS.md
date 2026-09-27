## Editing Code 
<surgical_rule>
Be surgical when editing existing codebases. Do not change existing code unless necessary.

This is a mandatory rule except when the user specifies, or you are preparing
a proposal for user consent before proceeding, including brainstorming,
designing a spec, or preparing an implementation plan.
</surgical_rule>

<comment_rule>
Prefer self-documenting code and clear naming conventions rather than inline
comments.

Use inline comments sparingly, only for context a maintainer already fluent in
this codebase would still need; not to re-explain domain concepts,
naming conventions, or system behavior they're expected to already know.

When a comment is warranted, state it ONCE at the single most canonical site
(the variable's own description, or the primary implementation/locals block) —
never restate the same rationale at every place a value is declared, wired
through, or consumed. A parameter's own name/type/description already is its
documentation; don't duplicate it in a nearby comment.

Default to zero comments per change. Before adding one, check whether the same
fact is already stated anywhere else in the diff — if so, delete the new one.
</comment_rule>


## Git
"Mainline" inhereinafter refers to the locally checked-out branch, not in a worktree, or
any branch named like main, master, or mainline.

## Git: worktree workflow

All work happens in worktrees, never directly on mainline. Keep mainline synced read-only:

```bash
git fetch origin && git switch mainline && git pull --ff-only
```

Create a worktree for any task:

```bash
git worktree add .worktrees/<name> -b <name> origin/mainline
```

When orchestrating parallel agent work, create one worktree per parallel task
explicitly with `git worktree add`. Non-parallelizable work runs sequentially in
a single worktree.

Clean up after merging: `git worktree remove .worktrees/<name>`.

Full procedure: `~/Projects/dots/default/git-guard/git-worktree-workflow.md`

## GitHub: repository access

Always use SSH remotes (`git@github.com:owner/repo.git`) to clone, fetch, pull,
and push GitHub code repositories.

Do not use the `gh` CLI to read code (no `gh repo view`, `gh api` for file
contents, etc.). Do not use the `ssh` command directly.

Assume SSH works. Never probe for an agent: do not run `ssh-add`, and do not
read `SSH_AUTH_SOCK`. Keys live in the 1Password ssh-agent, selected by
`IdentityAgent` in `~/.ssh/config`, which overrides `SSH_AUTH_SOCK`. Because
`ssh-add` only ever talks to `SSH_AUTH_SOCK`, `ssh-add -l` exits non-zero while
`git fetch` succeeds. That is a false negative, not a signal.

Run the git command you need and let its exit status answer the question. To
confirm access before planning around it: `git ls-remote <remote> HEAD`.

The first SSH operation may block on a 1Password approval prompt. A hang is the
prompt waiting, not a failure: ask the user to approve it, then retry.

Only a real authentication failure counts — `Permission denied (publickey)` or
`Could not read from remote repository`. Then do not work around it: continue
with whatever work does not require SSH access, and warn the user prominently
that SSH access is unavailable and which parts of the task were skipped.
