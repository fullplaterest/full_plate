defmodule FullPlate.Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:full_plate)

    path = Application.app_dir(:full_plate, "priv/repo/migrations")

    Ecto.Migrator.run(FullPlate.Repo, path, :up, all: true)
  end
end
