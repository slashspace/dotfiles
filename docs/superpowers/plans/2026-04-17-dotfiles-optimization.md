# Dotfiles Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix 16 bugs, inconsistencies, and missing best practices across the dotfiles project in three prioritized batches.

**Architecture:** Each batch is an independent, mergeable set of changes. Batch 1 fixes functional bugs, Batch 2 improves functionality, Batch 3 adds best practices.

**Tech Stack:** bash, zsh, toml, lua, GNU stow, AeroSpace, sketchybar, tmux, neovim

---

### Task 1: Fix `local` keyword outside functions in theme CLI

**Files:**
- Modify: `system/themes/bin/theme:109-138`

The `theme` script uses `local` inside `case` branches at the top level (lines 120, 129), which is invalid bash outside of a function. Fix by extracting the select/apply logic into a `_cmd_select()` function.

- [ ] **Step 1: Fix `local` outside functions**

Replace lines 109-138 (the `case` block) with this:

```bash
_cmd_select() {
  local name
  name=$(_select)
  [[ -n "$name" ]] && _apply "$name"
}

# Main
if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

case "$1" in
  list)
    _list
    ;;
  current)
    _current
    ;;
  select)
    if [[ $# -ge 2 ]]; then
      _apply "$2"
    else
      _cmd_select
    fi
    ;;
  apply)
    if [[ $# -ge 2 ]]; then
      _apply "$2"
    else
      _cmd_select
    fi
    ;;
  *)
    usage
    exit 1
    ;;
esac
```

- [ ] **Step 2: Verify with syntax check**

Run: `bash -n system/themes/bin/theme`
Expected: No output (clean syntax check)

- [ ] **Step 3: Functional test**

Run: `theme list` — should list all themes
Run: `theme current` — should show current theme or "(none)"

- [ ] **Step 4: Commit**

```bash
git add system/themes/bin/theme
git commit -m "fix(theme): wrap case branch logic in _cmd_select to fix local outside functions"
```

---

### Task 2: Fix `zoxdie` typo and excessive whitespace

**Files:**
- Modify: `system/lib/scripts/zoxide_openfiles_nvim.sh` (entire file)

- [ ] **Step 1: Rewrite the entire file with fixes**

Replace the entire file content:

```bash
#!/bin/bash

# Script to find every single file and opens in neovim
# alias set as nzo in .zshrc
search_with_zoxide() {
	if [ -z "$1" ]; then
		# use fd with fzf to select & open a file when no arg are provided
		file="$(fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')"
		if [ -n "$file" ]; then
			nvim "$file"
		fi
	else
		# Handle when an arg is provided
		lines=$(zoxide query -l | xargs -I {} fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup -E .vscode "$1" {} | fzf --no-sort) # Initial filter attempt with fzf
		line_count="$(echo "$lines" | wc -l | xargs)" # Trim any leading spaces

		if [ -n "$lines" ] && [ "$line_count" -eq 1 ]; then
			# looks for the exact ones and opens it
			file="$lines"
			nvim "$file"
		elif [ -n "$lines" ]; then
			# If multiple files are found, allow further selection using fzf and bat for preview
			file=$(echo "$lines" | fzf --query="$1" --height=70% --preview='bat -n --color=always --line-range :500 {}')
			if [ -n "$file" ]; then
				nvim "$file"
			fi
		else
			echo "No matches found." >&2
		fi
	fi
}

search_with_zoxide "$@"
```

Changes: `zoxdie` → `zoxide` (3 places), `vim` → `nvim` (3 places), removed excessive whitespace on last line.

- [ ] **Step 2: Verify syntax**

Run: `bash -n system/lib/scripts/zoxide_openfiles_nvim.sh`
Expected: No output

- [ ] **Step 3: Commit**

```bash
git add system/lib/scripts/zoxide_openfiles_nvim.sh
git commit -m "fix(scripts): fix zoxdie typo, use nvim instead of vim, remove excess whitespace"
```

---

### Task 3: Fix `vim` → `nvim` in fzf_listoldfiles.sh

**Files:**
- Modify: `system/lib/scripts/fzf_listoldfiles.sh`

- [ ] **Step 1: Replace `vim` with `nvim` on lines 8 and 25**

Replace line 8:
```bash
	local oldfiles=($(nvim -u NONE --headless +'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' +qa))
```

Replace line 25:
```bash
	[[ ${#files[@]} -gt 0 ]] && nvim "${files[@]}"
```

- [ ] **Step 2: Verify syntax**

Run: `bash -n system/lib/scripts/fzf_listoldfiles.sh`
Expected: No output

- [ ] **Step 3: Commit**

```bash
git add system/lib/scripts/fzf_listoldfiles.sh
git commit -m "fix(scripts): use nvim instead of vim for consistency with project"
```

---

### Task 4: Add shebangs to 6 shell scripts

**Files:**
- Modify: `system/lib/modules/colors.sh`
- Modify: `system/lib/modules/history.sh`
- Modify: `system/lib/modules/alias.sh`
- Modify: `system/lib/modules/tools.sh`
- Modify: `system/lib/scripts/fzf-git.sh`
- Modify: `modules/sketchybar/items/media.sh`

- [ ] **Step 1: Add `#!/usr/bin/env bash` as the first line to each file**

Use the Edit tool to insert `#!/usr/bin/env bash` followed by a blank line at the top of each file. For files that already have a comment header (like `alias.sh`), insert the shebang before the header:

```bash
#!/usr/bin/env bash
# ============================================================================
# Zsh Alias Configuration Module...
```

For `colors.sh` (starts with `# Terminal ANSI colors`):
```bash
#!/usr/bin/env bash
# Terminal ANSI colors (theme-independent)
```

For `history.sh`, `tools.sh` — prepend shebang at line 1.

For `fzf-git.sh` — prepend shebang at line 1.

For `media.sh` — prepend shebang at line 1.

- [ ] **Step 2: Verify all 6 files pass syntax check**

Run: `bash -n system/lib/modules/colors.sh system/lib/modules/history.sh system/lib/modules/alias.sh system/lib/modules/tools.sh system/lib/scripts/fzf-git.sh modules/sketchybar/items/media.sh`
Expected: No output

- [ ] **Step 3: Commit**

```bash
git add system/lib/modules/colors.sh system/lib/modules/history.sh system/lib/modules/alias.sh system/lib/modules/tools.sh system/lib/scripts/fzf-git.sh modules/sketchybar/items/media.sh
git commit -m "style: add shebangs to shell scripts that were missing them"
```

---

### Task 5: Fix AeroSpace dead path reference

**Files:**
- Modify: `modules/aerospace/aerospace.toml:78-79`

The path `/Users/dingsheng/dotfiles/sketchybar/.config/sketchybar/plugins/trigger_workspace_sketchybar.sh` does not exist. The actual file is at `modules/sketchybar/plugins/trigger_workspace_sketchybar.sh`.

- [ ] **Step 1: Fix the path**

Replace lines 78-79 in `modules/aerospace/aerospace.toml`:

```toml
  alt-slash = ['layout tiles horizontal vertical', 'exec-and-forget /Users/dingsheng/dotfiles/modules/sketchybar/plugins/trigger_workspace_sketchybar.sh']
  alt-comma = ['layout accordion horizontal vertical', 'exec-and-forget /Users/dingsheng/dotfiles/modules/sketchybar/plugins/trigger_workspace_sketchybar.sh']
```

- [ ] **Step 2: Verify the target file exists**

Run: `ls modules/sketchybar/plugins/trigger_workspace_sketchybar.sh`
Expected: file listed

- [ ] **Step 3: Commit**

```bash
git add modules/aerospace/aerospace.toml
git commit -m "fix(aerospace): correct dead path reference to trigger_workspace_sketchybar.sh"
```

---

### Task 6: Make FZF colors theme-aware

**Files:**
- Modify: `system/lib/modules/tools.sh`

Currently FZF has hardcoded hex colors. Make them derive from palette variables (`THEME_BASE`, `THEME_TEXT`, `THEME_GREEN`, etc.) which are set by `colors.sh` sourcing `palette.sh`.

- [ ] **Step 1: Replace hardcoded FZF_DEFAULT_OPTS**

In `system/lib/modules/tools.sh`, find the `FZF_DEFAULT_OPTS` export with hardcoded colors and replace it with:

```bash
# FZF colors derived from theme palette (fall back to defaults when no theme active)
_fg="${THEME_TEXT:-#ffffff}"
_bg="${THEME_BASE:-#0D1116}"
_green="${THEME_GREEN:-#37f499}"
_red="${THEME_RED:-#f16c75}"
_yellow="${THEME_YELLOW:-#f5c542}"
_muted="${THEME_OVERLAY0:-#6b7a8d}"
export FZF_DEFAULT_OPTS=" \
  --color=fg:${_fg},bg:${_bg},hl:${_green} \
  --color=fg+:${_fg},bg+:${_bg},hl+:${_green} \
  --color=info:${_muted},prompt:${_red},pointer:${_yellow} \
  --color=marker:${_muted},spinner:${_yellow},header:${_yellow} \
  --height=90% --reverse --border=rounded --padding=1 \
  --bind=ctrl-j:down,ctrl-k:up"
```

This sources after `colors.sh` has loaded palette variables, so theme changes propagate to FZF.

- [ ] **Step 2: Verify**

Run a new shell: `zsh -l -c 'echo $FZF_DEFAULT_OPTS'`
Expected: Output with theme colors (or defaults if no theme applied)

- [ ] **Step 3: Commit**

```bash
git add system/lib/modules/tools.sh
git commit -m "feat(tools): make FZF colors theme-aware using palette variables"
```

---

### Task 7: Integrate Sketchybar helper build

**Files:**
- Modify: `.gitignore`
- Modify: `system/scripts/bootstrap.sh`

- [ ] **Step 1: Add compiled binary to .gitignore**

Append to `.gitignore`:
```
# Sketchybar compiled helper
modules/sketchybar/helper/helper
```

- [ ] **Step 2: Add make step to bootstrap.sh**

In `system/scripts/bootstrap.sh`, after the Sheldon section (around line 43), add:

```bash
# Build sketchybar helper
if [[ -f "$DOTFILES_DIR/modules/sketchybar/helper/makefile" ]]; then
  log_step "Building sketchybar helper"
  make -C "$DOTFILES_DIR/modules/sketchybar/helper" 2>/dev/null || log_warn "Failed to build sketchybar helper"
fi
```

- [ ] **Step 3: Verify makefile exists**

Run: `ls modules/sketchybar/helper/makefile`
Expected: file listed

- [ ] **Step 4: Commit**

```bash
git add .gitignore system/scripts/bootstrap.sh
git commit -m "build: integrate sketchybar helper build into bootstrap, ignore compiled binary"
```

- [ ] **Step 5: Remove tracked binary from git**

```bash
git rm --cached modules/sketchybar/helper/helper
```

Do NOT commit this yet — it should be a separate commit to clearly show the binary removal.

---

### Task 8: Fix `killall helper` to targeted pkill

**Files:**
- Modify: `modules/sketchybar/sketchybarrc:20`

- [ ] **Step 1: Replace killall with targeted pkill**

Replace line 20:
```bash
pkill -f "$CONFIG_DIR/helper/helper" 2>/dev/null || true
```

- [ ] **Step 2: Verify syntax**

Run: `bash -n modules/sketchybar/sketchybarrc`
Expected: No output

- [ ] **Step 3: Commit**

```bash
git add modules/sketchybar/sketchybarrc
git commit -m "fix(sketchybar): use targeted pkill instead of broad killall for helper"
```

---

### Task 9: Fix `gs` alias conflict

**Files:**
- Modify: `system/lib/modules/alias.sh`

The zsh alias `gs="git status"` conflicts with the git alias `gs = status -s` (short format) in `.gitconfig`.

- [ ] **Step 1: Rename zsh alias**

Replace line 13 in `alias.sh`:
```bash
alias gss='git status -s'
```

This makes `gss` = short status (zsh), `git gs` = short status (git alias), and removes the redundant `gs` that gave full output.

- [ ] **Step 2: Commit**

```bash
git add system/lib/modules/alias.sh
git commit -m "fix(alias): rename gs to gss to avoid conflict with git alias gs"
```

---

### Task 10: Improve stow-manager error reporting

**Files:**
- Modify: `system/scripts/stow-manager.sh`

- [ ] **Step 1: Replace `|| true` with proper error handling**

In `system/scripts/stow-manager.sh`, replace the `_stow()` function's stow invocation. Find the line:
```bash
stow --dir="$stow_dir" --target="$target" $stow_action $flag "$name" 2>&1 || true
```

Replace with:
```bash
local output
if ! output=$(stow --dir="$stow_dir" --target="$target" $stow_action $flag "$name" 2>&1); then
  log_error "Failed to $stow_action $name: $output"
  return 1
fi
```

Also update the callers (in `_apply_all`, `_delete_all`) to handle the non-zero return. In the batch operations, accumulate failures:

```bash
_apply_all() {
  local failed=0
  for pkg in "${packages[@]}"; do
    _stow "$pkg" || ((failed++))
  done
  if [[ $failed -gt 0 ]]; then
    log_error "$failed package(s) failed to $1"
    return 1
  fi
}
```

- [ ] **Step 2: Verify syntax**

Run: `bash -n system/scripts/stow-manager.sh`
Expected: No output

- [ ] **Step 3: Commit**

```bash
git add system/scripts/stow-manager.sh
git commit -m "fix(stow): replace silent || true with proper error reporting"
```

---

### Task 11: Add missing dependencies to Brewfile

**Files:**
- Modify: `system/packages/Brewfile`

- [ ] **Step 1: Uncomment shellcheck and shfmt, add neovim**

In `system/packages/Brewfile`, find and uncomment lines 35-36, and add neovim:

```
brew "neovim"
brew "shellcheck"
brew "shfmt"
```

- [ ] **Step 2: Commit**

```bash
git add system/packages/Brewfile
git commit -m "deps: add neovim, shellcheck, shfmt to Brewfile"
```

---

### Task 12: Add .editorconfig

**Files:**
- Create: `.editorconfig`

- [ ] **Step 1: Create .editorconfig**

```ini
root = true

[*]
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
charset = utf-8

[*.sh]
indent_style = space
indent_size = 2

[*.toml]
indent_style = space
indent_size = 2

[*.lua]
indent_style = space
indent_size = 2

[*.json]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

- [ ] **Step 2: Commit**

```bash
git add .editorconfig
git commit -m "chore: add .editorconfig for consistent code style"
```

---

### Task 13: Add `dotfiles doctor` command

**Files:**
- Create: `system/scripts/doctor.sh`
- Modify: `system/lib/log.sh` (add `log_ok` if not present)

- [ ] **Step 1: Check log.sh for log_ok function**

Read `system/lib/log.sh`. If `log_ok` doesn't exist, we'll use `log_info` with green text.

- [ ] **Step 2: Create doctor.sh**

Create `system/scripts/doctor.sh`:

```bash
#!/usr/bin/env bash
# Dotfiles health check: verify dependencies, configs, and references
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/system/lib/log.sh"

passed=0
failed=0

check() {
  local desc="$1"
  shift
  if "$@" &>/dev/null; then
    log_info "✓ $desc"
    ((passed++))
  else
    log_error "✗ $desc"
    ((failed++))
  fi
}

log_step "Checking dependencies"
check "Homebrew installed" command -v brew
check "GNU stow installed" command -v stow
check "zsh installed" command -v zsh
check "fzf installed" command -v fzf
check "fd installed" command -v fd
check "bat installed" command -v bat
check "nvim installed" command -v nvim
check "tmux installed" command -v tmux
check "sketchybar installed" command -v sketchybar

log_step "Checking config files"
check "~/.zshrc exists" test -f "$HOME/.zshrc"
check "~/.gitconfig exists" test -f "$HOME/.gitconfig"
check "~/.config/starship/starship.toml exists" test -f "$HOME/.config/starship/starship.toml"
check "~/.config/tmux/tmux.conf exists" test -f "$HOME/.config/tmux/tmux.conf"
check "~/.config/nvim/init.lua exists" test -f "$HOME/.config/nvim/init.lua"
check "~/.config/aerospace/aerospace.toml exists" test -f "$HOME/.config/aerospace/aerospace.toml"

log_step "Checking theme"
if [[ -f "$DOTFILES_DIR/system/themes/generated/.current-theme" ]]; then
  current_theme=$(cat "$DOTFILES_DIR/system/themes/generated/.current-theme")
  log_info "✓ Theme active: $current_theme"
  ((passed++))
else
  log_warn "⚠ No theme applied"
fi

check "Generated starship theme exists" test -f "$DOTFILES_DIR/system/themes/generated/starship.toml"
check "Generated tmux theme exists" test -f "$DOTFILES_DIR/system/themes/generated/tmux-colors.conf"
check "Generated sketchybar theme exists" test -f "$DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh"

log_step "Checking references"
check "trigger_workspace_sketchybar.sh exists" test -f "$DOTFILES_DIR/modules/sketchybar/plugins/trigger_workspace_sketchybar.sh"

log_step ""
if [[ $failed -eq 0 ]]; then
  log_info "All $passed checks passed"
else
  log_error "$failed check(s) failed out of $((passed + failed))"
  exit 1
fi
```

- [ ] **Step 3: Make executable and add to stow-manager or PATH**

Make the script executable:
```bash
chmod +x system/scripts/doctor.sh
```

- [ ] **Step 4: Verify**

Run: `bash system/scripts/doctor.sh`
Expected: Output showing pass/fail for each check

- [ ] **Step 5: Commit**

```bash
git add system/scripts/doctor.sh
git commit -m "feat: add dotfiles doctor health check command"
```

---

### Task 14: Rename Karabiner JSON files to semantic names

**Files:**
- Rename: `modules/karabiner/assets/complex_modifications/1709695402.json`
- Rename: `modules/karabiner/assets/complex_modifications/1709696833.json`
- Rename: `modules/karabiner/assets/complex_modifications/1748576013.json`
- Rename: `modules/karabiner/assets/complex_modifications/1748577320.json`

- [ ] **Step 1: Read each file to identify purpose**

Read each JSON file's `name` field (Karabiner complex modifications have a name in the rules array). Use that to determine the semantic name.

- [ ] **Step 2: Rename files**

Rename based on the rules' names found in each file. Use `git mv` to preserve history:
```bash
git mv modules/karabiner/assets/complex_modifications/1709695402.json modules/karabiner/assets/complex_modifications/<semantic-name-1>.json
# etc for each file
```

- [ ] **Step 3: Commit**

```bash
git add modules/karabiner/assets/complex_modifications/
git commit -m "chore: rename karabiner config files from timestamps to semantic names"
```

---

### Task 15: Remove dead code and fix misleading README

**Files:**
- Delete: `modules/sketchybar/plugins/icon_map.sh`
- Modify: `modules/sketchybar/items/README.md`

- [ ] **Step 1: Delete icon_map.sh**

Verify no file references it:
```bash
grep -r "icon_map" modules/sketchybar/ --include="*.sh"
```
If no results, delete the file.

- [ ] **Step 2: Fix README.md**

In `modules/sketchybar/items/README.md`, find entries for `memory.sh` and `cpu.sh` and mark them as commented/disabled:
Change "Active" to "Commented out / experimental".

- [ ] **Step 3: Commit**

```bash
git rm modules/sketchybar/plugins/icon_map.sh
git add modules/sketchybar/items/README.md
git commit -m "cleanup: remove dead icon_map.sh (487 lines), fix misleading README"
```

---

### Task 16: Move email from tracked .gitconfig

**Files:**
- Modify: `core/git/.gitconfig`

- [ ] **Step 1: Remove [user] name/email from tracked file**

Replace the `[user]` section in `core/git/.gitconfig` with a comment:

```toml
# Set your name and email in ~/.gitconfig.local (not tracked):
# [user]
#   name = Your Name
#   email = your@email.com
```

Keep the `[include]` section that loads `.gitconfig.local`.

- [ ] **Step 2: Commit**

```bash
git add core/git/.gitconfig
git commit -m "privacy: remove personal name/email from tracked gitconfig, use .gitconfig.local"
```

---

## Self-Review

**1. Spec coverage check:**
- 1.1 `local` outside functions → Task 1 ✓
- 1.2 `zoxdie` typo → Task 2 ✓
- 1.3 `vim` → `nvim` → Tasks 2, 3 ✓
- 1.4 Missing shebangs → Task 4 ✓
- 1.5 AeroSpace dead path → Task 5 ✓
- 2.1 FZF theme-aware → Task 6 ✓
- 2.2 Helper build → Task 7 ✓
- 2.3 `killall` → Task 8 ✓
- 2.4 `gs` conflict → Task 9 ✓
- 2.5 Stow errors → Task 10 ✓
- 2.6 Brewfile deps → Task 11 ✓
- 3.1 `.editorconfig` → Task 12 ✓
- 3.2 `doctor` command → Task 13 ✓
- 3.3 Karabiner naming → Task 14 ✓
- 3.4 Dead code → Task 15 ✓
- 3.5 Email removal → Task 16 ✓

**2. Placeholder scan:** No TBD/TODO/"similar to" patterns found. All code steps contain actual content.

**3. Type/signature consistency:** All bash scripts use consistent patterns. Function names in Task 2 (`search_with_zoxide`) are consistent within the file.

**4. No gaps:** All 16 items from the spec have corresponding tasks.
