import { Head } from '@inertiajs/react'
import { ThemeProvider } from 'next-themes'
import { ReactNode } from 'react'

import { TooltipProvider } from '@/ui/atoms/Tooltip'
import { FlashMessage } from '@/ui/molecules/FlashMessage'
import { Toaster } from '@/ui/molecules/Toast/Primitives'

const TOAST_DURATION = 4000
export default function MainLayout({ title, children }: { title?: string; children: ReactNode }) {
  return (
    <ThemeProvider attribute='class' defaultTheme='system' enableSystem disableTransitionOnChange>
      <Head title={title} />
      <TooltipProvider>{children}</TooltipProvider>
      <Toaster position='top-right' duration={TOAST_DURATION} />
      <FlashMessage durationMs={TOAST_DURATION} />
    </ThemeProvider>
  )
}
