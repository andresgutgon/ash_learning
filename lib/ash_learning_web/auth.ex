defmodule AshLearningWeb.Auth do
  @moduledoc """
  Shared authentication helper functions for controllers.
  """

  use AshLearningWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  use Phoenix.VerifiedRoutes,
    endpoint: AshLearningWeb.Endpoint,
    router: AshLearningWeb.Router,
    statics: AshLearningWeb.static_paths()

  alias AshAuthentication.{Info, Strategy}
  alias AshAuthentication.Plug.Helpers, as: AshAuthHelpers
  alias AshLearning.Accounts.User

  @doc """
  Stores the user in the session.
  Delegates to AshAuthentication.Plug.Helpers.
  """
  defdelegate store_in_session(conn, user), to: AshAuthHelpers

  @doc """
  Clear the session for the given app key (key is your app).
  Delegates to AshAuthentication.Phoenix.Controller behavior implementation.
  """
  defdelegate clear_session(conn, app_key), to: AshAuthentication.Phoenix.Controller

  @doc """
  Puts remember me cookie if applicable.
  Delegates to AshLearningWeb.AuthController.
  """
  defdelegate maybe_put_remember_me(conn, user), to: AshLearningWeb.Auth.AshAuthController

  @doc """
  Sign out user by clearing session and remember me cookie.
  Delegates to AshLearningWeb.Auth.AshAuthController.
  """
  defdelegate sign_out(conn, app_key), to: AshLearningWeb.Auth.AshAuthController

  @doc """
  Converts an action name to a form ID.
  E.g., :sign_in_with_password -> "sign-in-with-password-form"
  """
  def action_to_form_id(action) do
    action |> to_string() |> String.replace("_", "-") |> then(&"#{&1}-form")
  end

  @doc """
  Ensures the user is authenticated.
  If not, redirects to the login page.
  """
  def require_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def signed_in_path(_conn), do: ~p"/"

  @doc """
  Retrieves the return_to path from the session or params.
  Defaults to "/" if not found.
  """
  def get_return_to(conn, params \\ %{}) do
    case get_session(conn, :return_to) || params["return_to"] do
      nil -> signed_in_path(conn)
      "" -> signed_in_path(conn)
      path -> path
    end
  end

  @doc """
  Saves the return_to path in the session if it's valid.
  Ignores nil, empty, or root paths.
  """
  def save_return_to(conn, return_to) do
    case return_to do
      nil -> conn
      "" -> conn
      "/" -> conn
      path when is_binary(path) -> put_session(conn, :return_to, path)
      _ -> conn
    end
  end

  @doc """
  Returns a list of configured OAuth providers with their metadata.

  Each provider map contains:
  - `name` - the strategy name as a string (e.g., "github")
  - `display_name` - human readable name (e.g., "GitHub")
  - `icon` - icon identifier for provider_icon component
  - `auth_url` - the OAuth authorization URL
  """
  def oauth_providers do
    User
    |> Info.authentication_strategies()
    |> Enum.filter(fn strategy ->
      match?(%Strategy.OAuth2{}, strategy)
    end)
    |> Enum.map(fn strategy ->
      %{
        name: to_string(Strategy.name(strategy)),
        display_name: strategy_display_name(strategy),
        icon: get_strategy_icon(strategy),
        auth_url: build_oauth_url(strategy)
      }
    end)
  end

  def strategy_display_name(%{name: :github}), do: "GitHub"
  def strategy_display_name(%{name: :google}), do: "Google"
  def strategy_display_name(%{name: name}), do: Phoenix.Naming.humanize(name)

  defp get_strategy_icon(%{name: :github}), do: "github"
  defp get_strategy_icon(%{name: :google}), do: "google"
  defp get_strategy_icon(_), do: "globe"

  defp build_oauth_url(strategy) do
    "/auth/user/#{strategy.name}"
  end
end
