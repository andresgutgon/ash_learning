defmodule AshLearningWeb.Dashboard.DashboardIndexController do
  use AshLearningWeb, :controller

  def index(conn, _params) do
    render_inertia(conn, "Dashboard/DashboardPage")
  end
end
