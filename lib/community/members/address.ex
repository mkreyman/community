defmodule Community.Members.Address do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Community.Members.UserAddress
  alias Community.Accounts.User

  @address_types [
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
    field :address_type, :string

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
    :address_type
  ]

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, @attrs)
    |> validate_required([:country, :locality, :street_address])
  end

  @doc false
  def address_types() do
    @address_types
  end
end
