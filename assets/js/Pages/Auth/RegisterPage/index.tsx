import { ReactNode } from "react";
import { Form, Link } from "@inertiajs/react";
import AuthLayout from "@/Layouts/AuthLayout";
import { login } from "@/actions/Auth/SessionsController";
import { create as register } from "@/actions/Auth/RegisterController";
import { OAuthProvider } from "@/types";
import { MagicLinkForm } from "@/components/Auth/MagicLinkForm";

/**
 * TODO: Use Inertia.js `<Form />`
 */
function RegisterPage({
  return_to,
  oauth_providers,
}: {
  return_to: string;
  oauth_providers: OAuthProvider[];
}) {
  return (
    <>
      <div>
        <h1>Create Account</h1>
        <p>Join us and start your journey</p>
      </div>

      <Form action={register()}>
        {({ errors, processing }) => (
          <>
            <input type="hidden" name="return_to" value={return_to} />

            <div>
              <label htmlFor="email">Email address</label>
              <input
                id="email"
                type="email"
                name="email"
                autoComplete="username"
                placeholder="Enter your email"
              />
              {errors.email && <p>{errors.email}</p>}
            </div>

            <div>
              <label htmlFor="password">Password</label>
              <input
                id="password"
                type="password"
                name="password"
                autoComplete="new-password"
                placeholder="Create a password"
              />
              {errors.password && <p>{errors.password}</p>}
            </div>

            <div>
              <label htmlFor="password_confirmation">Confirm Password</label>
              <input
                type="password"
                id="password_confirmation"
                name="password_confirmation"
                autoComplete="new-password"
                placeholder="Confirm your password"
              />
              {errors.password_confirmation && (
                <p>{errors.password_confirmation}</p>
              )}
            </div>

            <button type="submit" disabled={processing}>
              Create Account
            </button>
          </>
        )}
      </Form>

      <div>
        <p>
          Already have an account? <Link href={login.url().path}>Sign in</Link>
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
  );
}

RegisterPage.layout = (children: ReactNode) => (
  <AuthLayout title="Register">{children}</AuthLayout>
);

export default RegisterPage;
