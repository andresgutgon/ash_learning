
import { ComponentProps, ReactNode } from 'react'
import { Link } from '@inertiajs/react'
import MainLayout from '@/Layouts/MainLayout'
import { index as signup } from '@/actions/Auth/RegisterController'
import { login } from '@/actions/Auth/SessionsController'
import { useHost } from '@/hooks/useHost'

function AuthLink({ text, href }: { text: string; href: string }) {
  // return (
  //   <Text.H5 asChild underline>
  //     <Link href={href}>{text}</Link>
  //   </Text.H5>
  // )
  return <Link href={href}>{text}</Link>
}

function FooterLink({ children }: { children: ReactNode }) {
  // return (
  //   <Text.H5 fullWidth align='center' display='block'>
  //     {children}
  //   </Text.H5>
  // )
  return children
}

function AuthLayout({
  title,
  card,
  showToS = false,
  children,
}: {
  title?: string
  card?: {
    title: string
    description: string
    footer?: ReactNode
    // variant?: ComponentProps<typeof Card>['variant']
  }
  showToS?: boolean
  children: ReactNode
}) {
  const { buildSiteUrl } = useHost()
  return (
    <MainLayout title={title}>
      <div className='bg-sidebar flex min-h-svh flex-col items-center justify-center gap-6 p-6 md:p-10'>
        <div className='flex w-full max-w-sm flex-col gap-6'>
          <a
            href={buildSiteUrl()}
            className='flex items-center gap-2 self-center'
          >
            <div className='text-primary dark:text-foreground'>
              {/* LOGO Here. Ignore do not change for now */}
            </div>
          </a>
          <div className='flex flex-col gap-6'>
            {card ? (
              <div className='grid gap-6'>{children}</div>
            ) : (
              children
            )}
            {showToS ? (
              <>
                By clicking continue, you agree to our{' '}
                  <a href='#'>Terms of Service</a>
                and{' '}
                  <a href='#'>Privacy Policy</a>
                .{' '}
              </>
            ) : null}
          </div>
        </div>
      </div>
    </MainLayout>
  )
}

AuthLayout.goSignup = () => (
  <FooterLink>
    Don&apos;t have an account?{' '}
    <AuthLink text='Sign up' href={signup.get().url} />
  </FooterLink>
)

AuthLayout.goLogin = () => (
  <FooterLink>
    Already have an account? <AuthLink text='Login' href={login.get().url} />
  </FooterLink>
)

export default AuthLayout
