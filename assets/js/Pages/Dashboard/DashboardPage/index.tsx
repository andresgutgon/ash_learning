import { ReactNode } from 'react'

import AppLayout from '@/Layouts/AppLayout'

function DashboardPage() {
  return (
    <div className='flex flex-1 flex-col gap-4 pt-0'>
      <div className='grid auto-rows-min gap-4 md:grid-cols-3'>
        <div className='aspect-video rounded-xl bg-muted/50' />
        <div className='aspect-video rounded-xl bg-muted/50' />
        <div className='aspect-video rounded-xl bg-muted/50' />
      </div>
      <div className='min-h-screen flex-1 rounded-xl bg-muted/50 md:min-h-min' />
    </div>
  )
}

/**
 * Persistent Layout (Inertia.js)
 *
 * [Learn more](https://inertiajs.com/pages#persistent-layouts)
 */
DashboardPage.layout = (children: ReactNode) => (
  <AppLayout title='Dashboard' breadcrumbs={[{ label: 'Dashboard' }]}>
    {children}
  </AppLayout>
)

export default DashboardPage
