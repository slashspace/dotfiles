export const githubUrl = "https://github.com/slashspace/dotfiles";

export const installCommand = `git clone https://github.com/slashspace/dotfiles ~/dotfiles
cd ~/dotfiles
./system/bin/dotfiles bootstrap`;

export const navItems = [
  { label: "Workflow", href: "#workflow" },
  { label: "Themes", href: "#themes" },
  { label: "Architecture", href: "#architecture" },
  { label: "Install", href: "#install" },
];

export const stats = [
  { value: "10", label: "themes" },
  { value: "3", label: "layers" },
  { value: "1", label: "bootstrap" },
  { value: "10+", label: "tool configs" },
];

export const features = [
  {
    title: "Stow-managed structure",
    description:
      "Core configs, optional macOS modules, and system tooling stay separated for predictable setup and rollback.",
  },
  {
    title: "Semantic theme engine",
    description:
      "One palette drives Ghostty, tmux, SketchyBar, Starship, Borders, Gitmux, and Neovim through generated configs.",
  },
  {
    title: "macOS desktop workflow",
    description:
      "Aerospace, SketchyBar, Borders, Karabiner, and Ghostty work together as a cohesive desktop environment.",
  },
  {
    title: "Terminal-first productivity",
    description:
      "Neovim, tmux, Starship, Sheldon, zoxide, bat, and eza create a fast command-line workflow.",
  },
];

export const themes = [
  {
    name: "Catppuccin Mocha",
    slug: "catppuccin-mocha",
    label: "pastel",
    bg: "#1e1e2e",
    fg: "#cdd6f4",
    swatches: ["#f5c2e7", "#cba6f7", "#89b4fa", "#94e2d5", "#a6e3a1"],
  },
  {
    name: "Gruvbox Dark",
    slug: "gruvbox",
    label: "warm",
    bg: "#282828",
    fg: "#ebdbb2",
    swatches: ["#d3869b", "#83a598", "#8ec07c", "#fabd2f", "#fe8019"],
  },
  {
    name: "Kanagawa Dragon",
    slug: "kanagawa-dragon",
    label: "ink",
    bg: "#181616",
    fg: "#c5c9c5",
    swatches: ["#8992a7", "#8a9a7b", "#7aa89f", "#c4b28a", "#c4746e"],
  },
  {
    name: "Matrix",
    slug: "matrix",
    label: "neon",
    bg: "#0f191c",
    fg: "#c1ff8a",
    swatches: ["#13ff25", "#82d967", "#50b45a", "#00ff87", "#faff00"],
  },
  {
    name: "Solarized Dark",
    slug: "solarized-dark",
    label: "classic",
    bg: "#002b36",
    fg: "#93a1a1",
    swatches: ["#268bd2", "#2aa198", "#859900", "#b58900", "#6c71c4"],
  },
  {
    name: "Dracula",
    slug: "dracula",
    label: "vivid",
    bg: "#282a36",
    fg: "#f8f8f2",
    swatches: ["#bd93f9", "#8be9fd", "#50fa7b", "#ff79c6", "#ffb86c"],
  },
  {
    name: "Nord",
    slug: "nord",
    label: "icy",
    bg: "#2e3440",
    fg: "#d8dee9",
    swatches: ["#88c0d0", "#81a1c1", "#8fbcbb", "#5e81ac", "#b48ead"],
  },
  {
    name: "Everforest Dark",
    slug: "everforest",
    label: "forest",
    bg: "#2b3339",
    fg: "#d3c6aa",
    swatches: ["#a7c080", "#7fbbb3", "#83c092", "#dbbc7f", "#d699b6"],
  },
  {
    name: "Monokai Pro",
    slug: "monokai-pro",
    label: "saturated",
    bg: "#2d2a2e",
    fg: "#fcfcfa",
    swatches: ["#ab9df2", "#78dce8", "#a9dc76", "#ffd866", "#ff6188"],
  },
  {
    name: "One Dark",
    slug: "one-dark",
    label: "editor",
    bg: "#282c34",
    fg: "#abb2bf",
    swatches: ["#61afef", "#c678dd", "#56b6c2", "#e5c07b", "#e06c75"],
  },
];

export const architecture = [
  {
    name: "core/",
    title: "Cross-platform essentials",
    items: ["git", "zsh", "sheldon", "nvim", "tmux", "starship"],
  },
  {
    name: "modules/",
    title: "macOS-specific integrations",
    items: ["aerospace", "ghostty", "karabiner", "sketchybar", "borders"],
  },
  {
    name: "system/",
    title: "Shared engine",
    items: ["bin", "lib", "packages", "themes"],
  },
];

export const cliCommands = [
  "dotfiles bootstrap",
  "dotfiles stow apply --core",
  "dotfiles stow apply --modules",
  "dotfiles theme",
  "dotfiles defaults",
];

export const cliHelp = `dotfiles v1.0.0 — macOS development environment

Commands:
  bootstrap    One-time setup
  defaults     Apply macOS system defaults
  stow         GNU Stow package manager
  theme        Pick a theme via fzf`;
