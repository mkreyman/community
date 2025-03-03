defmodule Congregation.Donor do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

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

  def get_by(donor_name) when is_binary(donor_name) do
    Repo.get_by(Donor, name: donor_name)
  end

  def create_or_update(params) do
    case Repo.get_by(Donor, name: params[:name]) do
      nil -> %Donor{name: params[:name]}
      donor -> donor
    end
    |> Donor.changeset(params)
    |> case do
      changeset = %Ecto.Changeset{valid?: false} ->
        {:error, changeset}

      changeset ->
        Repo.insert_or_update(changeset)
    end
  end

  def update(params) do
    donor =
      case Repo.get_by(Donor, name: params[:name]) do
        nil -> %Donor{}
        donor -> donor
      end

    changeset = Donor.changeset(donor, params)

    case Repo.insert_or_update(changeset) do
      {:ok, donor} -> {:ok, donor}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def filtered(:current) do
    Donor
    |> current_donors()
    |> Repo.all()
  end

  def filtered(:with_email) do
    Donor
    |> current_donors()
    |> with_email()
    |> have_not_been_emailed()
    # |> on_the_list(["Test User"])
    |> Repo.all()
  end

  def filtered(:with_email_only) do
    Donor
    |> current_donors()
    |> with_email_only()
    |> have_not_been_emailed()
    # |> on_the_list(["Test Donor"])
    |> Repo.all()
  end

  def filtered(:with_address_only) do
    Donor
    |> current_donors()
    |> with_address()
    |> with_no_email()
    |> Repo.all()
  end

  def filtered(:no_address) do
    Donor
    |> current_donors()
    |> with_no_address()
    |> with_no_email()
    |> Repo.all()
  end

  def filtered(:with_address_and_email) do
    Donor
    |> current_donors()
    |> with_address()
    |> with_email()
    |> have_not_been_emailed()
    # |> on_the_list(["Test Donor"])
    |> Repo.all()
  end

  def filtered(:receipt_emailed) do
    Donor
    |> current_donors()
    |> have_been_emailed()
    |> Repo.all()
  end

  def filtered(:zero) do
    Donor
    |> not_current_donors()
    |> Repo.all()
  end

  def update_status(filter, receipt_emailed)
      when is_atom(filter) and is_boolean(receipt_emailed) do
    filter
    |> filtered()
    |> Enum.map(& &1.name)
    |> Enum.each(&update(%{name: &1, receipt_emailed: receipt_emailed}))
  end

  def reset_status(donor) do
    update(%{name: donor.name, receipt_emailed: nil})
  end

  def summary(name) do
    Donor
    |> Query.where([d], ilike(d.name, ^"%#{name}%"))
    |> Repo.all()
  end

  def current_donors(query \\ Donor) do
    query
    |> Query.where([d], not is_nil(d.amount))
    |> Query.where([d], d.amount > 0)
  end

  def not_current_donors(query \\ Donor) do
    query
    |> Query.where([d], is_nil(d.amount) or d.amount == 0)
  end

  def with_email(query \\ Donor) do
    query
    |> Query.where([d], not is_nil(d.email))
  end

  def with_address(query \\ Donor) do
    query
    |> Query.where([d], not is_nil(d.address))
  end

  def with_email_only(query \\ Donor) do
    query
    |> with_email()
    |> with_no_address()
  end

  def have_not_been_emailed(query \\ Donor) do
    query
    |> Query.where([d], is_nil(d.receipt_emailed))
  end

  def have_been_emailed(query \\ Donor) do
    query
    |> Query.where([d], d.receipt_emailed)
  end

  def on_the_list(query \\ Donor, names_list) when is_list(names_list) do
    query
    |> Query.where([d], d.name in ^names_list)
  end

  def with_no_email(query \\ Donor) do
    query
    |> Query.where([d], is_nil(d.email))
  end

  def with_no_address(query \\ Donor) do
    query
    |> Query.where([d], is_nil(d.address))
  end
end
