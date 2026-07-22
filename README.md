# dots

Here be dragons. These are my dots.

These dots are deployed with [toda](https://github.com/hgto/toda), my bespoke
symlink manager that uses a bespoke file spec. Yes, I rolled my own.


## Quickstart, be lazy
https://raw.githubusercontent.com/hgto/lazybox/refs/heads/main/dots.sh


## Design Choices
Multi-platform support for POSIX-compliant systems, Debian GNU/Linux, Windows,
macOS and BSDs in that order of priority.


`bash` is the interactive shell, targeting v4, with support for v5. Support for the slower
  `zsh` is 2-3 orders of magnitude slower, and scripting language is not
  bash-compatible.

Shell scripts target `/bin/sh` assuming it implements POSIX.1-2017 Shell
    Command Language, and the five additional features specified under [Debian
    Policy](https://www.debian.org/doc/debian-policy/ch-files.html#s-scripts).

tmux config everywhere: versions 1.7 and all work roughly the same, using
  a single config file (black magic!) This is a big deal, because the tmux
  developer is a fan of breaking changes in config files.

vim and neovim use separate configurations. Neovim requires 0.12 and uses its
  native package manager; Vim remains the portable fallback. When you run as
  root, Vim loads no plugins. Neovim's plugin-free mode can be forced by setting
  the `SAFEVI` environment variable.

vi-keys in bash and powershell is key to my happiness.  `set -o vi` is my favourite
    thing to type in a reverse shell, even before `python -c 'import
    pty;pty.spawn("/bin/bash")'`.

## Shell completion & fzf

Programmable completion loads in `~/.bashrc` from wherever the platform installed
it (Homebrew on macOS, distro packages on Linux). When it is missing,
`setup-bash-completion` (auto-invoked once per shell, snooze-guarded) provisions
it: on macOS it `brew install`s `bash` + `bash-completion@2` and offers to switch
the login shell; on Linux it prints the distro package command and prompts before
installing.

`git <tab>` uses git's own completion (subcommands, branches, remotes, options,
and your `~/.gitconfig` aliases). It is loaded *after* fzf so it wins the `git`
completion spec, then re-wrapped by fzf so the fuzzy path trigger still works.

### fzf key bindings

| Key | Action |
| --- | --- |
| `CTRL-T` | paste selected files/dirs onto the command line (bat preview) |
| `CTRL-R` | fuzzy-search command history (full-command preview) |
| `ALT-C` | `cd` into a selected subdirectory (tree preview) |
| `ctrl-/` | toggle the preview pane |
| `<cmd> **<tab>` | fuzzy completion; trigger is `**` (e.g. `vim src/**<tab>`) |

### enabled fzf features

- **Source command**: `fd` (fast, `.gitignore`-aware, includes dotfiles); falls
  back to `rg --files`, then fzf's builtin walker.
- **Previews**: `bat` (syntax-highlighted) for files, `tree` for directories, the
  full command line for `CTRL-R`; degrade to `cat`/`ls` when absent.
- **Window**: centered tmux popup when the running tmux supports `display-popup`
  (>= 3.2), otherwise a 40% reverse bottom split.
- **Helpers** (`fd`, `bat`, `tree`): installed via Homebrew on macOS, prompted on
  Linux. `rg` is an optional fallback.

### ~Abandoned~ Features
<s>This repo used to also provide an up-to-date configuration for bspwm and sxkhd
that I loved dearly. This text blob is in loving memory of the days where
I felt that keeping up to date with the bspwm developer's breaking changes was
worth my time. It's not anymore. I'd rather use Microsoft Windows to host my
terminal emulators (<s>Windows Terminal is pretty good</s> Alacritty is cute)
so I can do things in docker and over ssh.  RIP bspwm & the Linux desktop.</s>

The above text blob is a reminder of the time I quit bspwm for a year.

This text blob commemorates the time that I killed moving my config from bspwm
0.9.2 to 0.9.9.

This text blob is a reminder to never give up on your favourite window manager.
Even if the X11 threat model is ~unconscionable~ hard on your stomach
in 2021, bspwm is worth it.
