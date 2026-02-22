ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(AshLearning.Repo, :manual)

# Set sql_sandbox configuration at runtime based on E2E environment
if System.get_env("E2E") == "true" do
  Application.put_env(:ash_learning, :sql_sandbox, true)
else
  Application.put_env(:ash_learning, :sql_sandbox, false)
end

if System.get_env("E2E") == "true" do
  PhoenixTest.Playwright.Supervisor.start_link()
  Application.put_env(:phoenix_test, :base_url, AshLearningWeb.Endpoint.url())
end
