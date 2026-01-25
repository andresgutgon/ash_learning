defmodule AshLearningWeb.Auth.MagicLinkController do
  use AshLearningWeb, :controller

  alias AshAuthentication.Info
  alias AshLearning.Accounts.User
  alias AshLearningWeb.Auth, as: AuthHelpers

  def create(conn, %{"email" => email, "return_to" => return_to}) do
    return_to = AuthHelpers.get_return_to(conn, %{"return_to" => return_to})
    conn = AuthHelpers.save_return_to(conn, return_to)

    case call_action(action: :request, params: %{"email" => email}) do
      :ok ->
        conn
        |> put_flash(:info, "Magic link sent! Check your email.")
        |> redirect(to: ~p"/register")

      {:error, errors} ->
        conn
        |> assign_errors(errors)
        |> redirect(to: ~p"/register")
    end
  end

  def edit(conn, %{"id" => token}) do
    conn
    |> render_inertia("Auth/ConfirmationTokenPage", %{
      token: token,
      action_type: "magic_link"
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
