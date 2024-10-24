defmodule FullPlateWeb.UserController do
  use FullPlateWeb, :controller

  require Logger

  alias FullPlateWeb.Guardian
  alias FullPlate.Service.UserService

  action_fallback(FullPlateWeb.FallbackController)

  plug :put_view, json: FullPlateWeb.Jsons.UserJson

  def create(conn, params) do
    with {:ok, user} <- UserService.create_user(params),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(%{id: user.id}) do
      UserService.insert_token_user(user.id, token)

      conn
      |> put_status(:created)
      |> render(:user, loyalt: false, user: user, token: token, status: :created)
    end
  end

  def log_in(conn, params) do
    with {:ok, user} <- UserService.get_user_email_password(params["email"], params["password"]),
         :ok <- UserService.delete_previews_token(user.id),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         :ok <- UserService.insert_token_user(user.id, token) do
      conn
      |> put_status(:ok)
      |> render(:user, loyalt: false, user: user, token: token, status: :log_in)
    end
  end
end
