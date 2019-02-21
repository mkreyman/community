defmodule Community.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :country, :string, null: false
      add :locality, :string, null: false
      add :region, :string
      add :po_box, :string
      add :postal_code, :string
      add :street_address, :string, null: false
      add :address_type, :string

      timestamps()
    end

    create unique_index(:addresses, [:street_address, :locality, :country])
  end
end
