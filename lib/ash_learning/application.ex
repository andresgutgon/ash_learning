defmodule AshLearning.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AshLearningWeb.Telemetry,
      AshLearning.Repo,
      {DNSCluster, query: Application.get_env(:ash_learning, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshLearning.PubSub},
      # Start a worker by calling: AshLearning.Worker.start_link(arg)
      # {AshLearning.Worker, arg},
      # Start to serve requests, typically the last entry
      AshLearningWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :ash_learning]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshLearning.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshLearningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
