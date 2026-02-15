defmodule AshLearning.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
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
      |> subject("Reset your password")
      |> html_body(body(token: token))
      |> Mailer.deliver()

    case result do
      {:ok, _} -> :ok
      {:error, _} = error -> error
    end
  end

  defp body(params) do
    url = app_url(~p"/reset-password/#{params[:token]}/edit")

    """
    <p>Click this link to reset your password:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
