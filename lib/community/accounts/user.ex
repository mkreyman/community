defmodule Community.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Community.Accounts.Credential
  alias Community.Members.Profile

  schema "users" do
    field :username, :string
    has_one :credential, Credential
    has_one :profile, Profile

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
    |> cast_assoc(:profile, with: &Profile.changeset/2, required: false)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> validate_length(:username, min: 1, max: 20)
  end
end
