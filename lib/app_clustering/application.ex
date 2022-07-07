defmodule AppClustering.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      clusteging_maiqui: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "maiqui-service-headless",
          application_name: "app_clustering",
          polling_interval: 10_000
        ]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Chat.ClusterSupervisor]]},
      # Start the Ecto repository
      # AppClustering.Repo,
      # Start the Telemetry supervisor
      AppClusteringWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AppClustering.PubSub},
      # Start the Endpoint (http/https)
      AppClusteringWeb.Endpoint
      # Start a worker by calling: AppClustering.Worker.start_link(arg)
      # {AppClustering.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AppClustering.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AppClusteringWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
