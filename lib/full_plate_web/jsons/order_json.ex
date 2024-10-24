defmodule FullPlateWeb.Jsons.OrderJson do
  def order(%{order: order, status: status}) do
    %{status: status, total_order: order.total}
  end

  def order_list(%{order: orders}) do
    Enum.map(orders, fn order -> %{
     products: order.products,
     total: Decimal.to_string(order.total),
     } end)
   end
end
