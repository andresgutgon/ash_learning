defmodule AshLearningWeb.Errors do
  @moduledoc """
  Protocol implementations for Inertia.Errors to handle custom error types.
  """

  defimpl Inertia.Errors, for: AshAuthentication.Errors.InvalidToken do
    def to_errors(invalid_token) do
      case invalid_token.type do
        :reset ->
          %{"password" => "Invalid or expired reset token"}

        :confirmation ->
          %{"confirmation_token" => "Invalid or expired confirmation token"}

        :magic_link ->
          %{"magic_link" => "Invalid or expired magic link"}

        _ ->
          %{"token" => "Invalid or expired token"}
      end
    end

    def to_errors(invalid_token, _msg_func) do
      to_errors(invalid_token)
    end
  end
end
