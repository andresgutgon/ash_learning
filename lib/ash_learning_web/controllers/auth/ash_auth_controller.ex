defmodule AshLearningWeb.Auth.AshAuthController do
  use AshLearningWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias AshLearningWeb.Auth, as: Auth

  def success(conn, activity, user, _token) do
    return_to = Auth.get_return_to(conn)

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
    {message, redirect_to} = failure_message_and_redirect(conn, activity, reason)

    conn
    |> put_flash(:error, message)
    |> redirect(to: redirect_to)
  end

  defp failure_message_and_redirect(conn, activity, reason) do
    case {activity, reason} do
      {{provider, :callback},
       %AshAuthentication.Errors.AuthenticationFailed{
         caused_by: %Ash.Error.Invalid{errors: errors}
       }}
      when provider in [:google, :github] ->
        if oauth_already_connected_error?(errors) do
          provider_name = provider |> to_string() |> String.capitalize()

          {
            "This #{provider_name} account is already connected to another user.",
            if(conn.assigns[:current_user], do: ~p"/", else: ~p"/login")
          }
        else
          {"Authentication failed. Please try again.", ~p"/login"}
        end

      # Unconfirmed user trying to sign in
      {_,
       %AshAuthentication.Errors.AuthenticationFailed{
         caused_by: %Ash.Error.Forbidden{
           errors: [%AshAuthentication.Errors.CannotConfirmUnconfirmedUser{}]
         }
       }} ->
        {
          """
          You have already signed in another way, but have not confirmed your account.
          You can confirm your account using the link we sent to you, or by resetting your password.
          """,
          ~p"/login"
        }

      # Default case
      _ ->
        {"Incorrect email or password", ~p"/login"}
    end
  end

  defp oauth_already_connected_error?(errors) do
    Enum.any?(errors, fn
      %Ash.Error.Changes.InvalidAttribute{message: message} ->
        String.contains?(message, "already connected to another user")

      _ ->
        false
    end)
  end

  @impl AshAuthentication.Phoenix.Controller
  def sign_out(conn, _params) do
    conn
    |> clear_session(:ash_learning)
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: Auth.get_return_to(conn))
  end

  @doc """
  Conditionally puts a remember me cookie if the user has remember me metadata.
  """
  def maybe_put_remember_me(conn, user) do
    case Map.get(user.__metadata__, :remember_me) do
      %{token: _token, cookie_name: cookie_name} = remember_me_token ->
        put_remember_me_cookie(conn, to_string(cookie_name), remember_me_token)

      _ ->
        conn
    end
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
end
