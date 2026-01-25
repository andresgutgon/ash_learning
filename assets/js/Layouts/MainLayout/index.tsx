import { ReactNode } from 'react'
import { Head } from '@inertiajs/react'

export default function MainLayout({
  title,
  children,
}: {
  title?: string
  children: ReactNode
}) {
  return (
    <div>
      <Head title={title} />
      {children}
    </div>
  )
}
