import { ReactNode } from 'react'

import MainLayout from '@/Layouts/MainLayout'

const APP_HORIZONTAL_PADDING = 'px-4'

// TODO: Move to breadcrumbs component file
type IBreadcrumbItem = {
  label: string
  href?: string
}

export default function AppLayout({
  title,
  children,
  breadcrumbs: _breadcrumbs,
}: {
  title?: string
  breadcrumbs: IBreadcrumbItem[]
  children: ReactNode
}) {
  return (
    <MainLayout title={title}>
      {/**
       * We need to scroll the content of the page, not the whole page.
       * So we need to add `scroll-region="true"` to the div below.
       *
       * [Read more](https://inertiajs.com/pages#scroll-regions)
       */}
      <div
        scroll-region='true'
        className={`@container/appLayout flex flex-1 flex-col gap-y-4 py-4 pt-0 ${APP_HORIZONTAL_PADDING}`}
      >
        {children}
      </div>
    </MainLayout>
  )
}
