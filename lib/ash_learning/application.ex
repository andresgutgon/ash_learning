defmodule AshLearning.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    dev_mode = Application.get_env(:ash_learning, :dev_mode)
    vite_domain = Application.fetch_env!(:ash_learning, AshLearningWeb)[:vite_domain]

    children = [
      AshLearningWeb.Telemetry,
      AshLearning.Repo,
      {DNSCluster, query: Application.get_env(:ash_learning, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshLearning.PubSub},
      AshLearningWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :ash_learning]},
      {Vitex,
       dev_mode: dev_mode,
       endpoint: AshLearningWeb.Endpoint,
       vite_host: vite_domain,
       js_framework: :react,
       manifest_name: "vite_manifest"},
      {Inertia.SSR, Application.fetch_env!(:ash_learning, Inertia.SSR)}
    ]

    children =
      if dev_mode do
        children ++ [{Wayfinder.RoutesWatcher, []}]
      else
        children
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: AshLearning.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshLearningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
