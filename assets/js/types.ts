import { usePage } from '@inertiajs/react'
import type { CSSProperties, Dispatch, SetStateAction } from 'react'

export type ReactStateDispatch<T> = Dispatch<SetStateAction<T>>

export type ExtendsUnion<T, U extends T> = U
export interface Organization {
  id: number
  name: string
  email: string
  phone: string
  address: string
  city: string
  region: string
  country: string
  postal_code: string
  deleted_at: string
  contacts: Contact[]
}

export interface Contact {
  id: number
  name: string
  first_name: string
  last_name: string
  email: string
  phone: string
  address: string
  city: string
  region: string
  country: string
  postal_code: string
  deleted_at: string
  organization_id: number
  organization: Organization
}

export interface Account {
  id: number
  name: string
  initials: string
  is_current: boolean
  is_default: boolean
}

export interface User {
  id: number
  uuid: string
  name: string
  first_name: string
  last_name: string
  initials: string
  email: string
  avatar_thumb?: string
  avatar_medium?: string
  email_changed?: string
  confirmed_at: string
  authenticated_at: string
  deleted_at: string
  default_account_id?: number
}

type Errors = ReturnType<typeof usePage>['props']['errors']
export type ConcretePageProps = Record<string, unknown>
export type PageProps<T extends ConcretePageProps = ConcretePageProps> = T & {
  ssr?: boolean
  currentPath: string
  main_host: string
  app_host: string
  site_url: string
  app_url: string
  auth: {
    user: User
    account: Account
    accounts: Account[]
    role: 'admin' | 'member'
  }
  errors: Errors
  flash: {
    success: string | null
    error: string | null
    info: string | null
    warning: string | null
  }
}

export type OauthStrategy = 'google' | 'github'
export type OAuthProvider<T extends OauthStrategy> = {
  name: T
  icon: T
  display_name: string
  auth_url: string
}

export type UserIdentity = {
  id: string
  uid: string
  strategy: string
  email: string | null
  avatar_url: string | null
  full_name: string | null
}

type CSSVars = Record<`--${string}`, string | number>
export type StyleWithVars = CSSProperties & CSSVars
