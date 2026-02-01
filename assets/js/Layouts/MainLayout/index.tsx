import { Head } from '@inertiajs/react'
import { ReactNode } from 'react'

export default function MainLayout({ title, children }: { title?: string; children: ReactNode }) {
  return (
    <div>
      <Head title={title} />
      {children}
    </div>
  )
}
