import { ReactNode } from 'react'

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuLabel,
  DropdownMenuItem,
  DropdownMenuCheckboxItem,
  DropdownMenuRadioGroup,
  DropdownMenuRadioItem,
  DropdownMenuSeparator,
  DropdownMenuShortcut,
  DropdownMenuSub,
  DropdownMenuSubTrigger,
  DropdownMenuSubContent,
  DropdownMenuTrigger,
} from './Primitives'
import type { DropdownProps, DropdownOption } from './types'

function renderOption(option: DropdownOption, level: number = 0): ReactNode {
  const key =
    option.id ||
    (option.type === 'separator' ? `separator-${Math.random()}` : Math.random().toString())

  switch (option.type) {
    case 'separator':
      return <DropdownMenuSeparator key={key} className={option.className} />

    case 'item':
    case undefined:
      return (
        <DropdownMenuItem
          key={key}
          onClick={option.onClick}
          disabled={option.disabled}
          className={option.className}
          variant={option.variant}
          inset={option.inset}
        >
          {option.icon}
          {option.label}
          {option.shortcut && <DropdownMenuShortcut>{option.shortcut}</DropdownMenuShortcut>}
        </DropdownMenuItem>
      )

    case 'checkbox':
      return (
        <DropdownMenuCheckboxItem
          key={key}
          checked={option.checked}
          onCheckedChange={option.onCheckedChange}
          disabled={option.disabled}
          className={option.className}
          inset={option.inset}
        >
          {option.icon}
          {option.label}
          {option.shortcut && <DropdownMenuShortcut>{option.shortcut}</DropdownMenuShortcut>}
        </DropdownMenuCheckboxItem>
      )

    case 'radio':
      return (
        <DropdownMenuRadioItem
          key={key}
          value={option.value}
          disabled={option.disabled}
          className={option.className}
          inset={option.inset}
        >
          {option.icon}
          {option.label}
          {option.shortcut && <DropdownMenuShortcut>{option.shortcut}</DropdownMenuShortcut>}
        </DropdownMenuRadioItem>
      )

    case 'submenu':
      return (
        <DropdownMenuSub key={key}>
          <DropdownMenuSubTrigger
            disabled={option.disabled}
            className={option.className}
            inset={option.inset}
          >
            {option.icon}
            {option.label}
          </DropdownMenuSubTrigger>
          <DropdownMenuSubContent>
            {option.options.map((subOption) => renderOption(subOption, level + 1))}
          </DropdownMenuSubContent>
        </DropdownMenuSub>
      )

    case 'group':
      return (
        <DropdownMenuGroup key={key} className={option.className}>
          {option.label && <DropdownMenuLabel>{option.label}</DropdownMenuLabel>}
          {option.options.map((groupOption) => renderOption(groupOption, level))}
        </DropdownMenuGroup>
      )

    case 'radiogroup':
      return (
        <DropdownMenuGroup key={key} className={option.className}>
          {option.label && <DropdownMenuLabel>{option.label}</DropdownMenuLabel>}
          <DropdownMenuRadioGroup value={option.value} onValueChange={option.onValueChange}>
            {option.options.map((radioOption) => renderOption(radioOption, level))}
          </DropdownMenuRadioGroup>
        </DropdownMenuGroup>
      )

    default:
      console.warn('Dropdown: Unknown option type:', option)
      return null
  }
}

export function Dropdown({
  trigger,
  options,
  open,
  defaultOpen,
  onOpenChange,
  align = 'start',
  alignOffset = 0,
  side = 'bottom',
  sideOffset = 4,
  className,
  ...rootProps
}: DropdownProps) {
  return (
    <DropdownMenu open={open} defaultOpen={defaultOpen} onOpenChange={onOpenChange} {...rootProps}>
      <DropdownMenuTrigger render={trigger} />
      <DropdownMenuContent
        align={align}
        alignOffset={alignOffset}
        side={side}
        sideOffset={sideOffset}
        className={className}
      >
        {options.map((option) => renderOption(option))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

export type { DropdownProps }
