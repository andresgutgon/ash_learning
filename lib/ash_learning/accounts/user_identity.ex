defmodule AshLearning.Accounts.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: AshLearning.Accounts

  user_identity do
    user_resource AshLearning.Accounts.User
  end

  postgres do
    table "user_identities"
    repo AshLearning.Repo
  end

  actions do
    action :disconnect, :atom do
      argument :user_id, :uuid, allow_nil?: false
      argument :provider, :string, allow_nil?: false

      run fn input, _context ->
        user_id = input.arguments.user_id
        provider = input.arguments.provider

        # Find and destroy the identity
        case Ash.read(__MODULE__, domain: AshLearning.Accounts) do
          {:ok, identities} ->
            identity =
              Enum.find(identities, fn id ->
                id.user_id == user_id and id.strategy == provider
              end)

            if identity do
              case Ash.destroy(identity, domain: AshLearning.Accounts) do
                {:ok, _destroyed_identity} ->
                  {:ok, :disconnected}

                :ok ->
                  {:ok, :disconnected}

                {:error, error} ->
                  {:error, error}
              end
            else
              {:ok, :not_found}
            end

          {:error, error} ->
            {:error, error}
        end
      end
    end
  end

  attributes do
    # Additional fields for storing provider user info
    attribute :email, :string, public?: true
    attribute :avatar_url, :string, public?: true

    # Display name from provider
    attribute :provider_name, :string, public?: true
  end
end
