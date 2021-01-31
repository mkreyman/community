defmodule Congregation.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  {Phoenix.PubSub, [name: Congregation.PubSub, adapter: Phoenix.PubSub.PG2]}

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Congregation.DynamicSupervisor},
      # Start the Ecto repository
      Congregation.Repo,
      # Start the endpoint when the application starts
      CongregationWeb.Endpoint
      # Starts a worker by calling: Congregation.Worker.start_link(arg)
      # {Congregation.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CongregationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
