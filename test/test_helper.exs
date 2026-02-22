ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(AshLearning.Repo, :manual)

PhoenixTest.Playwright.Supervisor.start_link()
Application.put_env(:phoenix_test, :base_url, AshLearningWeb.Endpoint.url())
