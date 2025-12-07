defmodule AshLearningWeb.AuthController do
  use AshLearningWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    message =
      case activity do
        {:confirm_new_user, :confirm} -> "Your email address has now been confirmed"
        {:password, :reset} -> "Your password has successfully been reset"
        _ -> "You are now signed in"
      end

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> put_flash(:info, message)
    |> redirect(to: return_to)
  end

  def failure(conn, activity, reason) do
    message =
      case {activity, reason} do
        {_,
         %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Forbidden{
             errors: [%AshAuthentication.Errors.CannotConfirmUnconfirmedUser{}]
           }
         }} ->
          """
          You have already signed in another way, but have not confirmed your account.
          You can confirm your account using the link we sent to you, or by resetting your password.
          """

        _ ->
          "Incorrect email or password"
      end

    conn
    |> put_flash(:error, message)
    |> redirect(to: ~p"/sign-in")
  end

  @impl AshAuthentication.Phoenix.Controller
  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session(:ash_learning)
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end

  @remember_me_cookie_options [
    http_only: true,
    secure: Mix.env() != :dev,
    same_site: "Lax"
  ]

  # Without AshAuthenticationPhoenix
  # https://github.com/team-alembic/ash_authentication/blob/main/documentation/tutorials/remember-me.md#without-ashauthenticationphoenix
  @impl AshAuthentication.Phoenix.Controller
  def put_remember_me_cookie(conn, cookie_name, %{token: token, max_age: max_age}) do
    cookie_options = Keyword.put(@remember_me_cookie_options, :max_age, max_age)

    conn
    |> put_resp_cookie(cookie_name, token, cookie_options)
  end

  def disconnect_provider(conn, %{"provider" => provider}) do
    current_user = conn.assigns.current_user

    case disconnect_identity(current_user, provider) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "#{String.capitalize(provider)} account disconnected successfully!")
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to disconnect #{provider} account.")
        |> redirect(to: ~p"/")
    end
  end

  defp disconnect_identity(user, provider) do
    AshLearning.Accounts.UserIdentity
    |> Ash.ActionInput.for_action(:disconnect, %{user_id: user.id, provider: provider})
    |> Ash.run_action(domain: AshLearning.Accounts)
  end
end
