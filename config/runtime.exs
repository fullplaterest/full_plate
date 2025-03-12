import Config

if System.get_env("PHX_SERVER") do
  config :full_plate, FullPlateWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") || "ecto://postgres:postgres@full-plate-prod.cwjquya2yre0.us-east-1.rds.amazonaws.com:5432/full-plate-prod"

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :full_plate, FullPlate.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :full_plate, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :full_plate, FullPlateWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base


    config :full_palte, FullPlate.Repo,
    database: System.get_env("DB_NAME"),
    username: System.get_env("DB_USER"),
    password: System.get_env("DB_PASSWORD"),
    hostname: System.get_env("DB_HOST"),
    pool_size: 10
end
