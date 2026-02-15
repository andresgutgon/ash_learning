import { Link } from '@inertiajs/react'

import { OAuthProvider, OauthStrategy } from '@/types'
import { Button } from '@/ui/atoms/Button'

import { ProviderIcon } from '../ProviderIcon'

export function OuathConnectButtons({ providers }: { providers: OAuthProvider<OauthStrategy>[] }) {
  return (
    <div className='grid grid-cols-1 gap-y-1'>
      {providers.map((provider) => (
        <Button key={provider.name} variant='outline' type='button'>
          <Link
            key={provider.name}
            href={provider.auth_url}
            className='flex w-full items-center justify-center gap-x-2'
          >
            <ProviderIcon name={provider.icon} />
            <div>{provider.display_name}</div>
          </Link>
        </Button>
      ))}
    </div>
  )
}
