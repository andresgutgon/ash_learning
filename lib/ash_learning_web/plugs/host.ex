defmodule AshLearningWeb.Plugs.Host do
  @moduledoc """
  A plug to assign the site and app host to Inertia props.
  """

  import Inertia.Controller, only: [assign_prop: 3]
  @hosts Application.compile_env!(:ash_learning, AshLearningWeb)
  @main_host @hosts[:main_host]
  @app_host @hosts[:app_host]
  @site_url @hosts[:site_url]
  @app_url @hosts[:app_url]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign_prop(:main_host, @main_host)
    |> assign_prop(:app_host, @app_host)
    |> assign_prop(:site_url, @site_url)
    |> assign_prop(:app_url, @app_url)
  end
end
