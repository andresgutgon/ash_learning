defmodule AshLearning.Accounts.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: AshLearning.Accounts

  alias AshLearning.Accounts.UserIdentity.Actions.Disconnect

  postgres do
    table "user_identities"
    repo AshLearning.Repo
  end

  user_identity do
    user_resource AshLearning.Accounts.User
  end

  attributes do
    attribute :email, :string, public?: true
    attribute :avatar_url, :string, public?: true
    attribute :full_name, :string, public?: true
    attribute :provider_name, :string, public?: true
  end

  actions do
    defaults [:read]

    update :update do
      accept [:avatar_url, :full_name]
    end

    action :disconnect, :atom do
      argument :user_id, :uuid, allow_nil?: false
      argument :provider, :string, allow_nil?: false
      argument :uid, :string, allow_nil?: false

      run Disconnect
    end
  end
end
