# AGENTS.md

Codex-facing guide for working in `/Users/vp/.dotfiles`.

## Core Model

- This is a personal macOS dotfiles repo managed with GNU Stow.
- `mac/` and `server/` are active Stow packages. Deploy the relevant package
  with `cd ~/.dotfiles && stow <package>`.
- `archive/linux/` preserves the old Linux package for reference only.
- The workflow is Vim-centric and keyboard-driven.
- Terminal tools use portable application defaults instead of a shared custom
  palette.
- Treat live config files as the source of truth when docs drift.
- Do not edit secrets or machine-local files such as `.zshenv.local`,
  `.zshrc.local`, or `config.local` unless explicitly asked.
- The worktree often contains user changes. Do not revert unrelated changes.

## Repository Map

```text
~/.dotfiles/
|-- mac/                    # Active macOS Stow package
|   |-- .zshrc
|   |-- .p10k.zsh
|   |-- .gitconfig
|   |-- .fzf.zsh
|   |-- .local/bin/
|   `-- .config/
|       |-- zsh/
|       |-- nvim/
|       |-- tmux/
|       |-- doom/
|       |-- aerospace/
|       |-- ghostty/
|       |-- alacritty/
|       |-- karabiner/
|       |-- linearmouse/
|       |-- git/
|       |-- ranger/
|       |-- bat/
|       |-- btop/
|       `-- neofetch/
|-- archive/linux/          # Inactive Linux configs
|-- server/                 # Ubuntu server terminal Stow package
|-- docs/
|-- README.md
|-- CLAUDE.md
`-- AGENTS.md
```

Important app docs:

- `mac/.config/zsh/CLAUDE.md`
- `mac/.config/nvim/CLAUDE.md`
- `mac/.config/tmux/CLAUDE.md`
- `mac/.config/tmux/AGENTS.md`
- `mac/.config/doom/CLAUDE.md`
- `mac/.config/aerospace/CLAUDE.md`
- `mac/.config/aerospace/AGENTS.md`
- `mac/.config/ghostty/CLAUDE.md`
- `mac/.config/ghostty/AGENTS.md`

When editing inside a subdirectory with its own `AGENTS.md`, read that file
first and treat it as more specific than this root guide.

## Common Commands

```bash
# Deploy configs
cd ~/.dotfiles && stow mac
cd ~/.dotfiles && stow server

# Validate/reload Ghostty
ghostty +validate-config --config-file ~/.config/ghostty/config
ghostty +show-config

# Validate/reload AeroSpace
aerospace reload-config
aerospace list-windows --all
aerospace list-workspaces
aerospace list-apps

# Reload tmux
tmux source-file ~/.config/tmux/tmux.conf
~/.config/tmux/plugins/tpm/bin/install_plugins

# Doom Emacs
~/.config/emacs/bin/doom sync
~/.config/emacs/bin/doom doctor

# Neovim
# Open :Lazy in nvim for plugin sync/update/clean.
```

## Stow And Local Files

Stow creates symlinks from `$HOME` and `$HOME/.config` into `mac/`. Examples:

- `~/.zshrc` points at the `.zshrc` in the deployed package.
- `~/.p10k.zsh` points at `mac/.p10k.zsh`.
- `~/.gitconfig` points at `mac/.gitconfig`.
- `~/.fzf.zsh` points at `mac/.fzf.zsh`.
- `~/.config/nvim/` points at `mac/.config/nvim/`.
- `~/.config/tmux/` points at `mac/.config/tmux/`.
- `~/.config/doom/` points at `mac/.config/doom/`.
- `~/.config/git/` points at `mac/.config/git/`.

Do not deploy `mac` and `server` to the same home directory. Both packages own
the shell and terminal configuration paths.

Machine-specific files are intentionally gitignored:

- `~/.config/zsh/.zshenv.local`: API keys and other secrets.
- `~/.config/zsh/.zshrc.local`: machine-local shell customizations.
- `~/.config/git/config.local`: credential helper.
- app-specific `config.local` files.

## Current Drift Watch

- Ghostty is currently minimal and native: no tmux autostart and no active
  Cmd-to-Meta keybind block.
- tmux still defines Meta bindings such as `M-d`, `M-t`, and `M-e`; they only
  fire in terminals that actually send Meta.
- Neovim loads Kanagawa Wave from `rebelot/kanagawa.nvim`.
- The tracked `.zshrc` does not define `glm`; verify local shell config before
  assuming the command exists.

## Color defaults

- Ghostty and Alacritty inherit their terminal palettes.
- macOS Powerlevel10k uses a compact one-line Lean layout; the server keeps the
  upstream rainbow layout.
- tmux status elements inherit terminal foreground and background colors.
- Ranger uses its bundled `default` colorscheme.
- Bat selects the built-in `ansi` theme in its config.
- Neovim loads Kanagawa Wave.
- Doom Org faces inherit their colors from Doom One.

## App Notes

Zsh:

- Main files: `mac/.zshrc`, `mac/.config/zsh/CLAUDE.md`, `mac/.p10k.zsh`.
- Secrets load at the top from `~/.config/zsh/.zshenv.local`.
- p10k instant prompt should stay near the top.
- `EDITOR` and `VISUAL` are `nvim`; Bat selects `ansi` in its config.
- Claude aliases in tracked config include `cl`, `cld`, `clds`, `cldr`, `cldc`,
  `cldp`, `ccv`, `ccvcd`, and `ccvd`.

Neovim:

- Main files: `mac/.config/nvim/init.lua` and plugin specs in
  `mac/.config/nvim/lua/plugins/`.
- Leader key is Space.
- Current colorscheme is Kanagawa Wave.
- `claude-tmux.lua` adds `<leader>cc`, `<leader>cC`, `<leader>cg`, and
  `<leader>cr` tmux split helpers.

tmux:

- Main files: `mac/.config/tmux/tmux.conf`, docs in `mac/.config/tmux/`.
- Prefix is Ctrl-a, vi mode and mouse are enabled, windows/panes start at 1.
- Clipboard copy-mode uses `pbcopy` on macOS and keeps Linux fallback branches
  for portability.
- TPM manages tmux plugins. The plugin directory is ignored for new files, but
  existing tracked plugin files are intentionally left alone in this migration.

Doom Emacs:

- Main source is `mac/.config/doom/emacs.org`.
- `config.el` is generated by tangling; do not edit it directly unless asked.
- Run `doom sync` after changing `init.el` or `packages.el`.

Ghostty:

- Main files: `mac/.config/ghostty/config` and docs under
  `mac/.config/ghostty/`.
- Current setup uses native Ghostty behavior. The old tmux-centric config is
  archived in `mac/.config/ghostty/docs/config.original-2026-06-16.bak`.

AeroSpace:

- Main files: `mac/.config/aerospace/aerospace.toml` plus local docs.
- Keep the catch-all `[[on-window-detected]]` block last.
- Keep menu-bar/popover exclusions above the catch-all.
- Update `CHANGELOG.md` for meaningful behavior changes.

## Editing And Verification Checklist

- Use `rg`/`rg --files --hidden` for search.
- Read nearby `CLAUDE.md` and `AGENTS.md` files before changing an app config.
- Prefer small, local edits that match the existing style.
- Do not commit secrets or edit ignored local override files.
- Update docs/changelogs when behavior changes, especially for Ghostty,
  AeroSpace, tmux, and keybindings.
- Update `docs/shortcut-reference.md` whenever a Logitech Options+ profile,
  BetterTouchTool trigger, Wispr Flow shortcut, or related Karabiner remap
  changes. Keep it focused on current behavior and put implementation history
  in the specialized setup guides.
- Update the matching provider profile under `docs/transcription/` whenever a
  transcription application's defaults, custom shortcuts, device mappings, or
  switch contract changes. Label built-in defaults and custom mappings
  separately; do not infer that an entry is custom merely because it appears
  under an application's user preferences.
- Keep `mac/.local/bin/trx`, `docs/transcription/README.md`, and the provider
  profiles synchronized. A provider switch must update the two global BTT
  triggers and the `c195` assignment in every Logitech profile listed by the
  live database, verify the result, and preserve transactional rollback.
- Treat transcription providers that share a global shortcut as mutually
  exclusive until a dispatcher is implemented. Document tap-only versus
  hold-capable device paths rather than assuming a generated keystroke
  preserves physical press duration.
- For Stow changes, run `stow -n -v mac` before `stow mac`.
- For Ghostty edits, run `ghostty +validate-config --config-file ...`.
- For AeroSpace edits, run `aerospace reload-config`.
- For tmux edits, run `tmux source-file ~/.config/tmux/tmux.conf`.
- For Doom `init.el` or `packages.el` edits, run `doom sync`.
- For Neovim plugin edits, verify plugin specs load through lazy.nvim.
