defmodule AshLearning.Accounts.User.Actions.GithubOauthActions do
  @moduledoc """
  Actions for signing in or registering a user via GitHub OAuth.
  """
  alias AshAuthentication.Strategy.OAuth2

  alias AshLearning.Accounts.User.Changes.{
    SetEmailFromUserInfo,
    UpdateIdentityInfo,
    RequireConfirmedUser
  }

  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    create :register_with_github do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false

      upsert? true
      upsert_identity :unique_email
      upsert_fields []

      change AshAuthentication.GenerateTokenChange
      change OAuth2.IdentityChange
      change {SetEmailFromUserInfo, strategy: "github"}

      change {UpdateIdentityInfo,
              strategy: "github", mappings: [avatar_url: "picture", full_name: "name"]}

      change RequireConfirmedUser
    end
  end
end
