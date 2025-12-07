defmodule AshLearningWeb.PageController do
  use AshLearningWeb, :controller

  def home(conn, _params) do
    current_user = conn.assigns[:current_user]

    user_with_identities =
      case current_user do
        nil ->
          nil

        user ->
          case Ash.load(user, :identities, domain: AshLearning.Accounts) do
            {:ok, loaded_user} -> loaded_user
            {:error, _} -> user
          end
      end

    render(conn, :home, current_user: user_with_identities)
  end
end
