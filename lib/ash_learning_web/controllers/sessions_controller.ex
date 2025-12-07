defmodule AshLearningWeb.SessionsController do
  use AshLearningWeb, :controller

  alias AshLearningWeb.Controllers.AuthHelpers

  alias AshPhoenix.Form

  @action :sign_in_with_password
  @page_title "Sign In"

  def index(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)
    form = AuthHelpers.build_form(%{action: @action})
    conn = AuthHelpers.save_return_to(conn, return_to)

    render(conn, :new,
      page_title: @page_title,
      params: params,
      form: form,
      return_to: return_to
    )
  end

  def create(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)
    form_params = Map.get(params, "user", %{})
    form = AuthHelpers.build_form(%{action: @action})

    case Form.submit(form, params: form_params, read_one?: true) do
      {:ok, user} ->
        conn
        |> AuthHelpers.store_in_session(user)
        |> delete_session(:return_to)
        |> AuthHelpers.maybe_put_remember_me(user)
        |> put_flash(:info, "You're now signed in")
        |> redirect(to: return_to)

      {:error, form} ->
        conn
        |> AuthHelpers.save_return_to(return_to)
        |> render(:new, %{
          form: form,
          action: @action,
          page_title: @page_title,
          return_to: return_to,
          params: params
        })
    end
  end

  def delete(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> AuthHelpers.clear_session(:ash_learning)
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end
end
