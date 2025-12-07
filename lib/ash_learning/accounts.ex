defmodule AshLearning.Accounts do
  use Ash.Domain, otp_app: :ash_learning

  resources do
    resource AshLearning.Accounts.Token
    resource AshLearning.Accounts.User
    resource AshLearning.Accounts.UserIdentity
  end
end
