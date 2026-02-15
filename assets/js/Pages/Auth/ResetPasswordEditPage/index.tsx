import { Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { update } from '@/actions/Auth/ResetPasswordsController'
import { PasswordField } from '@/components/Auth/PasswordField'
import AuthLayout from '@/Layouts/AuthLayout'
import { Button } from '@/ui/atoms/Button'
import { FieldGroup } from '@/ui/molecules/Form/Field'

function ResetPasswordEditPage({ reset_token }: { reset_token: string }) {
  return (
    <Form action={update(reset_token)} options={{ preserveUrl: true }}>
      {({ errors, processing }) => (
        <FieldGroup>
          <AuthLayout.Header
            title='Reset your password'
            description='Please enter your new password below.'
          />
          <input type='hidden' name='reset_token' value={reset_token} />
          <PasswordField showPasswordConfirmation errors={errors} />

          <Button type='submit' disabled={processing}>
            Reset Password
          </Button>
        </FieldGroup>
      )}
    </Form>
  )
}

ResetPasswordEditPage.layout = (children: ReactNode) => (
  <AuthLayout title='Reset Password'>{children}</AuthLayout>
)

export default ResetPasswordEditPage
