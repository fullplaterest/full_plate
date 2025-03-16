import Config

if System.get_env("PHX_SERVER") do
  config :full_plate, FullPlateWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL")

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :full_plate, FullPlate.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") || "TtvK69c6zV0DNWeia63fpeIO7rjRrjPc7mOLLjXKPOVhqAiIby/+GKcvcaKC6g62"

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :full_plate, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :full_plate, FullPlateWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
