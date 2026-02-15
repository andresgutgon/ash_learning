import { useEffect, useCallback, type SetStateAction } from 'react'
import { createStore, useStore } from 'zustand'
import { persist, createJSONStorage } from 'zustand/middleware'

import type { ReactStateDispatch } from '@/types'

// Define your localStorage keys here
export enum AppLocalStorage {
  colorTheme = 'colorTheme',
}

// Check localStorage availability
export const isLocalStorageAvailable = (() => {
  try {
    const testKey = '__test__'
    localStorage.setItem(testKey, testKey)
    localStorage.removeItem(testKey)
    return true
  } catch {
    return false
  }
})()

// Namespace the key
export function buildKey(key: AppLocalStorage): string {
  return `pingcrm:${key}`
}

// Parse from localStorage with fallback
export function getStorageValue(key: string, defaultValue: unknown) {
  if (!isLocalStorageAvailable) return defaultValue

  try {
    const saved = localStorage.getItem(key)
    if (saved === 'undefined') return undefined
    return saved ? JSON.parse(saved) : defaultValue
  } catch {
    return defaultValue
  }
}

type LocalStorageStore = {
  values: Partial<Record<string, unknown>>
  setValue: (key: string, value: SetStateAction<unknown>) => void
}

const localStorageStore = createStore<LocalStorageStore>()(
  persist(
    (set) => ({
      values: {},
      setValue: (key, value) => {
        const prev = getStorageValue(key, null)
        const next = typeof value === 'function' ? value(prev) : value

        if (isLocalStorageAvailable) {
          try {
            localStorage.setItem(key, JSON.stringify(next))
          } catch {
            // silent fail
          }
        }

        set((state) => ({
          values: {
            ...state.values,
            [key]: next,
          },
        }))
      },
    }),
    {
      name: 'local-storage-store',
      storage: createJSONStorage(() => localStorage),
    },
  ),
)

const useLocalStorageStore = <T>(selector: (state: LocalStorageStore) => T) =>
  useStore(localStorageStore, selector)

// Public hook
type Props<T> = {
  key: AppLocalStorage
  defaultValue: T
}

type ReturnType<T> = {
  value: T
  setValue: ReactStateDispatch<T>
}

export const useLocalStorage = <T>({ key, defaultValue }: Props<T>): ReturnType<T> => {
  const fullKey = buildKey(key)

  const value = useLocalStorageStore((state) => state.values[fullKey] ?? defaultValue)
  const setValue = useLocalStorageStore((state) => state.setValue)

  // Initialize only once
  useEffect(() => {
    localStorageStore.setState((state) => {
      if (!(fullKey in state.values)) {
        const initial = getStorageValue(fullKey, defaultValue)
        return {
          values: {
            ...state.values,
            [fullKey]: initial,
          },
        }
      }
      return state
    })
  }, [fullKey, defaultValue])

  return {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-type-assertion
    value: value as unknown as T,
    setValue: useCallback(
      (newValue: SetStateAction<T>) => {
        setValue(fullKey, newValue)
      },
      [setValue, fullKey],
    ),
  }
}
