defmodule AshLearningWeb.ResetPasswordsController do
  use AshLearningWeb, :controller

  import AshLearningWeb.Controllers.AuthHelpers
  import Phoenix.Component, only: [to_form: 2]

  alias AshPhoenix.Form
  alias AshAuthentication.Info
  alias AshLearning.Accounts.User

  @request_reset_password_action :request_password_reset_token
  @reset_password_action :reset_password_with_token

  def index(conn, params) do
    form_id = action_to_form_id(@request_reset_password_action)
    email = Map.get(params, "email")

    initial_params = if email, do: %{"email" => email}, else: %{}

    form =
      User
      |> Form.for_action(@request_reset_password_action,
        domain: Info.authentication_domain!(User),
        id: form_id,
        as: "user",
        authorize?: false,
        params: initial_params
      )
      |> to_form(csrf_token: get_csrf_token())

    render(conn, :new,
      page_title: "Reset Password",
      form: form
    )
  end

  def create(conn, %{"user" => user_params}) do
    form =
      User
      |> Form.for_action(@request_reset_password_action,
        domain: Info.authentication_domain!(User),
        as: "user",
        authorize?: false
      )
      |> to_form(csrf_token: get_csrf_token())

    case Form.submit(form, params: user_params) do
      :ok ->
        conn
        |> put_flash(
          :info,
          "If your email is in our system, you will receive reset instructions shortly."
        )
        |> redirect(to: ~p"/login")

      {:error, form} ->
        render(conn, :new,
          page_title: "Reset Password",
          form: form
        )
    end
  end

  def edit(conn, params) do
    form_id = action_to_form_id(@reset_password_action)
    reset_token = Map.get(params, "id", "")

    form =
      User
      |> Form.for_action(@reset_password_action,
        domain: Info.authentication_domain!(User),
        id: form_id,
        as: "user",
        params: %{"reset_token" => reset_token}
      )
      |> to_form(csrf_token: get_csrf_token())

    render(conn, :edit,
      page_title: "Reset Password",
      form: form
    )
  end

  def update(conn, %{"user" => params}) do
    strategy = AshAuthentication.Info.strategy!(User, :password)

    case AshAuthentication.Strategy.action(strategy, :reset, params,
           domain: Info.authentication_domain!(User),
           authorize?: false
         ) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password reset successfully! You can now log in.")
        |> redirect(to: ~p"/login")

      {:error, _error} ->
        form =
          User
          |> Form.for_action(@reset_password_action,
            domain: Info.authentication_domain!(User),
            as: "user",
            authorize?: false,
            params: params
          )
          |> Form.validate(params)
          |> to_form(csrf_token: get_csrf_token())

        render(conn, :edit,
          page_title: "Reset Password",
          form: form
        )
    end
  end
end
