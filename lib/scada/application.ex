defmodule Scada.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScadaWeb.Telemetry,
      Scada.Repo,
      {DNSCluster, query: Application.get_env(:scada, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Scada.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Scada.Finch},
      Supervisor.child_spec({Scada.ADSMenager, []}, restart: :permanent),
      Supervisor.child_spec({Scada.DataManager, []}, restart: :permanent),
      # Start a worker by calling: Scada.Worker.start_link(arg)
      # {Scada.Worker, arg},
      # Start to serve requests, typically the last entry
      ScadaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scada.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScadaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
