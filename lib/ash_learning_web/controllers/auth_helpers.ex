defmodule AshLearningWeb.Controllers.AuthHelpers do
  @moduledoc """
  Shared authentication helper functions for controllers.
  """

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.Component, only: [to_form: 2]

  use Phoenix.VerifiedRoutes,
    endpoint: AshLearningWeb.Endpoint,
    router: AshLearningWeb.Router,
    statics: AshLearningWeb.static_paths()

  alias AshLearning.Accounts.User
  alias AshPhoenix.Form
  alias AshAuthentication.Info
  alias AshAuthentication.Plug.Helpers, as: AshAuthHelpers

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
  defdelegate maybe_put_remember_me(conn, user), to: AshLearningWeb.AuthController

  @doc """
  Converts an action name to a form ID.
  E.g., :sign_in_with_password -> "sign-in-with-password-form"
  """
  def action_to_form_id(action) do
    action |> to_string() |> String.replace("_", "-") |> then(&"#{&1}-form")
  end

  @doc """
  Builds a form for the given action.
  """
  def build_form(%{action: action}) do
    form_id = action_to_form_id(action)

    User
    |> Form.for_action(action,
      domain: Info.authentication_domain!(User),
      as: "user",
      id: form_id,
      authorize?: false
    )
    |> to_form(csrf_token: get_csrf_token())
  end

  @doc """
  Retrieves the return_to path from the session or params.
  Defaults to "/" if not found.
  """
  def get_return_to(conn, params) do
    case get_session(conn, :return_to) || params["return_to"] do
      nil -> ~p"/"
      "" -> ~p"/"
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
end
