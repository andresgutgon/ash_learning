import { Link } from '@inertiajs/react'
import { ReactNode } from 'react'

import { deleteMethod as logout } from '@/actions/Auth/SessionsController'
import { ProvidersList } from '@/components/Dashboard/ProvidersList'
import AppLayout from '@/Layouts/AppLayout'
import type { OAuthProvider, UserIdentity } from '@/types'

type Props = {
  oauth_providers: OAuthProvider[]
  identities: UserIdentity[]
  user_email: string
}

function DashboardPage({ oauth_providers, identities, user_email }: Props) {
  return (
    <>
      <div className="grid gap-6 md:grid-cols-3">
        {/* Placeholder for other dashboard content */}
        <div className="flex flex-col rounded-xl border border-gray-100 bg-gray-50 p-6">
          <h2 className="mb-2 text-lg font-semibold">Welcome to your Dashboard</h2>
          <p className="flex-1 text-gray-600">
            Manage your account settings and connected services.
          </p>

          <div className="mt-4 text-sm text-gray-600">{user_email}</div>

          <Link
            href={logout()}
            as="button"
            className="mt-2 flex items-center gap-2 rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50"
          >
            Logout
          </Link>
        </div>

        {/* Provider management section - 2/3 width on the right */}
        <div className="rounded-xl border border-gray-100 bg-white p-6 shadow-sm md:col-span-2">
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
  <AppLayout title="Dashboard" breadcrumbs={[{ label: 'Dashboard' }]}>
    {children}
  </AppLayout>
)

export default DashboardPage
