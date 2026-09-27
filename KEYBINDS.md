# Keybinds

One page for the keys I actually reach for, across the tools I live in. These
reflect my configs in this repo, not upstream defaults.

**Notation.** `C-` is Ctrl, `M-` (or `Alt-`) is Meta/Alt/Option, `S-` is Shift,
`<leader>` is the editor leader key. In tmux, `C-a x` means press the prefix
`C-a`, release, then `x`.

## Leader keys at a glance

| Tool        | Prefix / leader | Config                              |
| ----------- | --------------- | ----------------------------------- |
| tmux        | `C-a`           | `default/tmux.conf`                 |
| Neovim      | `Space`         | `default/nvim/`                     |
| Vim         | `Space`         | `default/vimdir/`                   |
| OpenCode    | `C-x`           | `~/.config/opencode/cli.json`       |
| Claude Code | —               | readline + modal vim (`editorMode`) |
| Codex       | —               | readline, optional vim mode         |

Agents use the same editing reflexes: `C-a/E/W/K/U/Y`, `Alt+B/F/D` for readline,
and `Esc` to interrupt. The differences are the product-level keys.

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

| Key           | Action                                              |
| ------------- | --------------------------------------------------- |
| `C-a v`       | Split left/right                                    |
| `C-a s`       | Split top/bottom                                    |
| `C-a h`       | Select pane right *(as configured)*                 |
| `C-a l`       | Select pane left *(as configured)*                  |
| `C-a j`/`C-a k` | Select pane down / up                             |
| `C-h/j/k/l`   | Move pane, no prefix (vim-aware: forwards to Vim)   |
| `C-a C-o`     | Rotate panes                                        |

### Popups and plugins (tmux ≥ 3.2/3.3)

| Key     | Action                                       |
| ------- | -------------------------------------------- |
| `C-a g` | Floating scratch shell                       |
| `C-a f` | Fuzzy pane switcher (fzf)                    |
| `C-a u` | Pick a URL in the pane, open or copy (fzf)   |
| `C-a ~` | htop, or top as fallback, in a bottom split  |
| `C-a b` | Bury the current window                      |
| `C-a e` | Exhume a buried window                       |

### Copy mode (vi keys)

| Key     | Action                                |
| ------- | ------------------------------------- |
| `v`     | Begin selection                       |
| `C-v`   | Toggle rectangle selection            |
| `y`     | Copy selection to the system clipboard |
| `Enter` | Copy selection and exit               |

---

## Neovim

Leader is `Space`. Plugin-free mode: set `SAFEVI`.

### Find and navigate

| Key              | Action                 |
| ---------------- | ---------------------- |
| `<leader>ff`     | Find files             |
| `<leader>fg`     | Live grep              |
| `<leader>fG`     | Git files              |
| `<leader>fs`     | Git status files       |
| `<leader>fb`     | Buffers                |
| `<leader>fr`     | Recent files           |
| `<leader>fp`     | Projects (`~/Projects`)|
| `<leader>fm`     | Keymaps                |
| `C-n`            | Toggle file tree       |
| `<leader>v`      | Netrw explorer         |
| `<leader><leader>` | Clear search highlight |

### LSP, format, lint

| Key           | Action              |
| ------------- | ------------------- |
| `<leader>ld`  | Definition          |
| `<leader>li`  | Implementation      |
| `<leader>lr`  | References          |
| `<leader>ls`  | Document symbols    |
| `<leader>ln`  | Rename              |
| `<leader>la`  | Code action         |
| `<leader>lf`  | Format              |
| `<leader>ll`  | Lint                |

### Git and GitHub

| Key             | Action                   |
| --------------- | ------------------------ |
| `]g` / `[g`     | Next / previous hunk     |
| `<leader>gp`    | Preview hunk             |
| `<leader>gs`    | Stage hunk               |
| `<leader>gr`    | Reset hunk               |
| `<leader>gb`    | Blame line               |
| `<leader>gt`    | Toggle Git signs         |
| `<leader>gg`    | Fugitive status          |
| `<leader>gw`    | Open worktree            |
| `<leader>gP`    | Open PR worktree         |
| `<leader>opl`   | List pull requests       |
| `<leader>opr`   | Start PR review          |
| `<leader>opR`   | Resume PR review         |
| `<leader>opc`   | PR checks                |
| `<leader>ops`   | Submit PR review         |

### Editing and quality of life

| Key                          | Action                    |
| ---------------------------- | ------------------------- |
| `>` / `<`                    | Indent / outdent, reselect |
| `C-a` / `C-x`                | Increment / decrement     |
| `vq` / `Q`                   | Format paragraph / selection |
| `C-h/j/k/l`                  | Pane navigation           |
| `]b` / `[b`                  | Next / previous buffer    |
| `]t` / `[t`                  | Next / previous tab       |
| `]q` / `[q`, `]l` / `[l`     | Quickfix / location items |
| `<leader>b`                  | Black-hole register       |
| `<leader>on/r/s/w/l/m`       | Toggle number, relnum, spell, wrap, list, modifiable |
| `<leader>occ/cl/cb`          | Toggle cursorcolumn, cursorline, clipboard |
| `<leader>rc/rp/rl`           | Edit config / plugins / local |
| `<leader>dts`                | Delete trailing spaces    |

**Timestamps and signatures:** `<leader>zld` local date, `<leader>zlt` local
timestamp, `<leader>zt` UTC timestamp, `<leader>zd` UTC date, `<leader>zy`
`[hgto // …]`, `<leader>zz` `<user> // …`.

---

## Vim

Portable fallback, leader `Space`. Shares most Neovim bindings; the meaningful
additions are the tmux-aware pane jumps and the plugin maps.

| Key                  | Action                                       |
| -------------------- | -------------------------------------------- |
| `C-h/j/k/l`          | Move between Vim and tmux splits             |
| `[n` / `]n`          | Previous / next diff context                 |
| `[a` / `]a`          | Previous / next ALE message                  |
| `<leader>af`         | Autoformat                                   |
| `<leader>alf`        | ALE fix                                      |
| `<leader>sy/sl/sj`   | Syntastic: toggle, loclist, JS context color |
| `<leader>8`          | AutoPEP8 the buffer / selection              |
| `<leader>ml`         | Modeline stub                                |
| `<leader>dts`        | Delete trailing spaces                       |
| `<leader>v`          | Netrw explorer                               |
| `F8`                 | Rotate colorscheme                           |

Timestamps and signatures mirror Neovim: `<leader>zh` NATO block, `<leader>zi`
note stub, `<leader>zld/zlt/zln/zt/zd`, `<leader>zy/zz`.

---

## OpenCode

Leader `C-x`. Tabs are enabled (`tabs.layout: vertical` in `cli.json`).

### Sessions and tabs

| Key                      | Action                       |
| ------------------------ | ---------------------------- |
| `<leader>n`              | New session                  |
| `<leader>l`              | List sessions                |
| `C-o`                    | Recent sessions and projects |
| `<leader>w`              | Close tab                    |
| `C-S-t`                  | Reopen closed tab            |
| `M-Down` / `M-Up`        | Next / previous tab          |
| `C-Tab` / `C-S-Tab`      | Next / previous tab          |
| `<leader>1` … `<leader>0` | Jump to tab 1–10            |
| `C-1` … `C-0`            | Jump to tab 1–10             |
| `M-S-Down` / `M-S-Up`    | Next / previous unread tab   |
| `<leader>b`              | Toggle sidebar               |
| `<leader>x`              | Export session               |

### Models, agents, prompt

| Key           | Action                 |
| ------------- | ---------------------- |
| `<leader>m`   | List models            |
| `F2` / `S-F2` | Cycle recent models    |
| `<leader>a`   | List agents            |
| `S-Tab`       | Cycle agent            |
| `C-t`         | Cycle model variants   |
| `C-p`         | Command palette        |
| `Enter`       | Submit prompt          |
| `M-Enter`     | Queue prompt           |
| `C-c`         | Clear input            |
| `S-Enter`     | Insert newline         |

### Navigation and history

| Key           | Action                  |
| ------------- | ----------------------- |
| `Esc`         | Interrupt               |
| `<leader>u`   | Undo message            |
| `<leader>r`   | Redo message            |
| `<leader>c`   | Compact session         |
| `<leader>y`   | Copy message            |
| `<leader>t`   | Switch theme            |
| `PgUp`/`PgDn` | Scroll a page           |
| `C-g`         | First message           |
| `C-M-g`       | Last message            |

**Diff viewer.** Open with `/diff`, then `d` chooses the scope (All, Committed,
Uncommitted, Last turn, Base), `n`/`p` move between files, `v` toggles
split/unified, and `m` marks a file reviewed.

**Input.** Newline with `S-Enter`, `C-Enter`, or `C-j`. Paste with `C-v`.
Attach images with `<leader>i`.

> In tmux, `C-Tab` and `C-1` don't reach OpenCode; `M-Up`/`M-Down` and the
> `<leader>N` sequences do.

---

## Claude Code

Readline editing plus modal vim (`editorMode: vim`). Option-level keys use
`Option` on macOS with Option-as-Meta enabled.

### General

| Key             | Action                              |
| --------------- | ----------------------------------- |
| `Esc`           | Interrupt, or close a dialog        |
| `Esc Esc`       | Clear draft, or open rewind menu    |
| `C-c`           | Interrupt; clear input; exit        |
| `C-d`           | Exit (deletes forward when typing)  |
| `C-o`           | Toggle transcript viewer            |
| `C-r`           | Reverse-search history              |
| `C-s`           | Stash / restore prompt              |
| `C-b`           | Background the running task         |
| `C-t`           | Toggle the task checklist           |
| `C-l`           | Redraw the screen                   |
| `C-g`           | Open prompt in `$EDITOR`            |
| `S-Tab`         | Cycle permission modes              |
| `Option+P`      | Switch model                        |
| `Option+T`      | Toggle extended thinking            |
| `?` on empty    | Toggle the shortcut help panel      |

### Input and quick commands

| Key                  | Action                          |
| -------------------- | ------------------------------- |
| `\` + `Enter`        | Insert a newline                |
| `S-Enter` / `C-J`    | Newline (terminal permitting)   |
| `Ctrl+X Ctrl+E`      | External editor (readline)      |
| `/`                  | Command or skill                |
| `!`                  | Shell mode                      |
| `@`                  | File path mention               |
| `:`                  | Emoji shortcode                 |

### Vim mode

`Esc` to NORMAL; `i/a/I/A/o/O` to INSERT; `v`/`V` for visual. Motions `h j k l
w e b 0 $ ^ gg G f/F/t/T ; ,`. Edits `x r dd D dw cc C s S yy p P >> << J u .`,
with text objects `iw/aw`, `i"/a"`, `i(/a(`, etc. Remap a two-key INSERT
sequence to `Esc` with `vimInsertModeRemaps`.

---

## Codex

Readline editing, optional vim mode (`/vim` or `toggle_vim_mode`). Many keys are
remappable with `/keymap`.

### Composer and turns

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `Enter`      | Submit, or inject into the running turn  |
| `C-J`        | Insert a newline                          |
| `Esc`        | Interrupt the turn                        |
| `Esc Esc`    | Edit the previous message (empty composer)|
| `Tab`        | Queue a follow-up for the next turn       |
| `C-c`        | Cancel; press twice to exit               |
| `C-r`        | Reverse-search prompt history             |
| `C-g`        | Open the draft in `$EDITOR`               |
| `C-o`        | Copy the last completed output            |
| `C-l`        | Clear the terminal view                   |
| `C-t`        | Open the transcript overlay               |
| `S-Tab`      | Cycle approval modes                      |
| `Alt+.`/`Alt+,` | Raise / lower reasoning effort         |
| `@`          | Attach a workspace file                   |
| `!`          | Run a local shell command                 |

### Slash commands

| Command        | Action                           |
| -------------- | -------------------------------- |
| `/keymap`      | Inspect and remap shortcuts      |
| `/model`       | Model and reasoning effort       |
| `/permissions` | Approval mode                    |
| `/plan`        | Plan mode                        |
| `/review`      | Review the working tree          |
| `/diff`        | Show the working-tree diff       |
| `/compact`     | Summarize to free context        |
| `/vim`         | Toggle vim composer mode         |
| `/init`        | Scaffold an `AGENTS.md`          |

### Vim mode

Standard modal editing in the composer: `i/a/A/I/o/O`, motions `h j k l w b e 0
$`, operators `d`/`y`/`c` with motions and `dd`/`yy`, `x`, `s`, `p`, `u`, `Esc`.
