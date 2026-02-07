import { Link } from '@inertiajs/react'

import { Logo } from '@/components/Logo'
import { useHost } from '@/hooks/useHost'

export function LogoLink({ url }: { url?: string }) {
  const { buildSiteUrl } = useHost()
  const logoLinkUrl = url || buildSiteUrl()
  return (
    <Link href={logoLinkUrl} className='flex items-center gap-2 font-medium'>
      <div className='flex size-6 items-center justify-center rounded-md text-primary-foreground'>
        <Logo />
      </div>
      Ash Learning Inc.
    </Link>
  )
}
