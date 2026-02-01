import { Form } from '@inertiajs/react'

import { create as magicLink } from '@/actions/Auth/MagicLinkController'

export function MagicLinkForm({ returnTo }: { returnTo: string }) {
  return (
    <Form action={magicLink()}>
      {({ errors, processing }) => (
        <>
          <input type="hidden" name="return_to" value={returnTo} />
          <div>
            <label htmlFor="magic-link-email">Email address</label>
            <input
              id="magic-link-email"
              type="text"
              name="email"
              placeholder="Enter your email"
              required
            />
            {errors.email && <p>{errors.email}</p>}
          </div>
          <button type="submit" disabled={processing}>
            Send Magic Link
          </button>
        </>
      )}
    </Form>
  )
}
