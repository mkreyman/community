defmodule Community.Members.Person do
  # use Ecto.Schema
  # import Ecto.Changeset

  # alias Community.Members.Person

  # schema "persons" do
  #   field :additional_name, :string
  #   field :alternative_name, :string
  #   field :alumni_of, :string
  #   field :birth_date, :date
  #   field :birth_place, :string
  #   field :death_date, :date
  #   field :family_name, :string
  #   field :gender, :string
  #   field :given_name, :string
  #   field :honorific_prefix, :string
  #   field :honorific_suffix, :string
  #   field :image, :string
  #   field :nationality, :string

  #   has_many :addresses
  #   has_many :affiliations
  #   has_many :same_as, Person
  #   has_many :email_addresses
  #   has_many :children, Person
  #   has_many :colleagues, Person
  #   has_many :donations, Donation
  #   has_many :facts
  #   has_many :grandchildren, Person
  #   has_many :phone_numbers
  #   many_to_many :followers, Person
  #   has_many :occupations
  #   has_many :job_titles
  #   has_many :skills
  #   has_many :languages
  #   has_many :memberships
  #   has_many :pets, Pet
  #   has_many :relationships, Person
  #   has_many :siblings, Person
  #   has_one :spouse, Person
  #   has_many :user_accounts, User
  #   has_many :web_addresses
  #   has_many :workplaces

  #   timestamps()
  # end

  # def changeset(user, attrs) do
  #   user
  #   |> cast(attrs, [:given_name, :family_name])
  #   |> validate_required([:given_name, :family_name])
  # end
end
