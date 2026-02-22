defmodule AshLearningWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by
  feature tests (E2E tests with Playwright).
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use PhoenixTest.Playwright.Case, async: true
      import PhoenixTest
      import TestHelpers

      @endpoint AshLearningWeb.Endpoint
    end
  end

  setup tags do
    AshLearning.DataCase.setup_sandbox(tags)
    :ok
  end
end
