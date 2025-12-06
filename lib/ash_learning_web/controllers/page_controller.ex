defmodule AshLearningWeb.PageController do
  use AshLearningWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
