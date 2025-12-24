defmodule AshLearningWeb.AppUrl do
  @moduledoc """
  Helper for generating full URLs pointing to specific subdomains.

  ## Usage

      use AshLearningWeb.AppUrl

      # Generate URL for app subdomain (default)
      app_url(~p"/reset-password/\#{token}/edit", host: :app)
      #=> "https://app.mydomain.com/reset-password/abc123/edit"

      # Generate URL for main domain
      app_url(~p"/some-page", host: :main)
      #=> "https://mydomain.com/some-page"

  The URLs are read from the application config at compile time:
  - `:app` uses `app_url` config
  - `:main` uses `site_url` config
  """

  @hosts Application.compile_env(:ash_learning, AshLearningWeb, [])
  @site_url @hosts[:site_url]
  @app_url @hosts[:app_url]

  @doc """
  Builds a full URL for the specified host from a path.

  ## Options

    * `:host` - The host to use. Either `:app` (default) or `:main`.

  ## Examples

      iex> AshLearningWeb.AppUrl.app_url("/reset-password/token123/edit", host: :app)
      "https://app.mydomain.com/reset-password/token123/edit"

      iex> AshLearningWeb.AppUrl.app_url("/landing", host: :main)
      "https://mydomain.com/landing"

  """
  def app_url(path, opts \\ [])

  def app_url(path, opts) when is_binary(path) do
    host = Keyword.get(opts, :host, :app)
    url_base(host) <> path
  end

  defp url_base(:app), do: @app_url
  defp url_base(:main), do: @site_url

  defmacro __using__(_opts) do
    quote do
      use AshLearningWeb, :verified_routes
      import AshLearningWeb.AppUrl, only: [app_url: 1, app_url: 2]
    end
  end
end
