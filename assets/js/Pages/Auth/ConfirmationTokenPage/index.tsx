import { Form, Link } from '@inertiajs/react'
import { ReactNode } from 'react'

import { update as magicLinkUpdate } from '@/actions/Auth/MagicLinkController'
import { update as registerUpdate } from '@/actions/Auth/RegisterController'
import { login } from '@/actions/Auth/SessionsController'
import AuthLayout from '@/Layouts/AuthLayout'

type Props = {
  token: string
  action_type: 'register' | 'magic_link'
}

function ConfirmationTokenPage({ token, action_type }: Props) {
  const action = action_type === 'register' ? registerUpdate(token) : magicLinkUpdate(token)

  return (
    <>
      <div>
        <h1>Complete Sign In</h1>
        <p>Click the button below to sign in to your account.</p>
      </div>

      <Form action={action}>
        {({ processing }) => (
          <button type="submit" disabled={processing}>
            Sign In Now
          </button>
        )}
      </Form>

      <Link href={login.url().path}>Back to Login</Link>
    </>
  )
}

ConfirmationTokenPage.layout = (children: ReactNode) => (
  <AuthLayout title="Confirm">{children}</AuthLayout>
)

export default ConfirmationTokenPage
