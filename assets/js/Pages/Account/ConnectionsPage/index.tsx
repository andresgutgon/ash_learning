import { ReactNode } from 'react'

import AppLayout from '@/Layouts/AppLayout'
import { Text } from '@/ui/atoms/Text'

import { ProvidersList, Props } from './ProvidersList'

const ConnectionsPage = ({ providers, identities }: Props) => {
  return (
    <div className='space-y-6 divide-y divide-border'>
      <div className='flex flex-col pb-4'>
        <Text.H2 asChild>
          <h1>Connected Accounts</h1>
        </Text.H2>
        <Text.H5 asChild color='mutedForeground'>
          <p>
            Manage your OAuth providers and connected accounts. You can sign in using any of these
            connected services.
          </p>
        </Text.H5>
      </div>

      <ProvidersList providers={providers} identities={identities} />
    </div>
  )
}

ConnectionsPage.layout = (children: ReactNode) => (
  <AppLayout title='Connected accounts' breadcrumbs={[{ label: 'Dashboard' }]}>
    {children}
  </AppLayout>
)

export default ConnectionsPage
