# Neovim configuration

This is the standalone Neovim configuration for this dots repository. It
targets Neovim 0.12 or newer and is intentionally separate from the classic Vim
configuration in `default/vimdir`.

The configuration is designed around three workflows:

1. Preserve the useful muscle memory from the long-lived Vim configuration.
2. Review GitHub pull requests without leaving Neovim for routine review work.
3. Work in many Git worktrees concurrently without sharing editor, LSP, Git, or
   agent state between tasks.

## Design choices

### Neovim and Vim are separate

Classic Vim remains the portable and remote-host fallback. Neovim uses native
Lua APIs and does not carry Coc, ALE, vim-plug, or compatibility branches for
older Vim versions.

`MANIFEST` deploys:

- `default/nvim/*` to `~/.config/nvim/` for Neovim.
- `default/vimdir/*` to `~/.vim/` for classic Vim.

### Small native configuration, not a distribution

The configuration uses purpose-oriented modules under `lua/dots/`. There is no
framework layered on top of Neovim and no dependency on LazyVim, Kickstart, or
another distribution.

Configuration responsibilities are kept explicit:

| Module | Responsibility |
| --- | --- |
| `options.lua` | Editor behavior, display, undo, search, statusline, and netrw |
| `keymaps.lua` | Core Vim-compatible mappings and option toggles |
| `autocmds.lua` | Cursor restoration, resize behavior, and filetype policy |
| `commands.lua` | Repository search and formatting utility commands |
| `plugins.lua` | Native package declarations and module startup order |
| `completion.lua` | Blink completion |
| `lsp.lua` | Mason, native LSP, diagnostics, and LSP mappings |
| `format.lua` | Explicit formatting through Conform |
| `lint.lua` | Non-LSP linting through nvim-lint |
| `treesitter.lua` | Parser installation and native Tree-sitter highlighting |
| `navigation.lua` | fzf-lua, split navigation, and surrounds |
| `git.lua` | Gitsigns, Fugitive, and increment/decrement behavior |
| `github.lua` | Octo mappings and worktree commands |
| `worktrees.lua` | Safe PR checkout and separate-process worktree launching |

### Native package management

Plugins are managed with Neovim 0.12's `vim.pack`. The resolved revisions are
recorded in `nvim-pack-lock.json`.

Run `:PackUpdate` to review plugin updates, then restart Neovim. If
`nvim-treesitter` changed, run `:TSUpdate` after restarting.

Plugins are loaded eagerly. This keeps startup behavior predictable and avoids
adding lazy-loading lifecycle complexity to a personal configuration.

### One process per worktree

Neovim never changes the current process from one worktree to another. Opening
a worktree creates another Neovim process, normally in a new tmux window.

This isolates:

- Current working directory and Git branch.
- Language-server roots and diagnostics.
- Open buffers, undo history, and editor state.
- Tests, terminals, and adjacent OpenCode sessions.

The shell and tmux remain the process orchestrators. Neovim consumes the
existing Git worktree model instead of becoming a project manager.

### OpenCode remains terminal-first

There is deliberately no OpenCode Neovim plugin. Start `opencode` in an adjacent
tmux pane from the same worktree as Neovim. The process remains available if
Neovim restarts, and its filesystem and Git context cannot drift into another
worktree.

### Explicit formatting ownership

Formatting is manual by default. `<leader>lf` invokes one configured formatter,
with LSP formatting as a fallback. There is no global format-on-save hook.

Diagnostics are similarly divided:

- Native LSP supplies language diagnostics.
- nvim-lint supplies ShellCheck diagnostics for shell files.
- ESLint runs as an LSP rather than a duplicate standalone linter.

## Requirements

Core requirements:

- Neovim 0.12 or newer.
- Git.
- tmux for opening worktrees in new interactive Neovim processes.
- `fzf`; `rg`, `fd`, and `bat` improve picker behavior and previews.
- GitHub CLI (`gh`) authenticated with `gh auth login` for Octo and PR
  worktrees.

Mason installs the configured language servers, formatters, linters, and
Tree-sitter CLI on first launch.

## Install and first launch

Deploy the default dots profile from the repository root:

```sh
python3 -m toda --manifest ./MANIFEST install default
```

If the old `~/.config/nvim/init.vim` link conflicts with the new directory
deployment, allow Toda to replace it:

```sh
python3 -m toda --manifest ./MANIFEST -f install default
```

Launch Neovim explicitly:

```sh
nvim
```

Mason starts installing tools on the first launch. After the Tree-sitter CLI is
available, install the configured parsers:

```vim
:TSInstallConfigured
:checkhealth
```

The shell profile still prefers classic Vim. To use Neovim as the editor in the
current shell:

```sh
export EDITOR=nvim VISUAL=nvim
```

## Key conventions

`<leader>` is Space. `<localleader>` is backslash.

Global functionality is grouped by leader prefix:

| Prefix | Purpose |
| --- | --- |
| `<leader>f` | Find and search with fzf-lua |
| `<leader>g` | Git, GitHub, and worktrees |
| `<leader>l` | LSP, formatting, and linting |
| `<leader>o` | Local option toggles |
| `<leader>op` | GitHub pull-request review |
| `<leader>r` | Edit configuration files |
| `<leader>d` | Diff and text-cleanup operations |
| `<leader>z` | Dates, timestamps, and signatures |

Plugin- or filetype-local actions use `<localleader>`. Octo review comments are
the main example.

## Keybindings

### Core editing and navigation

| Key | Action |
| --- | --- |
| `gb`, `]b` | Next buffer |
| `gB`, `[b` | Previous buffer |
| `]t`, `[t` | Next or previous tab |
| `]q`, `[q` | Next or previous quickfix item |
| `]Q`, `[Q` | Next or previous quickfix file |
| `]l`, `[l` | Next or previous location-list item |
| `]L`, `[L` | Next or previous location-list file |
| `<C-h/j/k/l>` | Move across Neovim splits and tmux panes |
| `<Esc>` in a terminal | Leave terminal mode |
| `<leader><leader>` | Clear search highlighting and redraw |
| `<leader>v` | Open the netrw explorer |
| `<leader>b` followed by an operation | Use the black-hole register |
| `vq` | Format the current paragraph |
| `Q` in visual mode | Format the selection with `gq` |
| `<` or `>` in visual mode | Indent and keep the selection |

Search motions `*`, `#`, `g*`, `g#`, `n`, and `N`, plus tag jump `<C-]>`,
automatically center the destination line.

### Finding and searching

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files below the current working directory |
| `<leader>fb` | Find loaded buffers |
| `<leader>fg` | Live ripgrep search |
| `<leader>fG` | Find Git-tracked files |
| `<leader>fs` | Find files in Git status |
| `<leader>fl` | Search lines in the current buffer |
| `<leader>fL` | Search lines in all loaded buffers |
| `<leader>fh` | Search help tags |
| `<leader>fc` | Search Ex commands |
| `<leader>fm` | Search mappings |
| `<leader>fr` | Search recent files |
| `<leader>fp` | Find files below `~/Projects` |

fzf-lua also supplies `vim.ui.select`, so LSP, Octo, and worktree selections
share the same picker interface.

### LSP, completion, formatting, and linting

Neovim's native LSP mappings remain available, including `K`, `gd`, and the
`gr*` family.

| Key | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `<leader>ld` | Go to definition |
| `<leader>li` | Go to implementation |
| `<leader>lr` | Find references |
| `<leader>ln` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>ls` | Document symbols |
| `<leader>lf` | Format the buffer or visual selection |
| `<leader>ll` | Lint the current buffer |

Blink uses its default completion keymap and combines LSP, path, snippet, and
buffer sources. Signature help is enabled; completion documentation is shown on
demand rather than automatically.

Configured language support:

| Language | LSP | Formatter | Additional diagnostics |
| --- | --- | --- | --- |
| Lua | `lua_ls` | Stylua | LSP |
| Vimscript | `vimls` | LSP fallback | LSP |
| Shell | `bashls` | shfmt | ShellCheck |
| Python | BasedPyright | Ruff format | LSP |
| JavaScript/TypeScript | `ts_ls`, ESLint | Prettierd/Prettier | ESLint LSP |
| Terraform | `terraformls` | LSP fallback | LSP |
| Rust | rust-analyzer | rustfmt/LSP | LSP |

### Git

| Key | Action |
| --- | --- |
| `<leader>gg` | Open Fugitive status |
| `]g`, `[g` | Next or previous Git hunk |
| `<leader>gp` | Preview the current hunk |
| `<leader>gs` | Stage the current hunk |
| `<leader>gr` | Reset the current hunk |
| `<leader>gb` | Blame the current line |
| `<leader>gt` | Toggle Git signs |
| `ig`, `ag` in operator/visual mode | Select the current Git hunk |
| `dgr` | `diffget REMOTE` |
| `dgb` | `diffget BASE` |
| `dgl` | `diffget LOCAL` |
| `<C-a>`, `<C-x>` | Increment or decrement numbers, booleans, and rebase actions |

The diff mappings are retained for Fugitive's three-way merge buffers.

### GitHub pull requests

`gh auth status` must succeed before using Octo or PR discovery.

| Key or command | Action |
| --- | --- |
| `<leader>opl` | List pull requests in Octo |
| `<leader>opr` | Start a review for the open PR |
| `<leader>opR` | Resume a pending review |
| `<leader>opc` | Show PR checks |
| `<leader>ops` | Submit the pending review |
| `<leader>gP`, `:PRWorktree` | Select a PR and open its worktree |
| `:PRWorktree 123` | Open PR 123 in `.worktrees/pr-123` |
| `<leader>gw`, `:Worktrees` | Open an existing worktree |

Inside an Octo review buffer:

| Key | Action |
| --- | --- |
| `\ca` | Add a review comment |
| `\sa` | Add a suggestion |
| `]q`, `[q` | Next or previous changed file |
| `]t`, `[t` | Next or previous review thread |
| `\rt`, `\rT` | Resolve or reopen a thread |

Use `:Octo help` in an Octo buffer for the complete context-sensitive mapping
list. Saving a review-comment buffer records a pending comment; comments are not
published until the review is submitted.

### Worktree behavior

`:PRWorktree` performs guarded checkout rather than blindly changing branches:

1. Resolve the GitHub repository through `gh`.
2. Fetch the PR head into a dedicated local ref.
3. Create or validate `.worktrees/pr-N` and branch `pr-N`.
4. Refuse to update dirty, mismatched, or divergent worktrees.
5. Verify the checked-out commit exactly matches the PR head.
6. Open another Neovim process and the corresponding Octo PR.

Inside tmux, the new process opens in a new window. Outside tmux, Neovim prints
the path to open manually rather than launching a detached process without a
terminal.

### Option toggles

| Key | Action |
| --- | --- |
| `<leader>on` | Toggle line numbers |
| `<leader>or` | Toggle relative line numbers |
| `<leader>os` | Toggle spell checking |
| `<leader>ow` | Toggle line wrapping |
| `<leader>ol` | Toggle visible whitespace |
| `<leader>om` | Toggle buffer modifiability |
| `<leader>occ` | Toggle cursor column |
| `<leader>ocl` | Toggle cursor line |
| `<leader>ocb` | Toggle the `unnamedplus` clipboard |

### Configuration and timestamps

| Key | Action |
| --- | --- |
| `<leader>rc` | Edit `init.lua` in a new tab |
| `<leader>rp` | Edit `plugins.lua` in a new tab |
| `<leader>rl` | Edit the optional local override file |
| `<leader>dts` | Delete trailing whitespace without moving the view |
| `<leader>zld` | Insert local date as `DD.MM.YYYY` |
| `<leader>zlt` | Insert local timestamp with numeric timezone |
| `<leader>zt` | Insert compact UTC timestamp |
| `<leader>zd` | Insert compact UTC date |
| `<leader>zy` | Insert an `hgto` timestamped signature |
| `<leader>zz` | Insert a timestamped `$USER` signature |

An untracked local override may be placed at
`~/.config/nvim/lua/dots/local.lua`. It is loaded after the core keymaps.

## Commands

| Command | Purpose |
| --- | --- |
| `:Todo` | Put repository TODO/FIXME/XXX/BUG/ERROR/BLACKMAGIC matches in quickfix |
| `:Gdiffnames [base]` | Put names changed from `base` in quickfix |
| `:DeleteTrailingSpaces` | Remove trailing whitespace while preserving view/search state |
| `:Format [range]` | Format the buffer or supplied range |
| `:FormatJSON [range]` | Format JSON through the configured formatter path |
| `:Prettier` | Compatibility command for explicit formatting |
| `:Worktrees` | Select an existing worktree to open |
| `:PRWorktree [number]` | Select or directly open a pull-request worktree |
| `:PackUpdate` | Review and update native packages |
| `:TSInstallConfigured` | Install parsers for configured languages |

## Safe mode

Use plugin-free mode when debugging startup or working in a constrained
environment:

```sh
SAFEVI=1 nvim
```

Safe mode loads core options, mappings, commands, and autocommands, but does not
download or load plugins. Classic Vim remains available separately.

## Maintenance

Update plugins and parsers deliberately:

```vim
:PackUpdate
```

Restart Neovim, then run:

```vim
:TSUpdate
:checkhealth
```

Mason tools do not auto-update. Use Mason's UI or tool update commands when an
upgrade is intended.

Run smoke tests from the dots repository root:

```sh
XDG_CONFIG_HOME="$PWD/default" nvim --headless \
  '+luafile default/nvim/tests/smoke.lua' +qa
```

Run the plugin-free test with:

```sh
SAFEVI=1 XDG_CONFIG_HOME="$PWD/default" nvim --headless \
  '+luafile default/nvim/tests/smoke.lua' +qa
```
