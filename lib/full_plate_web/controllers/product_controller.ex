defmodule FullPlateWeb.ProductController do
  use FullPlateWeb, :controller

  require Logger

  alias FullPlate.Service.ProductService
  alias FullPlate.Accounts.User

  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.ProductJson

  def create(conn, params) do
    with %User{id: id, admin: true} <- user_id_identification(conn),
      updated_params <- Map.put(params, "id_user", id),
      {:ok, product} <- ProductService.create_product(updated_params) do
      conn
      |> put_status(:created)
      |> render(:product, loyalt: false, product: product, status: :created)
    else
      %User{admin: false} -> {:erro, :not_admin}

      error -> error
    end
  end

  def get_product(conn, params) do
    with %User{admin: true} <- user_id_identification(conn),
      product <- ProductService.get_product_by_type(params["type"]) do
      conn
      |> put_status(:ok)
      |> render(:product_list, loyalt: false, product: product)
    end
  end

  def update_product(conn, params) do
    with %User{admin: true} <- user_id_identification(conn),
      product <- ProductService.update_product(params["id"], params) do
      conn
      |> put_status(:ok)
      |> render(:product, loyalt: false, product: product, status: :updated)
    end
  end

  def delete_product(conn, params) do
    with %User{admin: true} <- user_id_identification(conn),
      product <- ProductService.delete_product(params["id"]) do
      conn
      |> put_status(:ok)
      |> render(:product, loyalt: false, product: product, status: :deleted)
    end
  end

  defp user_id_identification(conn) do
    conn.private[:guardian_default_resource]
  end
end
