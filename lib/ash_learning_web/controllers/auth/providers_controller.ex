defmodule AshLearningWeb.Auth.ProvidersController do
  use AshLearningWeb, :controller

  def delete(conn, %{"provider" => provider, "uid" => uid}) do
    current_user = conn.assigns.current_user

    case disconnect_identity(current_user, provider, uid) do
      {:ok, _} ->
        conn
        |> put_flash(
          :info,
          "#{provider_display_name(provider)} account disconnected successfully!"
        )
        |> redirect(to: ~p"/dashboard")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to disconnect #{provider_display_name(provider)} account.")
        |> redirect(to: ~p"/dashboard")
    end
  end

  defp disconnect_identity(user, provider, uid) do
    AshLearning.Accounts.UserIdentity
    |> Ash.ActionInput.for_action(:disconnect, %{user_id: user.id, provider: provider, uid: uid})
    |> Ash.run_action(domain: AshLearning.Accounts)
  end

  defp provider_display_name("github"), do: "GitHub"
  defp provider_display_name("google"), do: "Google"
  defp provider_display_name(provider), do: String.capitalize(provider)
end
