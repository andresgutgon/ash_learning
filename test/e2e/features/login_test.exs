defmodule AshLearningWeb.Features.LoginTest do
  use AshLearningWeb.FeatureCase

  @moduletag :e2e

  @tag :e2e_smoke
  test "login with email and password", %{conn: conn} do
    %{user: user, password: password} = account_owner()

    conn
    |> visit(app_url("/login"))
    |> fill_in("Email", with: user.email)
    |> fill_in("Password", with: password)
    |> click_button("Login")
    |> assert_path("/")
  end
end
