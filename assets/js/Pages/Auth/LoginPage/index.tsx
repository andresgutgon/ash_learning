import { Form } from '@inertiajs/react'
import { ReactNode } from 'react'

import { create as login } from '@/actions/Auth/SessionsController'
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

type Props = {
  return_to: string
  oauth_providers: OAuthProvider<OauthStrategy>[]
}

function LoginPage({ return_to, oauth_providers }: Props) {
  const { action, showPassword, toggle } = usePassword({ route: login() })

  return (
    <Form action={action}>
      {({ errors, getData, processing }) => (
        <FieldGroup>
          <AuthLayout.Header
            title='Login to your account'
            description='Welcome back! Please enter your details to continue.'
          />
          <input type='hidden' name='return_to' value={return_to} />
          <Field>
            <FieldLabel htmlFor='email'>Email</FieldLabel>
            <Input id='email' name='email' type='email' placeholder='m@example.com' required />
            <FieldError error={errors.email} />
          </Field>
          {showPassword && (
            <PasswordField showPasswordConfirmation={false} errors={errors} getData={getData} />
          )}
          <Field>
            <Button type='submit' disabled={processing}>
              {showPassword ? 'Login' : 'Send Magic Link'}
            </Button>
            <Button type='button' variant='outline' onClick={toggle}>
              {showPassword ? 'Use magic link instead' : 'Use password instead'}{' '}
            </Button>
          </Field>

          <FieldSeparator>Or continue with</FieldSeparator>

          <OuathConnectButtons providers={oauth_providers} />
          <AuthLayout.SignupLink />
        </FieldGroup>
      )}
    </Form>
  )
}

LoginPage.layout = (children: ReactNode) => <AuthLayout title='Login'>{children}</AuthLayout>

export default LoginPage
