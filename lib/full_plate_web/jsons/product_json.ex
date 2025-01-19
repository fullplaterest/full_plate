defmodule FullPlateWeb.Jsons.ProductJson do
  def product(%{product: product, status: status}) do
    %{status: status, product: product.product_name}
  end

  def product_list(%{product: products}) do
   Enum.map(products, fn product -> %{
    product_name: product.product_name,
    description: product.description,
    price: Decimal.to_string(product.price)
    } end)
  end
end
