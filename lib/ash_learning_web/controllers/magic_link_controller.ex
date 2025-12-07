defmodule AshLearningWeb.MagicLinkController do
  use AshLearningWeb, :controller

  alias AshAuthentication.Info
  alias AshLearning.Accounts.User
  alias AshLearningWeb.ConfirmationTokenHTML
  alias AshLearningWeb.Controllers.AuthHelpers

  def create(conn, %{"user" => %{"email" => email, "return_to" => return_to}}) do
    return_to = AuthHelpers.get_return_to(conn, %{"return_to" => return_to})
    conn = AuthHelpers.save_return_to(conn, return_to)

    case call_action(action: :request, params: %{"email" => email}) do
      :ok ->
        conn
        |> put_flash(:info, "Magic link sent! Check your email.")
        |> redirect(to: ~p"/register")

      {:error, _} ->
        conn
        |> put_flash(:error, "Error sending magic link. Please try again.")
        |> redirect(to: ~p"/register")
    end
  end

  def edit(conn, %{"id" => token}) do
    strategy = AshAuthentication.Info.strategy!(User, :magic_link)

    ConfirmationTokenHTML.render_token(conn, %{
      page_title: "Confirm Sign In",
      token: token,
      token_name: "token",
      strategy: strategy,
      action_name: strategy.sign_in_action_name,
      action_url: ~p"/magic-link/#{token}",
      back_link_url: ~p"/login"
    })
  end

  def update(conn, %{"id" => token} = params) do
    return_to = AuthHelpers.get_return_to(conn, params)

    case call_action(action: :sign_in, params: %{"token" => token}) do
      {:ok, user} ->
        conn
        |> AuthHelpers.store_in_session(user)
        |> delete_session(:return_to)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: return_to)

      {:error, _error} ->
        conn
        |> put_flash(:error, "Invalid or expired magic link.")
        |> redirect(to: ~p"/login")
    end
  end

  defp call_action(action: action, params: params) do
    AshAuthentication.Strategy.action(
      AshAuthentication.Info.strategy!(User, :magic_link),
      action,
      params,
      domain: Info.authentication_domain!(User),
      authorize?: false
    )
  end
end
