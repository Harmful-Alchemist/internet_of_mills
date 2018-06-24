use Mix.Config
# Production in this case is just my raspberry pi not connected tot the outside internet. Don't use this on the real internet!

config :internet_of_mills, InternetOfMillsWeb.Endpoint,
  http: [port: 4002]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :internet_of_mills, InternetOfMills.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "internet_of_mills_dev",
  hostname: "localhost",
  pool_size: 10
