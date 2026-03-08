defmodule AshLearning.Factories.UserFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      use Ash.Generator

      alias AshLearning.Accounts.User

      def valid_user_password, do: "Secret_Password1234!@#"

      @doc """
      A changeset generator for account owners.

      Pass it to `generate/1` to create a user via the `:register_with_password` action,
      or to `generate_many/2` to create many.

      Overrides can be passed as a keyword list to customize the generated input:

      generate(account_owner_generator())
      generate(account_owner_generator(email: "specific@example.com"))
      """
      def account_owner_generator(opts \\ []) do
        changeset_generator(
          User,
          :register_with_password,
          defaults: [
            email: sequence(:user_email, &"user#{&1}@example.com"),
            password: valid_user_password(),
            password_confirmation: valid_user_password()
          ],
          after_action: fn user ->
            Ash.Seed.update!(user, %{confirmed_at: DateTime.utc_now()})
          end,
          overrides: opts
        )
      end

      @doc """
      Convenience: generate an account owner and return it along with the
      plaintext password (useful for login tests).

      Emails are normalized to plain strings to play nicely with browser test
      helpers like `fill_in/3` (since Ash's default email type is `Ash.CiString`).
      """
      def account_owner(opts \\ []) do
        user = generate(account_owner_generator(opts))

        user = %{user | email: to_string(user.email)}

        %{user: user, password: valid_user_password()}
      end
    end
  end
end
