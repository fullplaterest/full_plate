defmodule FullPlate.Service.ProductService do
  require Logger

  alias FullPlate.Products

  @spec create_product(map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def create_product(params) do
    case Products.register_product(params) do
      {:ok, product} ->
        Logger.info("Product created with #{product.product_name}")
        {:ok, product}

      error ->
        Logger.error(
          "Could not create product with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  @spec get_product_by_type(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  def get_product_by_type(product_type) do
    product_type = String.to_atom(product_type)
    case Products.get_by_type(product_type) do
      [] ->
        Logger.info("products from type #{product_type} not found")
        {:error, :not_found}

      product ->
        Logger.info("products with id #{product_type} was requested")
        product
    end
  end

  @spec update_product(Binary_id.t(), map()) :: {:ok, Product.t()} | {:error, :not_found}
  def update_product(product_id, attrs) do
    case Products.update_product(product_id, attrs) do
      nil ->
        Logger.info("products from type #{product_id} not found")
        {:error, :not_found}

      product ->
        Logger.info("products with id #{product_id} was updated")
        product
    end
  end

  @spec delete_product(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  def delete_product(product_id) do
    case Products.delete_product_by_id(product_id) do
      nil ->
        Logger.info("products #{product_id} not found")
        {:error, :not_found}

      product ->
        Logger.info("products with id #{product_id} was deleted")
        product
    end
  end
end
