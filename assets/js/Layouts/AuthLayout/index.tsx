import { Link } from '@inertiajs/react'
import { ReactNode } from 'react'

import { index as signup } from '@/actions/Auth/RegisterController'
import { login } from '@/actions/Auth/SessionsController'
import { LogoLink } from '@/components/LogoLink'
import MainLayout from '@/Layouts/MainLayout'
import { Text } from '@/ui/atoms/Text'
import { FieldDescription } from '@/ui/molecules/Form/Field'

function FooterLink({ children }: { children: ReactNode }) {
  return <FieldDescription align='center'>{children}</FieldDescription>
}

function AuthLayout({ title, children }: { title?: string; children: ReactNode }) {
  return (
    <MainLayout title={title}>
      <div className='grid min-h-svh lg:grid-cols-2'>
        <div className='flex flex-col gap-4 p-6 md:p-10'>
          <div className='flex justify-center gap-2 md:justify-start'>
            <LogoLink />
          </div>
          <div className='flex flex-1 items-center justify-center'>
            <div className='w-full max-w-xs'>{children}</div>
          </div>
        </div>
        <div className='relative hidden bg-muted lg:block'>
          <img
            src='/images/placeholder.svg'
            alt=''
            className='absolute inset-0 h-full w-full object-cover dark:brightness-[0.2] dark:grayscale'
          />
        </div>
      </div>
    </MainLayout>
  )
}

AuthLayout.SignupLink = () => (
  <FooterLink>
    Don&apos;t have an account? <Link href={signup.get().url}>Sign up</Link>
  </FooterLink>
)

AuthLayout.LoginLink = () => (
  <FooterLink>
    Already have an account? <Link href={login.get().url}>Sign in</Link>
  </FooterLink>
)

AuthLayout.FooterLink = FooterLink

AuthLayout.Header = ({ title, description }: { title: string; description: string }) => (
  <div className='flex flex-col items-center gap-1 text-center'>
    <Text.H2B asChild>
      <h1>{title}</h1>
    </Text.H2B>
    <Text.H5 centered textBalance asChild color='mutedForeground'>
      <p>{description}</p>
    </Text.H5>
  </div>
)

export default AuthLayout
