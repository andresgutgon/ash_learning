defmodule AshLearningWeb.ConfirmationTokenHTML do
  @moduledoc """
  Confirmation token templates for authentication flows.
  """
  use AshLearningWeb, :html

  embed_templates "confirmation_token_html/*"

  import Phoenix.Component, only: [to_form: 2]
  import Phoenix.Controller, only: [get_csrf_token: 0, put_view: 2, render: 3]
  alias AshPhoenix.Form
  alias AshLearningWeb.Controllers.AuthHelpers
  alias AshLearning.Accounts.User

  def render_token(conn, %{
        token: token,
        strategy: strategy,
        action_name: action_name,
        action_url: action_url,
        page_title: page_title,
        back_link_url: back_link_url
      }) do
    domain = AshAuthentication.Info.authentication_domain!(User)

    form =
      User
      |> Form.for_action(action_name,
        domain: domain,
        as: "user",
        id: AuthHelpers.action_to_form_id(action_name),
        context: %{
          strategy: strategy,
          private: %{ash_authentication?: true}
        },
        params: %{token: token}
      )
      |> to_form(csrf_token: get_csrf_token())

    conn
    |> put_view(__MODULE__)
    |> render(:token_form,
      token: token,
      form: form,
      action_url: action_url,
      back_link_url: back_link_url,
      page_title: page_title
    )
  end
end
