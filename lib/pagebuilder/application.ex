defmodule Pagebuilder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PagebuilderWeb.Telemetry,
      Pagebuilder.Repo,
      {DNSCluster, query: Application.get_env(:pagebuilder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pagebuilder.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pagebuilder.Finch},
      # Start a worker by calling: Pagebuilder.Worker.start_link(arg)
      # {Pagebuilder.Worker, arg},
      # Start to serve requests, typically the last entry
      PagebuilderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pagebuilder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PagebuilderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
