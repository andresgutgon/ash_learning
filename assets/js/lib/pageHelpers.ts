import { PageProps } from '@inertiajs/core'
import { ReactNode, ComponentType } from 'react'

type PageModule = {
  default: ComponentType<PageProps> & {
    layout?: (page: ReactNode) => ReactNode
  }
}

export async function resolvePage(name: string) {
  const pages = import.meta.glob<PageModule>('../Pages/**/*.tsx')
  const importPage = pages[`../Pages/${name}/index.tsx`]

  if (!importPage) {
    throw new Error(`Page ${name} not found.`)
  }

  const page = await importPage()
  const component = page.default
  return component
}
