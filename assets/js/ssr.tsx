import type { Page } from '@inertiajs/core'
import { createInertiaApp } from '@inertiajs/react'
import ReactDOMServer from 'react-dom/server'

import { resolvePage } from '@/lib/pageHelpers'

export async function render(page: Page) {
  return createInertiaApp({
    page,
    resolve: resolvePage,
    render: ReactDOMServer.renderToString,
    setup: ({ App, props }) => <App {...props} />,
  })
}
