defmodule Congregation.Repo.Migrations.CreateDonors do
  use Ecto.Migration

  def change do
    create table(:donors) do
      add :name, :string
      add :amount, :float, precision: 10, scale: 2
      add :address, :string
      add :email, :string
      add :phone, :string
      add :receipt_emailed, :boolean

      timestamps()
    end

    create unique_index(:donors, [:name])
  end
end
