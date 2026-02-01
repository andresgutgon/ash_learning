defmodule AshLearningWeb.HomeControllerTest do
  use AshLearningWeb.ConnCase

  @moduletag host: :main

  test "GET / renders home page", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Welcome to the Home Page"
  end
end
