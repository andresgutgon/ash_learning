import { router } from '@inertiajs/core'
import { BadgeCheck, Bell, ChevronsUpDown, CreditCard, LogOut } from 'lucide-react'

import { accountConnections } from '@/actions/Account/ConnectionsController'
import { logout } from '@/actions/Auth/SessionsController'
import { Avatar, AvatarFallback, AvatarImage } from '@/ui/atoms/Avatar'
import { Dropdown, type DropdownProps } from '@/ui/atoms/Dropdown'
import { SidebarMenu, SidebarMenuButton, SidebarMenuItem } from '@/ui/organisms/Sidebar'
import { useSidebar } from '@/ui/organisms/Sidebar/useSidebar'

export function NavUser({
  user,
}: {
  user: {
    name: string
    email: string
    avatar?: string
  }
}) {
  const { isMobile } = useSidebar()

  const options: DropdownProps['options'] = [
    {
      type: 'group',
      label: (
        <div className='flex items-center gap-2 px-1 py-1.5 text-left text-sm'>
          <Avatar className='h-8 w-8 rounded-lg'>
            <AvatarImage src={undefined} alt={user.name} />
            <AvatarFallback className='rounded-lg'>CN</AvatarFallback>
          </Avatar>
          <div className='grid flex-1 text-left text-sm leading-tight'>
            <span className='truncate font-medium'>{user.name}</span>
            <span className='truncate text-xs'>{user.email}</span>
          </div>
        </div>
      ),
      className: 'p-0 font-normal',
      options: [],
    },
    { type: 'separator' },
    {
      type: 'group',
      options: [
        {
          label: 'Upgrade to Pro',
          inset: true,
          onClick: () => console.log('Upgrade clicked'),
        },
      ],
    },
    { type: 'separator' },
    {
      type: 'submenu',
      label: 'Account Settings',
      icon: <BadgeCheck />,
      options: [
        {
          label: 'Profile Information',
          onClick: () => console.log('Profile info clicked'),
        },
        {
          type: 'submenu',
          label: 'Privacy & Security',
          options: [
            {
              label: 'Password',
              onClick: () => console.log('Password clicked'),
            },
            {
              label: 'Two-Factor Auth',
              onClick: () => console.log('2FA clicked'),
            },
            {
              label: 'Login History',
              onClick: () => console.log('Login history clicked'),
            },
          ],
        },
        {
          label: 'Connected Accounts',
          onClick: () => router.visit(accountConnections()),
        },
      ],
    },
    {
      type: 'group',
      options: [
        {
          label: 'Billing',
          icon: <CreditCard />,
          onClick: () => console.log('Billing clicked'),
        },
        {
          label: 'Notifications',
          icon: <Bell />,
          onClick: () => console.log('Notifications clicked'),
        },
      ],
    },
    { type: 'separator' },
    {
      label: 'Log out',
      icon: <LogOut />,
      onClick: () => router.visit(logout()),
    },
  ]

  return (
    <SidebarMenu>
      <SidebarMenuItem>
        <Dropdown
          className='w-(--anchor-width) min-w-56'
          align='start'
          side={isMobile ? 'bottom' : 'right'}
          sideOffset={4}
          options={options}
          trigger={
            <SidebarMenuButton
              size='lg'
              className='data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground'
            >
              <Avatar className='h-8 w-8 rounded-lg'>
                <AvatarImage src={user.avatar} alt={user.name} />
                <AvatarFallback className='rounded-lg'>CN</AvatarFallback>
              </Avatar>
              <div className='grid flex-1 text-left text-sm leading-tight'>
                <span className='truncate font-medium'>{user.name}</span>
                <span className='truncate text-xs'>{user.email}</span>
              </div>
              <ChevronsUpDown className='ml-auto size-4' />
            </SidebarMenuButton>
          }
        />
      </SidebarMenuItem>
    </SidebarMenu>
  )
}
