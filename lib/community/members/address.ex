defmodule Community.Members.Address do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Community.Members.UserAddress
  alias Community.Accounts.User

  @address_categories [
    "primary",
    "business",
    "mailing"
  ]

  schema "addresses" do
    field :country, :string
    field :locality, :string
    field :po_box, :string
    field :postal_code, :string
    field :region, :string
    field :street_address, :string
    field :category, :string

    many_to_many :users, User, join_through: UserAddress

    timestamps()
  end

  @attrs [
    :country,
    :locality,
    :region,
    :po_box,
    :postal_code,
    :street_address,
    :category
  ]

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, @attrs)
    |> validate_required([:country, :locality, :street_address])
  end

  @doc false
  def categories() do
    @address_categories
  end
end
