# Neovim configuration

This is the Neovim 0.12 configuration. Classic Vim continues to use
`default/vimdir`.

Plugins are managed by native `vim.pack`. Run `:PackUpdate` to review updates
and restart Neovim. Mason installs the configured language servers, tools, and
the Tree-sitter CLI on first launch. After that completes, run
`:TSInstallConfigured`; run `:TSUpdate` after Tree-sitter plugin updates.

## GitHub reviews and worktrees

`gh auth status` must succeed for Octo and PR discovery.

- `<leader>opl`: list pull requests in Octo.
- `<leader>opr`: start a review for the open PR.
- `<leader>opR`: resume a review.
- `<leader>opc`: show checks.
- `<leader>ops`: submit the pending review.
- `<leader>gP` or `:PRWorktree`: select a PR, create `.worktrees/pr-N`, and
  open it in another Neovim process.
- `<leader>gw` or `:Worktrees`: open an existing worktree in another Neovim
  process.

Launching a separate terminal Neovim process requires tmux. Outside tmux, the
command reports the worktree path to open manually rather than starting an
unusable detached process.

Inside an Octo review, use the buffer-local mappings shown by `:Octo help`.
Notably, `\\ca` adds a review comment, `\\sa` adds a suggestion, and `]t`/`[t`
navigate review threads.

Each worktree intentionally gets a separate Neovim process. Start OpenCode in
an adjacent terminal or tmux pane from that same worktree so editor, LSP, Git,
and agent context remain isolated.

## Safe mode

`SAFEVI=1 nvim` loads the core options, mappings, commands, and autocommands
without downloading or loading plugins.

Run the smoke tests from the repository root with:

```sh
XDG_CONFIG_HOME="$PWD/default" nvim --headless \
  '+luafile default/nvim/tests/smoke.lua' +qa
```
