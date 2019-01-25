defmodule Congregation.Donor do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Congregation.{Repo, Donor}

  schema "donors" do
    field(:name, :string)
    field(:amount, :integer)
    field(:address, :string)
    field(:email, :string)
    field(:receipt_emailed, :boolean)

    timestamps()
  end

  @fields ~w(name amount address email receipt_emailed)a

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, @fields)
    |> validate_required(:name)
    |> unique_constraint(:name)
    |> validate_number(:amount, greater_than: 0)
  end

  def add(name, amount, address, email, receipt_emailed) do
    %Donor{}
    |> Donor.changeset(%{
      name: name,
      amount: amount,
      address: address,
      email: email,
      receipt_emailed: receipt_emailed
    })
    |> Repo.insert!()
  end

  def create_or_update(params) do
    case Repo.get_by(Donor, name: params[:name]) do
      nil -> %Donor{name: params[:name]}
      donor -> donor
    end
    |> Donor.changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, donor} -> {:ok, donor}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def with_contributions do
    query =
      from(
        d in Donor,
        where: d.amount > 0,
        select: [:name, :amount, :address, :email, :receipt_emailed]
      )

    Repo.all(query)
  end

  def summary(name) do
    query =
      from(
        d in Donor,
        where: ilike(d.name, ^"%#{name}%"),
        select: [:name, :amount, :address, :email, :receipt_emailed]
      )

    Repo.all(query)
  end
end
