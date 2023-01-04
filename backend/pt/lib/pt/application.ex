defmodule Pt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Pt.Repo,
      {Plug.Cowboy, scheme: :http, plug: Pt.ApiRouter, port: 4040}
      # Starts a worker by calling: Pt.Worker.start_link(arg)
      # {Pt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
