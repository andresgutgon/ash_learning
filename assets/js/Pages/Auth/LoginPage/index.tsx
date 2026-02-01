import { Form, Link } from '@inertiajs/react'
import { ReactNode, useCallback } from 'react'

import { index as register } from '@/actions/Auth/RegisterController'
import { index as resetPassword } from '@/actions/Auth/ResetPasswordsController'
import { create as login } from '@/actions/Auth/SessionsController'
import { MagicLinkForm } from '@/components/Auth/MagicLinkForm'
import AuthLayout from '@/Layouts/AuthLayout'
import { OAuthProvider } from '@/types'

type Props = {
  return_to: string
  oauth_providers: OAuthProvider[]
}

function LoginPage({ return_to, oauth_providers }: Props) {
  const resetPasswordUrl = useCallback((formData: object) => {
    const resetPath = resetPassword.url().path
    const email = 'email' in formData ? formData.email : null
    return email ? `${resetPath}?email=${email}` : resetPath
  }, [])

  return (
    <>
      <div>
        <h1>Welcome Back</h1>
        <p>Login to your account to continue learning</p>
      </div>

      <Form action={login()}>
        {({ errors, getData, processing }) => (
          <>
            <input type="hidden" name="return_to" value={return_to} />

            <div>
              <label htmlFor="email">Email address</label>
              <input id="email" type="email" name="email" placeholder="Enter your email" />
              {errors.email && <p>{errors.email}</p>}
            </div>

            <div>
              <label htmlFor="password">Password</label>
              <input
                id="password"
                type="password"
                name="password"
                placeholder="Enter your password"
              />
              {errors.password && <p>{errors.password}</p>}
            </div>

            <Link href={resetPasswordUrl(getData())}>Forgot your password?</Link>

            <div>
              <input type="checkbox" id="remember_me" name="remember_me" />
              <label htmlFor="remember_me">Remember me on this device</label>
            </div>

            <button type="submit" disabled={processing}>
              Login
            </button>
          </>
        )}
      </Form>

      <div>
        <p>
          Need an account? <Link href={register.url().path}>Create one</Link>
        </p>
      </div>

      <hr />
      <p>Use other methods</p>

      <div>
        {oauth_providers.map((provider) => (
          <a className="block" key={provider.name} href={provider.auth_url}>
            Continue with {provider.display_name}
          </a>
        ))}
      </div>

      <hr />
      <p>Or continue with email</p>

      <MagicLinkForm returnTo={return_to} />
    </>
  )
}

LoginPage.layout = (children: ReactNode) => <AuthLayout title="Login">{children}</AuthLayout>

export default LoginPage
