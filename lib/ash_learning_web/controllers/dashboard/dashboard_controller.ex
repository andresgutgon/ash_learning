defmodule AshLearningWeb.Dashboard.DashboardIndexController do
  use AshLearningWeb, :controller

  alias AshLearningWeb.Auth, as: AuthHelpers

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    identities = load_user_identities(current_user)

    conn
    |> render_inertia("Dashboard/DashboardPage", %{
      oauth_providers: AuthHelpers.oauth_providers(),
      identities: serialize_identities(identities),
      user_email: to_string(current_user.email)
    })
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
