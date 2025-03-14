defmodule FullPlateWeb.ProductController do
  use FullPlateWeb, :controller

  require Logger

  alias FullPlate.Service.ProductService
  alias FullPlate.Service.UserService
  alias FullPlate.Accounts.User

  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.ProductJson

  def create(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
    %User{id: id, admin: true} <- user_id_identification(conn),
      updated_params <- Map.put(params, "user_id", id),
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
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{admin: true} <- user_id_identification(conn),
      product <- ProductService.get_product_by_type(params["type"]) do
      conn
      |> put_status(:ok)
      |> render(:product_list, loyalt: false, product: product)
    end
  end

  def update_product(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{admin: true} <- user_id_identification(conn),
     {:ok, product} <- ProductService.update_product(params["id"], params) do
      conn
      |> put_status(:ok)
      |> render(:product, loyalt: false, product: product, status: :updated)
    end
  end

  def delete_product(conn, params) do
    token = conn.private[:guardian_default_token]
    with {:ok, :authorized} <- UserService.validate_token(token),
     %User{admin: true} <- user_id_identification(conn),
     {:ok, product} <- ProductService.delete_product(params["id"]) do
      conn
      |> put_status(:ok)
      |> render(:product, loyalt: false, product: product, status: :deleted)
    end
  end

  defp user_id_identification(conn) do
    conn.private[:guardian_default_resource]
  end
end
