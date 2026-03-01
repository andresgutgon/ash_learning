ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(AshLearning.Repo, :manual)

# Configure phoenix_test endpoint
Application.put_env(:phoenix_test, :endpoint, AshLearningWeb.Endpoint)

PhoenixTest.Playwright.Supervisor.start_link()
Application.put_env(:phoenix_test, :base_url, AshLearningWeb.Endpoint.url())
