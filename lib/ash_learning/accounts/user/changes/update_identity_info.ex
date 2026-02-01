defmodule AshLearning.Accounts.User.Changes.UpdateIdentityInfo do
  @moduledoc """
  Updates the user's identity record with information from OAuth provider.

  ## Options

    * `:strategy` - The OAuth strategy name (e.g., "google", "github"). Required.
    * `:mappings` - A keyword list mapping identity fields to user_info keys.
      Example: `[avatar_url: "picture", full_name: "name"]`

  ## Example

      change {UpdateIdentityInfo, strategy: "google", mappings: [avatar_url: "picture", full_name: "name"]}
      change {UpdateIdentityInfo, strategy: "github", mappings: [avatar_url: "avatar_url", full_name: "name"]}
  """
  use Ash.Resource.Change

  import Ash.Expr
  require Ash.Query

  alias AshLearning.Accounts.User.Changes.OAuthHelpers
  alias AshLearning.Accounts.UserIdentity

  @impl true
  def change(changeset, opts, _context) do
    strategy = Keyword.fetch!(opts, :strategy)
    mappings = Keyword.get(opts, :mappings, [])

    Ash.Changeset.after_action(changeset, fn _changeset, user ->
      user_info = Ash.Changeset.get_argument(changeset, :user_info)
      uid = OAuthHelpers.extract_uid(user_info)

      identity =
        UserIdentity
        |> Ash.Query.for_read(:read)
        |> Ash.Query.filter(expr(user_id == ^user.id and strategy == ^strategy and uid == ^uid))
        |> Ash.read_one!()

      update_params =
        Enum.reduce(mappings, %{}, fn {identity_field, user_info_key}, acc ->
          Map.put(acc, identity_field, user_info[user_info_key])
        end)

      identity
      |> Ash.Changeset.for_update(:update, update_params)
      |> Ash.update!()

      {:ok, user}
    end)
  end
end
