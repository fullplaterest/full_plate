defmodule FullPlateWeb.OrderController do
  use FullPlateWeb, :controller

  require Logger

  alias FullPlate.Service.OrderService

  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.OrderJson

  def create(conn, params) do
    with {:ok, order} <- OrderService.create_order(params) do
    conn
    |> put_status(:created)
    |> render(:order, loyalt: false, order: order, status: :created)
    end
  end

  def get_orders(conn, params) do
    with order <- OrderService.get_order(params["page"], params["page_size"]) do
    conn
    |> put_status(:created)
    |> render(:order_list, loyalt: false, order: order, status: :created)
    end
  end
end
