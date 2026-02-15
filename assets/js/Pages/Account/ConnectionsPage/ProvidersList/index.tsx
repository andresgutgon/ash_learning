import { Link } from '@inertiajs/react'

import {
  accountConnections,
  deleteAccountConnection,
} from '@/actions/Account/ConnectionsController'
import { redirectWithReturnTo } from '@/actions/Auth/OAuthRedirectController'
import { ProviderIcon } from '@/components/Auth/ProviderIcon'
import type { OAuthProvider, OauthStrategy, UserIdentity } from '@/types'
import { Button } from '@/ui/atoms/Button'
import { Text } from '@/ui/atoms/Text'

export type Props = {
  providers: OAuthProvider<OauthStrategy>[]
  identities: UserIdentity[]
}

function groupIdentitiesByProvider(identities: UserIdentity[]) {
  return identities.reduce(
    (acc, identity) => {
      const strategy = identity.strategy
      if (!acc[strategy]) {
        acc[strategy] = []
      }
      acc[strategy].push(identity)
      return acc
    },
    {} as Record<string, UserIdentity[]>,
  )
}

function IdentityRow<T extends OauthStrategy>({
  identity,
  provider,
}: {
  identity: UserIdentity
  provider: OAuthProvider<T>
}) {
  return (
    <li className='flex items-center justify-between p-3'>
      <div className='flex items-center gap-2'>
        {identity.avatar_url && (
          <img
            src={identity.avatar_url}
            alt={`${provider.display_name} profile`}
            referrerPolicy='no-referrer'
            className='h-8 w-8 rounded-full'
          />
        )}
        <div>
          {identity.full_name && <span className='text-sm font-medium'>{identity.full_name}</span>}
          {identity.email && <p className='text-xs text-gray-500'>{identity.email}</p>}
        </div>
      </div>

      <Button
        variant='destructive'
        size='xs'
        render={
          <Link
            href={deleteAccountConnection({
              provider: provider.name,
              uid: identity.uid,
            })}
            onBefore={() =>
              confirm(`Are you sure you want to disconnect this ${provider.display_name} account?`)
            }
          >
            Disconnect
          </Link>
        }
      />
    </li>
  )
}

function ProviderSection<T extends OauthStrategy>({
  provider,
  identities,
}: {
  provider: OAuthProvider<T>
  identities: UserIdentity[]
}) {
  const isConnected = identities.length > 0

  return (
    <div className='rounded-lg border border-border'>
      <div className='flex items-center justify-between bg-card p-2'>
        <div className='flex items-center gap-3'>
          <ProviderIcon name={provider.icon} />
          <div>
            <Text.H3>{provider.display_name}</Text.H3>
            {isConnected ? (
              <p className='flex items-center gap-1 text-sm text-green-600'>
                <svg className='h-4 w-4' viewBox='0 0 20 20' fill='currentColor'>
                  <path
                    fillRule='evenodd'
                    d='M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z'
                    clipRule='evenodd'
                  />
                </svg>
                {identities.length} account(s) connected
              </p>
            ) : (
              <p className='text-sm text-gray-500'>Not connected</p>
            )}
          </div>
        </div>

        <a
          href={
            redirectWithReturnTo(provider.name, {
              query: { return_to: accountConnections().url },
            }).url
          }
        >
          <Button variant='default'>
            <svg className='h-4 w-4' viewBox='0 0 20 20' fill='currentColor'>
              <path
                fillRule='evenodd'
                d='M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z'
                clipRule='evenodd'
              />
            </svg>
            {isConnected ? 'Add another' : 'Connect'}
          </Button>
        </a>
      </div>

      {/* Connected identities list */}
      {isConnected && (
        <ul className='divide-y divide-border'>
          {identities.map((identity) => (
            <IdentityRow key={identity.id} identity={identity} provider={provider} />
          ))}
        </ul>
      )}
    </div>
  )
}

export function ProvidersList({ providers, identities }: Props) {
  const identitiesByProvider = groupIdentitiesByProvider(identities)

  return (
    <>
      {providers.map((provider) => (
        <ProviderSection
          key={provider.name}
          provider={provider}
          identities={identitiesByProvider[provider.name] || []}
        />
      ))}
    </>
  )
}

export default ProvidersList
