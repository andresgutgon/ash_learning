defmodule AshLearning.Accounts.UserIdentity.Actions.Disconnect do
  @moduledoc """
  Action implementation for disconnecting user identities
  """

  require Ash.Query

  def run(input, _opts, _context) do
    user_id = input.arguments.user_id
    provider = input.arguments.provider
    uid = input.arguments.uid

    case find_identity(user_id, provider, uid) do
      {:ok, nil} ->
        {:ok, :not_found}

      {:ok, identity} ->
        case Ash.destroy(identity, domain: AshLearning.Accounts) do
          :ok -> {:ok, :disconnected}
          {:ok, _} -> {:ok, :disconnected}
          {:error, error} -> {:error, error}
        end
    end
  end

  defp find_identity(user_id, provider, uid) do
    AshLearning.Accounts.UserIdentity
    |> Ash.Query.filter(user_id: user_id, strategy: provider, uid: uid)
    |> Ash.read_one(domain: AshLearning.Accounts)
  end
end
