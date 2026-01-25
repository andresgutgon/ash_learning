defmodule AshLearningWeb.HomeController do
  use AshLearningWeb, :controller

  def show(conn, _params) do
    conn
    |> render_inertia("HomePage")
  end
end
