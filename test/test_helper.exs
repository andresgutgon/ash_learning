is_e2e = System.get_env("E2E") == "true"

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(AshLearning.Repo, :manual)
Application.put_env(:ash_learning, :sql_sandbox, !is_e2e)

if is_e2e do
  PhoenixTest.Playwright.Supervisor.start_link()
  Application.put_env(:phoenix_test, :base_url, AshLearningWeb.Endpoint.url())
end
