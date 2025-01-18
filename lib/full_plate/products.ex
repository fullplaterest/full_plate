defmodule FullPlate.Products do
  import Ecto.Query, warn: false

  alias FullPlate.Products.Product
  alias FullPlate.Repo

  @doc """
  Create a product by

  ## Examples

      iex> register_product(%{
      "product_name" => "hamburguer",
      "description" => "pao bola com carne artesanal e queijo",
      "type" => "lanche",
      "price" => 11.59,
      "picture" => "www.picture.com",
      "user_id" => "f16e5245-fef1-4f67-9e5e-86df9ccaf99a"
      })
  """
  def register_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_id(id), do: Repo.get(Product, id)

  def get_by_id_list(ids) do
    Product
    |> from()
    |> where([p], p.id in ^ids)
    |> select([p], %{producMt_name: p.product_name})
    |> Repo.all()
  end

  def get_by_type(type) do
    Product
    |> from()
    |> where([p], p.type == ^type)
    |> Repo.all()
  end

  def update_product(id, attrs) do
    Repo.get(Product, id)
    |> case do
      nil -> nil

      product -> product
      |> Product.changeset(attrs)
      |> Repo.update()
    end
  end

  def delete_product_by_id(id) do
    case Repo.get(Product, id) do
      nil -> {:error, :not_found}
      product -> Repo.delete(product)
    end
  end
end
