defmodule Community.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Community.Accounts.Credential
  alias Community.Members.{Profile, Address, UserAddress}

  schema "users" do
    field :username, :string
    has_one :credential, Credential
    has_one :profile, Profile
    many_to_many :addresses, Address, join_through: UserAddress

    timestamps()
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def profile_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:profile, with: &Profile.changeset/2, required: true)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> validate_length(:username, min: 1, max: 20)
  end
end
