defmodule AshLearningWeb.Features.LoginTest do
  use AshLearningWeb.FeatureCase

  alias AshLearning.Accounts.User

  @app_host "app.ashlearning.dev"  # Use dev domain for proper Vite HMR

  test "can create and verify user", %{conn: conn} do
    # Test just the user creation part
    email = "test@example.com"
    password = "password1234"
    {:ok, user} = create_user(email, password)
    
    # Verify user was created with confirmation
    assert to_string(user.email) == email
    assert user.confirmed_at != nil
    # Just verify the user exists - authentication testing will be in the E2E test
  end

  test "login with email and password", %{conn: conn} do
    # 1. Create a user
    email = "user@example.com"
    password = "SuperSecret!!!69"
    {:ok, user} = create_user(email, password)
    
    # Debug: verify the user before test
    IO.inspect(user, label: "Created user")
    IO.inspect(user.confirmed_at, label: "User confirmed_at")

    # 2. Test the actual login flow
    conn
    |> visit("https://#{@app_host}/login")
    |> fill_in("Email", with: email)
    |> fill_in("Password", with: password)
    |> click_button("Login")
    |> assert_path("/") # Should redirect to home page after successful login
  end

  defp create_user(email, password) do
    {:ok, user} =
      User
      |> Ash.Changeset.for_create(:register_with_password, %{
        email: email,
        password: password,
        password_confirmation: password
      })
      |> Ash.Changeset.force_change_attribute(:confirmed_at, DateTime.utc_now())
      |> Ash.create()

    {:ok, user}
  end
end
