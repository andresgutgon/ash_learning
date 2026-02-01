defmodule AshLearning.Accounts.User.Actions.GoogleOAuthActions do
  @moduledoc """
  Actions for signing in or registering a user via Google OAuth.
  """
  alias AshAuthentication.Strategy.OAuth2

  alias AshLearning.Accounts.User.Changes.{
    RequireConfirmedUser,
    SetEmailFromUserInfo,
    UpdateIdentityInfo
  }

  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    create :register_with_google do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false

      upsert? true
      upsert_identity :unique_email
      upsert_fields []

      change AshAuthentication.GenerateTokenChange
      change OAuth2.IdentityChange
      change {SetEmailFromUserInfo, strategy: "google"}

      change {UpdateIdentityInfo,
              strategy: "google", mappings: [avatar_url: "picture", full_name: "name"]}

      change RequireConfirmedUser
    end
  end
end
