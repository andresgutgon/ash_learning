defmodule AshLearningWeb.Auth.RegisterController do
  use AshLearningWeb, :controller

  alias AshAuthentication.{Info, Strategy}
  alias AshLearning.Accounts
  alias AshLearningWeb.Auth, as: AuthHelpers

  def index(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)

    conn
    |> AuthHelpers.save_return_to(return_to)
    |> render_inertia("Auth/RegisterPage", %{
      return_to: return_to,
      oauth_providers: oauth_providers()
    })
  end

  def create(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)

    case Accounts.signup(%{
           email: params["email"],
           password: params["password"],
           password_confirmation: params["password_confirmation"],
           remember_me: !!params["remember_me"]
         }) do
      {:ok, _user} ->
        conn
        |> put_flash(
          :info,
          "Account created successfully! Please check your email to confirm your account."
        )
        |> redirect(to: ~p"/login")

      {:error, errors} ->
        conn
        |> AuthHelpers.save_return_to(return_to)
        |> assign_errors(errors)
        |> render_inertia("Auth/RegisterPage", %{
          return_to: return_to,
          oauth_providers: oauth_providers()
        })
    end
  end

  def edit(conn, %{"id" => token}) do
    conn
    |> render_inertia("Auth/ConfirmationTokenPage", %{
      token: token,
      action_type: "register"
    })
  end

  def update(conn, %{"id" => token}) do
    redirect_url = AuthHelpers.get_return_to(conn)
    strategy = Info.strategy!(Accounts.User, :confirm_new_user)

    case Strategy.action(strategy, :confirm, %{"confirm" => token}) do
      {:ok, user} ->
        conn
        |> AuthHelpers.store_in_session(user)
        |> delete_session(:return_to)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: redirect_url)

      {:error, _errors} ->
        conn
        |> put_flash(:error, "Invalid or expired confirmation link. Request a new one.")
        |> redirect(to: ~p"/reset-password")
    end
  end

  defp oauth_providers do
    AuthHelpers.oauth_providers()
  end
end
