defmodule PlugoidDemo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      PlugoidDemoWeb.Telemetry,
      {Phoenix.PubSub, name: PlugoidDemo.PubSub},
      PlugoidDemoWeb.Endpoint,
      {JTIRegister.ETS, cleanup_interval: 17},
      OAuth2TokenManager.Store.Local
    ]

    :ets.new(:plugoid_auth_cookie, [:named_table, :public])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugoidDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PlugoidDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
