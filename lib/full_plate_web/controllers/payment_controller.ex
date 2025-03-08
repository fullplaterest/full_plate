defmodule FullPlateWeb.PaymentController do
  use FullPlateWeb, :controller

  alias FullPlate.Service.OrderService


  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.PaymentJson

  def payments(conn, params) do
    with order <- OrderService.update_order(params["id"], Map.put(params, "payment_status", true)) do
      conn
      |> put_status(:ok)
      |> render(:confirmation, loyalt: false, payment: order, status: :created)
    end
  end
end
