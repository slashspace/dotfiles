# Dotfiles Cozy Pro Site Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a static Astro + Tailwind single-page introduction website under `site/` for the dotfiles project using the approved Cozy Pro design.

**Architecture:** The website is isolated from runtime dotfiles under `site/`. Astro owns page composition, Tailwind owns visual styling, and theme/CLI content is represented as local typed data inside the site so the homepage stays maintainable without touching shell runtime behavior.

**Tech Stack:** Astro, Tailwind CSS, TypeScript, static HTML/CSS/JS, npm.

---

## Source Spec

- Design spec: `docs/superpowers/specs/2026-05-16-dotfiles-cozy-pro-site-design.md`

## File Structure

- Create `site/package.json` — npm scripts and dependencies for the isolated site.
- Create `site/astro.config.mjs` — Astro config with Tailwind integration.
- Create `site/tsconfig.json` — TypeScript config extending Astro defaults.
- Create `site/tailwind.config.mjs` — Cozy Pro color tokens, font family, and content paths.
- Create `site/src/styles/global.css` — base CSS, CSS variables, focus styles, reduced-motion handling, and Tailwind layers.
- Create `site/src/data/site.ts` — all homepage copy, CLI commands, features, architecture cards, and theme card data.
- Create `site/src/layouts/BaseLayout.astro` — HTML shell, metadata, font loading, and body wrapper.
- Create `site/src/components/Header.astro` — sticky pill nav with mobile-safe compact links.
- Create `site/src/components/TerminalCard.astro` — reusable macOS-style terminal panel.
- Create `site/src/components/Hero.astro` — hero copy, CTAs, decorative Cozy Pro terminal visual, and copy-install button hook.
- Create `site/src/components/StatsStrip.astro` — 9 themes / 3 layers / 1 bootstrap / 10+ configs.
- Create `site/src/components/FeatureGrid.astro` — four workflow feature cards.
- Create `site/src/components/ThemeGallery.astro` — 9 theme cards with swatches and tiny terminal previews.
- Create `site/src/components/Architecture.astro` — core/modules/system architecture diagram.
- Create `site/src/components/CliPreview.astro` — public CLI commands and help output.
- Create `site/src/components/QuickStart.astro` — install command block and copy button target.
- Create `site/src/components/Footer.astro` — minimal footer.
- Create `site/src/components/CopyButton.astro` — small client script for clipboard copy, scoped and progressively enhanced.
- Create `site/src/pages/index.astro` — page composition only.
- Modify `.gitignore` — ignore `site/dist/` and Astro temporary artifacts if generated.
- Modify `README.md` and `README.zh-CN.md` — add a short website development note only after the site exists.

## Implementation Tasks

### Task 1: Scaffold Astro + Tailwind site

**Files:**
- Create: `site/package.json`
- Create: `site/astro.config.mjs`
- Create: `site/tsconfig.json`
- Create: `site/tailwind.config.mjs`
- Create: `site/src/styles/global.css`
- Modify: `.gitignore`

- [ ] **Step 1: Create isolated package metadata**

Create `site/package.json`:

```json
{
  "name": "dotfiles-site",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview"
  },
  "dependencies": {
    "@astrojs/tailwind": "^6.0.0",
    "astro": "^5.0.0",
    "tailwindcss": "^3.4.0"
  },
  "devDependencies": {}
}
```

- [ ] **Step 2: Add Astro config**

Create `site/astro.config.mjs`:

```js
import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";

export default defineConfig({
  integrations: [tailwind()],
});
```

- [ ] **Step 3: Add TypeScript config**

Create `site/tsconfig.json`:

```json
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "baseUrl": "."
  }
}
```

- [ ] **Step 4: Add Tailwind Cozy Pro tokens**

Create `site/tailwind.config.mjs` with content paths and Catppuccin-like colors:

```js
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      colors: {
        cozy: {
          bg: "#11111b",
          "bg-alt": "#181825",
          surface: "#1e1e2e",
          raised: "#313244",
          text: "#cdd6f4",
          strong: "#f5e0dc",
          muted: "#a6adc8",
          pink: "#f5c2e7",
          mauve: "#cba6f7",
          blue: "#89b4fa",
          teal: "#94e2d5",
          green: "#a6e3a1",
          yellow: "#f9e2af"
        }
      },
      fontFamily: {
        sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "ui-monospace", "SFMono-Regular", "Menlo", "monospace"]
      },
      boxShadow: {
        glow: "0 24px 80px rgba(203, 166, 247, 0.18)"
      }
    }
  },
  plugins: []
};
```

- [ ] **Step 5: Add global CSS**

Create `site/src/styles/global.css` with Tailwind layers, body background, focus-visible ring, smooth scrolling, and reduced-motion handling.

- [ ] **Step 6: Ignore generated site artifacts**

Add to `.gitignore`:

```gitignore
site/node_modules/
site/dist/
site/.astro/
```

- [ ] **Step 7: Install dependencies**

Run:

```bash
cd site && npm install
```

Expected: `site/package-lock.json` is created and install exits 0.

- [ ] **Step 8: Build smoke test**

Run:

```bash
cd site && npm run build
```

Expected: build succeeds if Astro has a page. If it fails only because no page exists yet, continue to Task 2. Any dependency, config, or Tailwind error must be fixed before continuing.

- [ ] **Step 9: Commit scaffold**

```bash
git add .gitignore site/package.json site/package-lock.json site/astro.config.mjs site/tsconfig.json site/tailwind.config.mjs site/src/styles/global.css
git commit -m "feat(site): scaffold Astro Tailwind site

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 2: Add content data and base layout

**Files:**
- Create: `site/src/data/site.ts`
- Create: `site/src/layouts/BaseLayout.astro`
- Create: `site/src/pages/index.astro`

- [ ] **Step 1: Create homepage data**

Create `site/src/data/site.ts` exporting:

- `installCommand`: exact three-line quick start block.
- `navItems`: Workflow, Themes, Architecture, Install.
- `stats`: 9 themes, 3-layer structure, 1 bootstrap command, 10+ tool configs.
- `features`: four cards from the spec.
- `themes`: all 9 current themes with label, background, foreground, and 5 swatches.
- `architecture`: core/modules/system cards.
- `cliCommands` and `cliHelp`.

- [ ] **Step 2: Create HTML base layout**

Create `site/src/layouts/BaseLayout.astro` that:

- Imports `../styles/global.css`.
- Sets `<html lang="en">`.
- Adds title: `dotfiles — Cozy macOS developer environment`.
- Adds description matching the hero.
- Loads Inter and JetBrains Mono with `font-display=swap`.
- Includes `<slot />`.

- [ ] **Step 3: Create temporary page**

Create `site/src/pages/index.astro` using `BaseLayout` and a simple `<main>` with the hero headline as a placeholder.

- [ ] **Step 4: Build**

Run:

```bash
cd site && npm run build
```

Expected: Astro build succeeds and creates `site/dist/`.

- [ ] **Step 5: Commit data/layout**

```bash
git add site/src/data/site.ts site/src/layouts/BaseLayout.astro site/src/pages/index.astro
git commit -m "feat(site): add homepage data and base layout

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 3: Build shared components

**Files:**
- Create: `site/src/components/CopyButton.astro`
- Create: `site/src/components/TerminalCard.astro`
- Create: `site/src/components/Header.astro`

- [ ] **Step 1: Implement `CopyButton.astro`**

Create a button component accepting `text` and optional `label`. Include a small inline script that:

- Uses `navigator.clipboard.writeText`.
- Changes visible label to `Copied` briefly.
- Fails gracefully by leaving the original label.
- Supports multiple instances on the page without duplicate IDs by using `data-copy-button`/`data-copy-text` attributes and event delegation.

- [ ] **Step 2: Implement `TerminalCard.astro`**

Create a reusable terminal window component with:

- macOS dots.
- Optional `title`.
- `<slot />` for command content.
- Accessible label on the containing region.

- [ ] **Step 3: Implement `Header.astro`**

Use data from `site.ts`; include brand, nav anchors, GitHub link, and install anchor. Mobile should keep brand plus both GitHub and Install actions visible, while hiding secondary middle nav under `sm`.

- [ ] **Step 4: Use components in placeholder page**

Update `index.astro` to render `Header` and a sample `TerminalCard`.

- [ ] **Step 5: Build**

Run:

```bash
cd site && npm run build
```

Expected: build succeeds.

- [ ] **Step 6: Commit shared components**

```bash
git add site/src/components site/src/pages/index.astro
git commit -m "feat(site): add shared UI components

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 4: Build page sections

**Files:**
- Create: `site/src/components/Hero.astro`
- Create: `site/src/components/StatsStrip.astro`
- Create: `site/src/components/FeatureGrid.astro`
- Create: `site/src/components/ThemeGallery.astro`
- Create: `site/src/components/Architecture.astro`
- Create: `site/src/components/CliPreview.astro`
- Create: `site/src/components/QuickStart.astro`
- Create: `site/src/components/Footer.astro`
- Modify: `site/src/pages/index.astro`

- [ ] **Step 1: Implement Hero**

Use spec copy, two CTAs, full quick-start copy action, and a cozy terminal mockup. Decorative glyphs/symbols must be marked `aria-hidden="true"` when rendered outside normal prose.

- [ ] **Step 2: Implement StatsStrip**

Render stats from `site.ts` in responsive pill/card layout.

- [ ] **Step 3: Implement FeatureGrid**

Render four cards from `site.ts`, with no emoji structural icons.

- [ ] **Step 4: Implement ThemeGallery**

Render all 9 themes from `site.ts` with terminal previews, personality labels, and swatches. Theme cards must be keyboard-focusable (`tabindex="0"` or links/buttons if interactive) and include visible hover/focus styling.

- [ ] **Step 5: Implement Architecture**

Render core/modules/system cards and keep copy concise.

- [ ] **Step 6: Implement CliPreview**

Render public CLI command list and help output inside terminal cards.

- [ ] **Step 7: Implement QuickStart**

Render install command block with copy button and macOS/Homebrew note.

- [ ] **Step 8: Implement Footer**

Render minimal footer from spec.

- [ ] **Step 9: Compose final page**

Update `site/src/pages/index.astro` to render all sections in this order:

Header, Hero, StatsStrip, FeatureGrid, ThemeGallery, Architecture, CliPreview, QuickStart, Footer.

- [ ] **Step 10: Build**

Run:

```bash
cd site && npm run build
```

Expected: build succeeds.

- [ ] **Step 11: Commit page sections**

```bash
git add site/src/components site/src/pages/index.astro
git commit -m "feat(site): build Cozy Pro landing page

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### Task 5: Polish, docs, and verification

**Files:**
- Modify: `README.md`
- Modify: `README.zh-CN.md`
- Modify: site files as needed for final polish.

- [ ] **Step 1: Add README website note**

Add a short section to `README.md`:

```markdown
## Website

The introduction site lives in `site/`.

```bash
cd site
npm install
npm run dev
```
```

- [ ] **Step 1b: Add localized README note**

Add equivalent localized content to `README.zh-CN.md`:

```markdown
## 网站

介绍网站位于 `site/`。

```bash
cd site
npm install
npm run dev
```
```

- [ ] **Step 2: Verify responsive/static build**

Run:

```bash
cd site && npm run build
```

Expected: build succeeds.

- [ ] **Step 3: Preview locally**

Run:

```bash
cd site && npm run preview -- --host 127.0.0.1
```

Expected: preview server starts. Open the printed URL and verify:

- Hero explains project.
- Theme gallery has 9 themes.
- Copy install button copies the three-line install command.
- No horizontal scroll at mobile width.
- Focus states are visible.
- Keyboard tab order reaches header links, CTAs, copy buttons, and theme cards in visual order.
- Reduced-motion mode does not depend on motion for comprehension.

- [ ] **Step 4: Stop preview server**

Stop the preview process with its specific process/session control.

- [ ] **Step 5: Commit docs/polish**

```bash
git add README.md README.zh-CN.md site
git commit -m "docs(site): document local website workflow

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

## Final Verification

- [ ] Run:

```bash
cd site && npm run build
```

Expected: exit 0.

- [ ] Run:

```bash
git status --short
```

Expected: only pre-existing unrelated local changes remain, specifically `modules/ghostty/config` if still present. If a plan/spec document was intentionally created during planning, commit it before final verification or explicitly account for it in the final status.
