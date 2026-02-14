# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for macOS. Manages Neovim and Claude Code configuration, deployed via symlinks.

## Setup

Run `./install.sh` to symlink configs and install vim-plug. After install, open Neovim and run `:PlugInstall`. Plugins listed in `settings.json` under `enabledPlugins` need to be installed separately via `claude /install-plugin`.

## Architecture

### Claude Code (`.claude/`)

Only portable config is tracked — ephemeral data (history, cache, sessions, telemetry) is machine-local. `install.sh` uses two strategies:

**Symlinked files** (single source of truth):
- **`CLAUDE.md`** — User-level instructions (mandatory 4-phase workflow).
- **`settings.json`** — Permissions, hooks, and enabled plugins.

**Copied directories** (merged into `~/.claude/` without overwriting plugin-installed items):
- **`skills/`** — Custom skill definitions (e.g., `cesarpowers/development-workflow`).
- **`agents/`** — Custom agent definitions (placeholder for now).
- **`keybindings/`** — Custom keybindings (placeholder for now).

### Neovim (`.config/nvim/`)

Hybrid VimScript/Lua approach:

- **`.config/nvim/init.vim`** — Entry point. Declares plugins (vim-plug), sets theme (gruvbox), loads Lua config and treesitter.
- **`.config/nvim/plugin/`** — Auto-loaded VimScript: `sets.vim` (editor options), `keybinds.vim` (leader=Space, Telescope/LSP/git/tree mappings), `closetag.vim` (HTML/JSX auto-close config).
- **`.config/nvim/lua/config/`** — Lua modules loaded from init.vim: `init.lua` requires `lsp.lua` (nvim-cmp + tsserver LSP setup) and `nvim-tree.lua` (file explorer config).

## Key Details

- Plugin manager: [vim-plug](https://github.com/junegunn/vim-plug) (not lazy.nvim/packer)
- LSP: configured for `tsserver` only; add other servers in `lua/config/lsp.lua`
- Completion: nvim-cmp with vsnip snippet engine
- External tool dependencies: ripgrep, lazygit, a Nerd Font
