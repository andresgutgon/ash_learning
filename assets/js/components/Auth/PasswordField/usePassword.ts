import { useState, useCallback } from 'react'

import { create as magicLink } from '@/actions/Auth/MagicLinkController'
import { RouteDefinition } from '@/wayfinder'

export function usePassword({ route }: { route: RouteDefinition<'post'> }) {
  const [showPassword, setUsePassword] = useState(true)
  const handleToggleMethod = useCallback(() => {
    setUsePassword((prev) => !prev)
  }, [])
  return {
    showPassword,
    toggle: handleToggleMethod,
    action: showPassword ? route : magicLink(),
  }
}
