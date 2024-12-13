defmodule FullPlateWeb.Jsons.PaymentJson do
  def confirmation(%{payment: order, status: status}) do
    %{confirmation: %{
      id: order.id,
      message: "pagamento confirmado"
    }}
  end
end
