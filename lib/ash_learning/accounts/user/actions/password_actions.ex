defmodule AshLearning.Accounts.User.Actions.PasswordActions do
  @moduledoc """
  Action for changing a user's password.

  Requires the current password for verification before allowing
  the password to be changed.
  """

  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    create :register_with_password do
      description "Register a new user with a email and password."

      argument :email, :ci_string do
        allow_nil? false
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      argument :remember_me, :boolean do
        description "Whether to generate a remember me token."
        allow_nil? true
      end

      change set_attribute(:email, arg(:email))
      change AshAuthentication.Strategy.Password.HashPasswordChange
      change AshAuthentication.GenerateTokenChange
      change AshAuthentication.Strategy.RememberMe.MaybeGenerateTokenChange

      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end

      metadata :remember_me, :map do
        description "A map that includes the token options"
        allow_nil? true
      end
    end

    read :sign_in_with_password do
      description "Attempt to sign in using a email and password."
      get? true

      argument :email, :ci_string do
        description "The email to use for retrieving the user."
        allow_nil? false
      end

      argument :password, :string do
        description "The password to check for the matching user."
        allow_nil? false
        sensitive? true
      end

      argument :remember_me, :boolean do
        description "Whether to generate a remember me token."
        allow_nil? true
      end

      prepare AshAuthentication.Strategy.Password.SignInPreparation
      prepare AshAuthentication.Strategy.RememberMe.MaybeGenerateTokenPreparation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end

      metadata :remember_me, :map do
        description "A map with the remember me token and strategy."
        allow_nil? true
      end
    end

    action :request_password_reset_token do
      description "Send password reset instructions to a user if they exist."

      argument :email, :ci_string do
        allow_nil? false
      end

      run {AshAuthentication.Strategy.Password.RequestPasswordReset, action: :get_by_email}
    end

    update :reset_password_with_token do
      argument :reset_token, :string do
        allow_nil? false
        sensitive? true
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      validate AshAuthentication.Strategy.Password.ResetTokenValidation
      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation
      change AshAuthentication.Strategy.Password.HashPasswordChange
      change AshAuthentication.GenerateTokenChange
    end

    update :change_password do
      require_atomic? false
      accept []
      argument :current_password, :string, sensitive?: true, allow_nil?: false

      argument :password, :string,
        sensitive?: true,
        allow_nil?: false,
        constraints: [min_length: 8]

      argument :password_confirmation, :string, sensitive?: true, allow_nil?: false

      validate confirm(:password, :password_confirmation)

      validate {AshAuthentication.Strategy.Password.PasswordValidation,
                strategy_name: :password, password_argument: :current_password}

      change {AshAuthentication.Strategy.Password.HashPasswordChange, strategy_name: :password}
    end

    read :sign_in_with_remember_me do
      description "Attempt to sign in using a remember me token."
      get? true

      argument :token, :string do
        description "The remember me token."
        allow_nil? false
        sensitive? true
      end

      prepare AshAuthentication.Strategy.RememberMe.SignInPreparation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end
  end
end
