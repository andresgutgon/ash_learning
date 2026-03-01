defmodule AshLearningWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by
  feature tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Use Playwright for E2E tests with real Phoenix server
      use PhoenixTest.Playwright.Case, async: false
      import PhoenixTest

      @endpoint AshLearningWeb.Endpoint
    end
  end

  # For E2E tests, use shared sandbox mode to allow server and test to share DB state
  setup _tags do
    # Use shared mode so both the test process and Phoenix server can access the same sandbox
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AshLearning.Repo, shared: true)
    :ok
  end
end
