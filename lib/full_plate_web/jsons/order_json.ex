defmodule FullPlateWeb.Jsons.OrderJson do
  def order(%{order: order, status: status}) do
    %{status: status,
    total_order: order.total,
    link_for_payment: "localhost:4000/api/pagamento/#{order.id}"
    }
  end

  def order_list(%{order: orders}) do
    Enum.map(orders, fn order -> %{
     products: order.products,
     total: Decimal.to_string(order.total),
     payment_status: order.payment_status
     } end)
   end

   def order_list_admin(%{order: orders}) do
    Enum.map(orders, fn order -> %{
     id: order.id,
     products: order.products,
     total: Decimal.to_string(order.total),
     payment_status: order.payment_status,
     order_status: order.order_status
     } end)
   end

   def updated_order_list_admin(%{order: order}) do
    %{
     total: Decimal.to_string(order.total),
     payment_status: order.payment_status,
     order_status: order.order_status,
     is_finished?: order.is_finished?
     }
   end
end
