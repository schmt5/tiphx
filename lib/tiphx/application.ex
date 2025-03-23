defmodule Tiphx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TiphxWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tiphx, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tiphx.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tiphx.Finch},
      # Start a worker by calling: Tiphx.Worker.start_link(arg)
      # {Tiphx.Worker, arg},
      # Start to serve requests, typically the last entry
      TiphxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tiphx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TiphxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
