defmodule FullPlateWeb.OrderController do
  use FullPlateWeb, :controller

  require Logger

  alias FullPlate.Accounts.User
  alias FullPlate.Service.OrderService
  alias FullPlate.Service.UserService

  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.OrderJson

  def create(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{id: id, admin: false} <- user_id_identification(conn),
      {:ok, order} <- OrderService.create_order(Map.put(params, "user_id", id)) do
    conn
    |> put_status(:created)
    |> render(:order, loyalt: false, order: order, status: :created)
    end
  end

  def get_orders(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{id: id, admin: false} <- user_id_identification(conn),
     order <- OrderService.get_order(params["page"], params["page_size"], id) do
    conn
    |> put_status(:ok)
    |> render(:order_list, loyalt: false, order: order, status: :ok)
    end
  end

  def list_orders(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{admin: true} <- user_id_identification(conn),
     order <- OrderService.list_order(params["page"], params["page_size"]) do
    conn
    |> put_status(:ok)
    |> render(:order_list_admin, loyalt: false, order: order, status: :ok)
    end
  end

  def update_status(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{admin: true} <- user_id_identification(conn),
     order <- OrderService.update_order(params) do
    conn
    |> put_status(:ok)
    |> render(:updated_order_list_admin, loyalt: false, order: order, status: :updated)
    end
  end

  defp user_id_identification(conn) do
    conn.private[:guardian_default_resource]
  end
end
