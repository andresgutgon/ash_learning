defmodule AshLearningWeb.Account.ConnectionsController do
  use AshLearningWeb, :controller

  alias AshLearningWeb.Auth, as: AuthHelpers

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    identities = load_user_identities(current_user)

    conn
    |> render_inertia("Account/ConnectionsPage", %{
      providers: AuthHelpers.oauth_providers(),
      identities: serialize_identities(identities)
    })
  end

  def delete(conn, %{"provider" => provider, "uid" => uid}) do
    current_user = conn.assigns.current_user
    provider_name = AuthHelpers.strategy_display_name(%{name: String.to_existing_atom(provider)})

    case disconnect_identity(current_user, provider, uid) do
      {:ok, _} ->
        conn
        |> put_flash(
          :info,
          "#{provider_name} account disconnected successfully!"
        )
        |> redirect(to: ~p"/account/connections")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to disconnect #{provider_name} account.")
        |> redirect(to: ~p"/account/connections")
    end
  end

  defp disconnect_identity(user, provider, uid) do
    AshLearning.Accounts.UserIdentity
    |> Ash.ActionInput.for_action(:disconnect, %{user_id: user.id, provider: provider, uid: uid})
    |> Ash.run_action(domain: AshLearning.Accounts)
  end

  defp load_user_identities(user) do
    case Ash.load(user, :identities, domain: AshLearning.Accounts) do
      {:ok, user_with_identities} -> user_with_identities.identities
      _ -> []
    end
  end

  defp serialize_identities(identities) do
    Enum.map(identities, fn identity ->
      %{
        id: identity.id,
        uid: identity.uid,
        strategy: to_string(identity.strategy),
        email: identity.email,
        avatar_url: identity.avatar_url,
        full_name: identity.full_name
      }
    end)
  end
end
