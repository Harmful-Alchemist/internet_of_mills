defmodule InternetOfMills.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(InternetOfMills.Repo, []),
      # Start the endpoint when the application starts
      supervisor(InternetOfMillsWeb.Endpoint, []),
      # supervise the IO connections
      supervisor(DynamicSupervisor, [[strategy: :one_for_one, name: InternetOfMills.PinSupervisor]]),
      # {DynamicSupervisor, strategy: :one_for_one, name: InternetOfMills.PinSupervisor},
      # Start your own worker by calling: InternetOfMills.Worker.start_link(arg1, arg2, arg3)
      worker(Application.get_env(:internet_of_mills, :mill_io, InternetOfMills.Peripheral.MillIO), []),
      worker(Application.get_env(:picam, :camera, Picam.Camera), []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InternetOfMills.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InternetOfMillsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
