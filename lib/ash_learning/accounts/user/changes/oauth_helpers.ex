defmodule AshLearning.Accounts.User.Changes.OAuthHelpers do
  @moduledoc """
  Shared helpers for OAuth-related changes.
  """

  @doc """
  Extracts the uid from OAuth user_info.

  Matches AshAuthentication.UserIdentity.UpsertIdentityChange logic.
  uid is a convention, sub is from OpenID spec, id is from some providers.
  """
  def extract_uid(user_info) do
    user_info
    |> Map.take(["uid", "sub", "id", :uid, :sub, :id])
    |> Map.values()
    |> Enum.reject(&is_nil/1)
    |> List.first()
    |> to_string()
  end
end
