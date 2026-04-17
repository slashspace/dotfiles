# Dotfiles Optimization Design

**Date**: 2026-04-17
**Author**: Claude Code
**Status**: Draft

## Problem

The dotfiles project has accumulated functional bugs, inconsistencies, and missing best practices over time. A deep audit revealed 16 issues across three severity levels.

## Approach

Three-batch delivery by priority. Each batch is independent and can be merged separately.

---

## Batch 1: Functional Bugs

### 1.1 `local` outside functions in theme CLI
- **File**: `system/themes/bin/theme` lines 120, 129
- **Fix**: Wrap case branch logic in `_cmd_select()` function

### 1.2 `zoxdie` typo + excessive whitespace
- **File**: `system/lib/scripts/zoxide_openfiles_nvim.sh`
- **Fix**: Rename `search_with_zoxdie` → `search_with_zoxide`, strip tabs on line 33

### 1.3 `vim` → `nvim` in scripts
- **Files**: `system/lib/scripts/fzf_listoldfiles.sh`, `zoxide_openfiles_nvim.sh`
- **Fix**: Replace `vim` with `nvim` in all invocations

### 1.4 Missing shebangs
- **Files**: `system/lib/modules/{colors,history,alias,tools}.sh`, `system/lib/scripts/fzf-git.sh`, `modules/sketchybar/items/media.sh`
- **Fix**: Add `#!/usr/bin/env bash` as first line

### 1.5 AeroSpace dead path reference
- **File**: `modules/aerospace/aerospace.toml` lines 78-79
- **Fix**: Correct path to actual location of `trigger_workspace_sketchybar.sh`

---

## Batch 2: Functional Improvements

### 2.1 FZF theme-aware colors
- **File**: `system/lib/modules/tools.sh`
- **Fix**: Generate `FZF_DEFAULT_OPTS` colors from palette.sh variables instead of hardcoded hex

### 2.2 Sketchybar helper build integration
- **Files**: `.gitignore`, `system/scripts/bootstrap.sh`
- **Fix**: Add `helper` binary to .gitignore, run `make` in bootstrap

### 2.3 `killall helper` precision
- **File**: `modules/sketchybar/sketchybarrc` line 20
- **Fix**: Replace `killall helper` with targeted pkill

### 2.4 `gs` alias conflict
- **File**: `system/lib/modules/alias.sh`
- **Fix**: Rename zsh `gs` to `gss`, keep git alias `gs` for short status

### 2.5 stow-manager error exposure
- **File**: `system/scripts/stow-manager.sh` line 96
- **Fix**: Replace `|| true` with proper error reporting

### 2.6 Brewfile dependency completion
- **File**: `system/packages/Brewfile`
- **Add**: `neovim`, `shellcheck`, `shfmt`

---

## Batch 3: Best Practices

### 3.1 `.editorconfig`
- **File**: New `.editorconfig` at repo root
- **Content**: 2-space indent for shell/lua/toml/json, LF line endings, trim trailing whitespace

### 3.2 `dotfiles doctor` command
- **File**: New `system/scripts/doctor.sh`
- **Checks**: Dependencies installed, config files exist, theme applied, no dead references

### 3.3 Karabiner JSON semantic naming
- **Files**: `modules/karabiner/assets/complex_modifications/*.json`
- **Fix**: Rename timestamp-named files to descriptive names

### 3.4 Dead code cleanup
- **Delete**: `modules/sketchybar/plugins/icon_map.sh` (487 lines, never called)
- **Fix**: `modules/sketchybar/items/README.md` - mark commented items correctly

### 3.5 Email from tracked files
- **File**: `core/git/.gitconfig`
- **Fix**: Remove `[user]` name/email, add comment pointing to `.gitconfig.local`

---

## Verification

Each batch is verified by:
1. Running affected scripts directly
2. Checking syntax with `bash -n` for shell scripts
3. Confirming no broken functionality in affected tools
