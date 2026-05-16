import { themes } from "./site";

export const defaultThemeSlug = "gruvbox";
export const defaultTheme = themes.find((theme) => theme.slug === defaultThemeSlug) ?? themes[0];

export type Theme = (typeof themes)[number];

export const getPreviewColors = (theme: Theme) => ({
  primary: theme.slug === defaultThemeSlug ? theme.swatches[3] : theme.swatches[0],
  secondary: theme.swatches[1],
  tertiary: theme.swatches[2],
  accent: theme.slug === defaultThemeSlug ? theme.swatches[0] : theme.swatches[3],
});

export const getSiteColors = (theme: Theme) => {
  const preview = getPreviewColors(theme);

  return {
    bg: `color-mix(in srgb, ${theme.bg} 92%, black)`,
    bgAlt: theme.bg,
    surface: `color-mix(in srgb, ${theme.bg} 88%, ${theme.fg} 6%)`,
    surfaceRaised: `color-mix(in srgb, ${theme.bg} 76%, ${theme.fg} 12%)`,
    border: `color-mix(in srgb, ${theme.fg} 14%, transparent)`,
    text: theme.fg,
    textStrong: `color-mix(in srgb, ${theme.fg} 92%, white)`,
    textMuted: `color-mix(in srgb, ${theme.fg} 70%, transparent)`,
    pink: preview.accent,
    mauve: preview.primary,
    blue: preview.secondary,
    teal: preview.tertiary,
    green: preview.tertiary,
    yellow: preview.primary,
    glowShadow: `0 24px 80px color-mix(in srgb, ${preview.primary} 18%, transparent)`,
    terminalBg: theme.bg,
    terminalFg: theme.fg,
    terminalPrimary: preview.primary,
    terminalSecondary: preview.secondary,
    terminalTertiary: preview.tertiary,
    terminalAccent: preview.accent,
  };
};
