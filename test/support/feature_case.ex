defmodule AshLearningWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by
  feature tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Don't use sandbox for E2E tests - we need real DB persistence
      use PhoenixTest.Playwright.Case, async: false
      import PhoenixTest

      @endpoint AshLearningWeb.Endpoint
    end
  end

  # No sandbox setup for E2E tests - Phoenix needs to see the same data
  setup _tags do
    :ok
  end
end
