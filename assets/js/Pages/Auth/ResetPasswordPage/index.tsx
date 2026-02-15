import { Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { create } from '@/actions/Auth/ResetPasswordsController'
import AuthLayout from '@/Layouts/AuthLayout'
import { Button } from '@/ui/atoms/Button'
import { Input } from '@/ui/atoms/Input'
import { Field, FieldError, FieldLabel, FieldGroup } from '@/ui/molecules/Form/Field'

function ResetPasswordPage({ email }: { email?: string }) {
  return (
    <Form action={create()}>
      {({ errors, processing }) => (
        <FieldGroup>
          <AuthLayout.Header
            title='Reset your password'
            description='Enter your email address and we will send you a link to reset your password.'
          />
          <Field>
            <FieldLabel htmlFor='email'>Email</FieldLabel>
            <Input
              id='email'
              name='email'
              type='email'
              defaultValue={email}
              placeholder='m@example.com'
              autoComplete='email'
              required
            />
            <FieldError error={errors.email} />
          </Field>
          <Button type='submit' disabled={processing}>
            Reset Password
          </Button>

          <AuthLayout.SignupLink />
        </FieldGroup>
      )}
    </Form>
  )
}

ResetPasswordPage.layout = (children: ReactNode) => (
  <AuthLayout title='Reset Password'>{children}</AuthLayout>
)

export default ResetPasswordPage
