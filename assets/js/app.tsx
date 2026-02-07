import '../css/app.css'

import { createInertiaApp } from '@inertiajs/react'
import axios from 'axios'
import { StrictMode } from 'react'
import { createRoot, hydrateRoot } from 'react-dom/client'

import { resolvePage } from '@/lib/pageHelpers'
import { PageProps } from '@/types'

axios.defaults.xsrfHeaderName = 'x-csrf-token'

void createInertiaApp({
  resolve: resolvePage,
  setup({ App, el, props }) {
    // Type guard for PageProps
    const isPageProps = (obj: unknown): obj is PageProps => {
      return obj !== null && typeof obj === 'object' && ('ssr' in obj || 'currentPath' in obj)
    }

    const initialPageProps = props.initialPage.props
    const ssr = initialPageProps && isPageProps(initialPageProps) ? initialPageProps.ssr : false

    const app = (
      <StrictMode>
        <App {...props} />
      </StrictMode>
    )

    if (ssr) {
      hydrateRoot(el, app)
    } else {
      createRoot(el).render(app)
    }
  },
})
