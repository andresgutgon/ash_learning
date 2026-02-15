import { Form, Link } from '@inertiajs/react'
import { ReactNode } from 'react'

import { update as magicLinkUpdate } from '@/actions/Auth/MagicLinkController'
import { update as registerUpdate } from '@/actions/Auth/RegisterController'
import { login } from '@/actions/Auth/SessionsController'
import AuthLayout from '@/Layouts/AuthLayout'
import { Button } from '@/ui/atoms/Button'
import { FieldGroup } from '@/ui/molecules/Form/Field'

type Props = {
  token: string
  action_type: 'register' | 'magic_link'
}

function ConfirmationTokenPage({ token, action_type }: Props) {
  const action = action_type === 'register' ? registerUpdate(token) : magicLinkUpdate(token)

  return (
    <Form action={action}>
      {({ processing }) => (
        <FieldGroup>
          <AuthLayout.Header
            title='Complete Sign In'
            description='Click the button below to sign in to your account.'
          />
          <Button type='submit' disabled={processing}>
            Enter the app
          </Button>
          <AuthLayout.FooterLink>
            <Link href={login.url().path}>Back to Login</Link>
          </AuthLayout.FooterLink>
        </FieldGroup>
      )}
    </Form>
  )
}

ConfirmationTokenPage.layout = (children: ReactNode) => (
  <AuthLayout title='Confirm'>{children}</AuthLayout>
)

export default ConfirmationTokenPage
