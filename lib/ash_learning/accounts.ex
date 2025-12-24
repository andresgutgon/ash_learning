defmodule AshLearning.Accounts do
  use Ash.Domain, otp_app: :ash_learning

  resources do
    resource(AshLearning.Accounts.Token)
    resource(AshLearning.Accounts.UserIdentity)

    resource AshLearning.Accounts.User do
      define(:signup, action: :register_with_password)
      define(:signin, action: :sign_in_with_password)
      define(:request_password, action: :request_password_reset_token)
    end
  end
end
