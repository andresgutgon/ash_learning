import { Folder, Forward, MoreHorizontal, Trash2, type LucideIcon } from 'lucide-react'

import { Dropdown, type DropdownProps } from '@/ui/atoms/Dropdown'
import {
  SidebarGroup,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuAction,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/ui/organisms/Sidebar'
import { useSidebar } from '@/ui/organisms/Sidebar/useSidebar'

export function NavProjects({
  projects,
}: {
  projects: {
    name: string
    url: string
    icon: LucideIcon
  }[]
}) {
  const { isMobile } = useSidebar()

  const getProjectOptions = (projectName: string): DropdownProps['options'] => [
    {
      label: 'View Project',
      icon: <Folder className='text-muted-foreground' />,
      onClick: () => console.log('View project:', projectName),
    },
    {
      label: 'Share Project',
      icon: <Forward className='text-muted-foreground' />,
      onClick: () => console.log('Share project:', projectName),
    },
    { type: 'separator' },
    {
      label: 'Delete Project',
      icon: <Trash2 className='text-muted-foreground' />,
      variant: 'destructive',
      onClick: () => console.log('Delete project:', projectName),
    },
  ]

  return (
    <SidebarGroup className='group-data-[collapsible=icon]:hidden'>
      <SidebarGroupLabel>Projects</SidebarGroupLabel>
      <SidebarMenu>
        {projects.map((item) => (
          <SidebarMenuItem key={item.name}>
            <SidebarMenuButton
              render={
                <a href={item.url}>
                  <item.icon />
                  <span>{item.name}</span>
                </a>
              }
            />
            <Dropdown
              trigger={
                <SidebarMenuAction showOnHover>
                  <MoreHorizontal />
                  <span className='sr-only'>More</span>
                </SidebarMenuAction>
              }
              options={getProjectOptions(item.name)}
              className='w-48 rounded-lg'
              side={isMobile ? 'bottom' : 'right'}
              align={isMobile ? 'end' : 'start'}
            />
          </SidebarMenuItem>
        ))}
      </SidebarMenu>
    </SidebarGroup>
  )
}
