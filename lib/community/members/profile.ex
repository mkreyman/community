defmodule Community.Members.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :additional_name, :string
    field :alternative_name, :string
    field :alumni_of, :string
    field :birth_date, :date
    field :birth_place, :string
    field :family_name, :string
    field :gender, :string
    field :given_name, :string
    field :honorific_prefix, :string
    field :honorific_suffix, :string
    field :image, :string
    field :nationality, :string
    belongs_to :user, Community.Accounts.User

    timestamps()
  end

  @attrs [
    :additional_name,
    :alternative_name,
    :alumni_of,
    :birth_date,
    :birth_place,
    :family_name,
    :gender,
    :given_name,
    :honorific_prefix,
    :honorific_suffix,
    :image,
    :nationality
  ]

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @attrs)
    |> unique_constraint(:user_id)
  end
end
