defmodule Community.Members.UserAddress do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users_addresses" do
    belongs_to :user, Community.Accounts.User
    belongs_to :address, Community.Members.Address

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:user_id, :address_id])
    |> validate_required([:user_id, :address_id])
  end
end
