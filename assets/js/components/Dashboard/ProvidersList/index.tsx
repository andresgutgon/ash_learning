import { Link } from '@inertiajs/react'

import { ProviderIcon } from '@/components/Auth/ProviderIcon'
import type { OAuthProvider, OauthStrategy, UserIdentity } from '@/types'

type Props = {
  providers: OAuthProvider<OauthStrategy>[]
  identities: UserIdentity[]
}

// Group identities by strategy/provider
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
  const disconnectUrl = `/providers/${provider.name}/${encodeURIComponent(identity.uid)}`

  return (
    <div className='flex items-center justify-between p-3 pl-12'>
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

      <Link
        href={disconnectUrl}
        method='delete'
        as='button'
        className='rounded border border-red-300 px-2 py-1 text-xs font-medium text-red-600 transition-colors hover:bg-red-50'
        onBefore={() =>
          confirm(`Are you sure you want to disconnect this ${provider.display_name} account?`)
        }
      >
        Disconnect
      </Link>
    </div>
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
    <div className='overflow-hidden rounded-lg border border-gray-200 bg-white'>
      <div className='flex items-center justify-between bg-gray-50 p-4'>
        <div className='flex items-center gap-3'>
          <ProviderIcon name={provider.icon} />
          <div>
            <h3 className='font-medium'>{provider.display_name}</h3>
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
          href={provider.auth_url}
          className='inline-flex items-center gap-1.5 rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-indigo-700'
        >
          <svg className='h-4 w-4' viewBox='0 0 20 20' fill='currentColor'>
            <path
              fillRule='evenodd'
              d='M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z'
              clipRule='evenodd'
            />
          </svg>
          {isConnected ? 'Add another' : 'Connect'}
        </a>
      </div>

      {/* Connected identities list */}
      {isConnected && (
        <div className='divide-y divide-gray-200'>
          {identities.map((identity) => (
            <IdentityRow key={identity.id} identity={identity} provider={provider} />
          ))}
        </div>
      )}
    </div>
  )
}

export function ProvidersList({ providers, identities }: Props) {
  const identitiesByProvider = groupIdentitiesByProvider(identities)

  return (
    <div className='space-y-4'>
      <div>
        <h2 className='text-lg font-semibold'>Connect your accounts</h2>
        <p className='text-gray-600'>
          Link your social accounts to enable sign-in with multiple providers.
        </p>
      </div>

      <div className='space-y-3'>
        {providers.map((provider) => (
          <ProviderSection
            key={provider.name}
            provider={provider}
            identities={identitiesByProvider[provider.name] || []}
          />
        ))}
      </div>
    </div>
  )
}

export default ProvidersList
