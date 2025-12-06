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
end
