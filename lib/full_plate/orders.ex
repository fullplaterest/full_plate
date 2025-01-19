defmodule FullPlate.Orders do
  import Ecto.Query, warn: false

  alias FullPlate.Orders.Order
  alias FullPlate.Repo

  def create_order(order) do
    order
    |> Order.registration_changeset()
    |> Repo.insert()
  end

  def get_order(page, page_size) do
    Order
    |> from()
    |> order_by([o], desc: o.inserted_at)
    |> limit(^page_size)
    |> offset((^page - 1) * ^page_size)
    |> Repo.all()
  end
end
