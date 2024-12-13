defmodule FullPlate.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @type order_status_types :: :recebido | :em_preparacao | :pronto
  @type t :: %__MODULE__{
    id: Ecto.UUID.t(),
    order: String.t(),
    total: Decimal.t(),
    payment_status: Boolean.t(),
    is_finished?: Boolean.t(),
    order_status: order_status_types(),
    user_id: Ecto.UUID.t()
  }

  @fields ~w(order total user_id order_status is_finished? payment_status)a
  @order_status_types ~w(recebido em_preparacao pronto)a
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "orders" do
    field :order, {:array, Ecto.UUID}
    field :total, :decimal
    field :payment_status, :boolean, default: false
    field :is_finished?, :boolean, default: false
    field :order_status, Ecto.Enum, values: @order_status_types, default: :recebido

    belongs_to :user, FullPlate.Accounts.User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(order \\ %__MODULE__{}, attrs) do
    order
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
