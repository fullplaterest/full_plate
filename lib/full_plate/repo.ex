defmodule FullPlate.Repo do
  use Ecto.Repo,
    otp_app: :full_plate,
    adapter: Ecto.Adapters.Postgres
end
