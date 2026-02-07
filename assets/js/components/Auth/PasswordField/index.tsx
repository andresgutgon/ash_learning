import { FormDataConvertible } from '@inertiajs/core'
import { Link } from '@inertiajs/react'
import { useCallback } from 'react'

import { index as resetPassword } from '@/actions/Auth/ResetPasswordsController'
import { Input } from '@/ui/atoms/Input'
import { Text } from '@/ui/atoms/Text'
import { Field, FieldLabel, FieldError } from '@/ui/molecules/Form/Field'

export function PasswordField({
  errors,
  getData,
  showPasswordConfirmation,
}: {
  errors: Record<string, string>
  showPasswordConfirmation?: boolean
  getData?: () => Record<string, FormDataConvertible>
}) {
  const resetPasswordUrl = useCallback((formData: Record<string, any>) => {
    const resetPath = resetPassword.url().path
    const email = typeof formData.email === 'string' ? formData.email : ''
    return email ? `${resetPath}?email=${encodeURIComponent(email)}` : resetPath
  }, [])
  const resetUrl = getData ? resetPasswordUrl(getData()) : null
  return (
    <>
      <Field>
        <div className='flex items-center'>
          <FieldLabel htmlFor='password'>Password</FieldLabel>
          {resetUrl ? (
            <Text.H5 asChild underlineHover className='ml-auto'>
              <Link href={resetUrl}>Forgot your password?</Link>
            </Text.H5>
          ) : null}
        </div>
        <Input id='password' name='password' type='password' required placeholder='••••••••' />
        <FieldError error={errors.password} />
      </Field>
      {showPasswordConfirmation ? (
        <Field>
          <FieldLabel htmlFor='password_confirmation'>Confirm Password</FieldLabel>
          <Input
            id='password_confirmation'
            name='password_confirmation'
            type='password'
            required
            placeholder='••••••••'
          />
          <FieldError error={errors.password_confirmation} />
        </Field>
      ) : null}
    </>
  )
}
