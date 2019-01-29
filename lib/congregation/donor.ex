defmodule Congregation.Donor do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Congregation.{Repo, Donor}
  alias Ecto.Query

  schema "donors" do
    field(:name, :string)
    field(:amount, :integer)
    field(:address, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:receipt_emailed, :boolean)

    timestamps()
  end

  @failed ["Test Donor"]

  @fields ~w(name amount address email phone receipt_emailed)a

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, @fields)
    |> validate_required(:name)
    |> unique_constraint(:name)
    |> validate_number(:amount, greater_than: 0)
  end

  def add(name, amount, address, email, phone, receipt_emailed) do
    %Donor{}
    |> Donor.changeset(%{
      name: name,
      amount: amount,
      address: address,
      email: email,
      phone: phone,
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

  def update(params) do
    case Repo.get_by(Donor, name: params[:name]) do
      nil -> %Donor{name: params[:name]}
      donor -> donor
    end
    |> Donor.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, donor} -> {:ok, donor}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def filtered(nil), do: filtered(:current)

  def filtered(:current) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Repo.all()
  end

  def filtered(:with_email) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], not is_nil(d.email))
    |> Query.where([d], is_nil(d.receipt_emailed))
    # |> Query.where([d], d.name in ["Test Donor"])
    |> Repo.all()
  end

  def filtered(:with_email_only) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], not is_nil(d.email))
    |> Query.where([d], is_nil(d.address))
    |> Query.where([d], is_nil(d.receipt_emailed))
    # |> Query.where([d], d.name in ["Test Donor"])
    |> Repo.all()
  end

  def filtered(:with_address_only) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], not is_nil(d.address))
    |> Query.where([d], is_nil(d.email))
    |> Repo.all()
  end

  def filtered(:no_address) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], is_nil(d.address))
    |> Query.where([d], is_nil(d.email))
    |> Repo.all()
  end

  def filtered(:with_address_and_email) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], not is_nil(d.address))
    |> Query.where([d], not is_nil(d.email))
    |> Query.where([d], is_nil(d.receipt_emailed))
    # |> Query.where([d], d.name in ["Test Donor"])
    |> Repo.all()
  end

  def filtered(:receipt_emailed) do
    Donor
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
    |> Query.where([d], d.receipt_emailed)
    |> Repo.all()
  end

  def filtered(:zero) do
    Donor
    |> Query.where([d], is_nil(d.amount) or d.amount == 0)
    |> Repo.all()
  end

  def update_status() do
    @failed
    |> Enum.each(&update(%{name: &1, receipt_emailed: nil}))
  end

  def reset_status(donor) do
    update(%{name: donor.name, receipt_emailed: nil})
  end

  def summary(name) do
    Donor
    |> Query.where([d], ilike(d.name, ^"%#{name}%"))
    |> Repo.all()
  end
end
