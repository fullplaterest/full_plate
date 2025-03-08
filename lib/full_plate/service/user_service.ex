defmodule FullPlate.Service.UserService do
  require Logger

  alias FullPlate.Accounts

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        Logger.info("User created with email #{user.email}")
        {:ok, user}

      error ->
        Logger.error(
          "Could not create user with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  @spec get_user_by_id(Binary_id.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_by_id(user_id) do
    case Accounts.get_user!(user_id) do
      nil ->
        Logger.info("User with id: #{user_id} not found")
        {:error, :not_found}

      user ->
        Logger.info("User with id #{user_id} was requested")
        user
    end
  end

  @spec get_user_cpf_password(String.t(), String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_cpf_password(cpf, password) do
    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      nil ->
        Logger.error("User with email: #{cpf} not found")
        {:error, :not_found}

      user ->
        Logger.info("User with email: #{cpf} requested")
        {:ok, user}
    end
  end

  @spec insert_token_user(Binary_id.t(), String.t()) :: :ok
  def insert_token_user(user_id, token), do: Accounts.insert_user_session_token(user_id, token)

  @spec delete_previews_token(Binary_id.t()) :: :ok
  def delete_previews_token(user_id) do
    Logger.info("All previews tokens from user #{user_id} was deleted")
    Accounts.delete_user_session_token(user_id)
  end

  @spec authenticate_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
  def authenticate_user(cpf, password) do
    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      nil ->
        Logger.error("User tried to authenticated and get denied with #{cpf}")
        {:error, :invalid_credentials}

      user ->
        Logger.info("User #{cpf} was been authenticated in #{DateTime.utc_now()}")
        {:ok, user}
    end
  end

  @spec validate_token(String.t()) ::
          {:ok, :authorized} | {:error, :unauthorized}
  def validate_token(token) do
    case Accounts.validate_token_user(token) do
      nil -> {:error, :unauthorized}
      _user_token -> {:ok, :authorized}
    end
  end
end
