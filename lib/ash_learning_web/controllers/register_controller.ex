defmodule AshLearningWeb.RegisterController do
  use AshLearningWeb, :controller

  alias AshLearningWeb.Controllers.AuthHelpers

  alias AshPhoenix.Form
  alias AshLearning.Accounts.User
  alias AshAuthentication.Info
  alias AshLearningWeb.ConfirmationTokenHTML

  @action :register_with_password
  @page_title "Register"

  def index(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)
    form = AuthHelpers.build_form(%{action: @action})
    conn = AuthHelpers.save_return_to(conn, return_to)

    render(conn, :new, %{
      action: @action,
      page_title: @page_title,
      params: params,
      form: form,
      return_to: return_to
    })
  end

  def create(conn, params) do
    return_to = AuthHelpers.get_return_to(conn, params)
    form_params = Map.get(params, "user", %{})
    form = AuthHelpers.build_form(%{action: @action})

    case Form.submit(form, params: form_params) do
      {:ok, user} ->
        conn
        |> AuthHelpers.maybe_put_remember_me(user)
        |> put_flash(
          :info,
          "Account created successfully! Please check your email to confirm your account."
        )
        |> redirect(to: ~p"/login")

      {:error, form} ->
        conn
        |> AuthHelpers.save_return_to(return_to)
        |> render(:new, %{
          form: form,
          action: @action,
          page_title: @page_title,
          params: params
        })
    end
  end

  def edit(conn, %{"id" => token}) do
    strategy =
      AshAuthentication.Info.strategy!(
        User,
        :confirm_new_user
      )

    ConfirmationTokenHTML.render_token(conn, %{
      page_title: "Confirm Registration",
      token: token,
      strategy: strategy,
      action_name: strategy.confirm_action_name,
      action_url: ~p"/register/#{token}",
      back_link_url: ~p"/register"
    })
  end

  def update(conn, %{"id" => token}) do
    case AshAuthentication.Strategy.action(
           AshAuthentication.Info.strategy!(User, :confirm_new_user),
           :confirm,
           %{"confirm" => token},
           domain: Info.authentication_domain!(User),
           authorize?: false
         ) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: ~p"/")

      {:error, _error} ->
        conn
        |> put_flash(:error, "Invalid or expired confirmation link. Request a new one.")
        |> redirect(to: ~p"/reset-password")
    end
  end
end
