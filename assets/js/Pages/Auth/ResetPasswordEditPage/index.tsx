import { Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { update } from '@/actions/Auth/ResetPasswordsController'
import AuthLayout from '@/Layouts/AuthLayout'

function ResetPasswordEditPage({ reset_token }: { reset_token: string }) {
  return (
    <>
      <div>
        <h1>Reset Password</h1>
        <p>Please enter your new password below.</p>
      </div>

      <Form action={update(reset_token)} options={{ preserveUrl: true }}>
        {({ errors, processing }) => (
          <>
            <input type="hidden" name="reset_token" value={reset_token} />
            <div>
              <label htmlFor="password">New password</label>
              <input
                id="password"
                type="password"
                name="password"
                placeholder="Enter your new password"
              />
              {errors.password && <p>{errors.password}</p>}
            </div>

            <div>
              <label htmlFor="password_confirmation">Confirm new password</label>
              <input
                type="password"
                id="password_confirmation"
                name="password_confirmation"
                placeholder="Confirm your new password"
              />
              {errors.password_confirmation && <p>{errors.password_confirmation}</p>}
            </div>

            <button type="submit" disabled={processing}>
              Reset Password
            </button>
          </>
        )}
      </Form>
    </>
  )
}

ResetPasswordEditPage.layout = (children: ReactNode) => (
  <AuthLayout title="Reset Password">{children}</AuthLayout>
)

export default ResetPasswordEditPage
