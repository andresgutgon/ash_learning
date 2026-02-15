import { Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { create as register } from '@/actions/Auth/RegisterController'
import { OuathConnectButtons } from '@/components/Auth/OuathConnectButtons'
import { PasswordField } from '@/components/Auth/PasswordField'
import { usePassword } from '@/components/Auth/PasswordField/usePassword'
import AuthLayout from '@/Layouts/AuthLayout'
import { OAuthProvider, OauthStrategy } from '@/types'
import { Button } from '@/ui/atoms/Button'
import { Input } from '@/ui/atoms/Input'
import {
  Field,
  FieldError,
  FieldLabel,
  FieldGroup,
  FieldSeparator,
} from '@/ui/molecules/Form/Field'

function RegisterPage({
  return_to,
  oauth_providers,
}: {
  return_to: string
  oauth_providers: OAuthProvider<OauthStrategy>[]
}) {
  const { action, showPassword, toggle } = usePassword({ route: register() })
  return (
    <Form action={action} resetOnSuccess>
      {({ errors, processing }) => (
        <FieldGroup>
          <AuthLayout.Header
            title='Create your account'
            description='Join us and start your journey'
          />
          <input type='hidden' name='return_to' value={return_to} />

          <Field>
            <FieldLabel htmlFor='email'>Email</FieldLabel>
            <Input id='email' name='email' type='email' placeholder='m@example.com' required />
            <FieldError error={errors.email} />
          </Field>

          {showPassword && <PasswordField showPasswordConfirmation errors={errors} />}
          <Field>
            <Button type='submit' disabled={processing}>
              {showPassword ? 'Create account' : 'Send Magic Link'}
            </Button>
            <Button type='button' variant='outline' onClick={toggle}>
              {showPassword ? 'Use magic link instead' : 'Use password instead'}{' '}
            </Button>
          </Field>
          <FieldSeparator>Or continue with</FieldSeparator>
          <OuathConnectButtons providers={oauth_providers} />
          <AuthLayout.LoginLink />
        </FieldGroup>
      )}
    </Form>
  )
}

RegisterPage.layout = (children: ReactNode) => <AuthLayout title='Register'>{children}</AuthLayout>

export default RegisterPage
