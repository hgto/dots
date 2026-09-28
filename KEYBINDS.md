# Keybinds

One page for the keys I actually reach for, across the tools I live in. These
reflect my configs in this repo, not upstream defaults.

**Notation.** `C-` is Ctrl, `M-` (or `Alt-`) is Meta/Alt/Option, `S-` is Shift,
`<leader>` is the editor leader key. In tmux, `C-a x` means press the prefix
`C-a`, release, then `x`.

## Leader keys at a glance

| Tool           | Prefix / leader | Mode            | Config                        |
| -------------- | --------------- | --------------- | ----------------------------- |
| tmux           | `C-a`           | —               | `default/tmux.conf`           |
| Neovim         | `Space`         | vi              | `default/nvim/`               |
| Vim            | `Space`         | vi              | `default/vimdir/`             |
| OpenCode v2    | `C-x`           | vi (plugin)     | `default/opencode_cli.json`   |
| Claude Code    | —               | vi              | `default/claude_keybindings.json` |
| Codex          | —               | vi              | `default/codex_config.toml`   |

---

## tmux

Prefix is `C-a`. Standard bindings I haven't overridden (`C-a d` detach, `C-a z`
zoom) still work.

### Windows and sessions

| Key          | Action                             |
| ------------ | ---------------------------------- |
| `C-a c`      | New window at the current path     |
| `C-a C`      | New window at the default path     |
| `C-a n`      | Next window                        |
| `C-a m`      | Previous window                    |
| `C-a \`      | Last window                        |
| `C-a BSpace` | Clear scrollback history           |
| `C-a r`      | Refresh client                     |
| `C-a R`      | Reload config                      |
| `C-a [`      | Enter copy mode                    |

### Panes

| Key             | Action                                            |
| --------------- | ------------------------------------------------- |
| `C-a v`         | Split left/right                                  |
| `C-a s`         | Split top/bottom                                  |
| `C-a h`         | Select pane right *(as configured)*               |
| `C-a l`         | Select pane left *(as configured)*                |
| `C-a j`/`C-a k` | Select pane down / up                             |
| `C-h/j/k/l`     | Move pane, no prefix (vim-aware: forwards to Vim) |
| `C-a C-o`       | Rotate panes                                      |

### Popups and plugins (tmux ≥ 3.2/3.3)

| Key     | Action                                      |
| ------- | ------------------------------------------- |
| `C-a g` | Floating scratch shell                      |
| `C-a f` | Fuzzy pane switcher (fzf)                   |
| `C-a u` | Pick a URL in the pane, open or copy (fzf)  |
| `C-a ~` | htop, or top as fallback, in a bottom split |
| `C-a b` | Bury the current window                     |
| `C-a e` | Exhume a buried window                      |

### Copy mode (vi keys)

| Key     | Action                                 |
| ------- | -------------------------------------- |
| `v`     | Begin selection                        |
| `C-v`   | Toggle rectangle selection             |
| `y`     | Copy selection to the system clipboard |
| `Enter` | Copy selection and exit                |

---

## Editors

Neovim and Vim, side by side. Both use `Space` as leader. Neovim is the daily
driver: fzf-lua under `<leader>f` and built-in LSP under `<leader>l`. Vim is the
portable fallback: fzf.vim with single-letter leader keys, ALE or syntastic for
linting, and coc or YCM for code navigation when they're installed.

### Find and open

| Action         | Neovim        | Vim               |
| -------------- | ------------- | ----------------- |
| Files          | `<leader>ff`  | `<leader>f`       |
| Live grep      | `<leader>fg`  | `<leader>r`       |
| Git files      | `<leader>fG`  | `<leader>gf`      |
| Buffers        | `<leader>fb`  | `<leader>b`       |
| Recent files   | `<leader>fr`  | `<leader>i`       |
| Projects       | `<leader>fp`  | `<leader>p`       |
| Commands       | `<leader>fc`  | `<leader>x`       |
| Keymaps        | `<leader>fm`  | `<leader>m`       |
| Help tags      | `<leader>fh`  | `<leader>h`       |
| Buffer lines   | `<leader>fl`  | `<leader>ll`      |
| All lines      | `<leader>fL`  | `<leader>lb`      |
| File tree      | `C-n`         | `:Vexplore`       |
| Explorer       | `<leader>v`   | `<leader>v`       |

### Code: LSP, format, lint

| Action           | Neovim       | Vim                            |
| ---------------- | ------------ | ------------------------------ |
| Definition       | `<leader>ld` | `gd` (coc/YCM, if installed)   |
| Implementation   | `<leader>li` | `<leader>gi` (coc)             |
| References       | `<leader>lr` | `<leader>yr` (YCM)             |
| Rename           | `<leader>ln` | `<leader>rn` (coc)             |
| Code action/fix  | `<leader>la` | `<leader>qf` (coc)             |
| Document symbols | `<leader>ls` | —                              |
| Format           | `<leader>lf` | `<leader>af`                   |
| Lint             | `<leader>ll` | `<leader>alf`, `<leader>sy/sl` |

### Git

| Action            | Neovim       | Vim                       |
| ----------------- | ------------ | ------------------------- |
| Next / prev hunk  | `]g` / `[g`  | `]g` / `[g`               |
| Stage hunk        | `<leader>gs` | `<leader>gs`              |
| Preview hunk      | `<leader>gp` | `<leader>gp`              |
| Blame line        | `<leader>gb` | —                         |
| Toggle signs      | `<leader>gt` | `<leader>ogg`             |
| Fugitive status   | `<leader>gg` | `:Git`                    |
| Open worktree     | `<leader>gw` | —                         |
| Open PR worktree  | `<leader>gP` | —                         |
| PR actions        | `<leader>opr/opR/opc/ops` | —             |

### Editing and navigation

| Action                    | Neovim       | Vim            |
| ------------------------- | ------------ | -------------- |
| Pane navigation           | `C-h/j/k/l`  | `C-h/j/k/l`    |
| Next / prev buffer        | `]b` / `[b`  | `]b` / `[b`    |
| Next / prev tab           | `]t` / `[t`  | `]t` / `[t`    |
| Quickfix items            | `]q` / `[q`  | `]q` / `[q`    |
| Location items            | `]l` / `[l`  | `]l` / `[l`    |
| Diff context              | —            | `[n` / `]n`    |
| Increment / decrement     | `C-a` / `C-x`| `C-a` / `C-x`  |
| Indent / outdent, reselect| `>` / `<`    | `>` / `<`      |
| Format paragraph / selection | `vq` / `Q` | `vq` / `Q`    |
| Black-hole register       | `<leader>b`  | `<leader>b`    |
| Align (EasyAlign)         | —            | `ga`           |
| Narrow region             | —            | `<leader>nr`   |
| Delete trailing spaces    | `<leader>dts`| `<leader>dts`  |

**Timestamps and signatures.** Shared: `<leader>zld` local date, `<leader>zlt`
local timestamp, `<leader>zt` UTC timestamp, `<leader>zd` UTC date, `<leader>zy`
`[hgto // …]`, `<leader>zz` `<user> // …`. Vim adds `<leader>zh` NATO block,
`<leader>zi` note stub, `<leader>zln` NATO local time.

### Vim only

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<leader>af` | Autoformat (format-on-demand)   |
| `<leader>alf`| ALE fix                         |
| `<leader>8`  | AutoPEP8 buffer / selection     |
| `<leader>ml` | Modeline stub                   |
| `F8`         | Rotate colorscheme              |

---

## Coding agents

OpenCode v2, Claude Code, and Codex, side by side. All three run **vi mode**, so
the editing layer is identical and `Esc` leaves insert and does nothing else at
the prompt. Every action that used to sit on `Esc` now sits on `C-c`.

vi mode comes from Claude's `editorMode: vim`, Codex's `tui.vim_mode_default`,
and the `@leohenon/opencode-vim-plugin` for OpenCode (installed with
`opencode plugin add @leohenon/opencode-vim-plugin`).

### Shared core

The same key in all three.

| Action                 | Key         |
| ---------------------- | ----------- |
| Submit                 | `Enter`     |
| Newline                | `S-Enter`   |
| Leave insert → normal  | `Esc`       |
| Interrupt turn         | `C-c`       |
| Exit                   | `C-d`       |
| External editor        | `C-g`       |
| Reverse-search history | `C-r`       |

### Where they still differ

The action sets and key grammar differ — Codex takes single keys only, so no
chords — and these stay per-tool.

| Action                | OpenCode v2        | Claude Code          | Codex             |
| --------------------- | ------------------ | -------------------- | ----------------- |
| Queue a follow-up     | `M-Enter`          | `C-Enter`            | `Tab`             |
| Switch model          | `<leader>m` (`F2`) | `Option+P`           | `/model`          |
| Permission / approval | —                  | `S-Tab`              | `S-Tab`           |
| Compact context       | `<leader>c`        | `/compact`           | `/compact`        |
| New / resume session  | `<leader>n` / `l`  | `/clear` / `/resume` | `/new` / `/resume`|
| Panel / transcript    | —                  | `C-o`                | `C-t`             |
| Toggle vim mode       | `/vim`             | `/config`            | `/vim`            |

Two things still touch `Esc`: double-`Esc` rewinds to edit an earlier message
in Claude Code and Codex (not exposed for remapping), and dialogs keep `Esc` to
close. At the prompt, `Esc` is only for leaving insert.

### Prompts and tokens

| Action          | OpenCode v2 | Claude Code  | Codex     |
| --------------- | ----------- | ------------ | --------- |
| File mention    | `@`         | `@`          | `@`       |
| Shell command   | —           | `!`          | `!`       |
| Command / skill | `/`         | `/`          | `/`       |
| Emoji shortcode | —           | `:`          | —         |
| Help            | `C-p`       | `?` on empty | `/keymap` |

**OpenCode diff viewer.** Open with `/diff`, then `d` chooses the scope (All,
Committed, Uncommitted, Last turn, Base), `n`/`p` move between files, `v`
toggles split/unified, and `m` marks a file reviewed.

**OpenCode tabs.** `C-x` chords, `M-Up`/`M-Down`, and `M-S-Up`/`M-S-Down`
switch tabs; `C-x 1`–`C-x 0` jump directly. Paste with `C-v`, attach images with
`<leader>i`.

**Claude Code vim mode.** `editorMode: vim`; `Esc` enters NORMAL, with `i/a/o`,
motions `h j k l w e b 0 $ gg G`, edits `x r dd D dw cc C yy p u .`, and text
objects `iw/aw`, `i"/a"`, `i(/a(`. Remap a two-key INSERT sequence to `Esc` with
`vimInsertModeRemaps`.

**Codex vim mode.** `tui.vim_mode_default = true` (or `/vim`). Modal editing in
the composer: `i/a/A/I/o/O`, motions `h j k l w b e 0 $`, operators `d`/`y`/`c`
with `dd`/`yy`, plus `x`, `s`, `p`, `u`.

> In tmux, OpenCode's `C-Tab` and `C-1` don't reach the app; `M-Up`/`M-Down` and
> the `C-x` chords do.
