defmodule FullPlate.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: Ecto.UUID.t(),
    order: String.t(),
    total: Decimal.t()
  }

  @fields ~w(order total)a
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "orders" do
    field :order, {:array, Ecto.UUID}
    field :total, :decimal

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(order \\ %__MODULE__{}, attrs) do
    order
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
