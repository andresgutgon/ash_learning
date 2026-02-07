export const colors = {
  backgrounds: {
    background: 'bg-background',
    card: 'bg-card',
    popover: 'bg-popover',
    primary: 'bg-primary',
    secondary: 'bg-secondary',
    muted: 'bg-muted',
    accent: 'bg-accent',
    destructive: 'bg-destructive',
    sidebar: 'bg-sidebar',
    chart1: 'bg-chart-1',
    chart2: 'bg-chart-2',
    chart3: 'bg-chart-3',
    chart4: 'bg-chart-4',
    chart5: 'bg-chart-5',
    destructiveMuted: 'bg-destructive-muted',
    warning: 'bg-warning',
    warningMuted: 'bg-warning-muted',
    success: 'bg-success',
    successMuted: 'bg-success-muted',
  },
  textColors: {
    foreground: 'text-foreground',
    cardForeground: 'text-card-foreground',
    popoverForeground: 'text-popover-foreground',
    primaryForeground: 'text-primary-foreground',
    secondaryForeground: 'text-secondary-foreground',
    mutedForeground: 'text-muted-foreground',
    accentForeground: 'text-accent-foreground',
    sidebarForeground: 'text-sidebar-foreground',
    sidebarPrimaryForeground: 'text-sidebar-primary-foreground',
    sidebarAccentForeground: 'text-sidebar-accent-foreground',
    destructive: 'text-destructive-foreground',
    destructiveMuted: 'text-destructive-foreground-muted',
    warning: 'text-warning-foreground',
    warningMuted: 'text-warning-foreground-muted',
    success: 'text-success-foreground',
    successMuted: 'text-success-foreground-muted',
  },
  borderColors: {
    border: 'border-border',
    input: 'border-input',
    sidebarBorder: 'border-sidebar-border',
  },
  ringColors: {
    ring: 'ring-ring',
    sidebarRing: 'ring-sidebar-ring',
  },
}

export type BackgroundColor = keyof typeof colors.backgrounds
export type TextColor = keyof typeof colors.textColors
export type BorderColor = keyof typeof colors.borderColors
export type RingColor = keyof typeof colors.ringColors
