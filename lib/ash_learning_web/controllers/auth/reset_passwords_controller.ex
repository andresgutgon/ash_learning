defmodule AshLearningWeb.Auth.ResetPasswordsController do
  use AshLearningWeb, :controller

  alias AshAuthentication.Info
  alias AshLearning.Accounts
  alias AshLearning.Accounts.User

  def index(conn, params) do
    email = Map.get(params, "email")

    conn
    |> render_inertia("Auth/ResetPasswordPage", %{email: email})
  end

  def create(conn, %{"email" => email}) do
    case Accounts.request_password(%{email: email}) do
      :ok ->
        conn
        |> put_flash(
          :info,
          "If your email is in our system, you will receive reset instructions shortly."
        )
        |> redirect(to: ~p"/login")

      {:error, errors} ->
        conn
        |> assign_errors(errors)
        |> render_inertia("Auth/ResetPasswordPage", %{email: email})
    end
  end

  def edit(conn, params) do
    reset_token = Map.get(params, "id", "")

    conn
    |> assign_prop(:reset_token, reset_token)
    |> render_inertia("Auth/ResetPasswordEditPage")
  end

  def update(conn, params) do
    case AshAuthentication.Strategy.action(
           Info.strategy!(User, :password),
           :reset,
           %{
             "reset_token" => params["reset_token"],
             "password" => params["password"],
             "password_confirmation" => params["password_confirmation"]
           },
           domain: Info.authentication_domain!(User),
           authorize?: false
         ) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password reset successfully! You can now log in.")
        |> redirect(to: ~p"/login")

      {:error, errors} ->
        conn
        |> assign_errors(errors)
        |> assign_prop(:reset_token, params["reset_token"])
        |> render_inertia("Auth/ResetPasswordEditPage")
    end
  end
end
