import { MonitorIcon, MoonIcon, SunIcon } from 'lucide-react'
import { useTheme } from 'next-themes'
import { useCallback } from 'react'

import { AppLocalStorage, useLocalStorage } from '@/hooks/useLocalStorage'
import { cn } from '@/lib/utils'
import { ReactStateDispatch } from '@/types'
import { colors } from '@/ui/tokens/colors'
import { opacity } from '@/ui/tokens/opacity'
import { ThemeValue, THEMES, isThemeValue } from '@/ui/tokens/theme'

import { Button } from '../../atoms/Button'

function ThemeIcon({
  theme,
  setTheme,
  setLocalTheme,
}: {
  theme: ThemeValue
  setTheme: ReactStateDispatch<string>
  setLocalTheme: ReactStateDispatch<ThemeValue>
}) {
  const Icon = theme === 'light' ? SunIcon : theme === 'dark' ? MoonIcon : MonitorIcon
  const onClick = useCallback(
    (t: ThemeValue) => () => {
      setLocalTheme(t)
      setTimeout(() => {
        setTheme(() => t)
      }, 200) // Css transition duration
    },
    [setTheme, setLocalTheme],
  )
  return (
    <Button
      key={theme}
      variant='nope'
      size='icon'
      onClick={onClick(theme)}
      aria-label={`Switch to ${theme} theme`}
      className='relative z-10 rounded-full'
    >
      <Icon className={cn(colors.textColors.foreground, opacity['80'])} />
    </Button>
  )
}

export function TripleThemeToggle() {
  const { theme: initialTheme, setTheme } = useTheme()
  const defaultValue = isThemeValue(initialTheme) ? initialTheme : 'system'
  const { value: theme, setValue: setLocalTheme } = useLocalStorage<ThemeValue>({
    key: AppLocalStorage.colorTheme,
    defaultValue,
  })
  return (
    <div className='relative flex'>
      {THEMES.map((t) => (
        <ThemeIcon key={t} theme={t} setTheme={setTheme} setLocalTheme={setLocalTheme} />
      ))}
      <div
        className={cn(
          'absolute top-0 left-0',
          'rounded-full bg-muted',
          'transition-transform duration-200 ease-in-out',
          'h-full w-8',
          {
            'translate-x-0': theme === 'light',
            'translate-x-8': theme === 'dark',
            'translate-x-16': theme === 'system',
          },
        )}
      />
    </div>
  )
}
