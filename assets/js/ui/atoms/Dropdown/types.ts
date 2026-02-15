import { ReactNode, ReactElement } from 'react'

export type BaseOption = {
  id?: string
  disabled?: boolean
  className?: string
  shortcut?: string
  icon?: ReactNode
  variant?: 'default' | 'destructive'
  inset?: boolean
}

export type SimpleOption = BaseOption & {
  type?: 'item'
  label: ReactNode
  onClick?: () => void
}

export type CheckboxOption = BaseOption & {
  type: 'checkbox'
  label: ReactNode
  checked?: boolean
  onCheckedChange?: (checked: boolean) => void
}

export type RadioOption = BaseOption & {
  type: 'radio'
  label: ReactNode
  value: string
}

export type SeparatorOption = {
  type: 'separator'
  id?: string
  className?: string
}

export type SubMenuOption = BaseOption & {
  type: 'submenu'
  label: ReactNode
  options: DropdownOption[]
}

export type GroupOption = {
  type: 'group'
  id?: string
  label?: ReactNode
  className?: string
  options: DropdownOption[]
}

export type RadioGroupOption = {
  type: 'radiogroup'
  id?: string
  label?: ReactNode
  className?: string
  value?: string
  onValueChange?: (value: string) => void
  options: RadioOption[]
}

export type DropdownOption =
  | SimpleOption
  | CheckboxOption
  | RadioOption
  | SeparatorOption
  | SubMenuOption
  | GroupOption
  | RadioGroupOption

export type DropdownProps = {
  trigger: ReactElement
  options: DropdownOption[]
  open?: boolean
  defaultOpen?: boolean
  onOpenChange?: (open: boolean) => void
  align?: 'start' | 'center' | 'end'
  alignOffset?: number
  side?: 'top' | 'bottom' | 'left' | 'right'
  sideOffset?: number
  className?: string
}
