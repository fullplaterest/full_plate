defmodule FullPlate.Products.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias FullPlate.Accounts.User

  @type type_types :: :lanche | :acompanhamento | :bebida | :sobremesa
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          product_name: String.t(),
          id_user: Ecto.UUID.t(),
          description: Text.t(),
          type: type_types(),
          price: Decimal.t(),
          picture: String.t()
        }

  @fields ~w(product_name description id_user type price picture)a
  @type_types ~w(lanche acompanhamento bebida sobremesa)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field(:product_name, :string)
    field(:description, :string)
    field(:id_user, :binary_id)
    field(:type, Ecto.Enum, values: @type_types)
    field(:price, :decimal)
    field(:picture, :string)

    has_one(:users, User)

    timestamps()
  end

  @spec changeset(:__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(product \\ %__MODULE__{}, attrs) do
    product
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:id_user, name: :products_id_store_fkey)
    |> validate_price()
  end

  defp validate_price(changeset) do
    validate_number(changeset, :price,
      greater_than_or_equal_to: 1,
      message: "must be greater than or equal to one"
    )
  end
end
