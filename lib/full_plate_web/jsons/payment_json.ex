defmodule FullPlateWeb.Jsons.PaymentJson do
  def confirmation(%{payment: order, status: _status}) do
    %{confirmation: %{
      id: order.id,
      message: "pagamento confirmado"
    }}
  end
end
