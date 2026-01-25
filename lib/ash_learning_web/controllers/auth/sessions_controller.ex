defmodule AshLearningWeb.Auth.SessionsController do
  use AshLearningWeb, :controller

  alias AshLearningWeb.Auth, as: AuthHelpers
  alias AshLearning.Accounts

  def index(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)

    conn
    |> AuthHelpers.save_return_to(return_to)
    |> render_inertia("Auth/LoginPage", %{
      return_to: return_to,
      oauth_providers: oauth_providers()
    })
  end

  def create(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)

    case Accounts.signin(%{
           email: params["email"],
           password: params["password"],
           remember_me: !!params["remember_me"]
         }) do
      {:ok, user} ->
        conn
        |> AuthHelpers.store_in_session(user)
        |> delete_session(:return_to)
        |> AuthHelpers.maybe_put_remember_me(user)
        |> put_flash(:info, "You're now signed in")
        |> redirect(to: return_to)

      {:error, errors} ->
        conn
        |> AuthHelpers.save_return_to(return_to)
        |> assign_errors(errors)
        |> render_inertia("Auth/LoginPage", %{
          return_to: return_to,
          oauth_providers: oauth_providers()
        })
    end
  end

  def delete(conn, params) do
    AuthHelpers.sign_out(conn, params)
  end

  defp oauth_providers do
    AuthHelpers.oauth_providers()
  end
end
