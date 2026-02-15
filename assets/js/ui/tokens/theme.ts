export const THEMES = ['light', 'dark', 'system'] as const
export type ThemeValue = (typeof THEMES)[number]
