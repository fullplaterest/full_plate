defmodule FullPlate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FullPlateWeb.Telemetry,
      FullPlate.Repo,
      {DNSCluster, query: Application.get_env(:full_plate, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FullPlate.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FullPlate.Finch},
      # Start a worker by calling: FullPlate.Worker.start_link(arg)
      # {FullPlate.Worker, arg},
      # Start to serve requests, typically the last entry
      FullPlateWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FullPlate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FullPlateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
