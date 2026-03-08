defmodule TestHelpers do
  @moduledoc """
  Global test helpers available in all tests.
  """

  @doc """
  Generate a URL for the app subdomain.

  ## Example
      app_url("/login")
      #=> "https://app.ashlearning.dev/login"
  """
  def app_url(path) do
    AshLearningWeb.AppUrl.app_url(path, host: :app)
  end

  @doc """
  Generate a URL for the main domain.

  ## Example
      main_url("/landing")
      #=> "https://ashlearning.dev/landing"
  """
  def main_url(path) do
    AshLearningWeb.AppUrl.app_url(path, host: :main)
  end
end
