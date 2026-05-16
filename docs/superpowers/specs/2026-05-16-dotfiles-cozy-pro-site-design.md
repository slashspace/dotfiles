# Dotfiles Cozy Pro Site Design

## Purpose

Design and build a single-page introduction website for this macOS dotfiles project using the selected **Cozy Pro** direction: soft, cute-terminal inspired, but polished enough to feel like a serious developer tool.

The reference inspiration is `https://cute-ghostty.vercel.app/#`. The site should borrow its warmth, terminal charm, pastel mood, and playful atmosphere, but avoid becoming overly kawaii or novelty-focused.

## Product Positioning

**Primary message:** A cozy macOS developer environment, engineered cleanly.

**Expanded message:** Stow-managed configs, semantic palettes, and a focused CLI that keep macOS setup predictable while preserving personality across Ghostty, Neovim, tmux, Starship, SketchyBar, Aerospace, Borders, and Karabiner.

The site should communicate that this is not a random dotfiles dump. It is a curated, structured, themed development environment.

## Audience

- macOS developers who live in the terminal.
- Neovim, tmux, Ghostty, and SketchyBar users.
- Developers interested in clean dotfiles architecture.
- People who like themed, cohesive desktop environments.
- Users who may fork for inspiration rather than install blindly.

## Design Direction: Cozy Pro

Cozy Pro combines:

- Cute Ghostty-style warmth.
- Pastel terminal visuals.
- Rounded, friendly cards.
- Soft glows and decorative symbols used sparingly.
- Professional developer-tool structure and copy.

The site should feel friendly and personal, not corporate. It should also remain readable, structured, and credible.

## Visual Language

### Mood

- Cozy
- Polished
- Pastel dark
- Terminal-first
- Soft macOS desktop feel
- Cute but not childish
- Technical but approachable

### Avoid

- Excessive emoji or kaomoji in every section.
- Heavy mascot dependency.
- Overly busy animated backgrounds.
- Corporate SaaS styling.
- Pure black hacker aesthetic.
- Making the site look like a product with pricing, login, or sales funnel.

## Color System

Base the site on a Catppuccin-like dark pastel palette.

```css
--bg: #11111b;
--bg-alt: #181825;
--surface: #1e1e2e;
--surface-raised: #313244;
--border: rgba(205, 214, 244, 0.14);
--text: #cdd6f4;
--text-strong: #f5e0dc;
--text-muted: #a6adc8;
--pink: #f5c2e7;
--mauve: #cba6f7;
--blue: #89b4fa;
--teal: #94e2d5;
--green: #a6e3a1;
--yellow: #f9e2af;
```

Use gradients sparingly:

- Hero background: radial pastel glow behind terminal mockup.
- Buttons: pink-to-mauve gradient.
- Cards: translucent dark surfaces with subtle pastel border glow.

## Typography

Use modern readable fonts:

- Heading: Inter, Geist, or Satoshi.
- Body: Inter or Geist Sans.
- Code and terminal UI: JetBrains Mono, Geist Mono, SF Mono, or ui-monospace.

Typography rules:

- Hero headline should be large, soft, and confident.
- Body text must remain at least 16px on mobile.
- Terminal text can be smaller but must remain readable.
- Use monospace selectively for commands, labels, and terminal previews.

## Page Structure

The first version is a single-page landing site.

### 1. Sticky Header

Content:

- Brand: `♡ dotfiles` or `dotfiles`
- Nav links:
  - Workflow
  - Themes
  - Architecture
  - Install
  - GitHub

Style:

- Rounded pill header.
- Semi-transparent dark surface.
- Backdrop blur.
- Pastel border.
- Mobile: collapse to compact top bar with only brand and GitHub/install actions.

### 2. Hero

Goal: explain the project in 3 seconds.

Primary headline:

```text
A cozy terminal stack, engineered cleanly
```

Secondary headline option:

```text
Soft-themed dotfiles for a focused macOS workflow
```

Subheadline:

```text
Stow-managed configs, semantic palettes, and a focused CLI that keep Ghostty, Neovim, tmux, SketchyBar, and your macOS workflow in sync.
```

Primary CTA:

```text
Copy install command
```

The copy action should copy the full three-line quick-start block from the
Quick Start section, not only the final bootstrap command.

Secondary CTA:

```text
View on GitHub
```

Hero visual:

- Large terminal/mock desktop card.
- Shows `dotfiles bootstrap`, `dotfiles theme`, and generated CLI output.
- Include subtle decorative text such as `₊✩‧₊˚ macOS dev setup ˚₊✩‧₊`, but only in hero/section dividers.

### 3. Stats Strip

Show compact trust markers:

```text
9 themes
3-layer structure
1 bootstrap command
10+ tool configs
```

The strip should be visually lightweight: small rounded cards or inline pills.

### 4. Workflow Features

Four feature cards:

1. **Stow-managed structure**
   - Core configs, optional macOS modules, and system tooling are separated cleanly for predictable setup and rollback.

2. **Semantic theme engine**
   - One palette drives Ghostty, tmux, SketchyBar, Starship, Borders, Gitmux, and Neovim through generated configs.

3. **macOS desktop workflow**
   - Aerospace, SketchyBar, Borders, Karabiner, and Ghostty work together as a cohesive desktop environment.

4. **Terminal-first productivity**
   - Neovim, tmux, Starship, Sheldon, zoxide, bat, and eza create a fast command-line workflow.

Cards should use:

- Rounded corners.
- Soft border glow.
- Optional Lucide-style line icons.
- No emoji as structural icons.

### 5. Theme Gallery

This should be the most visually distinctive section.

Show all current themes:

- Catppuccin Mocha
- Gruvbox Dark
- Matrix
- Solarized Dark
- Dracula
- Nord
- Everforest Dark
- Monokai Pro
- One Dark

Each theme card should include:

- Theme name.
- Tiny terminal preview.
- Color swatch row.
- Short personality label, e.g. `pastel`, `warm`, `neon`, `classic`, `vivid`, `icy`, `forest`, `saturated`, `editor`.

Interaction:

- Hover/focus raises the card slightly.
- Selected/active visual state is optional for the first version.
- Respect `prefers-reduced-motion`.

### 6. Architecture Section

Explain the project shape visually:

```text
core/      cross-platform essentials
modules/   macOS-specific integrations
system/    CLI, theme engine, packages, shared libraries
```

Use three connected cards or a simple diagram. Keep this easy to understand and avoid over-explaining internal details.

### 7. CLI Preview

Show the actual public CLI commands:

```bash
dotfiles bootstrap
dotfiles stow apply --core
dotfiles stow apply --modules
dotfiles theme
dotfiles defaults
```

Also show the help-style output:

```text
dotfiles v1.0.0 — macOS development environment

Commands:
  bootstrap    One-time setup
  defaults     Apply macOS system defaults
  stow         GNU Stow package manager
  theme        Pick a theme via fzf
```

This preview should look like a cozy terminal card with macOS window controls.

### 8. Quick Start

Show installation commands:

```bash
git clone https://github.com/slashspace/dotfiles ~/dotfiles
cd ~/dotfiles
./system/bin/dotfiles bootstrap
```

Supporting note:

```text
Requires macOS and Homebrew. Designed for personal use, shared for inspiration.
```

### 9. Footer

Minimal footer:

```text
Built for cozy macOS terminal workflows.
GNU Stow · Ghostty · Neovim · tmux · SketchyBar
GitHub · MIT License
```

## Content Tone

Use clear product copy with light warmth.

Good:

- "cozy terminal stack"
- "themed macOS workflow"
- "engineered cleanly"
- "one palette, many tools"
- "personal setup, shared for inspiration"

Avoid:

- Overly salesy copy.
- Too many cute glyphs.
- Claims like "perfect", "best", or "production-ready" unless verifiable.

## Interaction Requirements

- Smooth anchor navigation.
- Copy button for install command.
- CTA hover states.
- Theme card hover/focus states.
- Reduced-motion fallback.
- Keyboard-focusable interactive elements.

## Accessibility Requirements

- Normal text contrast at least WCAG AA.
- Visible focus rings.
- No icon-only buttons without labels.
- Decorative symbols must be hidden from screen readers if implemented as separate elements.
- Terminal mockups must not be the only place where critical instructions appear.
- Page must work at 375px mobile width without horizontal scroll.

## Responsiveness

Desktop:

- Hero can use two columns: copy on left, terminal mockup on right.
- Feature cards in a 2x2 grid.
- Theme gallery in 3-column grid.

Tablet:

- Hero may stack.
- Feature cards and theme cards can use 2 columns.

Mobile:

- Single-column layout.
- Header simplified.
- Terminal mockups full width.
- Theme cards stacked or horizontally scrollable only if accessibility is preserved.

## Technical Scope

This spec is for a static marketing/documentation site only.

Recommended implementation:

- Directory: `site/`
- Framework: Astro
- Styling: Tailwind CSS
- No login
- No newsletter
- No pricing
- No CMS
- No analytics by default

The website should not change the dotfiles runtime behavior.

## Success Criteria

- The homepage clearly explains the project within the hero section.
- The design feels like Cozy Pro: soft, pastel, terminal-inspired, and credible.
- Theme gallery includes all 9 current themes.
- CLI and install instructions match the repository.
- The site is responsive and accessible.
- The implementation stays isolated under `site/`.
