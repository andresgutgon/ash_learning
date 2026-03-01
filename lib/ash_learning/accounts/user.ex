defmodule AshLearning.Accounts.User do
  @moduledoc false
  alias AshLearning.Accounts.User.Actions

  use Ash.Resource,
    otp_app: :ash_learning,
    domain: AshLearning.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication],
    fragments: [
      Actions.PasswordActions,
      Actions.MagicLinkActions,
      Actions.GoogleOAuthActions,
      Actions.GithubOauthActions
    ]

  postgres do
    table "users"
    repo AshLearning.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: true, sensitive?: true

    attribute :confirmed_at, :utc_datetime_usec
  end

  relationships do
    has_many :identities, AshLearning.Accounts.UserIdentity do
      destination_attribute :user_id
      public? true
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    # Public actions
    policy action([
             :register_with_password,
             :sign_in_with_password,
             :request_password_reset_token
           ]) do
      authorize_if always()
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end

      confirmation :confirm_new_user do
        monitor_fields [:email]
        confirm_on_create? true
        confirm_on_update? true

        # Display a UI to confirm the email
        # Confirm screen is more secure
        # Avoid confirming email on GET request.
        require_interaction? true

        confirmed_at_field :confirmed_at

        auto_confirm_actions [
          :sign_in_with_magic_link,
          :reset_password_with_token,
          :register_with_google,
          :register_with_github
        ]

        sender AshLearning.Accounts.User.Senders.SendNewUserConfirmationEmail
      end
    end

    tokens do
      enabled? true
      token_resource AshLearning.Accounts.Token
      signing_secret AshLearning.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    strategies do
      password :password do
        identity_field :email
        hash_provider AshAuthentication.BcryptProvider
        require_confirmed_with :confirmed_at

        resettable do
          sender AshLearning.Accounts.User.Senders.SendPasswordResetEmail
          password_reset_action_name :reset_password_with_token
          request_password_reset_action_name :request_password_reset_token
        end
      end

      remember_me do
        sign_in_action_name :sign_in_with_remember_me
        cookie_name :remember_me
        token_lifetime {30, :days}
      end

      magic_link do
        identity_field :email
        registration_enabled? true
        require_interaction? true

        sender AshLearning.Accounts.User.Senders.SendMagicLinkEmail
      end

      github do
        client_id AshLearning.Secrets
        redirect_uri AshLearning.Secrets
        client_secret AshLearning.Secrets
        identity_resource AshLearning.Accounts.UserIdentity
      end

      google do
        client_id AshLearning.Secrets
        redirect_uri AshLearning.Secrets
        client_secret AshLearning.Secrets
        identity_resource AshLearning.Accounts.UserIdentity
      end
    end
  end

  actions do
    defaults [:read]

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end

    read :get_by_email do
      description "Looks up a user by their email"
      argument :email, :ci_string, allow_nil?: false
      get_by :email
    end
  end
end
