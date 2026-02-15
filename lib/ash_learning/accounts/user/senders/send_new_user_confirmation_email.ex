defmodule AshLearning.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
  """

  use AshAuthentication.Sender
  use AshLearningWeb.AppUrl

  import Swoosh.Email

  alias AshLearning.Mailer

  @impl true
  def send(user, token, _) do
    result =
      new()
      # TODO: Replace with your email
      |> from({"noreply", "noreply@example.com"})
      |> to(to_string(user.email))
      |> subject("Confirm your email address")
      |> html_body(body(token: token))
      |> Mailer.deliver()

    case result do
      {:ok, _} -> :ok
      {:error, _} = error -> error
    end
  end

  defp body(params) do
    url = app_url(~p"/register/#{params[:token]}/edit")

    """
    <p>Click this link to confirm your email:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
