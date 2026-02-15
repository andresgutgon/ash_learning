export const THEMES = ['light', 'dark', 'system'] as const
export type ThemeValue = (typeof THEMES)[number]
export const isThemeValue = (v: unknown): v is ThemeValue =>
  v === 'light' || v === 'dark' || v === 'system'
