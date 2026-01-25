import { ReactNode } from 'react'
import { Link } from '@inertiajs/react'
import AppLayout from '@/Layouts/AppLayout'
import { ProvidersList } from '@/components/Dashboard/ProvidersList'
import { deleteMethod as logout } from '@/actions/Auth/SessionsController'
import type { OAuthProvider, UserIdentity } from '@/types'

type Props = {
  oauth_providers: OAuthProvider[]
  identities: UserIdentity[]
  user_email: string
}

function DashboardPage({ oauth_providers, identities, user_email }: Props) {
  return (
    <>
      <div className='grid gap-6 md:grid-cols-3'>
        {/* Placeholder for other dashboard content */}
        <div className='p-6 bg-gray-50 rounded-xl border border-gray-100 flex flex-col'>
          <h2 className='text-lg font-semibold mb-2'>Welcome to your Dashboard</h2>
          <p className='text-gray-600 flex-1'>
            Manage your account settings and connected services.
          </p>

          <div className='mt-4 text-sm text-gray-600'>
            {user_email}
          </div>

          <Link
            href={logout()}
            as="button"
            className='mt-2 flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 transition-colors'
          >
            Logout
          </Link>
        </div>

        {/* Provider management section - 2/3 width on the right */}
        <div className='md:col-span-2 p-6 bg-white rounded-xl shadow-sm border border-gray-100'>
          <ProvidersList providers={oauth_providers} identities={identities} />
        </div>
      </div>
    </>
  )
}

/**
 * Persistent Layout (Inertia.js)
 *
 * [Learn more](https://inertiajs.com/pages#persistent-layouts)
 */
DashboardPage.layout = (children: ReactNode) => (
  <AppLayout
    title='Dashboard'
    children={children}
    breadcrumbs={[{ label: 'Dashboard' }]}
  />
)

export default DashboardPage
