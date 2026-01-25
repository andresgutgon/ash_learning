defmodule AshLearning.Accounts.User.Actions.MagicLinkActions do
  @moduledoc """
  Actions for signing in or registering a user via magic link.
  """

  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    action :request_magic_link do
      argument :email, :ci_string do
        allow_nil? false
      end

      validate match(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/) do
        message "must be a valid email address"
      end

      run AshAuthentication.Strategy.MagicLink.Request
    end

    create :sign_in_with_magic_link do
      description "Sign in or register a user with magic link."

      argument :token, :string do
        description "The token from the magic link that was sent to the user"
        allow_nil? false
      end

      upsert? true
      upsert_identity :unique_email
      upsert_fields [:email]

      change AshAuthentication.Strategy.MagicLink.SignInChange

      metadata :token, :string do
        allow_nil? false
      end
    end
  end
end
