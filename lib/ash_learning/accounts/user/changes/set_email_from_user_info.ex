defmodule AshLearning.Accounts.User.Changes.SetEmailFromUserInfo do
  @moduledoc """
  Sets the email attribute from user_info, preserving actor's email if present.

  Used in OAuth registration actions to set email from the provider's user_info,
  but keeps the existing email when linking to an authenticated user.

  When no actor is present, it also checks for an existing UserIdentity
  matching the provider's uid to find and use the linked user's email.

  Returns an error if actor is present but the OAuth identity is already
  connected to a different user.
  """
  use Ash.Resource.Change

  alias AshLearning.Accounts.User.Changes.OAuthHelpers
  alias AshLearning.Accounts.UserIdentity

  require Ash.Query

  @impl true
  def change(changeset, opts, %{actor: actor}) do
    user_info = Ash.Changeset.get_argument(changeset, :user_info)
    strategy = Keyword.fetch!(opts, :strategy)
    uid = OAuthHelpers.extract_uid(user_info)

    existing_identity_user = find_existing_user_by_identity(uid, strategy)

    case determine_email(actor, existing_identity_user, user_info, strategy) do
      {:ok, email} ->
        Ash.Changeset.change_attribute(changeset, :email, email)

      {:error, message} ->
        Ash.Changeset.add_error(changeset, field: :email, message: message)
    end
  end

  # Actor present, identity belongs to a different user
  defp determine_email(actor, {:ok, existing_user}, _user_info, strategy)
       when not is_nil(actor) and existing_user.id != actor.id do
    {:error, "This #{strategy} account is already connected to another user"}
  end

  # Actor present (identity doesn't exist or belongs to same user)
  defp determine_email(actor, _existing_identity_user, _user_info, _strategy)
       when not is_nil(actor) do
    {:ok, actor.email}
  end

  # No actor, but identity exists - use existing user's email
  defp determine_email(nil, {:ok, existing_user}, _user_info, _strategy) do
    {:ok, existing_user.email}
  end

  # No actor, no identity - use email from OAuth provider
  defp determine_email(nil, :not_found, user_info, _strategy) do
    {:ok, user_info["email"]}
  end

  defp find_existing_user_by_identity(uid, strategy) do
    UserIdentity
    |> Ash.Query.filter(uid == ^uid and strategy == ^strategy)
    |> Ash.Query.load(:user)
    |> Ash.Query.limit(1)
    |> Ash.read(authorize?: false)
    |> case do
      {:ok, [%{user: user}]} when not is_nil(user) -> {:ok, user}
      _ -> :not_found
    end
  end
end
