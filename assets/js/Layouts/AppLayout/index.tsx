import { ReactNode } from 'react'

import MainLayout from '@/Layouts/MainLayout'
import { TripleThemeToggle } from '@/ui/molecules/TripleThemeToggle'
import { SidebarProvider, SidebarInset, SidebarTrigger } from '@/ui/organisms/Sidebar'

import { AppSidebar } from './Sidebar'

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
      <SidebarProvider>
        <AppSidebar />
        <SidebarInset>
          <header className='flex h-16 w-full shrink-0 items-center gap-2 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12'>
            <div className='flex w-full items-center justify-between gap-2 px-4'>
              <SidebarTrigger className='-ml-1' />
              <TripleThemeToggle />
            </div>
          </header>
          {/**
           * We need to scroll the content of the page, not the whole page.
           * So we need to add `scroll-region="true"` to the div below.
           *
           * [Read more](https://inertiajs.com/docs/v2/advanced/scroll-management#scroll-regions)
           */}
          <div
            scroll-region='true'
            className={`@container/appLayout flex flex-1 flex-col gap-y-4 py-4 pt-0 ${APP_HORIZONTAL_PADDING}`}
          >
            {children}
          </div>
        </SidebarInset>
      </SidebarProvider>
    </MainLayout>
  )
}
