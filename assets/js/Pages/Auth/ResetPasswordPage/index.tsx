import { Link, Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { index as register } from '@/actions/Auth/RegisterController'
import { create } from '@/actions/Auth/ResetPasswordsController'
import AuthLayout from '@/Layouts/AuthLayout'

function ResetPasswordPage({ email }: { email?: string }) {
  return (
    <>
      <div>
        <h1>Reset Password</h1>
        <p>
          Forgot your password? No problem. Just let us know your email address and we will email
          you a password reset link that will allow you to choose a new one.
        </p>
      </div>

      <Form action={create()}>
        {({ errors, processing }) => (
          <>
            <div>
              <label htmlFor="email">Email address</label>
              <input
                id="email"
                name="email"
                type="email"
                defaultValue={email}
                placeholder="Enter your email"
              />
              {errors.email && <p>{errors.email}</p>}
            </div>

            <button type="submit" disabled={processing}>
              Send Password Reset Link
            </button>
          </>
        )}
      </Form>

      <div>
        <p>
          Need an account? <Link href={register.url().path}>Create one</Link>
        </p>
      </div>
    </>
  )
}

ResetPasswordPage.layout = (children: ReactNode) => (
  <AuthLayout title="Reset Password">{children}</AuthLayout>
)

export default ResetPasswordPage
