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

  # Use Ash-compatible database setup (same as ConnCase)
  setup tags do
    AshLearning.DataCase.setup_sandbox(tags)
    :ok
  end
end
