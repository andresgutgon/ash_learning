defmodule AshLearningWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides

  # configure your UI overrides here

  # For a complete reference, see https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html

  # Add top navigation to auth pages by modifying the SignIn component layout
  override AshAuthentication.Phoenix.Components.SignIn do
    set :root_class, "min-h-screen bg-base-100"
  end
end
