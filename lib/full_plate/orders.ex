defmodule FullPlate.Orders do
  import Ecto.Query, warn: false

  alias FullPlate.Orders.Order
  alias FullPlate.Repo

  def create_order(order) do
    order
    |> Order.registration_changeset()
    |> Repo.insert()
  end

  def get_order(page, page_size, user_id) do
    Order
    |> from()
    |> where([o], o.user_id == ^user_id)
    |> order_by([o], desc: o.inserted_at)
    |> limit(^page_size)
    |> offset((^page - 1) * ^page_size)
    |> Repo.all()
  end

  def list_orders(page, page_size) do
    Order
    |> from()
    |> where([o], not o.is_finished?)
    |> order_by([o], [desc: fragment("CASE order_status WHEN 'pronto' THEN 1 WHEN 'em_preparacao' THEN 2 WHEN 'recebido' THEN 3 END"), desc: o.inserted_at])
    |> limit(^page_size)
    |> offset((^page - 1) * ^page_size)
    |> Repo.all()
  end

  def update_order(params) do
    Order
    |> from()
    |> where([o], o.id == ^params["id"])
    |> Repo.one()
    |> case do
      nil -> nil

      order ->
        order
        |> Order.registration_changeset(params)
        |> Repo.update()
    end
  end
end
