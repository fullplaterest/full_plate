defmodule FullPlate.Service.OrderService do
  require Logger

  alias FullPlate.Products
  alias FullPlate.Orders

  def create_order(order) do
   total = order["order"]
    |> calculate_total_price()

   final_order =
    order
    |> Map.put("total", total)

    case Orders.create_order(final_order) do
      {:ok, order} ->
        Logger.info("Order created")
        {:ok, order}

      error ->
        Logger.error(
          "Could not create order with attributes #{inspect(order)}. Error: #{inspect(error)}"
        )
        error
    end
  end

  def get_order(page, page_size, user_id) do
    page = String.to_integer(page)
    page_size = String.to_integer(page_size)
    case Orders.get_order(page, page_size, user_id) do
      [] -> {:error, :not_found}

      orders ->
       Enum.map(orders, fn order ->
       products = Products.get_by_id_list(order.order)
       %{total: order.total, products: products, payment_status: order.payment_status}
      end)
    end
  end

  def list_order(page, page_size) do
    page = String.to_integer(page)
    page_size = String.to_integer(page_size)
    case Orders.list_orders(page, page_size) do
      [] -> {:error, :not_found}

      orders ->
       Enum.map(orders, fn order ->
       products = Products.get_by_id_list(order.order)
       %{id: order.id, total: order.total, products: products, payment_status: order.payment_status, order_status: order.order_status}
      end)
    end
  end

  def update_order(params) do
    case Orders.update_order(params) do
      nil -> {:error, :not_found}

      {:ok, order} -> order
    end
  end

  defp calculate_total_price(order) do
  total = Enum.reduce(order, Decimal.new(0), fn id, acc ->
     product = Products.get_by_id(id)
     Decimal.add(acc, product.price)
    end)

    Decimal.to_string(total)
  end
end
