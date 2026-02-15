defmodule AshLearningWeb.Auth.OAuthRedirectController do
  use AshLearningWeb, :controller
  alias AshLearningWeb.Auth

  def redirect_with_return_to(conn, %{"provider" => provider} = params) do
    return_to = params["return_to"]

    conn =
      if return_to && return_to != "" do
        Auth.save_return_to(conn, return_to)
      else
        conn
      end

    redirect(conn, external: "/auth/user/#{provider}")
  end
end
