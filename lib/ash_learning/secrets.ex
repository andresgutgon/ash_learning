defmodule AshLearning.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        AshLearning.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:ash_learning, :token_signing_secret)
  end

  def secret_for(
        [:authentication, :strategies, :github, :client_id],
        AshLearning.Accounts.User,
        _opts,
        _context
      ) do
    get_config(:client_id)
  end

  def secret_for(
        [:authentication, :strategies, :github, :redirect_uri],
        AshLearning.Accounts.User,
        _opts,
        _context
      ) do
    get_config(:redirect_uri)
  end

  def secret_for(
        [:authentication, :strategies, :github, :client_secret],
        AshLearning.Accounts.User,
        _opts,
        _context
      ) do
    get_config(:client_secret)
  end

  defp get_config(key) do
    case :ash_learning
         |> Application.get_env(:github, [])
         |> Keyword.fetch(key) do
      {:ok, value} when not is_nil(value) -> {:ok, value}
      _ -> :error
    end
  end
end
